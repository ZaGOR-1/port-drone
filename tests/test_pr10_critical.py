"""Run critical regressions against a fresh PCK and an isolated user directory."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

from test_godot import _find_godot
from tools.check_performance import _unexpected_errors


ROOT = Path(__file__).resolve().parent.parent


class Pr10CriticalTests(unittest.TestCase):
    def test_critical_gameplay_transitions(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest("Pinned Godot unavailable; set DF_GODOT")
        with tempfile.TemporaryDirectory(prefix="df_pr10_critical_") as tmp:
            work = Path(tmp)
            env = os.environ.copy()
            env.update(DF_NO_UPDATE="1", DF_STEAM_MOCK="0")
            for key in ("XDG_DATA_HOME", "XDG_CONFIG_HOME", "XDG_CACHE_HOME", "APPDATA", "LOCALAPPDATA"):
                env[key] = str(work / key.lower())
                Path(env[key]).mkdir()
            pack = work / "game.pck"
            result = subprocess.run(
                [str(godot), "--headless", "--path", str(ROOT / "tools/packproj"),
                 "--script", "res://pack.gd", "--", str(ROOT / "game"), str(pack)],
                cwd=ROOT, env=env, capture_output=True, text=True, timeout=60,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            report = work / "critical.json"
            result = subprocess.run(
                [str(godot), "--headless", "--main-pack", str(pack),
                 "--script", str(ROOT / "tests/test_pr10_critical.gd"), "--", f"--out={report}"],
                cwd=ROOT, env=env, capture_output=True, text=True, timeout=120,
            )
            log = result.stdout + result.stderr
            self.assertEqual(result.returncode, 0, log)
            self.assertNotIn("SCRIPT ERROR:", log)
            self.assertEqual(_unexpected_errors(log), [], log)
            self.assertTrue(report.exists(), log)
            data = json.loads(report.read_text())
            self.assertTrue(data["passed"], data)
            self.assertGreater(data["checks"], 0)
