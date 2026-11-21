[Українська](README.md) | [English](README.en.md)

# DroneFlames

**DroneFlames** is a real-time strategy game about running a country, building an economy, negotiating agreements and fighting wars on a generated map. Develop cities and production, supply your armed forces, and expand your influence through diplomacy and military action.

This repository develops an independent PC port using **Godot 4.7.2**. The target platform is **Windows 11 x64**; development uses **Ubuntu under WSL2**; earlier build results are historical.

> The current beta is for development and testing. The original code and artwork remain the property of their authors; see the usage terms below.

## Features

The current beta implements the following systems. Their presence in the code does not mean that all GUI and network testing is complete:

- **Country management:** cities, territories, political ideologies and AI opponents.
- **Economy and development:** resource extraction, production, energy, construction, and infrastructure and military upkeep.
- **Military systems:** ground forces, drones, missiles, radar and air defense.
- **Air and naval operations:** airbases, aircraft rebasing, ships, carriers, carrier-based aviation and airborne operations.
- **Nuclear systems:** a nuclear program, plutonium production, intercontinental missiles and the Zaslon anti-ballistic missile system.
- **Diplomacy:** relations, alliances, ultimatums and territorial agreements; transferring land to another human player requires their consent.
- **Seasons and presentation:** seasonal changes, weather, snow, visual effects, flags and alliance emblems.
- **Saves:** save, load and continue a match; a Chronicle of recorded snapshots rather than a full command replay.

**Multiplayer:** LAN and Steam transports are implemented. Current v0.36 compatibility, command, snapshot and hash/RNG fixtures pass CI; loopback admission does not replace a match on two PCs. A full match between two independent peers, reconnect/resync and real Steam/LAN acceptance testing are still **NOT RUN**. Both test peers must use the same exact EXE/DLL set with matching SHA256 hashes. Steam integration uses the Spacewar test AppID 480.

For current evidence and coverage limits, see the [re-onboarding audit](docs/codex/verified/REONBOARDING_AUDIT.md) and [architecture and mechanics](docs/codex/verified/ARCHITECTURE_AND_FLOWS.md). [Phase 5C results](docs/codex/verified/PHASE5C_INTEGRATION_RESULTS.md) are historical.

## Development status

- **`main`** holds the last accepted stable baseline and is kept separate from experimental development.
- **`beta`** is the active development and testing branch. The owner imported the initial snapshot into a new Git history. PR #2 restored CI and PR #4 integrated v0.36.0 with regression fixes. The PR #1–#11 series mentioned in older Phase reports belongs to the earlier history, not the current GitHub numbering. Verified branch state is recorded in [CURRENT_STATE](docs/codex/verified/CURRENT_STATE.md).
- The beta is **not a stable release**. Windows GUI and full multiplayer QA are still pending, and some features may contain bugs.

Open work includes update integrity and atomicity, save durability, general network command validation, confirmed inherited shutdown leaks and CPU regressions in early-world measurements requiring a controlled late-game profile. See the [backlog](docs/codex/verified/BACKLOG.md) and [Beta QA plan](docs/codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md).

## Running on Windows

1. Prepare an agreed beta test package, or build one using the instructions below: `DroneFlames.exe`, `DroneFlames-libs-r1.zip` and `SHA256SUMS.txt`.
2. Verify the EXE and ZIP against `SHA256SUMS.txt`. Extract the three DLLs beside the EXE. Copy [Run-DroneFlames.ps1](tools/qa/Run-DroneFlames.ps1) from this repository into the same directory.
3. Open PowerShell in the package directory and run:

```powershell
& .\Run-DroneFlames.ps1 -Mode Gui
```

The launcher disables the updater, bypasses Steam initialization, and keeps test data and logs in `test-user/` and `test-logs/` beside the build. This is a single-player launch, not a Steam test. Copy the logs before another run so you retain the previous results.

**Do not use the updater to download or replace files in this test beta.** Keep `DF_NO_UPDATE=1` and an empty updater repository in the build. Use copies of saves; loading new saves in older builds is unsupported.

