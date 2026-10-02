#!/usr/bin/env python3
"""Apply, inspect, and synchronize the agent environment from two Git checkouts."""
import argparse
import copy
import difflib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

if sys.version_info < (3, 11):
    sys.exit('agent-env requires Python 3.11+ (on macOS: brew install python)')
import tomllib

REPO = Path(__file__).resolve().parents[1]
PREFERENCES = REPO / 'agents/preferences.json'
CONFIGS = {'codex': '.codex/config.toml', 'claude': '.claude/settings.json'}
ALLOWED = {
    'codex': {'model': str, 'model_reasoning_effort': str, 'service_tier': str,
              'personality': str, 'tui.animations': bool, 'tui.show_tooltips': bool,
              'tui.status_line': list, 'tui.status_line_use_colors': bool},
    'claude': {'theme': str, 'tui': str, 'switchModelsOnFlag': bool},
}
MISSING = object()


def engine(skills_repo):
    source = skills_repo / 'scripts/skillset.py'
    if not source.is_file():
        raise ValueError(f'Skills checkout missing: {skills_repo}; clone the skills repo beside dotfiles or use --skills-repo')
    spec = importlib.util.spec_from_file_location('skillset', source)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    if module.API_VERSION != 1:
        raise ValueError('Incompatible skills installer; update both repos together')
    return module


def get(data, path):
    value = data
    for key in path.split('.'):
        if not isinstance(value, dict) or key not in value:
            return MISSING
        value = value[key]
    return value


def set_value(data, path, value):
    keys = path.split('.')
    for key in keys[:-1]:
        if key not in data:
            data[key] = {}
        if not isinstance(data[key], dict):
            raise ValueError(f'Cannot set {path}: {key} is not a table')
        data = data[key]
    data[keys[-1]] = value


def read_config(home, agent):
    path = home / CONFIGS[agent]
    raw = path.read_text() if path.is_file() else ''
    return raw, (tomllib.loads(raw) if agent == 'codex' else json.loads(raw or '{}'))


def preferences():
    value = json.loads(PREFERENCES.read_text())
    if set(value) - set(ALLOWED):
        raise ValueError('Unknown agent in preferences.json')
    for agent, entries in value.items():
        for key, val in entries.items():
            if key not in ALLOWED[agent] or type(val) is not ALLOWED[agent][key]:
                raise ValueError(f'Unsupported portable setting or type: {agent}.{key}')
            if isinstance(val, list) and not all(isinstance(item, str) for item in val):
                raise ValueError(f'{agent}.{key}: only lists of strings are supported')
    return value


def patch_toml(raw, changes):
    """Replace allowlisted values while preserving unrelated TOML and comments."""
    before = tomllib.loads(raw)
    expected = copy.deepcopy(before)
    for key, value in changes.items():
        set_value(expected, key, value)
    if before == expected:
        return raw
    pending = {k: v for k, v in changes.items() if get(before, k) != v}
    lines = raw.splitlines(keepends=True)
    section, result, index = '', [], 0
    while index < len(lines):
        line = lines[index]
        header = re.match(r'^\s*\[([^\[\]]+)\]\s*(?:#.*)?$', line.strip())
        if header:
            section = header.group(1).strip()
        elif re.match(r'^\s*\[\[', line):
            section = '<array-table>'
        assignment = re.match(r'^(\s*)([A-Za-z_][A-Za-z0-9_-]*)\s*=', line)
        key = ((section + '.') if section else '') + assignment.group(2) if assignment else None
        if key in pending:
            # Parse the complete existing assignment, including multiline arrays/strings.
            stop = index + 1
            while True:
                try:
                    tomllib.loads(''.join(lines[index:stop]))
                    break
                except tomllib.TOMLDecodeError:
                    if stop >= len(lines):
                        raise ValueError(f'Cannot safely rewrite TOML setting: {key}')
                    stop += 1
            value = json.dumps(pending.pop(key), ensure_ascii=False)
            result.append(f'{assignment.group(1)}{assignment.group(2)} = {value}\n')
            index = stop
        else:
            result.append(line)
            index += 1
    rendered = ''.join(result)
    for key, value in pending.items():
        section, _, field = key.rpartition('.')
        assignment = f'{field} = {json.dumps(value, ensure_ascii=False)}\n'
        if not section:
            rendered = assignment + rendered
        else:
            pattern = re.compile(r'(^\s*\[' + re.escape(section) + r'\]\s*(?:#[^\n]*)?\n)', re.M)
            if pattern.search(rendered):
                rendered = pattern.sub(lambda match: match.group(1) + assignment, rendered, count=1)
            else:
                rendered = rendered.rstrip() + f'\n\n[{section}]\n' + assignment
    if tomllib.loads(rendered) != expected:
        raise ValueError('TOML rewrite would change unmanaged settings; no files were written')
    return rendered


