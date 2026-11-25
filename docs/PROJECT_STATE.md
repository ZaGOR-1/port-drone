# DroneFlames — пам’ять проєкту

Базовий стан звірено 2026-11-22. PERF-01 і PERF-02 звірено 2026-11-24. Маршрут до технічних документів і архіву наведено в [індексі](INDEX.md).

## Project identity

DroneFlames — RTS про державу, економіку, дипломатію й війну на генерованій карті. PC-порт використовує Godot 4.7.2 і GDScript. Поточна ціль — Windows x64, середовище розробки — Ubuntu у WSL2. У [репозиторії ZaGOR-1/port-drone](https://github.com/ZaGOR-1/port-drone) почато нову історію зі snapshot. За правилами [AGENTS.md](../AGENTS.md) окремі гілки від актуальної `beta` проходять review та CI перед інтеграцією. `main` — стабільна база, випуск погоджує власник.

## Current baseline

| Контекст | Перевірений стан |
| --- | --- |
| INT-12 / R21 0.36.11 | Watchdog exit search і PATCH 0.36.11. Точний SHA та стан інтеграції в [PR #20](https://github.com/ZaGOR-1/port-drone/pull/20). |
| INT-11 / R19 0.36.10 | Ordered target acquisition buckets і PATCH 0.36.10. Точний SHA та стан інтеграції в [PR #19](https://github.com/ZaGOR-1/port-drone/pull/19). |
| INT-10 / R18B 0.36.9 | Ordered ground impact lookup і PATCH 0.36.9. SHA та стан інтеграції в [PR #18](https://github.com/ZaGOR-1/port-drone/pull/18). |
| INT-09 / R17 0.36.8 | Ordered unit membership lookup і PATCH 0.36.8. SHA та стан інтеграції в [PR #17](https://github.com/ZaGOR-1/port-drone/pull/17). |
| INT-08 / beta 0.36.7 | R15 і PATCH `6a41f0d`. Точний SHA, стан інтеграції й CI в [PR #16](https://github.com/ZaGOR-1/port-drone/pull/16). [Review, ризики й контекст R16](r15/INT08_INTEGRATION.md). |
| INT-07 / beta 0.36.6 | R14, кандидат PATCH `8649531`. Точний merge SHA та CI в [PR #15](https://github.com/ZaGOR-1/port-drone/pull/15). [Цільовий review і приймання](r14/INT07_INTEGRATION.md). |
| beta 0.36.5 / INT-06 | База 0.36.4 `d8114af`. Кандидат INT-06 з R10 і version bump `a2bcdb0`. Merge commit і CI зафіксовано в [PR #14](https://github.com/ZaGOR-1/port-drone/pull/14). |
| База `beta` перед INT-03 | `11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b`. [INT-02, PR #10](https://github.com/ZaGOR-1/port-drone/pull/10). |
| Інтеграція `beta` 0.36.2 | Merge commit та перевірки приймання прив’язані до [INT-03, PR #11](https://github.com/ZaGOR-1/port-drone/pull/11). |
| Windows-стабілізація в `beta` | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5) об’єднано комітом `739a21bcdb74b31e8a9651f491c9f8271948b294` від бази `94aedbe36fc5d1abd4da100bed83f803fad53b2f`. Production tip `e174cd0ce6d6804a8f0598d29bfa7b7008c1206f`, дерево `game/` `052d3b1047774012be4fbc551cfe36d995845ea8`. |
| `main` / `origin/main` | `172df65e3bd004efed9a5444e90a284d9d69db10`. UI `v0.34.0`, updater config `0.33.2.3`, SIM_REV `pr10-phase5b2-1`. |
| Контракти INT-03 | `v0.36.2`, `PROTO 7`, `SIM_REV v036-integration-1`, `Save.FORMAT 1`. Мережевий допуск вимагає однакової повної версії. |
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

## PERF-03 · 2026-11-24

Гілка `perf/otrk-ammo-shortage` у `/home/zagor/projects/port-drone-perf03` від `beta` `11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b`. Оптимізація `2acc15e22b03a696ab83c44893a705e8273c0c93`, fixtures `9906cb142de5f05401811fc6b84d7a5636266a82`, перевірене дерево гри `3ee7ab1774c4bae884689db0fd9bb4dd01b93e7f`. Версія `0.36.1`.

На 500 цілях і 420 ракетах підтвердження 88,89 → 16,31 мс на RTX 4060 Laptop GPU з Vulkan. У 33 GUI-парах і 11 додаткових A/B-парах збережено ігрові результати. Simulation 2476/2476 і Python 47/47. Для приймання залишаються фізичний Windows GUI A/B за повного й недостатнього запасу та review. [Вимірювання й пакети](perf03/PERF03_RESULTS.md)

## INT-03 · beta 0.36.2

Цільовий review PERF-03 підтвердив еквівалентні фільтри установок, межі дальності, порядок розподілу й причини відмов. Координати перевикористовуються лише в межах одного синхронного планування. Змішані та відкладені пуски перевіряють актуальний запас. Підвищення версії `a08f24dbe77706b5f40d30ab2123553425f41371` синхронізує конфіг, меню, локалізовану примітку і тести build identity. Перевірене дерево `game/` — `5935cf8c6ba53258040417f06d41de9dc125aefb`.

Інтеграцію погоджено після review і успішного CI в [PR #11](https://github.com/ZaGOR-1/port-drone/pull/11). Фізичний Windows GUI QA — NOT RUN, відкладено власником. Фізичний LAN і Steam — NOT RUN. За повного запасу GUI-вимір лишається INCONCLUSIVE. Локальні QA-пакети та перевірка Git increment належать до handoff INT-03 у `/home/zagor/projects/droneflames-toolchain/int03.IGMm9Fth/`. Для відкату використовуй окремий PR із revert merge commit від першого батька.

## R07 · Watchdog і точки виходу

Гілка `perf/watchdog-exit-search`, worktree `/home/zagor/projects/port-drone-r07`, база `b2af27a67d503aa6587a82dc5255458fedf32e79` і версія `0.36.2`. Код кандидата `d534cc4a07c885f70676ac92136a8affb1f6dcdb`. На Late E, тик 4746, медіана пошуку 118,42 → 99,96 мс, усі три GUI-пари дали менший CPU пік watchdog. Детермінізм, snapshot roundtrip, simulation 2476/2476, Python 47/47, Linux і Windows official QA build та Wine smoke пройшли. FPS INCONCLUSIVE. Для приймання потрібні review і фізичний Windows A/B. [R07](r07/R07_RESULTS.md)

## INT-04 · R07 / beta 0.36.3

Кандидат [PR #12](https://github.com/ZaGOR-1/port-drone/pull/12) від `b2af27a67d503aa6587a82dc5255458fedf32e79` перевикористовує цілочисельну геометрію пошуку виходу. Review підтвердив збереження порядку кандидатів, розв’язання нічиїх, просторових запитів, поведінки fallback та моменту застосування наказів. У Late E `wd_exit` прискорився з 118,42 до 99,96 мс. Приріст FPS INCONCLUSIVE. Найдовший кадр зріс із 200,60 до 204,65 мс. [Вимірювання та fixture](r07/R07_RESULTS.md)

Версія 0.36.3 зберігає PROTO 7, SIM_REV v036-integration-1 і Save.FORMAT 1. Мережевий допуск порівнює повну версію. Фізичний Windows GUI й навантаження відкладені власником, фізичні LAN і Steam — NOT RUN. Локальні перевірки, QA ZIP/TAR, Git increment і матеріали майбутнього R08 — у handoff INT-04 в toolchain. Наступний профіль — кадр 4693 і чотири команди lockstep у `NetSession._exec`, включно з вкладеними обробниками.

## R08 · Lockstep-команди

Гілка `perf/lockstep-command-execution`, worktree `/home/zagor/projects/port-drone-r08`, база `690915646ec0186b5086cd254dcd6b8eab85f6c0`. Код `d59bba648144b4c866c4b0f351b8eb9ca44942e4`, версія 0.36.3. На Late E чотири `army.order_attack` викликають пошук суходолу під час побудови fallback-шляхів. Периметровий обхід у `land_point` скоротив медіану пакета 174,449 → 121,996 мс у трьох GUI A/B-парах. Детермінізм історичного replay збережено. FPS INCONCLUSIVE. Наступні кроки — review Draft і фізичний Windows QA. [Профіль, регресії й QA-пакети](r08/R08_RESULTS.md)

## INT-05 · R08 / beta 0.36.4

[PR #13](https://github.com/ZaGOR-1/port-drone/pull/13) від `690915646ec0186b5086cd254dcd6b8eab85f6c0`. Периметровий обхід `Economy.land_point` зберігає порядок клітинок, tie-breaking і результати `Army.safe_point`. Історичний апаратний R08 дав −30,1% latency пакета, FPS INCONCLUSIVE. PROTO 7, SIM_REV v036-integration-1 і Save.FORMAT 1 збережено. Мережевий допуск перевіряє повну версію. Фізичний Windows QA відкладено власником, фізичні LAN і Steam — NOT RUN. [Результати R08](r08/R08_RESULTS.md)

Worktree кандидата — `/home/zagor/projects/port-drone-r08`. Підсумок інтеграції, QA-пакети, Git increment і контекст R09 — `/home/zagor/projects/droneflames-toolchain/int05.qp8pp1c0/`. У всіх трьох B прогонах R08 найдовший кадр припав на watchdog на 4746. Для нового baseline лишаються Late E, C1200 і D1920/D2100.

## R10 · ArmyFire._impact

Worktree `/home/zagor/projects/port-drone-r10`, гілка `perf/armyfire-impact`, база `d8114afac56c2475ca9ded5bd8627d4d42000041`. Код `85d76a177110c802cee9c7792abfa4c295c6318a`, fixture і пакети з `8509ddb58a51e5775ab12479d6017b10c98bce03`, дерево гри `6e367205359cdc75d4e83520ac11901d421afae8`, версія 0.36.4.

Ранній фільтр відсікає 99.26% відвідувань D2100. Медіана inclusive `_impact` 8.81 → 4.94 мс/кадр, FPS 19.18 → 20.84. У C1200 exclusive `_impact` 3.12 → 2.04 мс/кадр, FPS INCONCLUSIVE. Late E, C1200 і D2100 збіглися покроково. Дисковий save і мережевий snapshot продовжилися ідентично між A/B. Python 49/49, simulation 2476/2476, differential 49/49 на кожному варіанті. Linux і Windows official QA-пакети, Linux native та Wine headless smoke пройшли.

Докази та QA-архіви — `/home/zagor/projects/droneflames-toolchain/performance/r10.sgT1Rl0N/`. Приймання цього кандидата зафіксовано в INT-06. [Методика, результати й обмеження](r10/R10_RESULTS.md)

## R09 · Baseline 0.36.4

На Ubuntu native з official Godot 4.7.2 і RTX 4060 Laptop GPU виміряно медіани C1200 41,62 FPS, D1920 21,89, D2100 20,28 і Late E 35,06. Контроль D2100 показав обмеження головного потоку. Дані R09 і гілка `docs/r09-baseline` `93a626e` збережені в `/home/zagor/projects/droneflames-toolchain/performance/r09.vlpdda5t/`. Фізичний Windows performance — NOT RUN.

## INT-06 · R10 / beta 0.36.5

[PR #14](https://github.com/ZaGOR-1/port-drone/pull/14) інтегрує R10 з `d8114afac56c2475ca9ded5bd8627d4d42000041`. Worktree кандидата `/home/zagor/projects/port-drone-r10`. Мережевий допуск зберігає перевірку повної версії, PROTO 7, SIM_REV v036-integration-1 і Save.FORMAT 1. D2100 Ubuntu дав +8,64% FPS, p99 кадру +3,98% за медіанами, причина лишається відкритою. Physical Windows user acceptance: PASS — owner-reported. Quantitative Windows A/B metrics: NOT PROVIDED. Фізичне приймання фінального пакета 0.36.5, LAN і Steam — NOT RUN. Merge SHA, CI, QA-пакети, Git increment і докази фіксуються в локальному handoff `/home/zagor/projects/droneflames-toolchain/int06.ruEDaqvC/`. [Review, ризики й R12](r10/INT06_INTEGRATION.md)

## R11 · NO-GO

Локальний worktree `/home/zagor/projects/port-drone-r11`, гілка `perf/r11-army-update`, HEAD `a72a67c`. Експеримент окопування не інтегровано. На Late E FPS і tick p95 погіршилися в усіх трьох мінімальних парах, причинність відкрита. Докази збережено в `/home/zagor/projects/droneflames-toolchain/performance/r11.AZ9TDOdC/`.

## R14 · Обхід споруд в ArmyFire._impact

Кандидат `13dd5bffbd2878bf416c0d3bdd7663c43f7d8f73` на `perf/armyfire-impact-buildings` від `8c83d91d06989cc3857c7560c4690188bf88a964`, worktree `/home/zagor/projects/port-drone-r14`, версія 0.36.5. Винесено пошук країни-атакувальника за межі циклу споруд. D2100 facility scan 3,583 → 2,011 мс/кадр, FPS 19,996 → 20,647 і simulation 25,831 → 24,478 мс/тик. Gate GO, локальний повний QA PASS. C1200 frame p95 і щільний tick p99 лишаються ризиками. Manual Windows A/B, LAN і Steam — NOT RUN. Handoff у `/home/zagor/projects/droneflames-toolchain/performance/r14.GEz1Tr3B/`. [Результати R14](r14/R14_RESULTS.md)

## R15 · ArmyFire._spot

Гілка `perf/armyfire-spotting`, worktree `/home/zagor/projects/port-drone-r15`, база `50f3f04306ec49ea600296135225282907c9955c`, версія 0.36.6. Код `0dc44603c07cd81c96f023295f6a21d928a77cd5`. R15 скоротив повторні перевірки стану наземних кандидатів зі збереженням порядку й результатів spotting. Gate GO, повний локальний QA PASS. D2100 inclusive `_spot` 356,525 → 99,413 мс за 120 тіків, frame p99 137,948 → 93,125 мс, tick p99 107,404 → 49,925 мс. Фізичне Windows приймання лишається відкритим. Докази й provenance в `/home/zagor/projects/droneflames-toolchain/performance/r15.pCbzhv2E/`. [Профіль, парні заміри й QA](r15/R15_RESULTS.md)

## INT-08 · R15 / beta 0.36.7

Кандидат із `/home/zagor/projects/port-drone-r15`, база `50f3f04306ec49ea600296135225282907c9955c`. Наземний spotting повторно використовує відфільтровані bucket-и тільки в межах скану країни. У R15 D2100 час чотирьох викликів `_spot` зменшився на 72,1%. Причина розбіжності FPS і максимуму кадру в щільних парах відкрита. R11–R13 лишаються NO-GO. Фізичний Windows GUI/FPS відкладено, LAN і Steam — NOT RUN. Докази, стан CI, QA-пакети, incremental bundle і матеріали R16 зберігаються в handoff INT-08. [INT-08](r15/INT08_INTEGRATION.md)

## R17 · Ordered Unit Membership Lookup

Локальний PoC у `/home/zagor/projects/port-drone-r17`, гілка `perf/operations-membership-lookup` від `d6a38e8db58361430df69ffe0a98e628acac6d8b`, версія 0.36.7. У синхронній фазі `Operations.update` впорядкований підбір за посиланням `Unit.home` перебудовується після зміни home або реєстру. Цільові перевірки 33/33 на A/B, repeated restore PASS, покроковий replay D2100/D5000/Late E 390/390. У 120-тикових вікнах D2100/D5000 консервативне зменшення visits склало 94,95% і 82,30%. На пікових тиках CPU membership зменшився на 94,56% і 96,01%. Медіана парного поліпшення tick p99 21,38% і 50,54%.

GUI Late E дав зміни середнього FPS +3,26%, −18,43% і −14,76% у трьох парах. Обидва повільні B-прогони мали вищу зайнятість CPU хоста. Причинність відкрита. Ранній gate INCONCLUSIVE. Повний QA, тривалий контроль, пакети, commit, push і PR відкладено. Локальний diff, сирі заміри, fixtures, replay traces і SHA256 збережено у `/home/zagor/projects/droneflames-toolchain/performance/r17.xD07pkTL/`. Наступна перевірка цього кандидата — парний Late E на стабільному фоновому навантаженні. У D2100 B підтверджений залишковий hotspot `Operations.wd_exit` має 58–72 мс exclusive на тиках 4816 і 4864.

### Фінальне приймання · 25.11.2026

Late E **GO** за Real-World Gaming (Profile B). Незмінний PoC зафіксовано в `617c58004261cff52a3ad035c9ccf11d87893aa5`. Чотири збалансовані пари по 150 тіків на плече дали медіани парних змін +3,11% FPS, +3,81% 1% low, −2,82% frame p99, −22,86% tick p99 і −0,75% CPU-часу процесу. Усі плечі збіглися за NetHash, RNG і wire payload. VM була активною у всіх плечах. Сторонній CPU між A і B змінювався в обох напрямках, а FPS і tick p99 поліпшились у кожній парі. Абсолютні показники описують виміряну сесію Ubuntu з VM. Історичні D2100/D5000 gates та repeated restore перенесено за SHA256.

Пройшли simulation regression 2476/2476, дисковий Save/Load 22/22, ENet admission і двопроцесні reconnect/resync, 600-тіковий lifecycle control, official Linux та Windows x64 build, PCK parity і Linux native/Wine smoke. Версія 0.36.7, PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с. Докази, збірки й Windows A/B комплект у `/home/zagor/projects/droneflames-toolchain/performance/r17-final-profile-b.9tC9OIb6/`. Наступна перевірка для Draft PR — фізичний Windows A/B, LAN і Steam. У smoke залишаються відомі попередження Godot під час виходу про ресурси.

### INT-09 · PATCH 0.36.8

Власник погодив інтеграцію через PR #17 з бази `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Перевірений R17 PoC, PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с збережено. ENet admission порівнює повну identity і відхиляє змішані 0.36.7/0.36.8. Фізичний Windows A/B, LAN і Steam — NOT RUN за рішенням власника. CI, QA-пакети, результати admission і incremental bundle фіксуються в локальному handoff `/home/zagor/projects/droneflames-toolchain/int09.svwoLWvo/`. Відомі повідомлення про ресурси під час виходу Godot залишаються відкритими.

## R18B · Ordered Ground Impact Lookup

Кандидат `b33d49cf0a70ed01cd36d0aae79b93497475ab31` від beta `117781083ff108c8353b9e53a3eda3d49bedd0fe`, версія 0.36.8. R18A `6d83ef995a154e842906d2ebdb15a41c5a883ce3` збережено в попередньому worktree. В Army save/load суміщено виключення транзієнтних полів R17 і R18. Цільові differential, 330 покрокових зіставлень, repeated restore, дискове продовження, ENet reconnect/resync та обмежений lifecycle пройшли.

Profile B **GO**. Медіани парних змін impact CPU, simulation CPU і FPS відповідно −40,97%, −14,60%, +10,09% у D5000 і −24,71%, −7,42%, +3,12% у щільному D5000. У щільному сценарії 981 457 рангів у 866 сортуваннях потребували 72,72 мс CPU за медіаною. Frame p99 та peak RSS щільного D5000 зросли на 1,33% і 1,19%. У щільному D2100 один контроль показав +11,01% impact CPU та +9,16% frame p95, за майже незмінного FPS. Важкі пари виміряно на Ubuntu з активною Windows VM. Фізичний Windows A/B, LAN і Steam — NOT RUN. Сирі дані та QA-артефакти в `/home/zagor/projects/droneflames-toolchain/performance/r18b-profile-b.gFaqgQ6i/`.

Simulation regression 2476/2476, official Linux і Windows x64 build, PCK parity та Linux native/Wine smoke — PASS. Windows A/B комплект містить official `beta` та R18B і спільний ручний disk save. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с успадковано з beta.

### INT-10 · PATCH 0.36.9

Власник погодив інтеграцію через PR #18 від `117781083ff108c8353b9e53a3eda3d49bedd0fe`. Production PoC і контракти R18B збережено. R17 fixture повторно пройшов 33/33 на official PCK обох варіантів. Типізований `Array[Unit]` зберігає початкове тестове присвоєння та всі assertions. Фізичні Windows A/B, LAN і Steam — NOT RUN за рішенням власника. Відомі teardown warnings відкриті. Ризик для подальшого приймання — +9,16% frame p95 в одній парі щільного D2100. CI, QA-пакети, admission та incremental bundle фіксуються в handoff `/home/zagor/projects/droneflames-toolchain/int10.GjFgeuwy/`.

## R19 · Ordered Target Acquisition Buckets

Окремий кандидат від beta `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035` (0.36.9) у `perf/army-target-acquisition`, worktree `/home/zagor/projects/port-drone-r19`. Ліниві списки чинних spatial buckets за маскою ворогів зберігають порядок, живі перевірки й початковий шлях у звичайному бою. У трьох парах Profile B щільний D5000 показав −56,73% повної acquire CPU, економію 10,68 мс/тик, −68,65% visits разом із побудовою списків та +7,63% FPS. Звичайний D5000 показав −2,24% FPS і +0,74% 1% low. GO за performance і детермінізмом. Differential 24/24, 420 зіставлених тіків, regression 2476/2476, Save/Load 22/22, ENet, official Linux/Windows build, PCK parity та headless smoke — PASS. Фізичні Windows FPS, LAN і Steam — NOT RUN. [Замір, QA й handoff](r19/R19_RESULTS.md)


### INT-11 · PATCH 0.36.10

Власник погодив інтеграцію [PR #19](https://github.com/ZaGOR-1/port-drone/pull/19) від `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035`. Production-код R19 прив’язано до `868b2b8e43fc1aa45d3cfbf7b9be492faa1207f8`. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с збережено. Повна версія входить до identity ENet. Після інтеграції основний checkout для beta — `/home/zagor/projects/port-drone`.

У коротких контролях кеш не активувався. D2100 показав −7,66% 1% low, Late E показав +9,77% tick p99 (+3,82 мс). B мав більше стороннє навантаження CPU в обох парах, причинність відкрита. Фізичні Windows FPS, LAN і Steam відкладено за рішенням власника, статус NOT RUN. Дефекти вивільнення ресурсів Godot залишаються відкритими. Фінальні CI, smoke, ENet admission, пакети, SHA256 і відновлення incremental bundle фіксуються в локальному handoff `/home/zagor/projects/droneflames-toolchain/int11.KkAMcCZr/`.

## R21 · Watchdog exit search

Кандидат від beta `3298af5878501d458920b41dc5738f60571ac551` (0.36.10), worktree `/home/zagor/projects/port-drone-r21`, гілка `perf/watchdog-lockstep-latency`. `wd_exit` пропускає групу з чотирьох клітин, якщо всі належать території виходу. D2100: медіанна парна зміна CPU `wd_exit` −41,49%, tick p99 −16,40%. Детермінізм 390/390, геометрія 576/576, Operations/transport 37/37 на плечі. Локальний повний QA — PASS. Командні піки та siege D5000 лишаються окремими джерелами затримок. [Результати, QA й обмеження](r21/R21_RESULTS.md)


### INT-12 · PATCH 0.36.11

Власник погодив інтеграцію [PR #20](https://github.com/ZaGOR-1/port-drone/pull/20) від `3298af5878501d458920b41dc5738f60571ac551` після перевірки ризиків. Production-код R21 збережено з `8b564ca15f4696f4009c97cd322f563371d0dbf4`. П’ять пар D2100 підтвердили менший CPU обох watchdog-тіків, стабільний порядок роботи та відсутність підтвердженої систематичної регресії FPS або 1% low понад 5%. Вищі p95, варіація CPU поза watchdog, command batch і siege у D5000 лишаються відкритими. [Перевірка INT-12](r21/R21_RESULTS.md#int-12--performance-review)

PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с збережено. Повна версія входить до ENet identity. Фізичні Windows FPS, LAN і Steam — NOT RUN. Основний checkout beta — `/home/zagor/projects/port-drone`. Фінальні CI, QA-пакети, PCK, admission та відновлення incremental bundle фіксуються в локальному handoff `/home/zagor/projects/droneflames-toolchain/int12.7iX78x0s/`.

## Known issues

- **DummyTexture:** відкритий дефект завершення життєвого циклу ресурсів. При seed фонової карти меню 57081466 HUD fixture відтворив витік чотирьох RID на базі та R08 після 36/36 assertions. Коміт `8066964` фіксує seed лише в тесті. Покриття HUD і фільтрацію логів збережено. [QA R08](r08/R08_RESULTS.md#детермінізм-та-qa)

- Фізичні LAN, Steam-матч на двох ПК та reconnect/resync мають статус NOT RUN. Кількісного Windows late-game A/B для фінального 0.36.5 ще немає. `Ctrl+1–9` без виділення очищає слот групи. Це чинна поведінка й окреме можливе UX-покращення.
- Падіння до 2–3 FPS у масштабних боях повідомлялося користувачем. Точний bottleneck ще потребує Windows профілювання. Відкриті shutdown leaks, цілісність updater, стійкість saves при збоях і загальне покриття мережевих схем. [Backlog](codex/verified/BACKLOG.md)

## Next steps

Дослідження NATIVE-01–02D завершено. Production-інтеграцію Rust відкладено. Відкладена перевірка R19 — фізичний Windows Profile B для 0.36.10, зокрема D2100 і Late E.

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
