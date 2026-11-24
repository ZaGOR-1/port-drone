# DroneFlames — пам’ять проєкту

Базовий стан звірено 2026-11-22. PERF-01 і PERF-02 звірено 2026-11-24. Маршрут до технічних документів і архіву наведено в [індексі](INDEX.md).

## Project identity

DroneFlames — RTS про державу, економіку, дипломатію й війну на генерованій карті. PC-порт використовує Godot 4.7.2 і GDScript. Поточна ціль — Windows x64, середовище розробки — Ubuntu у WSL2. У [репозиторії ZaGOR-1/port-drone](https://github.com/ZaGOR-1/port-drone) почато нову історію зі snapshot. За правилами [AGENTS.md](../AGENTS.md) окремі гілки від актуальної `beta` проходять review та CI перед інтеграцією. `main` — стабільна база, випуск погоджує власник.

## Current baseline

| Контекст | Перевірений стан |
| --- | --- |
| Актуальна production beta | `c91e0e6a7eef831687e6e63550560bba739a6b87`. PR #7 і #8 залишаються окремими Draft PR. |
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

FIX-01 перебуває у `~/projects/port-drone-fix-hud-input` на `fix/hud-camera-input` від production `beta` `c91e0e6`. Виправлено межі армійських панелей і routing вводу миші. Цільовий playback, симуляційна регресія та official Windows build пройшли. Нативний Windows GUI після виправлень очікує ручного QA. Звіт із вихідної Windows-збірки додано до PR #7. Вибір понад приблизно 200 цілей ОТРК відкладено до PERF-01. [Причини](FIX01_BUG_ANALYSIS.md), [регресії](FIX01_REGRESSION_TESTS.md), [Windows QA](FIX01_WINDOWS_QA.md).

Інтеграцію Windows-стабілізації в `beta` завершено. Фізичний LAN і профілювання late-game FPS залишаються завданнями наступного циклу.

## PERF-01

Кандидат `perf/otrk-target-selection`, worktree `~/projects/port-drone-perf01`. UI-коміт `1ebb914`, код Windows QA `130dce2`, версія кандидата `0.36.1`. На `beta` відтворено поступову деградацію вибору й промальовування. У двох ізольованих A/B-парах на 200 цілях клік зменшився з 24,93 до 0,69 мс, підготовка рендерингу з 9,63 до 5,02 мс/кадр. NetHash, порядок цілей, wire payload і черги збіглися. Симуляційна регресія 2476/2476.

Наступна перевірка — повтор на фізичній Windows 11 зі збігом SHA256 EXE/DLL, потім GUI зі спільним кандидатом з PR #8. Подальші зміни підтвердження й preview описано в PERF-02. Сирі дані та ZIP у `~/projects/droneflames-toolchain/performance/perf01/`. [PERF-01](perf01/PERF01_ANALYSIS.md)

## PERF-02

Гілка `perf/otrk-target-selection`, worktree `~/projects/port-drone-perf01`, код `3880359`, версія `0.36.1`, Draft PR #9 до `beta`. На 500 цілях headless-підтвердження 107,27 → 16,62 мс, контрольований preview 4,60 → 2,05 мс/кадр за тієї самої частоти. Повторний план для синхронного залпу лише ОТРК замінено застосуванням готового плану в межах виклику. У 15 A/B-парах порівняно команди, черги, першу хвилю й NetHash. Simulation regression 2476/2476, Python discovery 43/43.

Фізична Windows 11 GUI, LAN і Steam — NOT RUN. Пакет і сирі докази зберігаються в `~/projects/droneflames-toolchain/performance/perf02/`. Наступна перевірка — A/B з ZIP PERF-01 на тому самому Windows ПК. Фактичну затримку при вичерпанні боєзапасу зафіксовано для наступного профілювання. [PERF-02](perf02/PERF02_ANALYSIS.md)

## INT-01

QA-гілка `integration/qa-v0.36.1` у `/home/zagor/projects/port-drone-integration-qa` об’єднує Draft PR #7 → #8 → #9 від `c91e0e6a`. Перевірене дерево гри `26dd6975cf20e987d4db703f1cabde4e85483cb0`. Handoff і докази розміщені в `/home/zagor/projects/droneflames-toolchain/integration-qa-v0.36.1/`. Python 47/47, simulation 2476/2476, міжмовний replay 30 ticks і ENet loopback із reconnect/resync пройшли. Official Windows ZIP перевіряється через SHA256. Wine smoke і Linux GUI пройшли у задокументованому обсязі. Фізичні Windows DPI, LAN та Steam мають статус NOT RUN. [Інтеграція](INT01_INTEGRATION.md) · [Windows checklist](INT01_WINDOWS_QA.md)

## Known issues

- Фізичний LAN, Steam-матч на двох ПК, reconnect/resync і late-game FPS мають статус NOT RUN. `Ctrl+1–9` без виділення очищає слот групи. Це чинна поведінка й окреме можливе UX-покращення.
- Падіння до 2–3 FPS у масштабних боях повідомлялося користувачем. Точний bottleneck ще потребує Windows профілювання. Відкриті shutdown leaks, цілісність updater, стійкість saves при збоях і загальне покриття мережевих схем. [Backlog](codex/verified/BACKLOG.md)

## Next steps

1. Пройти фізичний LAN/Steam QA на двох ПК з однаковими SHA256, зокрема reconnect/resync.
2. Оцінити UX очищення груп без виділення, зберігши можливість явного очищення.
3. Профілювати й оптимізувати Windows FPS у масштабних боях. Після стабілізації й профілювання заплановано Linux-порт, після нього — перепроєктування UI.

## Important paths

- Основний worktree `~/projects/port-drone` на `beta`. Допоміжні worktrees збережено в `~/port-drone-worktrees-archive/`, а резервні копії, збірки й докази Windows QA — у його підпапці `droneflames/`. Робочі каталоги прогонів `df-*` збережено в `droneflames/qa-runs/`.

- Boot і ресурси: [game/override.cfg](../game/override.cfg), [pc/boot.tscn](../game/pc/boot.tscn), [main.tscn.remap](../game/game/main.tscn.remap).
- Контракти: [pc/version.cfg](../game/pc/version.cfg), [net_config.gd](../game/net/net_config.gd), [save.gd](../game/game/save.gd).
- Збірка й тести: [tools/build.py](../tools/build.py), [tools/ci](../tools/ci/), [tools/qa](../tools/qa/), [tests](../tests/), [Windows QA](WINDOWS_QA.md).

## Decisions & constraints

Використовувати `game/project.binary` і tracked `game/.godot/`. Editor/import запускати у фізичній копії. Не змінювати контракти сумісності без погодження. Для QA вимикати updater й ізолювати профілі. Steam AppID 480 тестовий. Докази прив’язувати до точних EXE, PCK, DLL і сценаріїв.

## Handoff

Прочитай [AGENTS.md](../AGENTS.md) і цей файл. Звір `git status`, HEAD, refs та worktrees. Для QA відкрий [Windows QA](WINDOWS_QA.md) і перевір маніфест ще раз. Після суттєвої роботи онови цей стан і відповідний технічний документ.

## Development Standards v1

Локальна гілка feature/development-standards-l10n від c91e0e6, worktree ~/projects/port-drone-standards-l10n. Git/версійні правила й перевірки локалізації додано. Локалізація PARTIAL. Виправлені 180 активних ключів uk/en, locale boot/updater та runtime HUD. Пройшли 77 localization checks, 31 релевантний regression test, 2476 simulation checks і короткий replay ru/uk/en. Вибірково перевірено GUI та Save/Continue в ізольованому Linux QA, зібрано Windows x64 QA. Native Windows GUI, повне покриття dynamic keys та transport UI відкриті. Версія v0.36.0. Production beta, R01–R06 і L01 залишилися без змін. [Перевірки](LOCALIZATION_TESTS.md)

## L10N-02 · 2026-11-24

Часткове приймання локалізації у `feature/development-standards-l10n`, worktree `~/projects/port-drone-standards-l10n`. Початкова вершина `15b6bbb`. Виправлення `f1e1f66` і `3ee7f1d`. Перевірене дерево `game/` `26e85284d4c7ae2d11bdc95a0f09eef623d15683`. Локальна й віддалена production `beta` на `c91e0e6a7eef831687e6e63550560bba739a6b87`.

Переглянуто 466 порожніх записів uk/en, заповнено 29 і класифіковано 437 службових. Виправлено складені підписи, повторний рендер сповіщень і текст анімованого завантаження. Каталоги, L10N, simulation, replay, Windows build check і вибірковий Linux/Wine GUI пройдено. Версія `0.36.0`. Для інтеграції залишається Windows native GUI, живий transport UI та сценарії з [ручного checklist](LOCALIZATION_TESTS.md#ручний-checklist-l10n-02). Локальний handoff з bundle і доказами є в `~/projects/droneflames-toolchain/l10n02-qa.sfnBnw/handoff/`. [Аудит](LOCALIZATION_AUDIT.md#l10n-02--перевірка-порожніх-записів)

## Git Workflow v2

Постійну політику локальних комітів, тематичних гілок, погодженого push і Draft PR закріплено в [AGENTS.md](../AGENTS.md) та [Development Workflow](DEVELOPMENT_WORKFLOW.md). Worktree `~/projects/port-drone-standards-l10n` використовує гілку `feature/development-standards-l10n` для Draft PR у `beta`. Кандидат L10N-02 лишається PARTIAL для review. Версія `0.36.0`, перевірене дерево гри `26e85284d4c7ae2d11bdc95a0f09eef623d15683`. Для приймання залишається [ручний QA](LOCALIZATION_TESTS.md#ручний-checklist-l10n-02).

## L10N-03

PR #7 з `~/projects/port-drone-standards-l10n` до `beta` лишається Draft. Перевірений runtime і Windows ZIP походять із `0e8316e`, дерево гри `26e85284d4c7ae2d11bdc95a0f09eef623d15683`, версія `0.36.0`. CI для дерева пакета пройшов. На Ubuntu пройшли точкові перевірки Save/Load, updater з локальними mocks і двоклієнтський ENet loopback з reconnect та resync. Для інтеграції статус NOT READY через відкритий Windows native GUI і DPI. Physical LAN, Steam й native updater лишаються NOT RUN. [Підсумок QA](L10N03_QA_SUMMARY.md) · [Merge gates](L10N03_MERGE_READINESS.md)