def settings_plan(lib, home, profile, prior, adopt):
    desired = preferences()
    operations, managed = [], {}
    for agent in profile['agents'] if profile.get('settings', True) else []:
        raw, current = read_config(home, agent)
        desired_agent = desired.get(agent, {})
        for key, value in desired_agent.items():
            actual = get(current, key)
            last = prior.get('preferences', {}).get(agent, {}).get(key, MISSING)
            if actual is not MISSING and actual != value and actual != last and not adopt:
                raise lib.Conflict(f'{agent}.{key} changed outside dotfiles; use export-config --write to capture it, or --adopt to back it up and apply the repo value')
        if agent == 'codex':
            updated = patch_toml(raw, desired_agent)
        else:
            expected = copy.deepcopy(current)
            for key, value in desired_agent.items():
                set_value(expected, key, value)
            updated = raw if expected == current else lib.json_bytes(expected).decode()
        operations.extend(lib.write_plan(home, CONFIGS[agent], updated.encode(), adopt=adopt))
        managed[agent] = desired_agent
    return operations, managed


def profiles():
    value = json.loads((REPO / 'agents/profiles.json').read_text())
    for name, profile in value.items():
        if not profile.get('agents') or set(profile['agents']) - {'codex', 'claude'}:
            raise ValueError(f'{name}: agents must contain codex and/or claude')
        if not isinstance(profile.get('skills'), str):
            raise ValueError(f'{name}: skill profile is required')
    return value


def environment_links(profile):
    links = {f'.{agent}/' + ('AGENTS.md' if agent == 'codex' else 'CLAUDE.md'):
            str(REPO / 'agents' / agent / ('AGENTS.md' if agent == 'codex' else 'CLAUDE.md'))
            for agent in profile['agents']}
    links['.local/bin/agent-env'] = str(REPO / 'scripts/agent_env.py')
    return links


def planned(lib, skills_repo, home, name, profile, adopt=False):
    prior = lib.read_json(lib.safe_target(home, lib.STATE / 'environment.json'), {})
    operations, catalog, _ = lib.prepare(skills_repo, home, profile['skills'], profile['agents'], adopt, environment_links(profile))
    for source in environment_links(profile).values():
        if not Path(source).is_file():
            raise ValueError(f'Missing global instruction source: {source}')
    config_operations, managed = settings_plan(lib, home, profile, prior, adopt)
    operations.extend(config_operations)
    state = {'version': 1, 'profile': name, 'dotfiles': str(REPO), 'skills': str(skills_repo),
             'preferences': managed, 'revisions': {'dotfiles': lib.git_revision(REPO), 'skills': lib.git_revision(skills_repo)}}
    operations.extend(lib.write_plan(home, lib.STATE / 'environment.json', lib.json_bytes(state)))
    return operations, catalog


def check(lib, skills_repo):
    catalog = lib.load_catalog(skills_repo)
    preferences()
    for name, profile in profiles().items():
        lib.select(catalog, profile['skills'])
        for source in environment_links(profile).values():
            if not Path(source).is_file():
                raise ValueError(f'{name}: missing environment source')
    print(f'Valid: {len(catalog["skills"])} skills and {len(profiles())} environment profiles')


def diagnose(lib, skills_repo, home, name, profile, skip_tools=False):
    problems = lib.doctor(skills_repo, home, profile['skills'], profile['agents'], environment_links(profile), not skip_tools)
    desired = preferences()
    for agent in profile['agents'] if profile.get('settings', True) else []:
        if (home / CONFIGS[agent]).is_symlink():
            problems.append(f'Live {agent} config is linked; use apply --adopt to keep application state outside source control')
        _, current = read_config(home, agent)
        for key, value in desired.get(agent, {}).items():
            if get(current, key) != value:
                problems.append(f'Portable setting drift: {agent}.{key}; export-config or apply')
    state = lib.read_json(lib.safe_target(home, lib.STATE / 'environment.json'), {})
    if state.get('profile') != name or state.get('dotfiles') != str(REPO) or state.get('skills') != str(skills_repo):
        problems.append('Environment receipt differs from the selected profile/checkouts; run apply')
    if not skip_tools:
        for command in profile.get('commands', []):
            if not shutil.which(command):
                problems.append(f'Missing profile command: {command}')
    print(f'Dotfiles: {lib.git_revision(REPO)}')
    print(f'Skills:   {lib.git_revision(skills_repo)}')
    print(f'Profile:  {name}')
    if problems:
        raise lib.Conflict('\n'.join(problems))
    print('Skills, instructions, portable settings, and selected tools match')


def export_settings(home, write=False):
    before = PREFERENCES.read_text()
    result = preferences()
    for agent, keys in ALLOWED.items():
        _, current = read_config(home, agent)
        for key in keys:
            value = get(current, key)
            if value is not MISSING:
                if type(value) is not keys[key]:
                    raise ValueError(f'Unexpected setting type: {agent}.{key}')
                result.setdefault(agent, {})[key] = value
    after = json.dumps(result, indent=2, sort_keys=True) + '\n'
    print(''.join(difflib.unified_diff(before.splitlines(True), after.splitlines(True), fromfile='repo preferences', tofile='portable app preferences')), end='')
    if write:
        PREFERENCES.write_text(after)
        print('Captured portable settings in agents/preferences.json; review the Git diff and run apply')


