#!/usr/bin/env python3
"""Validate PO structure and literal translation lookups in DroneFlames."""
import argparse
from collections import Counter
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
LOCALES = {"ru": 3, "uk": 3, "en": 2, "es": 2}
FIELD = re.compile(r'(msgctxt|msgid_plural|msgid|msgstr(?:\[\d+\])?) (".*")$')
QUOTED = r'"(?:[^"\\]|\\.)*"'
EXPLICIT = re.compile(r'\bLoc\.(t|mk|f|tc|tx)\(\s*(' + QUOTED + r')')
CONTEXT = re.compile(r'\s*,\s*(' + QUOTED + r')\s*\)')
PLURAL = re.compile(r'\bLoc\.n\([^\n]+?,\s*(' + QUOTED + r'),\s*(' + QUOTED +
                    r'),\s*(' + QUOTED + r')(?:\s*,\s*(' + QUOTED + r'))?\s*\)')
WIDGET = re.compile(r'\b(?:_screen|_label|_button|_ibutton|_section|_nav_row|_selector|'
                    r'UiKit\.(?:lbl|title|big|btn))\(\s*(?:\w+(?:\.\w+)*,\s*)?(' + QUOTED + r')'
                    r'|\.(?:text|tooltip_text|placeholder_text)\s*=\s*(' + QUOTED + r')')
CYRILLIC = re.compile(r'[\u0400-\u04ff]')
PLACEHOLDER = re.compile(r'%%|%(?:[0-9+.*-]*[sdifovxXc])|\{([A-Za-z_]\w*)(?::[a-z]+)?\}')


def read_catalog(path):
    """Read regular Godot gettext entries, retaining duplicate keys and indices."""
    entries, errors = {}, []
    fields, active = {}, None
    fuzzy = False
    first_line = 1

    def finish():
        nonlocal fields, active, fuzzy
        if fields:
            if "msgid" not in fields:
                errors.append(f"{path.name}:{first_line}: entry has no msgid")
            else:
                key = fields.get("msgctxt", ""), fields["msgid"]
                if key in entries:
                    errors.append(f"{path.name}:{first_line}: duplicate key {key!r}")
                entries[key] = fields
            fuzzy = False
        fields, active = {}, None

    for number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        row = raw.strip()
        if not row:
            finish()
        elif row.startswith("#"):
            if fields:
                finish()
            if row.startswith("#,") and "fuzzy" in [flag.strip() for flag in row[2:].split(",")]:
                fuzzy = True
        else:
            match = FIELD.fullmatch(row)
            if match is not None:
                key, raw_value = match.groups()
                if key == "msgctxt" or (key == "msgid" and "msgid" in fields):
                    finish()
                if not fields:
                    first_line = number
                    if fuzzy:
                        fields["_fuzzy"] = True
                if key in fields:
                    errors.append(f"{path.name}:{number}: duplicate field {key}")
                active = key
                fields[active] = json.loads(raw_value)
            elif row.startswith('"') and active is not None:
                fields[active] += json.loads(row)
            else:
                errors.append(f"{path.name}:{number}: unsupported PO syntax")
    finish()
    return entries, errors


def placeholders(value):
    positional, named = [], Counter()
    for match in PLACEHOLDER.finditer(value):
        if match[1] is not None:
            named[match[1]] += 1
        else:
            positional.append(match[0])
    return positional, named


def structural_errors(locale, entries):
    errors = []
    header = entries.get(("", ""), {}).get("msgstr", "")
    if f"Language: {locale}\n" not in header or f"nplurals={LOCALES[locale]};" not in header:
        errors.append(f"{locale}: invalid locale header or plural count")
    for key, entry in entries.items():
        if not key[1]:
            continue
        if "msgid_plural" in entry:
            indices = {name for name in entry if name.startswith("msgstr")}
            expected = {f"msgstr[{i}]" for i in range(LOCALES[locale])}
            if indices != expected:
                errors.append(f"{locale}: wrong plural indices {key!r}")
                continue
            # Plural alternatives can have grammatically different case. Keep the
            # argument signature from the source alternative appropriate to each form.
            for index in range(LOCALES[locale]):
                text = entry[f"msgstr[{index}]"]
                src = entry["msgid"] if index == 0 else entry["msgid_plural"]
                if text and placeholders(src) != placeholders(text):
                    errors.append(f"{locale}: plural placeholders {key!r} form {index}")
        elif "msgstr" not in entry or any(name.startswith("msgstr[") for name in entry):
            errors.append(f"{locale}: invalid singular structure {key!r}")
        elif entry["msgstr"] and placeholders(entry["msgid"]) != placeholders(entry["msgstr"]):
            errors.append(f"{locale}: placeholder mismatch {key!r}")
    return errors


