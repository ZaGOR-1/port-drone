"""Regression coverage for STABILITY-01 MP checkpoint write and retry failures."""
import json
import os
from pathlib import Path
import re
import shutil
import socket
import subprocess
import sys
import tempfile
import unittest

from test_godot import _find_godot
from tools.check_performance import _unexpected_errors

ROOT = Path(__file__).resolve().parent.parent


def _limit_write(command, limit):
    # The limit applies only to the isolated Godot child. Capture through a
    # pipe so the limit does not truncate the diagnostic log.
    code = (
        "import os, resource, signal, sys;"
        "limit = int(sys.argv[1]);"
        "resource.setrlimit(resource.RLIMIT_FSIZE, (limit, limit));"
        "signal.signal(signal.SIGXFSZ, signal.SIG_IGN);"
        "os.execv(sys.argv[2], sys.argv[2:])"
    )
    return [sys.executable, "-c", code, str(limit), *command]


class MPCheckpointTests(unittest.TestCase):
    def test_transaction_and_retry(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest("Pinned Godot unavailable; set DF_GODOT")
        godot = godot.resolve()
        with tempfile.TemporaryDirectory(prefix="df_mp_checkpoint_") as tmp:
            work = Path(tmp)
            env = os.environ.copy()
            env.update(DF_NO_UPDATE="1", DF_NO_OPENING="1", DF_STEAM_MOCK="0")
            pack = work / "game.pck"
            result = subprocess.run(
                [str(godot), "--headless", "--path", str(ROOT / "tools/packproj"),
                 "--script", "res://pack.gd", "--", str(ROOT / "game"), str(pack)],
                cwd=work, env=env, capture_output=True, text=True, timeout=60,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            logs = Path(env["DF_TEST_LOG_DIR"]) if env.get("DF_TEST_LOG_DIR") else None
            if logs is not None:
                logs.mkdir(parents=True, exist_ok=True)
                (logs / "mp-checkpoint-pack.log").write_text(result.stdout + result.stderr)
                shutil.copyfile(pack, logs / "mp-checkpoint.pck")
            for case in ("seed", "short-write", "short-tail", "retry", "review", "publish", "resume"):
                with self.subTest(case=case):
                    if case in ("short-write", "short-tail") and sys.platform != "linux":
                        self.skipTest("RLIMIT_FSIZE short-write injection is Linux-only")
                    profile = work / (case if case in ("retry", "resume") else "transaction")
                    for key in ("XDG_DATA_HOME", "XDG_CONFIG_HOME", "XDG_CACHE_HOME", "APPDATA", "LOCALAPPDATA"):
                        directory = profile / key.lower()
                        directory.mkdir(parents=True, exist_ok=True)
                        env[key] = str(directory)
                    command = [
                        str(godot), "--headless", "--audio-driver", "Dummy",
                        "--main-pack", str(pack), "--script", str(ROOT / "tests/test_mp_checkpoint.gd"),
                        "--", case,
                    ]
                    if case == "short-write":
                        command = _limit_write(command, 32768)
                    if case == "short-tail":
                        checkpoint = next(profile.rglob("net_match.save"), None)
                        self.assertIsNotNone(checkpoint, "legacy checkpoint was not written")
                        command = _limit_write(command, checkpoint.stat().st_size - 1)
                    if case == "resume":
                        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
                            sock.bind(("127.0.0.1", 0))
                            command.append(str(sock.getsockname()[1]))
                    result = subprocess.run(
                        command,
                        cwd=work, env=env, capture_output=True, text=True, timeout=120,
                    )
                    output = result.stdout + result.stderr
                    if logs is not None:
                        (logs / f"mp-checkpoint-{case}.log").write_text(output)
                        for checkpoint in profile.rglob("net_match.save"):
                            if checkpoint.is_file():
                                shutil.copyfile(checkpoint, logs / f"mp-checkpoint-{case}.save")
                    self.assertEqual(result.returncode, 0, output)
                    self.assertNotIn("SCRIPT ERROR:", output)
                    unexpected = [
                        line for line in _unexpected_errors(output)
                        if not re.match(r"^ERROR: \d+ RID allocations of type .*DummyTextureE.* were leaked at exit\.$", line)
                    ]
                    self.assertEqual(unexpected, [], output)
                    report = next((line for line in output.splitlines() if line.startswith("MP_CHECKPOINT ")), "")
                    self.assertTrue(report, output)
                    data = json.loads(report.removeprefix("MP_CHECKPOINT "))
                    self.assertEqual(data["case"], case)
                    self.assertGreater(data["checks"], 0)
                    self.assertEqual(data["failures"], [])
