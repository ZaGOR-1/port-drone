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

**Multiplayer.** LAN and Steam transports are implemented. Both test peers should use an identical EXE/DLL set with matching SHA256 hashes. Full matches on two physical PCs and reconnect/resync still need acceptance testing. Steam uses test AppID 480. [Current QA evidence](docs/WINDOWS_QA.md)

## Development status

`main` is the stable baseline and `beta` is the development and QA branch. The current source identity is `v0.36.0 / PROTO 7 / v036-integration-1 / Save.FORMAT 1`. R02, UI and input fixes were tested together in the Windows QA package. SFX and MinGW remain a separate packaging and test path. [Project state](docs/PROJECT_STATE.md)

## Running and building on Windows

For the tracked build process, use the [Windows build guide](docs/codex/verified/BUILD_RELEASE.md). The usual build embeds the game PCK in `DroneFlames.exe` and ships three DLLs alongside it. Run the direct package with the [single-player launcher](tools/qa/Run-DroneFlames.ps1) or follow the [two-PC test plan](docs/codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md). The separate local SFX candidate unpacks its payload to a private cache. Use its exact hash and checklist from the [Windows QA record](docs/WINDOWS_QA.md).

Keep the tracked `game/.godot/` assets and the binary project configuration. Keep the updater disabled for QA and use an isolated profile. [Documentation index](docs/INDEX.md)

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
