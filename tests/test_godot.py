import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent


def _find_godot():
    env_bin = os.environ.get("DF_GODOT")
    if env_bin and Path(env_bin).exists():
        return Path(env_bin)
    linux_bin = ROOT / "godot_dl/godot"
    if linux_bin.exists():
        return linux_bin
    for candidate in sorted((ROOT / "godot_dl").glob("*win64_console.exe")):
        return candidate
    return None


class GodotSuiteTests(unittest.TestCase):
    def test_godot_headless_suite(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest("Godot binary not available in godot_dl/ or DF_GODOT")

        with tempfile.TemporaryDirectory(prefix="df_godot_test_") as tmp:
            work = Path(tmp)
            env = os.environ.copy()
            env.update(
                XDG_DATA_HOME=str(work / "data"),
                XDG_CONFIG_HOME=str(work / "config"),
                XDG_CACHE_HOME=str(work / "cache"),
                DF_NO_UPDATE="1",
            )
            if os.name == "nt":
                env.update(
                    APPDATA=str(work / "appdata"),
                    LOCALAPPDATA=str(work / "localappdata"),
                )
            for key in ("XDG_DATA_HOME", "XDG_CONFIG_HOME", "XDG_CACHE_HOME", "APPDATA", "LOCALAPPDATA"):
                if key in env:
                    Path(env[key]).mkdir(parents=True, exist_ok=True)

            pack = work / "game.pck"
            subprocess.run(
                [str(godot), "--headless", "--path", str(ROOT / "tools/packproj"),
                 "--script", "res://pack.gd", "--", str(ROOT / "game"), str(pack)],
                cwd=ROOT, env=env, check=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=60,
            )

            report = work / "suite.json"
            proc = subprocess.run(
                [str(godot), "--headless", "--main-pack", str(pack),
                 "--script", str(ROOT / "tests/test_godot_suite.gd"), "--", f"--out={report}"],
                cwd=ROOT, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=120,
            )
            self.assertEqual(proc.returncode, 0, f"Godot suite failed:\n{proc.stdout}")
            self.assertNotIn("SCRIPT ERROR:", proc.stdout)
            lines = proc.stdout.splitlines()
            for i, line in enumerate(lines):
                if not line.startswith("ERROR:"):
                    continue
                if any(name in line for name in ("addons/webrtc_native/", "addons/godotsteam/")):
                    continue
                if re.match(r"ERROR: \d+ resources still in use at exit", line):
                    continue
                if os.name == "nt" and 'Condition "!FileAccess::exists(path)"' in line:
                    window = "\n".join(lines[i : i + 4])
                    if "open_dynamic_library" in window and ("addons/webrtc_native/" in window or "addons/godotsteam/" in window):
                        continue
                self.fail(f"Unexpected Godot ERROR:\n{proc.stdout}")

            self.assertTrue(report.exists(), f"Missing report:\n{proc.stdout}")
            data = json.loads(report.read_text())
            self.assertTrue(data["passed"], f"Suite assertions failed: {data}")
            self.assertGreater(data["checks"], 0)


if __name__ == "__main__":
    unittest.main()
