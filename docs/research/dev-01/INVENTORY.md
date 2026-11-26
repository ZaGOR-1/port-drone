# Інвентар середовища · 2026-11-23

> Історичний матеріал з `toolchain/dev-environment/docs/INVENTORY.md`. [Реєстр досліджень](../INDEX.md)

| Клас | Матеріали | Джерело / відновлення |
| --- | --- | --- |
| CRITICAL | Production `beta` `c91e0e6a7eef831687e6e63550560bba739a6b87`, `main` `172df65e3bd004efed9a5444e90a284d9d69db10`, tracked `game/.godot`, CI, Python build/QA, Windows DLL | GitHub refs підтверджені через `ls-remote`. Локальна `beta` чиста; локальної `main` не було, bundle зберігає `origin/main`. У Git 39 доступних commits, tags, stash, submodules та LFS pointers не виявлені. `git-snapshot/` для автономного відновлення. |
| CRITICAL | Detached `performance/source`, base `c91e0e6…`, 11 tracked edits, 4 untracked probes | Essential. `staged.patch`, `unstaged.patch`, `untracked/`, `worktree.json` з mode/хешами. Окремо збережено історичні `R01_DIAGNOSTICS.patch` і `R02_DIAGNOSTICS.patch`. |
| CRITICAL | R01/R02 runner, scripts, сценарії та документація, сирі JSON/CSV, логи, synthetic saves, `e-long/state.snapshot`, пакети R01, R02, R02 LAN | Essential. `performance/`; дані локальні, старі архіви їх не містять. Сценарні `input.save` збігаються з двома synthetic saves, а `slot_1.save` під checkpoints є копіями тих самих fixtures. |
| CRITICAL | Patched Godot Release/QA, C++ diff, pinned build manifest, SCons/sh configs, logs та fixtures | Essential. Старий архів містить більшість цього набору. Extended додає pinned upstream shallow Git store і ANGLE/AccessKit ZIP із notices. |
| IMPORTANT | Official Linux editor, Official Windows template, `df-windows`, builds/profile manifests, CI pin і verifier, пакети з DLL, SFX launcher/packager/кандидати/докази | Essential. Офіційні pins в GitHub, локальні пакети й tooling поза game repo. Попередня копія містить engine, patched package і один SFX кандидат; відсутні локальні доповнення вказані в JSON. |
| IMPORTANT | Godot MCP Linux binary, shadow і addon, конвертер і launcher, шаблони Codex/VS Code | Essential. `godot-shadow` включено для локальних sidecar/addon. Перевстановлення решти MCP за [інструкцією](CODEX_MCP.md). |
| REGENERABLE | Godot object/cache ~4 ГБ, розпаковані ANGLE/AccessKit, POSIX symlinks, staging copies, Python cache | Відновлюються з pinned source/patch, dependency ZIP і системних пакетів. `backup-layout.json` фіксує рішення про виключення. |
| OPTIONAL | Попередній editor shadow ~106 МіБ, повторні копії QA, драйвери, архівна збірка `windows-build-c91e0e6.3lBIJY` | QA package/logs контрольної збірки в Extended. Старий shadow і повторні Wine-run cache залишилися на диску. |
| SECRET | SSH keys, Codex auth/session/history і config з довільними значеннями, VS Code history/storage, браузерні cookie, Wine/Steam профілі, приватні saves та `account.bin` | Облікові записи відновити повторним входом або з приватного зашифрованого сховища. Класифікацію виконано за шляхами, без виведення значень секретів. |

## Вміст і дати попередньої копії

Перевірено історичні `toolchain.tar.zst` і `portable-sfx.tar.zst` за їхнім SHA256SUMS. Перший містить `official-4.7.2`, `mingw-patched` і частину `windows-dev`. Другий доповнює `df-windows`, SFX tooling і кандидат `ubuntu-20261123`. Git bundle, діагностичні дані R01/R02 і shadow support були відсутні. R01/R02 evidence і наступні SFX артефакти з'явилися після копії. Детальний список розмірів, SHA256, перетину за вмістом і mtime після попередньої копії наведено в `manifests/backup-inventory.json`. `mtime` відображає час модифікації, а не гарантовану дату створення.

До копіювання перевірено allowlist, типи файлів, сигнатури секретів у текстових логах/JSON/поточному diff, походження synthetic saves і склад R02 snapshot за runner/сценарієм. У raw evidence збережено локальні шляхи та технічні метрики. Бінарні fixtures прийняті як локально згенеровані за runner і provenance, без заяви про повний семантичний аудит. Каталоги Wine профілів лишилися зовні.

## Платформи й дані гри

Ubuntu — Bash, Python, Git, Node/npm, uv, SCons, MinGW x64 POSIX, Wine x64, Godot Linux editor і графічний стек. Windows 11 — PowerShell, Git, Python, Node/npm/Codex, Godot Windows editor, Windows x64 template і DLL; C++ workload та SDK для нативних задач. Версії, профілі та GDExtension targets у manifest (`../manifests/environment.json`). Linux ELF editor, Bash launchers, Wine prefixes і `/proc`-збір метрик потребують платформного еквіваленту на Windows. Windows PE та DLL можуть використовуватись через Wine.

Гра зберігає `user://saves/slot_1.save`, `user://settings.cfg`, `user://pc_port.cfg` та `user://account.bin`. Windows шлях — `%APPDATA%\Godot\app_userdata\DroneFlames`; Wine — `$WINEPREFIX/drive_c/users/<user>/AppData/Roaming/Godot/app_userdata/DroneFlames`; Linux shadow — відповідний ізольований `XDG_DATA_HOME/godot/app_userdata/`. SFX cache окремий від даних гри.
