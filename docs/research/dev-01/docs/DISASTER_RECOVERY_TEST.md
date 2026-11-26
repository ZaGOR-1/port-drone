# Disaster Recovery Test · 2026-11-23

> Історичний матеріал з `toolchain/dev-environment/docs/DISASTER_RECOVERY_TEST.md`. [Реєстр досліджень](../../INDEX.md)

**PASS — Essential і Extended відновлено на Ubuntu 26.04.1 x86_64.** Обидва старти виконано з порожніх каталогів з пробілами в шляху. Використано тільки нові архіви, bootstrap із того самого backup та встановлені базові програми. Поточні Git worktrees не були джерелом файлів під час відновлення.

| Перевірка | Результат |
| --- | --- |
| Цілісність двох архівів і відновлених даних | PASS. SHA256 bootstrap і обох архівів. 1 800 відновлених файлів звірено за розміром, mode та SHA256. |
| Git і worktree | PASS. Bundle verify, повний fsck, чиста `beta` `c91e0e6a…`, `main` `172df65e…`, detached HEAD тієї самої `beta`, точний staged/unstaged diff, 11 модифікованих і 4 untracked. Relative worktree links діють після переносу в кінцевий каталог. |
| Patched/official Godot | PASS. SHA256 офіційного редактора, шаблону, patched Release/QA і C++ patch збігаються з source manifests. Extended містить shallow upstream `ed1daf0bf001b61586d9930840f2f1394092c079`, fsck і `git apply --check` пройшли. |
| `df-windows` і Windows packages | PASS. Обидва збережені профілі пройшли `run --check`. У відновленому каталозі нове пакування `build --template patched` без `--source` зібрало EXE із тим самим SHA256 `f2bffeb0e9ef6bb4cbc7ef003387f73dde7873a75382144a04e9175853853515`. Перевірено PE/PCK, DLL та identity. |
| SFX | PASS. Launcher source і packager збіглися за інвентарним SHA256. Обидва готові EXE пройшли `package_sfx.py verify`, включно з launcher і чотирма вбудованими компонентами. Нове SFX пакування й GUI **NOT RUN**. |
| Performance evidence | PASS. SHA256 пакетів R01, R02 і R02 LAN, `core-artifacts.sha256`, включно з `e-long/state.snapshot`. Обидва runner `--help` і summary replay пройшли. R01 `summary.json` та R02 `profiles.json` побайтово збіглися з архівом. Запуск ігрового snapshot, stress і LAN **NOT RUN**. |
| Безпека restore та release-тести | PASS. 4/4 тести restore, 15/15 Python release-тестів із відновленої `beta`, `build.py --print-version` → `0.36.0`. |
| Ubuntu setup/check | PASS з каталогом Wine у PATH. `--dry-run`, версії інструментів, apt packages, Godot і виявлення MCP за конфігом. `wineserver` встановлений під `/usr/lib/x86_64-linux-gnu/wine`. Початкова перевірка виявила його відсутність у PATH; після додавання каталогу повтор пройшов. |
| Повторна компіляція Godot | PASS для вихідного дерева, pinned dependency ZIP і `scons -n` preflight у фізичній копії **без пробілів**. SCons у каталозі з пробілами повернув `Invalid target platform "windows"`. Повна компіляція **NOT RUN**. |
| Godot MCP | PASS для відновленого launcher, stdio handshake, 33 інструментів і `project_info` у новій папці. Розширений offline smoke **PARTIAL**: `script_check` повідомив про відсутні Linux GDExtension, продовження вийшло за 60 с. Імпорт відбувався лише у відновленому фізичному shadow. |
| Windows 11 | PASS для PowerShell 7.7.0 parser обох скриптів і `setup-windows.ps1 -DryRun` під Ubuntu. Native Windows setup/build/GUI/Steam/LAN **NOT RUN**. |
| Вихідний стан | PASS. Production `beta` чиста, diagnostic status/diff/SHA256/modes незмінні. Старі файли backup підтверджені за SHA256, розміром, inode і mtime. |

## Після втрати SSD

Маючи обидва архіви на фізично іншому носії та документовані системні залежності, можна відновити Git, R01/R02, обидва build profiles, готовий SFX і повторити Windows PCK build без реконструкції Godot або SFX infrastructure. Повністю offline доступні відновлення й контроль артефактів на ОС із базовими інструментами. Повністю offline bootstrap чистої ОС і автентифікація сервісів потребують окремої підготовки. Зовнішню копію ще потрібно перенести й перевірити. [Інструкція](../BACKUP_GUIDE.md)