def git(repo, *args, capture=True):
    result = subprocess.run(['git', '-C', str(repo), *args], check=True, text=True,
                            stdout=subprocess.PIPE if capture else None)
    return result.stdout.strip() if capture else None


def pull(repositories, dry_run=False):
    repositories = [Path(repo).resolve() for repo in repositories]
    # Preflight both repos before advancing either working tree.
    for repo in repositories:
        if Path(git(repo, 'rev-parse', '--show-toplevel')) != repo:
            raise ValueError(f'Not a repository root: {repo}')
        if git(repo, 'status', '--porcelain', '--ignore-submodules=none'):
            raise ValueError(f'Uncommitted changes in {repo}; commit or resolve them before pull')
        if not git(repo, 'branch', '--show-current'):
            raise ValueError(f'Detached checkout: {repo}; choose a branch before pull')
        git(repo, 'rev-parse', '--abbrev-ref', '@{upstream}')
    if dry_run:
        print('Would fetch both remotes, check for divergence, fast-forward, then apply the selected profile')
        return
    for repo in repositories:
        git(repo, 'fetch', '--prune', capture=False)
    for repo in repositories:
        common = git(repo, 'merge-base', 'HEAD', '@{upstream}')
        if common not in {git(repo, 'rev-parse', 'HEAD'), git(repo, 'rev-parse', '@{upstream}')}:
            raise ValueError(f'Diverged checkout: {repo}; resolve with normal Git before pull')
    for repo in repositories:
        git(repo, 'merge', '--ff-only', '@{upstream}', capture=False)
        if (repo / '.gitmodules').is_file():
            git(repo, 'submodule', 'sync', '--recursive', capture=False)
            git(repo, 'submodule', 'update', '--init', '--recursive', capture=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=['apply', 'doctor', 'check', 'pull', 'export-config', 'restore'])
    parser.add_argument('--skills-repo', type=Path, help='Defaults to the installed checkout, or ../skills')
    parser.add_argument('--target-home', type=Path, default=Path.home(), help='Isolated test target; HOME is never changed')
    parser.add_argument('--profile', help='mac, cloud, or current; defaults to the installed profile or mac')
    parser.add_argument('--adopt', action='store_true', help='Back up unmanaged targets/settings before first adoption')
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument('--skip-tools', action='store_true', help='Check files only; useful for isolated tests')
    parser.add_argument('--write', action='store_true', help='Capture portable settings in the Git checkout')
    parser.add_argument('--backup', help='Backup ID printed by apply, for restore')
    args = parser.parse_args()
    home = args.target_home.expanduser().resolve()
    state_path = home / '.local/state/agent-env/environment.json'
    prior = json.loads(state_path.read_text()) if state_path.is_file() else {}
    skills_repo = (args.skills_repo or Path(prior.get('skills', str(REPO.parent / 'skills')))).expanduser().resolve()
    lib = engine(skills_repo)
    catalog_profiles = profiles()
    name = args.profile or prior.get('profile', 'mac')
    if name not in catalog_profiles:
        raise ValueError(f'Unknown environment profile: {name}')
    profile = catalog_profiles[name]
    if args.command == 'check':
        check(lib, skills_repo)
    elif args.command == 'restore':
        lib.restore(home, args.backup or '', args.dry_run)
        print(('Would restore ' if args.dry_run else 'Restored ') + args.backup)
    elif args.command == 'export-config':
        export_settings(home, args.write and not args.dry_run)
    elif args.command == 'doctor':
        diagnose(lib, skills_repo, home, name, profile, args.skip_tools)
    elif args.command == 'pull':
        pull([REPO, skills_repo], args.dry_run)
        if not args.dry_run:
            # Load the newly pulled implementation, rather than this process's old code.
            command = [sys.executable, str(Path(__file__).resolve()), 'apply', '--skills-repo', str(skills_repo), '--target-home', str(home), '--profile', name]
            if args.skip_tools:
                command.append('--skip-tools')
            subprocess.run(command, check=True)
    else:
        operations, _ = planned(lib, skills_repo, home, name, profile, args.adopt)
        print(('\n'.join(lib.describe(operations)) or 'Already applied') if args.dry_run else lib.summary(operations))
        if not args.dry_run:
            backup = lib.execute(home, operations)
            if backup:
                print(f'Backup: {backup.name}')
            diagnose(lib, skills_repo, home, name, profile, args.skip_tools)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError, subprocess.CalledProcessError) as error:
        print(f'Error: {error}', file=sys.stderr)
        sys.exit(1)
    except Exception as error:
        # The shared installer supplies its own Conflict type.
        if type(error).__name__ != 'Conflict':
            raise
        print(f'Error: {error}', file=sys.stderr)
        sys.exit(1)
