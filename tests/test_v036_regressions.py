"""Behavioral v0.36 regressions against an isolated, non-imported source PCK."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from test_godot import _find_godot
from tools.check_performance import _unexpected_errors

ROOT = Path(__file__).resolve().parent.parent


class V036RegressionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.godot = _find_godot()
        if cls.godot is None:
            raise unittest.SkipTest('Pinned Godot missing; set DF_GODOT')
        cls.tmp = tempfile.TemporaryDirectory(prefix='df_v036_')
        cls.addClassCleanup(cls.tmp.cleanup)
        cls.folder = Path(cls.tmp.name)
        cls.pack = cls.folder/'game.pck'
        cls.env = os.environ.copy()
        cls.env.update(DF_NO_UPDATE='1', DF_STEAM_MOCK='0', DF_NO_OPENING='1')
        for key in ('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','APPDATA','LOCALAPPDATA'):
            cls.env[key] = str(cls.folder/key)
            Path(cls.env[key]).mkdir()
        p = subprocess.run([str(cls.godot), '--headless', '--path', str(ROOT/'tools/packproj'),
            '--script', 'res://pack.gd', '--', str(ROOT/'game'), str(cls.pack)],
            env=cls.env, capture_output=True, text=True, timeout=90)
        if p.returncode:
            raise AssertionError(p.stdout+p.stderr)

    def run_case(self, name):
        report = self.folder/(name+'.json')
        p = subprocess.run([str(self.godot), '--headless', '--main-pack', str(self.pack),
            '--script', str(ROOT/'tests/test_v036_regressions.gd'), '--',
            '--case='+name, '--out='+str(report)], env=self.env,
            capture_output=True, text=True, timeout=120)
        log = p.stdout+p.stderr
        if self.env.get('DF_TEST_LOG_DIR'):
            logs = Path(self.env['DF_TEST_LOG_DIR']); logs.mkdir(parents=True, exist_ok=True)
            (logs/('v036-'+name+'.log')).write_text(log)
            if report.exists():
                (logs/report.name).write_bytes(report.read_bytes())
        self.assertEqual(p.returncode, 0, log)
        self.assertNotIn('SCRIPT ERROR:', log)
        self.assertEqual(_unexpected_errors(log), [], log)
        result = json.loads(report.read_text())
        self.assertTrue(result['passed'], result)
        self.assertGreater(result['checks'], 0)

    def test_autosave_isolation(self):
        self.run_case('autosave')

    def test_navy_restore_determinism(self):
        self.run_case('navy')

    def test_urban_hold_restore(self):
        self.run_case('hold')

    def test_power_priority_authorization(self):
        self.run_case('power')
