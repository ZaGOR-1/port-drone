# DroneFlames — пам’ять проєкту

Звірено 2026-11-22. Маршрут до технічних документів і архіву наведено в [індексі](INDEX.md).

## Project identity

DroneFlames — RTS про державу, економіку, дипломатію й війну на генерованій карті. PC-порт використовує Godot 4.7.2 і GDScript. Поточна ціль — Windows x64, середовище розробки — Ubuntu у WSL2. У [репозиторії ZaGOR-1/port-drone](https://github.com/ZaGOR-1/port-drone) почато нову історію зі snapshot. За правилами [AGENTS.md](../AGENTS.md) окремі гілки від актуальної `beta` проходять review та CI перед інтеграцією. `main` — стабільна база, випуск погоджує власник.

## Current baseline

| Контекст | Перевірений стан |
| --- | --- |
| Windows-стабілізація в `beta` | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5) об’єднано комітом `739a21bcdb74b31e8a9651f491c9f8271948b294` від бази `94aedbe36fc5d1abd4da100bed83f803fad53b2f`. Production tip `e174cd0ce6d6804a8f0598d29bfa7b7008c1206f`, дерево `game/` `052d3b1047774012be4fbc551cfe36d995845ea8`. |
| `main` / `origin/main` | `172df65e3bd004efed9a5444e90a284d9d69db10`. UI `v0.34.0`, updater config `0.33.2.3`, SIM_REV `pr10-phase5b2-1`. |
| Контракти `beta` і локального кандидата | `v0.36.0`, `PROTO 7`, `SIM_REV v036-integration-1`, `Save.FORMAT 1`. |
| Windows QA | R02, UI-01/02/03, INPUT-01, GAME-01, BUG-01 і BUG-02 у `beta`. Дерево `game/` в merge-коміті збігається з деревом перевіреного локального SFX. [Windows QA](WINDOWS_QA.md) |
| Локальні джерела | R02 — `fix/r02-release-recovery`; UI — `fix/windows-ui-qa`; ввід і шкала — `fix/windows-keyboard-controls`, `fix/windows-input-followup`, `fix/windows-context-hotkeys`. SFX tooling та native patch зберігаються окремо. Робочі дерева та оригінали патчів збережено. SFX tooling і MinGW не входять до CI-дерева гри. |

| Production commit | Зміна |
| --- | --- |
| `8b2d0bb192a7909ab275b5219ad9ad6ece187e7b` | fix(save): make network restore recovery explicit |
| `6e4bb1d8827e6e43e7571c96036b7dc17bb9e80a` | fix(ui): correct scrolling, clipping and capital preview |
| `ee8b77c6d949a4ec30cf654616ac2757785c7ce0` | fix(input): remove debug strike and resolve keyboard conflicts |
| `43f7749910a6dd1b78eeefe8491a2675ef582b2c` | fix(ui): clamp interface scale at supported bounds |
| `e174cd0ce6d6804a8f0598d29bfa7b7008c1206f` | feat(input): add contextual numeric menu shortcuts |

## Implemented

- У `beta` є генерація світу, симуляція міст/економіки/військ/ШІ, дипломатія, LAN і Steam lockstep, Save/Load/Continue й хроніка зі знімками. [Архітектура](codex/verified/ARCHITECTURE_AND_FLOWS.md)
- Windows-інтеграція додає явний результат R02 restore, виправляє scrollbar, межі layout і кільце столиці, прибирає тестовий удар, додає контекстні цифри й обмежує масштаб 70–130%. SFX розпаковує runtime та DLL у приватний кеш. [Windows QA](WINDOWS_QA.md)

## Verified

- Перед інтеграцією CI бази `94aedbe` завершився успішно. [Run 45069650295](https://github.com/ZaGOR-1/port-drone/actions/runs/45069650295)
- Локальний суміщений Windows PCK пройшов keyboard 130/130, scale 26/26, UI 20/20, R02 standard 49/49 і simulation 2476/2476. SFX smoke пройшов. Власник підтвердив основні GUI, хоткеї, масштаб, TEL, Save/Continue і запуск Steam на суміщеному EXE. [Матриця доказів](WINDOWS_QA.md#перевірки)
- MinGW patched пройшов контроль native race. У headless checkpoint середній CPU процесу на 7,68% нижчий за Official, з п’ятьма прогонами на runtime. [Методика й обмеження](WINDOWS_QA.md#godot-mingw)

## In progress

Інтеграцію Windows-стабілізації в `beta` завершено. Фізичний LAN і профілювання late-game FPS залишаються завданнями наступного циклу.

## Known issues

- Фізичний LAN, Steam-матч на двох ПК, reconnect/resync і late-game FPS мають статус NOT RUN. `Ctrl+1–9` без виділення очищає слот групи. Це чинна поведінка й окреме можливе UX-покращення.
- Падіння до 2–3 FPS у масштабних боях повідомлялося користувачем. Точний bottleneck ще потребує Windows профілювання. Відкриті shutdown leaks, цілісність updater, стійкість saves при збоях і загальне покриття мережевих схем. [Backlog](codex/verified/BACKLOG.md)

## Next steps

1. Пройти фізичний LAN/Steam QA на двох ПК з однаковими SHA256, зокрема reconnect/resync.
2. Оцінити UX очищення груп без виділення, зберігши можливість явного очищення.
3. Профілювати й оптимізувати Windows FPS у масштабних боях. Після стабілізації й профілювання заплановано Linux-порт, після нього — перепроєктування UI.

## Important paths

- Boot і ресурси: [game/override.cfg](../game/override.cfg), [pc/boot.tscn](../game/pc/boot.tscn), [main.tscn.remap](../game/game/main.tscn.remap).
- Контракти: [pc/version.cfg](../game/pc/version.cfg), [net_config.gd](../game/net/net_config.gd), [save.gd](../game/game/save.gd).
- Збірка й тести: [tools/build.py](../tools/build.py), [tools/ci](../tools/ci/), [tools/qa](../tools/qa/), [tests](../tests/), [Windows QA](WINDOWS_QA.md).

## Decisions & constraints

Використовувати `game/project.binary` і tracked `game/.godot/`. Editor/import запускати у фізичній копії. Не змінювати контракти сумісності без погодження. Для QA вимикати updater й ізолювати профілі. Steam AppID 480 тестовий. Докази прив’язувати до точних EXE, PCK, DLL і сценаріїв.

## Handoff

Прочитай [AGENTS.md](../AGENTS.md) і цей файл. Звір `git status`, HEAD, refs та worktrees. Для QA відкрий [Windows QA](WINDOWS_QA.md) і перевір маніфест ще раз. Після суттєвої роботи онови цей стан і відповідний технічний документ.
