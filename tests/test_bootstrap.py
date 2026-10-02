import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

SOURCE = Path(__file__).resolve().parents[1] / 'scripts/bootstrap.py'


class BootstrapTests(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory()
        self.addCleanup(self.scratch.cleanup)
        self.root = Path(self.scratch.name).resolve()
        self.repo, self.home = self.root / 'repo', self.root / 'home'
        (self.repo / 'scripts').mkdir(parents=True)
        self.home.mkdir()
        shutil.copy2(SOURCE, self.repo / 'scripts/bootstrap.py')
        (self.repo / 'dotfiles.json').write_text(json.dumps({'.bashrc': '.bashrc', '.vimrc': '.vimrc'}))
        (self.repo / '.bashrc').write_text('repo shell config\n')
        (self.repo / '.vimrc').write_text('repo vim config\n')
        (self.repo / 'new-unlisted-directory').mkdir()

    def cli(self, *args, success=True):
        result = subprocess.run([sys.executable, str(self.repo / 'scripts/bootstrap.py'), '--target-home', str(self.home), *args], capture_output=True, text=True)
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result

    def test_conflicts_block_the_entire_installation(self):
        (self.home / '.vimrc').write_text('local config')
        self.cli(success=False)
        self.assertFalse(os.path.lexists(self.home / '.bashrc'))
        self.assertEqual((self.home / '.vimrc').read_text(), 'local config')

    def test_explicit_mapping_and_idempotence(self):
        self.cli()
        self.assertTrue((self.home / '.bashrc').is_symlink())
        self.assertFalse((self.home / 'new-unlisted-directory').exists())
        self.assertIn('Already applied', self.cli().stdout)

    def test_adoption_backs_up_files_instead_of_deleting_them(self):
        (self.home / '.vimrc').write_text('local config')
        self.cli('--adopt')
        backups = list((self.home / '.local/state/dotfiles/backups').iterdir())
        self.assertEqual(len(backups), 1)
        self.assertEqual((backups[0] / '.vimrc').read_text(), 'local config')
        self.assertEqual(backups[0].stat().st_mode & 0o777, 0o700)
        self.assertTrue((self.home / '.vimrc').is_symlink())


if __name__ == '__main__':
    unittest.main()
