"""Functional snapshot guards; retain injected-error and known shutdown diagnostics separately."""
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


class SnapshotRestoreTests(unittest.TestCase):
    def test_failure_matrix_and_real_loader(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest("Pinned Godot unavailable; set DF_GODOT")
        with tempfile.TemporaryDirectory(prefix="df_snapshot_test_") as tmp:
            work = Path(tmp)
            env = os.environ.copy()
            env.update(DF_NO_UPDATE="1", DF_STEAM_MOCK="0", DF_NO_OPENING="1")
            for key in ("XDG_DATA_HOME", "XDG_CONFIG_HOME", "XDG_CACHE_HOME", "APPDATA", "LOCALAPPDATA"):
                env[key] = str(work / key.lower())
                Path(env[key]).mkdir()
            pack = work / "game.pck"
            proc = subprocess.run(
                [str(godot), "--headless", "--path", str(ROOT / "tools/packproj"),
                 "--script", "res://pack.gd", "--", str(ROOT / "game"), str(pack)],
                cwd=ROOT, env=env, capture_output=True, text=True, timeout=60,
            )
            self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
            scenarios = (
                ("test_snapshot_restore", ()),
                ("test_snapshot_restore_integration", ()),
                ("test_snapshot_restore_integration", ("--fault=disk",)),
            )
            for name, args in scenarios:
                label = "test_disk_restore_recovery" if args else name
                with self.subTest(fixture=label):
                    report = work / (label + ".json")
                    proc = subprocess.run(
                        [str(godot), "--headless", "--main-pack", str(pack),
                         "--script", str(ROOT / "tests" / (name + ".gd")), "--", f"--out={report}", *args],
                        cwd=ROOT, env=env, capture_output=True, text=True, timeout=180,
                    )
                    log = proc.stdout + proc.stderr
                    if env.get("DF_TEST_LOG_DIR"):
                        logs = Path(env["DF_TEST_LOG_DIR"])
                        logs.mkdir(parents=True, exist_ok=True)
                        (logs / (label + ".log")).write_text(log)
                        if report.exists():
                            shutil.copyfile(report, logs / report.name)
                    self.assertEqual(proc.returncode, 0, log)
                    self.assertTrue(report.exists(), log)
                    data = json.loads(report.read_text())
                    self.assertTrue(data["passed"], data)
                    self.assertNotIn("SCRIPT ERROR:", log)
                    unexpected = _unexpected_errors(log)
                    post_errors = [line for line in unexpected if line == "ERROR: R02_INJECTED_POST_LOAD_FAILURE"]
                    self.assertEqual(len(post_errors), data.get("expected_post_load_errors", 0), log)
                    unexpected = [line for line in unexpected if line not in post_errors]
                    if name == "test_snapshot_restore_integration":
                        # Deliberately malformed Variants and the already known dummy-renderer exit leak.
                        known = (r'^ERROR: Condition "count < 0 \|\| count > len"',
                                 r'^ERROR: Error when trying to decode Variant\.$',
                                 r'^ERROR: Condition "\(header & 0xFF\) >= Variant::VARIANT_MAX"',
                                 r'^ERROR: \d+ RID allocations of type .*DummyTextureE.* were leaked at exit\.$')
                        unexpected = [line for line in unexpected if not any(re.search(p, line) for p in known)]
                    self.assertEqual(unexpected, [], log)
