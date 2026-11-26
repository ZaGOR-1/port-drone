# DroneFlames FIX-01

> Історичний матеріал з `fix01-qa.6S6Ygb/EVIDENCE.md`. [Реєстр досліджень](../INDEX.md)

- Draft PR #8 targets beta: https://github.com/ZaGOR-1/port-drone/pull/8
- Branch HEAD: `56b0d205060fc6902a52866e3e237aef1b3886df`.
- Build source: `a0c33d76cdb52b3b667855220b2d6bee0a01d253`. Both commits contain game tree `d0fcbd205a2cf997b0ab7bef04916bb72e180070`.
- `baseline-headless.log` and `pr7-headless.log` — expected regression failures in beta and the PR #7 Windows QA source.
- `ci-fixtures-final/hud-camera-input.json` — targeted headless fixture. `keyboard_controls.json`, `ui_scale.json`, `windows_ui.json`, `simulation/regression.json` — regression reports.
- `native-gui-final.json` and `gui-final/` — successful Ubuntu X11 playback and screenshots. `gui-acceptance/group-uk-1280-actions.png` shows scrolled actions. The extended capture attempt reached ru and timed out; its partial evidence is retained.
- `linux-runtime-headless.log` and `wine-smoke.log` — release runtime startup exit 0. `linux-runtime-smoke.log` — graphical release startup attempt hit its timeout. Targeted Ubuntu GUI playback uses the official editor with the candidate pack.
- `windows-package/` — verified portable Windows x64 ZIP and archive checksum. `BUILD_PROVENANCE.json` inside the package records engine pins and exe/DLL digests.
- `fix01-commits.patch` and `full-source-and-docs.diff` — inspectable patches for the published branch.
- Native Windows GUI after the fixes and physical Windows DPI are NOT RUN.

- GitHub CI PASS: https://github.com/ZaGOR-1/port-drone/actions/runs/45289902816. Job and artifact metadata in `github-ci-final.json` and `github-ci-artifacts.json`.
- `wine-gui-smoke.log` and `gui-final/wine-launch.png` record the Ukrainian main menu on the official Windows binary under Wine, exit 0.
