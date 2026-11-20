"""Gemini G01 reviewed: run the actual GDScript, not a duplicate Python cleanup model."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from test_godot import _find_godot
from tools.check_performance import _unexpected_errors
ROOT = Path(__file__).resolve().parent.parent

class UpdaterCleanupTests(unittest.TestCase):
    def test_real_cleanup_in_isolated_directories(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest('Pinned Godot missing; set DF_GODOT')
        with tempfile.TemporaryDirectory(prefix='df_updater_') as tmp:
            folder = Path(tmp)
            env = os.environ.copy()
            env.update(DF_NO_UPDATE='1', DF_STEAM_MOCK='0', DF_NO_OPENING='1')
            for key in ('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','APPDATA','LOCALAPPDATA'):
                env[key] = str(folder/key.lower()); Path(env[key]).mkdir()
            pack = folder/'game.pck'
            p = subprocess.run([str(godot),'--headless','--path',str(ROOT/'tools/packproj'),
                '--script','res://pack.gd','--',str(ROOT/'game'),str(pack)],env=env,cwd=ROOT,capture_output=True,text=True,timeout=60)
            self.assertEqual(p.returncode,0,p.stdout+p.stderr)
            report=folder/'cleanup.json'
            p=subprocess.run([str(godot),'--headless','--main-pack',str(pack),'--script',str(ROOT/'tests/run_updater_cleanup.gd'),
                '--','--suite='+str(ROOT/'tests/test_updater_cleanup.gd'),'--root='+str(folder/'fixture'),'--out='+str(report)],
                env=env,cwd=ROOT,capture_output=True,text=True,timeout=120)
            log=p.stdout+p.stderr
            if env.get('DF_TEST_LOG_DIR'):
                logs=Path(env['DF_TEST_LOG_DIR']);logs.mkdir(parents=True,exist_ok=True)
                (logs/'updater_cleanup.log').write_text(log)
                if report.exists():shutil.copyfile(report,logs/report.name)
            self.assertEqual(p.returncode,0,log)
            self.assertNotIn('SCRIPT ERROR:',log)
            self.assertEqual(_unexpected_errors(log),[],log)
            data=json.loads(report.read_text())
            self.assertTrue(data['passed'],data)
            self.assertGreater(data['checks'],0)
            if os.name != 'nt':self.assertEqual(data['skipped'],[],data)
