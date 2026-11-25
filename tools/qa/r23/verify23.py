"""Check R23 coverage, unchanged fixture states and repeat comparability."""
import argparse
import hashlib
import json
from itertools import combinations
from pathlib import Path

from analyze23 import CASES, VERSIONS

FIXTURES = {
    "late-e.snapshot": "5d83751abcc0ab1cfc35141b0133b78d3982b2001dc9b2dbb8320af16131fcda",
    "long-d2100-4800.snapshot": "9f051db15acd4b90247731d6bcd694f550b946a9a114a529b02bbbb3729f19b4",
}
KEY = ("D2100", "D5000", "D5000-dense", "D2100-restore")
TARGETED = ("medium", "D2100-dense")


def read_result(root, name):
    return json.loads((root / "raw" / name / "result.json").read_text())


def verify(root, report):
    for fixture, expected in FIXTURES.items():
        assert hashlib.sha256((root / "fixtures" / fixture).read_bytes()).hexdigest() == expected, fixture

    data = json.loads(report.read_text())
    runs = data["runs"]
    names = {f"s1-{case}-v{version}" for case in CASES for version in VERSIONS}
    names |= {f"s{series}-{case}-v{version}" for series in (2, 3) for case in KEY
              for version in VERSIONS}
    names |= {f"s2-{case}-v{version}" for case in TARGETED for version in VERSIONS}
    names |= {"long-D2100-v4", "long-D2100-v11"}
    detail = {name for name in runs if name.startswith("profile-")}
    assert len(detail) == 3 and {"profile-D5000", "profile-D5000-dense"} <= detail, detail
    names |= detail
    actual = set(runs)
    assert names == actual, f"Missing runs {names - actual}; unexpected runs {actual - names}"
    for name in sorted(names):
        assert runs[name]["complete"], (name, runs[name]["reason"])
        assert runs[name]["host_samples"] and runs[name]["system_samples"], name

    for version in VERSIONS:
        d = read_result(root, f"s1-Late-E-v{version}")
        assert d["loaded_state"] and d["start_tick"] == 4650
        assert (d["initial_hash"], d["hash_after"]) == ("c3ba32fe4eed13e3", "3c338abc3ec9d5c7")
        for series in (1, 2, 3):
            d = read_result(root, f"s{series}-D2100-restore-v{version}")
            assert d["loaded_state"] and d["start_tick"] == 4800
            assert d["initial_hash"] == "1b05f1b5ed18fc7f"

    for version in (4, 11):
        name = f"long-D2100-v{version}"
        assert len(data["long"][name]) == 16
        d = read_result(root, name)
        assert d["start_tick"] == 0 and d["ticks_done"] == 4800
        assert d["initial_hash"] == "b1a480e4da8d8d82"
        assert d["hash_after"] == "1b05f1b5ed18fc7f"
        assert d["checkpoints"][-1] == [4800, "1b05f1b5ed18fc7f"]

    failures = {name: mismatch for name, mismatch in data["proof"].items() if mismatch}
    assert not failures, failures
    series = [(1, CASES), (2, KEY + TARGETED), (3, KEY)]
    expected_proof = {
        f"s{repeat}-{case}-v{left}/s{repeat}-{case}-v{right}"
        for repeat, cases in series for case in cases for left, right in combinations(VERSIONS, 2)
    }
    expected_proof.update(f"s1-{name.removeprefix('profile-')}-v11/{name}" for name in detail)
    expected_proof.add("long-D2100-v11/long-D2100-v4")
    actual_proof = set(data["proof"])
    assert actual_proof == expected_proof, (
        f"Missing comparisons {expected_proof - actual_proof}; "
        f"unexpected comparisons {actual_proof - expected_proof}"
    )
    expected = len(expected_proof)
    print(f"PASS: {len(names)} complete GUI runs, {expected} matched comparisons and historical snapshots")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("harness", type=Path, help="R23 handoff harness containing raw and fixtures")
    parser.add_argument("summary", type=Path, help="Summary JSON produced by analyze23.py")
    args = parser.parse_args()
    if not __debug__:
        parser.error("Run without -O to enable validation")
    try:
        verify(args.harness, args.summary)
    except (AssertionError, OSError, ValueError, KeyError, TypeError) as exc:
        parser.exit(1, f"R23 validation failed: {exc}\n")


if __name__ == "__main__":
    main()
