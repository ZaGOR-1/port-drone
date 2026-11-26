"""Exercise the normal SP Continue discovery and restore with isolated saves."""
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


class SPContinueTests(unittest.TestCase):
    def test_recovery_copies(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest("Pinned Godot unavailable; set DF_GODOT")
        with tempfile.TemporaryDirectory(prefix="df_sp_continue_") as tmp:
            work = Path(tmp)
            env = os.environ.copy()
            env.update(DF_NO_UPDATE="1", DF_NO_OPENING="1", DF_STEAM_MOCK="0")
            logs = Path(env["DF_TEST_LOG_DIR"]).resolve() if env.get("DF_TEST_LOG_DIR") else None
            if logs is not None:
                logs.mkdir(parents=True, exist_ok=True)
                env["DF_TEST_LOG_DIR"] = str(logs)
            for key in ("XDG_DATA_HOME", "XDG_CONFIG_HOME", "XDG_CACHE_HOME", "APPDATA", "LOCALAPPDATA"):
                profile = work / key.lower()
                profile.mkdir()
                env[key] = str(profile)
            pack = work / "game.pck"
            engine = str(godot.resolve())
            build = subprocess.run(
                [engine, "--headless", "--path", str(ROOT / "tools/packproj"),
                 "--script", "res://pack.gd", "--", str(ROOT / "game"), str(pack)],
                cwd=ROOT, env=env, capture_output=True, text=True, timeout=60,
            )
            self.assertEqual(build.returncode, 0, build.stdout + build.stderr)
            run = subprocess.run(
                [engine, "--headless", "--audio-driver", "Dummy", "--main-pack", str(pack),
                 "--script", str(ROOT / "tests/test_sp_continue.gd")],
                cwd=ROOT, env=env, capture_output=True, text=True, timeout=240,
            )
            log = run.stdout + run.stderr
            if logs is not None:
                (logs / "sp-continue-pack.log").write_text(build.stdout + build.stderr)
                (logs / "sp-continue.log").write_text(log)
                shutil.copyfile(pack, logs / "sp-continue.pck")
            self.assertEqual(run.returncode, 0, log)
            self.assertNotIn("SCRIPT ERROR:", log)
            errors = [
                line for line in _unexpected_errors(log)
                if not re.match(r"^ERROR: \d+ RID allocations of type .*DummyTextureE.* were leaked at exit\.$", line)
            ]
            self.assertEqual(errors, [], log)
            report = next((line for line in log.splitlines() if line.startswith("SP_CONTINUE ")), "")
            self.assertTrue(report, log)
            result = json.loads(report.removeprefix("SP_CONTINUE "))
            self.assertGreater(result["checks"], 0)
            self.assertEqual(result["failures"], [])
