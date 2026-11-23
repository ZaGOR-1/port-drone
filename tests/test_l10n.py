"""Guard the PO contracts and exercise the localized screens in the Godot job."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from test_godot import _find_godot

from tools.check_l10n import inspect, placeholders, read_catalog

ROOT = Path(__file__).resolve().parent.parent


class LocalizationTests(unittest.TestCase):
    def test_catalogs_and_active_literal_ui(self):
        errors, report = inspect(ROOT)
        self.assertEqual(errors, [])
        for locale in ("uk", "en"):
            self.assertEqual(report["catalogs"][locale]["untranslated_widget_candidates"], [])
        self.assertGreater(report["explicit_keys"], 1000)

    def test_context_duplicates_plural_and_placeholder_order(self):
        with tempfile.TemporaryDirectory() as folder:
            fixture = Path(folder, "sample.po")
            fixture.write_text('msgctxt "button"\nmsgid "go"\nmsgstr "start"\n\n'
                               'msgid "go"\nmsgid_plural "goes"\n'
                               'msgstr[0] "go"\nmsgstr[1] "goes"\n\n'
                               'msgctxt "button"\nmsgid "go"\nmsgstr "repeat"\n', encoding="utf-8")
            entries, problems = read_catalog(fixture)
            self.assertIn("duplicate key", problems[0])
            self.assertEqual(entries[("", "go")]["msgstr[1]"], "goes")
        self.assertNotEqual(placeholders("%s %02d"), placeholders("%02d %s"))
        self.assertEqual(placeholders("{who} к {city:dat}"), placeholders("до {city:gen} {who}"))
        self.assertNotEqual(placeholders("%d%%"), placeholders("%d"))

    def test_godot_localization_screens(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest("Godot binary not available in godot_dl/ or DF_GODOT")
        with tempfile.TemporaryDirectory(prefix="df_l10n_") as directory:
            stage = Path(directory)
            shutil.copytree(ROOT / "tools/packproj", stage / "packproj")
            env = os.environ | {"DF_NO_UPDATE": "1", "DF_NO_OPENING": "1", "DF_STEAM_MOCK": "0",
                                "XDG_DATA_HOME": str(stage / "data"), "XDG_CONFIG_HOME": str(stage / "config"),
                                "XDG_CACHE_HOME": str(stage / "cache")}
            for key in ("DF_LANG", "DF_PSEUDO"):
                env.pop(key, None)
            if os.name == "nt":
                env.update(APPDATA=str(stage / "appdata"), LOCALAPPDATA=str(stage / "localappdata"))
            pck = stage / "shared.pck"
            build = subprocess.run([str(godot), "--headless", "--path", str(stage / "packproj"),
                                    "--script", "res://pack.gd", "--", str(ROOT / "game"), str(pck)],
                                   cwd=stage, env=env, capture_output=True, text=True, timeout=45)
            self.assertEqual(build.returncode, 0, build.stdout + build.stderr)
            result = subprocess.run([str(godot), "--headless", "--main-pack", str(pck),
                                     "--script", str(ROOT / "tests/test_l10n.gd")], cwd=stage,
                                    env=env, capture_output=True, text=True, timeout=50)
            logs = result.stdout + result.stderr
            if folder := os.environ.get("DF_TEST_LOG_DIR"):
                target = Path(folder)
                target.mkdir(parents=True, exist_ok=True)
                (target / "l10n.log").write_text(logs, encoding="utf-8")
            self.assertEqual(result.returncode, 0, logs)
            self.assertNotIn("SCRIPT ERROR:", logs)
            self.assertIn("L10N PASS", logs)