Manual acceptance uses the [18 Windows scenarios](docs/codex/verified/WINDOWS_BETA_QA_CHECKLIST.md) and [LAN/Steam QA instructions](docs/codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md), with a separate [multiplayer launcher](tools/qa/Run-MultiplayerQA.ps1).

## Building from source

### Requirements

- Ubuntu under WSL2, Git and Python 3. The build scripts use the Python standard library.
- **Godot 4.7.2**: the Linux x86_64 editor and matching Windows x64 release export template.
- The three existing Windows DLLs in [libs/](libs/): GodotSteam, WebRTC and `steam_api64.dll`. A normal build does not require replacing them.
- Network access to obtain Godot if you do not already have the verified editor and template locally.

### Ubuntu / WSL2 commands

Run these from the root of a `beta` checkout:

```bash
GODOT_VERSION=4.7.2-stable python3 tools/fetch_godot.py godot_dl
python3 tools/build.py \
  --godot godot_dl/godot \
  --template godot_dl/windows_release_x86_64.exe \
  --version "$(python3 tools/build.py --print-version)" --repo "" --out dist/beta
cp libs/*.dll tools/qa/Run-*.ps1 dist/beta/
```

`--print-version` reads the checked source version, currently `0.36.0`; explicit --version asserts that value. This is a test beta, not a new stable release. Passing `--repo ""` leaves the package without an automatic update source.

[tools/build.py](tools/build.py) packs `game/` into a PCK and embeds it in the Windows EXE. The output in `dist/beta/` contains the **EXE with its embedded PCK**, the DLL ZIP, checksums and copied launchers. Follow the Windows launch steps next. Keep the tracked `game/.godot/` files: the current build depends on these imported resources.

The new beta passes CI:43 Godot/Python tests,2476 simulation checks, Windows x64 build/integrity/identity. Native Windows headless startup of the earlier PR #4 package also passed. Windows GUI, audio, GPU and full physical multiplayer QA remain **NOT RUN**; inherited shutdown leaks are open. Engine/template caches are not tracked; check local availability. See the [detailed build and QA plan](docs/codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md).

## Development and contributions

1. Update your local `beta` and create a task branch: `feature/*`, `fix/*` or `docs/*` as appropriate.
2. Make a focused change and preserve attribution for earlier work.
3. Run the relevant [checks](docs/codex/verified/TEST_MATRIX.md); for documentation, check links and the Markdown diff. Mark tests you have not run as `NOT RUN`, and unrelated checks as `N/A` with a reason.
4. After authorization to publish, open a Pull Request targeting **`beta`**. CI runs tests/builds for PRs into beta and pushes to beta/main without publishing Releases. There is no PR template; check required reviews and checks on GitHub.
5. Complete review. Promoting changes to `main` or making a stable release requires a separate decision by the repository owner.

Read [AGENTS.md](AGENTS.md) before working on the project. The [architecture](docs/codex/verified/ARCHITECTURE_AND_FLOWS.md) and [collaboration workflow](docs/codex/verified/COLLABORATION_WORKFLOW.md) provide further context. Protocol, save and deterministic simulation changes need a separate compatibility assessment.

## Credits and origins

The port derives from a DroneFlames Android closed-beta APK; the repository contains recovered GDScript and a PC adaptation. **The original game, code and artwork belong to their original authors.** The available documentation does not establish a complete list of their names.

Current independent development of the port is led by [ZaGOR-1](https://github.com/ZaGOR-1), the repository owner, and [OKREDU](https://github.com/OKREDU), a co-developer. Their work on the PC port and new mechanics does not imply authorship of the original game. The new Git history preserves the snapshot. Earlier contributions and decisions are documented in historical reports under docs/codex/verified/; old commits were deliberately not imported.

## License and usage rights

The current checkout has **no standalone LICENSE** defining a license for the game code and assets. A publicly accessible repository does not, by itself, make the whole project open source.

The original restriction still applies: **do not make derivative materials public or distribute builds without permission from the original rights holders**. Code and artwork remain the property of their authors. Bundled third-party components do not establish a license for the entire game. [PROJECT_FACTS.md](docs/codex/verified/PROJECT_FACTS.md) records the known provenance and the lack of confirmed permissions.
