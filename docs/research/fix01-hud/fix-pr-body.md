> Історичний матеріал з `fix01-qa.6S6Ygb/fix-pr-body.md`. [Реєстр досліджень](../INDEX.md)

## Problem and scope

Native Windows QA of PR #7 reported an overflowing army HUD, Settings wheel events zooming the map, and rapid LMB clicks changing camera position or zoom. The same controlled input and layout playback exposed the three defects on production beta and the tested PR #7 revision. This independent fix targets beta.

- Fit the army group editor and popovers to the visible viewport and keep their actions reachable by scrolling.
- Keep wheel and trackpad gestures owned by GUI controls out of the map camera.
- Restrict double-tap zoom to touch, clear desktop press state on a consumed release, and preserve world selection, dragging and order dispatch.
- Add a Godot regression fixture using real viewport event dispatch.

## Commits

- `86de54b` — fit army panels within viewport bounds
- `a0c33d7` — isolate GUI scroll and desktop mouse gestures
- `c59457f` — assert reachable army actions and applied orders
- `56b0d20` — record FIX-01 evidence and Windows acceptance checks

## Verified

- Regression fixture: 36/36. Simulation: 2476/2476. Existing keyboard, scale, and Windows UI fixtures: 130/130, 26/26, and 20/20.
- Ubuntu rendered QA of Settings, group editor and army context, with uk/ru/en and UI scales of 70%, 100%, 130%.
- Official Windows x64 build and package integrity PASS. Wine headless startup and graphical startup to the Ukrainian main menu both exited 0.
- Windows package built from `a0c33d7`, matching this PR's `game/` tree `d0fcbd205a2cf997b0ab7bef04916bb72e180070`. ZIP SHA256 `422ae4426a9ee5dd5420a0d8e265e0b6d8c911de51efab63773f096ccaee3c6c`. Version `0.36.0`.

[Bug analysis](https://github.com/ZaGOR-1/port-drone/blob/56b0d205060fc6902a52866e3e237aef1b3886df/docs/FIX01_BUG_ANALYSIS.md) · [HUD layout](https://github.com/ZaGOR-1/port-drone/blob/56b0d205060fc6902a52866e3e237aef1b3886df/docs/FIX01_HUD_LAYOUT.md) · [Input](https://github.com/ZaGOR-1/port-drone/blob/56b0d205060fc6902a52866e3e237aef1b3886df/docs/FIX01_INPUT_HANDLING.md) · [Regression tests](https://github.com/ZaGOR-1/port-drone/blob/56b0d205060fc6902a52866e3e237aef1b3886df/docs/FIX01_REGRESSION_TESTS.md) · [Windows checklist](https://github.com/ZaGOR-1/port-drone/blob/56b0d205060fc6902a52866e3e237aef1b3886df/docs/FIX01_WINDOWS_QA.md)

GitHub CI passed both jobs. [CI and QA artifacts](https://github.com/ZaGOR-1/port-drone/actions/runs/45289902816)

## Remaining QA and integration risk

**CONDITIONAL.** Retest on native Windows with the reported PC configuration, DPI 100/125/150%, actual wheel and mouse input, and resize. End-to-end physical Windows GUI acceptance remains open. Input, simulation and package checks do not substitute for that gate. No protocol, save format, RNG, NetHash, simulation rules or localization changes.

The [original Windows report on PR #7](https://github.com/ZaGOR-1/port-drone/pull/7#issuecomment-7116888734) also records slowdown above approximately 200 OTRK targets for PERF-01.
