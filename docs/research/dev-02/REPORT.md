# DEV-02 · переносиме середовище DroneFlames

> Історичний матеріал з `toolchain/dev02.tMRUbu/Development-Environment-v2/REPORT.md`. [Реєстр досліджень](../INDEX.md)

## Структура і залежності

| Роль | Компоненти |
| --- | --- |
| Щоденні збірки | dev-environment/scripts/df, manifests, офіційний pinned Linux editor і Windows export template, linux-native/scripts/l01.py, Linux runtime з ELF і .so, windows-dev/df-windows, Git checkout і tracked Windows DLL |
| Додаткові локальні QA | mingw-patched із release/QA templates і manifests, portable-sfx з MinGW compiler, Wine, ізольовані профілі, performance/portable з історичними Git pins та fixtures |
| Відновлення | Essential v1 із базовим Git bundle і перевіреними бінарними assets, L01 окремим increment, L02 overlay, DEV-02 overlay і Git increment, SHA256SUMS.txt та наявний bootstrap |
| Історичні артефакти | INT-01 QA ZIP і bundle, INT-02/L01/L02 звіти, R01–R06 і їхні каталоги, старі worktrees і benchmark wrappers |

df вибирає source з checkout або явного ref, підтримує workspace, build root і runtime overrides. Для запуску через PATH є user-level installer. Linux QA пакується як tar.gz з правами виконання та SHA256, Windows portable builds містять EXE і DLL, Windows SFX пакується з patched build.

Основні збірки більше не потребують старих symlink workspaces. performance/portable забирає код та fixtures з точних commits у відновленому Git database. Перевірено доступність усіх семи pinned commits і відновлення fixture PERF-02. Старі скрипти perf01/perf02/INT-01 та їхні symlinks збережені разом із первинним provenance. Для історичних вимірювань також потрібні відповідні runtime, навантаження і налаштування. Важкі benchmark suites не запускались.

Для майбутнього очищення спочатку перевірити modified, untracked та ignored файли в кожному worktree, зберегти унікальні матеріали та перевести на portable paths завдання, які досі використовують старі aliases. port-drone-standards-l10n мав ignored Python cache. port-drone-perf01 потрібен історичним performance aliases, port-drone-integration-qa — історичному INT-01 alias. Усі локальні worktrees збережено.

## Перевірки Ubuntu

- Повне відновлення Essential + L01 + L02 + DEV-02 + Git increment з нового каталогу. SHA256, LF, права виконання, Git fsck, офлайн fast-forward і Windows/Linux runtime pins перевірено.
- df doctor та build/check пройшли для Linux official, Windows official і Windows patched. Новий Linux QA tar.gz та Windows SFX зібрані локально. Packaging SFX перевірив AMD64 PE32+ та чотири вбудовані SHA256.
- Linux native headless та GUI завершилися з кодом 0. GUI використав Vulkan Forward Mobile на RTX 4060 Laptop GPU. Wine headless після створення ізольованого prefix завершився з кодом 0 на official та patched Windows. У логах лишилися відомі повідомлення Godot про ресурси при виході.
- Linux, Windows official та Windows patched мають ідентичний PCK SHA256 80bb33afe001eeb8ef4ac4b1f42a94c667f47be0b59adb888afdbc5257f46d07. Точне game tree 26dd6975cf20e987d4db703f1cabde4e85483cb0.
- Трасування execve, openat і readlink для трьох збірок не зафіксувало звернень до оригінального toolchain або історичних worktrees. Toolchain regression — 16 tests PASS. Python discovery гри — 39 тестів, 10 SKIP, 29 PASS. PowerShell bootstrap і QA launcher пройшли syntax parsing на Ubuntu. Mock interop перевіряє wslpath, CRLF, UTF-8, пробіли й forwarding exit code.
- Фізичні Windows 11, WSL2, Windows host interop і WSLg — NOT RUN. Windows QA ZIP з INT-01 збережений для фізичної перевірки.

beta 11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b. Main 172df65e3bd004efed9a5444e90a284d9d69db10. Основний checkout чистий. Зміни тільки у зовнішньому toolchain. Game version 0.36.1.

Відновлений Linux tar.gz перевірено після розпакування у каталог із кирилицею та пробілами. Динамічні залежності ELF і трьох .so знайдено на хості, executable bit збережений, SHA256 усіх файлів збігаються. Пакет стартував ізольовано та завершився з кодом 0. CRLF checkout на ext4 дав той самий LF PCK. Windows official та patched повторили попередні SHA256 своїх EXE після відновлення з копії комплекту.

Windows cross-packaging використовує наявний Linux Godot editor і відновлені Windows templates. Системні Wine та MinGW-w64 для локального smoke/SFX ставляться через пакетний менеджер за bootstrap manifest. Бінарний Windows editor для нативних Windows tools постачається окремо готовим upstream пакетом. Godot під час відновлення й перевірок не компілювався.
