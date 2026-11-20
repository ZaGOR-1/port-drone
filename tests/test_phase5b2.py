"""Gameplay wiring, cooldown persistence, cancellation and lazy upkeep regressions."""
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest
from test_godot import _find_godot
from tools.check_performance import _unexpected_errors

ROOT = Path(__file__).resolve().parent.parent

class Phase5B2Tests(unittest.TestCase):
    def run_fixtures(self, fixtures):
        godot = _find_godot()
        if godot is None:
            self.skipTest('Pinned Godot unavailable; set DF_GODOT')
        with tempfile.TemporaryDirectory(prefix='df_phase5b2_') as tmp:
            folder = Path(tmp)
            env = os.environ.copy()
            env.update(DF_NO_UPDATE='1', DF_STEAM_MOCK='0', DF_NO_OPENING='1')
            for key in ('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','APPDATA','LOCALAPPDATA'):
                env[key] = str(folder / key.lower())
                Path(env[key]).mkdir()
            pack = folder / 'game.pck'
            p = subprocess.run([str(godot),'--headless','--path',str(ROOT/'tools/packproj'),
                '--script','res://pack.gd','--',str(ROOT/'game'),str(pack)],
                cwd=ROOT, env=env, capture_output=True, text=True, timeout=60)
            self.assertEqual(p.returncode,0,p.stdout+p.stderr)
            for label, script, arguments in fixtures:
                with self.subTest(case=label):
                    report = folder/(label+'.json')
                    p = subprocess.run([str(godot),'--headless','--main-pack',str(pack),
                        '--script',str(ROOT/'tests'/script),'--','--out='+str(report)]+arguments,
                        cwd=ROOT,env=env,capture_output=True,text=True,timeout=180)
                    log = p.stdout+p.stderr
                    if env.get('DF_TEST_LOG_DIR'):
                        logs = Path(env['DF_TEST_LOG_DIR']); logs.mkdir(parents=True,exist_ok=True)
                        (logs/(label+'.log')).write_text(log)
                        if report.exists(): shutil.copyfile(report,logs/report.name)
                    self.assertEqual(p.returncode,0,log)
                    self.assertNotIn('SCRIPT ERROR:',log)
                    unexpected = [x for x in _unexpected_errors(log) if not re.match(
                        r'^ERROR: \d+ RID allocations of type .*DummyTextureE.* were leaked at exit\.$',x)]
                    self.assertEqual(unexpected,[],log)
                    self.assertTrue(report.exists(),log)
                    result=json.loads(report.read_text())
                    self.assertTrue(result['passed'],result)
                    self.assertGreater(result['checks'],0)

    def test_gameplay_integration(self):
        self.run_fixtures([(c,'test_phase5b2_gameplay.gd',['--case='+c]) for c in ['05','06','07R','07A']])

    def test_upkeep_fallback(self):
        self.run_fixtures([('upkeep','test_upkeep_fallback.gd',[])])
