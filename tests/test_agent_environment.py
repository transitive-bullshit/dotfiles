"""Test configuration preservation and Git sync through disposable checkouts."""
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import tomllib
import unittest

REPO = Path(__file__).resolve().parents[1]
SKILLS = Path(os.environ.get('AGENT_SKILLS_REPO', str(REPO.parent / 'skills'))).resolve()


def load_module(path):
    spec = importlib.util.spec_from_file_location('agent_environment_test', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def git(repo, *args):
    result = subprocess.run(['git', '-C', str(repo), '-c', 'user.name=Installer Test', '-c', 'user.email=test@example.invalid',
                             '-c', 'commit.gpgsign=false', *args], text=True, capture_output=True)
    if result.returncode:
        raise AssertionError(result.stderr)
    return result.stdout.strip()


class EnvironmentTests(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory()
        self.addCleanup(self.scratch.cleanup)
        self.root = Path(self.scratch.name).resolve()
        self.repo, self.skills, self.home = self.root / 'dotfiles', self.root / 'skills', self.root / 'home'
        (self.repo / 'scripts').mkdir(parents=True)
        (self.skills / 'scripts').mkdir(parents=True)
        self.home.mkdir()
        shutil.copy2(REPO / 'scripts/agent_env.py', self.repo / 'scripts/agent_env.py')
        shutil.copy2(SKILLS / 'scripts/skillset.py', self.skills / 'scripts/skillset.py')
        for agent, filename in [('codex', 'AGENTS.md'), ('claude', 'CLAUDE.md')]:
            directory = self.repo / 'agents' / agent
            directory.mkdir(parents=True)
            (directory / filename).write_text('Shared instructions\n')
        (self.repo / 'agents/preferences.json').write_text(json.dumps({'codex': {'model': 'repo-model', 'tui.animations': False}, 'claude': {'theme': 'light'}}))
        (self.repo / 'agents/profiles.json').write_text(json.dumps({'mac': {'skills': 'mac', 'agents': ['codex', 'claude']}, 'cloud': {'skills': 'cloud', 'agents': ['codex'], 'settings': False}}))
        self.manifest = {'version': 1, 'skills': {}, 'profiles': {'mac': {'skills': ['alpha', 'beta']}, 'cloud': {'skills': ['alpha']}}}
        for name in ['alpha', 'beta']:
            directory = self.skills / 'skills' / name
            directory.mkdir(parents=True)
            (directory / 'SKILL.md').write_text(f'---\nname: {name}\ndescription: Test\n---\n')
            self.manifest['skills'][name] = {'path': 'skills/' + name, 'origin': {'kind': 'personal'}, 'requires': []}
        (self.skills / 'skills.json').write_text(json.dumps(self.manifest))

    def cli(self, *args, success=True):
        result = subprocess.run([sys.executable, str(self.repo / 'scripts/agent_env.py'), *args,
                                 '--target-home', str(self.home), '--skip-tools'], capture_output=True, text=True)
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result

    def test_existing_configuration_is_preserved(self):
        codex = self.home / '.codex/config.toml'
        codex.parent.mkdir()
        raw = '# Important comment\nmodel = "old-model"\nsandbox_mode = "workspace-write"\n\n[projects."/local/path"]\ntrust_level = "trusted"\n\n[mcp_servers.example]\nhttp_headers = { Authorization = "test-secret-placeholder" }\n\n[tui]\nanimations = true\nstatus_line = [\n  "model",\n  "context-window"\n]\n'
        codex.write_text(raw)
        claude = self.home / '.claude/settings.json'
        claude.parent.mkdir()
        claude.write_text(json.dumps({'theme': 'dark', 'env': {'LOCAL_TOKEN': 'test-private-value'}, 'permissions': {'allow': ['Read']}}))
        self.cli('apply', '--adopt')
        expected = tomllib.loads(raw)
        expected['model'] = 'repo-model'
        expected['tui']['animations'] = False
        self.assertEqual(tomllib.loads(codex.read_text()), expected)
        self.assertIn('# Important comment', codex.read_text())
        after = json.loads(claude.read_text())
        self.assertEqual(after['env'], {'LOCAL_TOKEN': 'test-private-value'})
        self.assertEqual(after['permissions'], {'allow': ['Read']})
        self.assertEqual(after['theme'], 'light')
        self.assertTrue((self.home / '.codex/AGENTS.md').is_symlink())
        self.assertIn('Already applied', self.cli('apply').stdout)
        command = self.home / '.local/bin/agent-env'
        result = subprocess.run([str(command), 'doctor', '--target-home', str(self.home), '--skip-tools'], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_app_setting_drift_requires_capture_or_explicit_adoption(self):
        self.cli('apply')
        config = self.home / '.codex/config.toml'
        config.write_text(config.read_text().replace('repo-model', 'app-model'))
        result = self.cli('apply', success=False)
        self.assertIn('changed outside dotfiles', result.stderr)
        self.assertIn('app-model', config.read_text())
        self.assertIn('Portable setting drift', self.cli('doctor', success=False).stderr)
        self.cli('export-config', '--write')
        captured = json.loads((self.repo / 'agents/preferences.json').read_text())
        self.assertEqual(captured['codex']['model'], 'app-model')
        self.cli('apply')

    def test_export_never_includes_nonportable_values(self):
        self.cli('apply')
        path = self.home / '.claude/settings.json'
        values = json.loads(path.read_text())
        values.update({'theme': 'dark', 'env': {'TOKEN': 'do-not-export-this'}})
        path.write_text(json.dumps(values))
        result = self.cli('export-config', '--write')
        self.assertNotIn('do-not-export-this', result.stdout)
        self.assertNotIn('do-not-export-this', (self.repo / 'agents/preferences.json').read_text())

    def test_config_conflict_prevents_link_mutation(self):
        path = self.home / '.codex/config.toml'
        path.parent.mkdir()
        path.write_text('model = "existing-preference"\n')
        self.cli('apply', success=False)
        self.assertFalse((self.home / '.agents').exists())
        self.assertFalse((self.home / '.local').exists())

    def test_cloud_profile_does_not_copy_desktop_settings_or_claude(self):
        self.cli('apply', '--profile', 'cloud')
        self.assertTrue((self.home / '.codex/AGENTS.md').is_symlink())
        self.assertFalse((self.home / '.codex/config.toml').exists())
        self.assertFalse((self.home / '.claude').exists())
        self.assertFalse((self.home / '.agents/skills/beta').exists())
        self.cli('doctor')

    def test_multiline_toml_and_unmanaged_tables_survive(self):
        module = load_module(self.repo / 'scripts/agent_env.py')
        raw = 'model = "old"\n[tui]\nstatus_line = [\n "one",\n "two"\n]\n[other]\ntext = """\na long string\nwith lines\n"""\n'
        result = module.patch_toml(raw, {'model': 'new', 'tui.status_line': ['new'], 'tui.animations': False})
        expected = tomllib.loads(raw)
        expected['model'] = 'new'
        expected['tui']['status_line'] = ['new']
        expected['tui']['animations'] = False
        self.assertEqual(tomllib.loads(result), expected)

    def test_nonportable_setting_cannot_be_added_to_source(self):
        path = self.repo / 'agents/preferences.json'
        path.write_text(json.dumps({'codex': {'mcp_servers.secret.http_headers': {'Authorization': 'secret'}}}))
        self.assertIn('Unsupported portable setting', self.cli('check', success=False).stderr)


class GitSyncTests(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory()
        self.addCleanup(self.scratch.cleanup)
        self.root = Path(self.scratch.name).resolve()
        self.module = load_module(REPO / 'scripts/agent_env.py')
        self.repos, self.writers = [], []
        for name in ['dotfiles', 'skills']:
            remote, writer, reader = self.root / (name + '.git'), self.root / (name + '-writer'), self.root / name
            remote.mkdir()
            git(remote, 'init', '--bare', '--initial-branch=main')
            git(self.root, 'clone', str(remote), str(writer))
            (writer / 'file.txt').write_text('baseline\n')
            git(writer, 'add', '.')
            git(writer, 'commit', '-m', 'Baseline')
            git(writer, 'push', '-u', 'origin', 'main')
            git(self.root, 'clone', str(remote), str(reader))
            self.repos.append(reader)
            self.writers.append(writer)

    def advance(self, index):
        writer = self.writers[index]
        (writer / 'remote.txt').write_text('new shared content\n')
        git(writer, 'add', '.')
        git(writer, 'commit', '-m', 'Shared change')
        git(writer, 'push')

    def test_fast_forwards_both_checkouts(self):
        for index in range(2):
            self.advance(index)
        self.module.pull(self.repos)
        for repo in self.repos:
            self.assertEqual((repo / 'remote.txt').read_text(), 'new shared content\n')

    def test_dirty_second_checkout_prevents_first_update(self):
        self.advance(0)
        before = git(self.repos[0], 'rev-parse', 'HEAD')
        (self.repos[1] / 'file.txt').write_text('local changes\n')
        with self.assertRaisesRegex(ValueError, 'Uncommitted changes'):
            self.module.pull(self.repos)
        self.assertEqual(git(self.repos[0], 'rev-parse', 'HEAD'), before)
        self.assertEqual((self.repos[1] / 'file.txt').read_text(), 'local changes\n')

    def test_diverged_second_checkout_prevents_first_update(self):
        for index in range(2):
            self.advance(index)
        local = self.repos[1]
        (local / 'local.txt').write_text('Local commit\n')
        git(local, 'add', '.')
        git(local, 'commit', '-m', 'Local commit')
        before = [git(repo, 'rev-parse', 'HEAD') for repo in self.repos]
        with self.assertRaisesRegex(ValueError, 'Diverged checkout'):
            self.module.pull(self.repos)
        self.assertEqual([git(repo, 'rev-parse', 'HEAD') for repo in self.repos], before)


if __name__ == '__main__':
    unittest.main()
