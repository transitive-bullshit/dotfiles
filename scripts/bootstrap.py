#!/usr/bin/env python3
"""Link explicit shell/editor files. Conflicts require --adopt and are backed up."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import sys
import uuid

REPO = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target-home', type=Path, default=Path.home())
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument('--adopt', action='store_true', help='Move existing conflicting files to a private backup first')
    parser.add_argument('--force', '-f', action='store_true', help='Compatibility alias for --adopt; never deletes conflicts')
    args = parser.parse_args()
    home = args.target_home.expanduser().resolve()
    mapping = json.loads((REPO / 'dotfiles.json').read_text())
    plan, errors = [], []
    for source_name, target_name in mapping.items():
        relative = Path(target_name)
        if relative.is_absolute() or '..' in relative.parts or str(relative) == '.':
            raise ValueError(f'Invalid target: {target_name}')
        source, target = REPO / source_name, home / relative
        if not source.exists():
            errors.append(f'Missing source: {source}')
            continue
        parent = target.parent
        while parent != home:
            if parent.is_symlink() or (parent.exists() and not parent.is_dir()):
                errors.append(f'Target parent must be a directory: {parent}')
                break
            parent = parent.parent
        if target.is_symlink() and target.resolve() == source.resolve():
            continue
        existing = os.path.lexists(target)
        if existing and not (args.adopt or args.force):
            errors.append(f'Conflict: {target}; use --adopt to back it up')
        plan.append((source, target, existing))
    if errors:
        raise ValueError('\n'.join(errors))
    for source, target, existing in plan:
        print(f'{"Back up and link" if existing else "Link"}: {target} -> {source}')
    if args.dry_run or not plan:
        if not plan:
            print('Already applied')
        return
    run_id = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    backup = home / '.local/state/dotfiles/backups' / run_id
    # A linked state directory could send backups somewhere unexpected.
    parent = backup.parent
    while parent != home:
        if parent.is_symlink() or (parent.exists() and not parent.is_dir()):
            raise ValueError(f'Backup parent must be a directory: {parent}')
        parent = parent.parent
    backup.mkdir(parents=True, mode=0o700)
    completed = []
    try:
        for source, target, existing in plan:
            target.parent.mkdir(parents=True, exist_ok=True)
            saved = backup / target.relative_to(home)
            if existing:
                saved.parent.mkdir(parents=True, exist_ok=True)
                os.replace(target, saved)
            completed.append((target, saved, existing))
            target.symlink_to(source)
        (backup / 'manifest.json').write_text(json.dumps({'links': {str(target.relative_to(home)): str(source) for source, target, _ in plan}}, indent=2) + '\n')
    except BaseException:
        for target, saved, existing in reversed(completed):
            if target.is_symlink():
                target.unlink()
            if existing:
                os.replace(saved, target)
        raise
    print(f'Backup: {backup}')
    print('Open a new shell to load the updated configuration')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError) as error:
        print(f'Error: {error}', file=sys.stderr)
        sys.exit(1)