def source_literals(game):
    explicit, widgets = {}, {}
    for path in sorted(game.rglob("*.gd")):
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if line.lstrip().startswith("#"):
                continue
            location = f"{path.relative_to(game)}:{number}"
            for match in EXPLICIT.finditer(line):
                msgid = json.loads(match[2])
                if CYRILLIC.search(msgid):
                    rest = line[match.end():]
                    context = CONTEXT.match(rest) if match[1] in {"t", "tc"} else None
                    explicit.setdefault((json.loads(context[1]) if context else "", msgid), location)
            for match in PLURAL.finditer(line):
                msgid = json.loads(match[1])
                context = json.loads(match[4]) if match[4] else ""
                if CYRILLIC.search(msgid):
                    explicit.setdefault((context, msgid), location)
            for match in WIDGET.finditer(line):
                msgid = json.loads(match[1] or match[2])
                if CYRILLIC.search(msgid):
                    widgets.setdefault(("", msgid), location)
    return explicit, widgets


def missing(entry):
    values = [value for key, value in entry.items() if key.startswith("msgstr")]
    return entry.get("_fuzzy", False) or not values or any(not value.strip() for value in values)


def inspect(root):
    catalogs, errors = {}, []
    game = root / "game"
    files = sorted((game / "translations").glob("*.po"))
    if {path.stem for path in files} != LOCALES.keys():
        errors.append("Expected ru, uk, en and es PO catalogs")
    for path in files:
        if path.stem not in LOCALES:
            continue
        entries, problems = read_catalog(path)
        catalogs[path.stem] = {key: value for key, value in entries.items() if key[1]}
        errors.extend(problems)
        errors.extend(structural_errors(path.stem, entries))
    explicit, widgets = source_literals(game)
    summary = {"explicit_keys": len(explicit), "widget_candidates": len(widgets), "catalogs": {}}
    for locale, entries in catalogs.items():
        info = {"keys": len(entries), "empty": sum(missing(entry) for entry in entries.values())}
        if locale in {"uk", "en"}:
            for key, location in explicit.items():
                if missing(entries.get(key, {})):
                    errors.append(f"{locale}: active key missing or empty {key!r} at {location}")
            info["untranslated_widget_candidates"] = [
                {"key": key[1], "source": location}
                for key, location in widgets.items() if missing(entries.get(key, {}))]
        summary["catalogs"][locale] = info
    if {"uk", "en"} <= catalogs.keys():
        summary["catalog_structure_differences"] = {
            "uk_only": sorted(catalogs["uk"].keys() - catalogs["en"].keys()),
            "en_only": sorted(catalogs["en"].keys() - catalogs["uk"].keys()),
        }
    return errors, summary


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", type=Path, help="write the full audit, including manual candidates")
    args = parser.parse_args()
    errors, summary = inspect(ROOT)
    if args.json:
        args.json.write_text(json.dumps({"errors": errors, **summary}, ensure_ascii=False, indent=2) + "\n")
    for locale, info in summary["catalogs"].items():
        print(f"{locale}: {info['keys']} keys, {info['empty']} empty catalog entries, "
              f"{len(info.get('untranslated_widget_candidates', []))} widget candidates")
    for error in errors:
        print(error)
    print(f"{len(errors)} errors in structure or active literal lookups. "
          "Widget candidates and unused entries require manual triage.")
    return bool(errors)


if __name__ == "__main__":
    raise SystemExit(main())
