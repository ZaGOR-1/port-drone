"""Build and source must advertise the same simulation compatibility identity."""
from pathlib import Path
import re
import subprocess
import sys
import unittest

ROOT = Path(__file__).resolve().parent.parent


class BuildIdentityTests(unittest.TestCase):
    def test_print_source_version_without_engine(self):
        p = subprocess.run([sys.executable, str(ROOT/'tools/build.py'), '--print-version'],
                           capture_output=True, text=True, cwd=ROOT)
        self.assertEqual(p.returncode, 0, p.stderr)
        self.assertEqual(p.stdout.strip(), '0.36.4')

    def test_runtime_updater_and_simulation_revision(self):
        cfg = (ROOT/'game/pc/version.cfg').read_text()
        self.assertRegex(cfg, r'(?m)^version="0\.36\.4"$')
        net = (ROOT/'game/net/net_config.gd').read_text()
        self.assertIn('const SIM_REV: String = "v036-integration-1"', net)
        self.assertIn('const PROTO: int = 7', net)
        menus = (ROOT/'game/ui/menus.gd').read_text()
        self.assertIn('const VERSION: String = "v0.36.4"', menus)
        workflow = (ROOT/'.github/workflows/build.yml').read_text()
        self.assertNotRegex(workflow, r'(?m)^  BUILD_VERSION:')
        self.assertIn('python3 tools/build.py --print-version', workflow)

    def test_explicit_mismatched_version_fails_before_build(self):
        p = subprocess.run([sys.executable, str(ROOT/'tools/build.py'),
                            '--godot', 'must-not-run', '--template', 'must-not-read',
                            '--version', '0.34.0'], capture_output=True, text=True, cwd=ROOT)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn('must match source version', p.stderr)
