# Інвентар Markdown і межі аудиту

2026-11-22. Початковий інвентар містить 56 tracked Markdown-файлів на `beta` `94aedbe`. Окремо перевірено 16 локальних документів і варіантів звітів кандидатів. Сторонні матеріали, тимчасові build-копії та імпорти поза інвентарем. Маршрут за темами наведено в [INDEX](INDEX.md).

Усі файли з інвентарю прочитано для визначення scope, навігації, датованих тверджень і посилань. Поточні операційні твердження звірено з Git, кодом, конфігурацією, CLI, точним CI run і локальними доказами. Історичні висновки обмежено їхнім commit/артефактом. Старі тести, legacy commits, зовнішні посилання і звіти без сирих доказів не перевидавалися як нові результати.

## Поточна документація верхнього рівня

| Файл | Призначення й перевірка | Дія |
| --- | --- | --- |
| [AGENTS.md](../AGENTS.md) | Правила роботи та коротка ініціалізація, синхронізація і handoff. Оновлено точково. Вкладених tracked AGENTS немає. | Оновлено |
| [README.md](../README.md) | Огляд гри, запуск і внесок. Команди збірки зведено до основної інструкції. | Оновлено |
| [README.en.md](../README.en.md) | Англомовний відповідник README. Поточні compile/QA інструкції спільні. | Оновлено |
| [performance.md](performance.md) | Підтримувані CLI команди й історичні результати 0.33.2.2. Звірено параметри `tools/check_performance.py`. | Оновлено |
| [INDEX.md](INDEX.md) | Навігація та джерело на кожну тему. | Додано |
| [PROJECT_STATE.md](PROJECT_STATE.md) | Компактний Git/QA baseline і handoff. | Додано |
| [WINDOWS_QA.md](WINDOWS_QA.md) | SHA, cohort, SFX, MinGW, статуси точних тестів і локальні докази. | Додано |
| [DOCUMENTATION_AUDIT.md](DOCUMENTATION_AUDIT.md) | Цей інвентар і межі перевірки. | Додано |

## Документи в codex/verified

| Документ | Статус | Призначення, перетини й джерело перевірки | Дія |
| --- | --- | --- | --- |
| [ARCHITECTURE](codex/verified/ARCHITECTURE.md) | Історичний | Початковий опис runtime та 0.41. Для поточного boot і потоків дивись ARCHITECTURE_AND_FLOWS. | Збережено |
| [ARCHITECTURE_AND_FLOWS](codex/verified/ARCHITECTURE_AND_FLOWS.md) | Технічний | Boot, ownership і механіки. Звірено з override.cfg, remap, Main, World і NetSession. Вузька карта файлів у MODULE_INDEX. | Оновлено |
| [BACKLOG](codex/verified/BACKLOG.md) | Поточний + історія | Відкриті ризики й triage. Порядок і статус задач у PROJECT_STATE, докази у WINDOWS_QA. | Оновлено |
| [BUILD_RELEASE](codex/verified/BUILD_RELEASE.md) | Поточний + історія | Основна інструкція Windows build. Звірено tools/build.py, CI, verifier, PowerShell та updater. | Оновлено |
| [CI_RESTORATION](codex/verified/CI_RESTORATION.md) | Історичний | Відновлення CI у PR #2. Поточна політика в build.yml і BUILD_RELEASE. | Збережено |
| [COLLABORATION_WORKFLOW](codex/verified/COLLABORATION_WORKFLOW.md) | Політика + історія | Ролі й Git workflow. Чинні дозволи визначають AGENTS і поточна задача. | Оновлено |
| [CURRENT_STATE](codex/verified/CURRENT_STATE.md) | Історичний | Датовані handoffs і первинні результати. Стан перенесено до PROJECT_STATE. | Оновлено |
| [DECISIONS](codex/verified/DECISIONS.md) | Поточний + історія | Архітектурні й робочі рішення. Старі інтеграційні дозволи належать своїм задачам. | Оновлено |
| [ENVIRONMENT_SETUP](codex/verified/ENVIRONMENT_SETUP.md) | Історичний | Обладнання, пакети й інструменти Phase 2. Піни звіряти з tools/ci, доступність кешів із FS. | Збережено |
| [FEATURE_CATALOG](codex/verified/FEATURE_CATALOG.md) | Історичний | Каталог PR10 з тодішніми статусами. Дублює частини GAMEPLAY_SYSTEMS, які читаємо першими. | Оновлено |
| [FILE_COVERAGE](codex/verified/FILE_COVERAGE.md) | Історичний | Рядки, байти й ранні SHA з аудиту snapshot. Поточний пошук через Git, зміни після аудиту у SOURCE_COVERAGE. | Збережено |
| [GAMEPLAY_SYSTEMS](codex/verified/GAMEPLAY_SYSTEMS.md) | Технічний | Симуляція, world generation, економіка, війська й AI. Джерела у game/game і game/world, QA за конкретним PCK. | Оновлено |
| [INTEGRATION_STRATEGY](codex/verified/INTEGRATION_STRATEGY.md) | Історичний | Стратегія Phase 5–7 та старі PR. Чинні base і workflow у PROJECT_STATE і AGENTS. | Збережено |
| [MIGRATION_041](codex/verified/MIGRATION_041.md) | Історичний · відкладено | План сторонньої 0.41, умови й права. Цей план окремий від власного Linux-порту. | Збережено |
| [MODULE_INDEX](codex/verified/MODULE_INDEX.md) | Історичний | Карта GDScript модулів для раннього дерева. Актуальні шляхи через git ls-files. | Збережено |
| [MULTIPLAYER_PROTOCOL](codex/verified/MULTIPLAYER_PROTOCOL.md) | Технічний + історія | LAN/ENet, Steam, identity, queues і resync. Джерела net_config.gd, net_session.gd і pc/steam_net.gd. | Оновлено |
| [NEXT_SESSION](codex/verified/NEXT_SESSION.md) | Навігаційний | Handoff перенесено до PROJECT_STATE, посилання збережено. | Оновлено |
| [PHASE5B2_FIXES](codex/verified/PHASE5B2_FIXES.md) | Історичний | Airport, cooldown і cancel fixes. Для теперішнього v0.36 дивись V036_FIX_RESULTS і код. | Збережено |
| [PHASE5B2_PERFORMANCE](codex/verified/PHASE5B2_PERFORMANCE.md) | Історичний | Контрольовані upkeep і ранні CPU вимірювання. Власний workload, поза MinGW і GUI FPS. | Збережено |
| [PHASE5B2_REGRESSION_RESULTS](codex/verified/PHASE5B2_REGRESSION_RESULTS.md) | Історичний | RED/GREEN минулого кандидата, журнали його архіву. | Оновлено |
| [PHASE5B3_PLAN](codex/verified/PHASE5B3_PLAN.md) | Історичний | План наступних фаз і доставки. Чинні пріоритети в PROJECT_STATE. | Збережено |
| [PHASE5B_PLAN](codex/verified/PHASE5B_PLAN.md) | Історичний | План Phase 5B. Статус поточних кандидатів у WINDOWS_QA. | Збережено |
| [PHASE5B_PROGRESS](codex/verified/PHASE5B_PROGRESS.md) | Історичний | Handoffs R02 та 5B.2, експорт тодішнього патча й доказів. Шляхи-checkpoints збережено. | Оновлено |
| [PHASE5C_GEMINI_REVIEW](codex/verified/PHASE5C_GEMINI_REVIEW.md) | Історичний | Рев’ю внеску Gemini й рішення щодо scope. Джерело для тодішніх cleanup результатів. | Оновлено |
| [PHASE5C_INTEGRATION_RESULTS](codex/verified/PHASE5C_INTEGRATION_RESULTS.md) | Історичний | Точний PCK, EXE, матриця й межі Phase 5C. Попередня історія. | Оновлено |
| [PHASE7_BETA_INTEGRATION](codex/verified/PHASE7_BETA_INTEGRATION.md) | Історичний | Дозвіл власника й історія інтеграції до нового snapshot. Поточні refs звірено за Git. | Оновлено |
| [PHASE8_BETA_QA_PLAN](codex/verified/PHASE8_BETA_QA_PLAN.md) | Історичний | Колишня програма QA. Повторно використані сценарії у Windows Beta checklist і Two-peer QA. | Збережено |
| [PR10_BETA_PR_DRAFT](codex/verified/PR10_BETA_PR_DRAFT.md) | Історичний | Локальна чернетка PR у старій історії. | Збережено |
| [PR10_CRITICAL_FIXES](codex/verified/PR10_CRITICAL_FIXES.md) | Історичний | Рішення FIX-01–04 із джерелами й regressions. Статуси сучасного baseline у V036_FIX_RESULTS. | Збережено |
| [PR10_REGRESSION_RESULTS](codex/verified/PR10_REGRESSION_RESULTS.md) | Історичний | Тести, performance й готовність PR10. Межі саме його shell/engine/fixtures. | Збережено |
| [PROJECT_FACTS](codex/verified/PROJECT_FACTS.md) | Історичний | Походження, право, інвентар старого snapshot. Наявність LICENSE перевірено за tracked файлами. | Оновлено |
| [PR_01_TO_10_REVIEW](codex/verified/PR_01_TO_10_REVIEW.md) | Історичний | Авторські commits і diff review попередньої історії. Не карта поточних PR. | Оновлено |
| [PR_AUDIT_OVERVIEW](codex/verified/PR_AUDIT_OVERVIEW.md) | Історичний | Коротке зведення великого PR review, дублює його ключові висновки. | Збережено |
| [PR_DEPENDENCY_GRAPH](codex/verified/PR_DEPENDENCY_GRAPH.md) | Історичний | Ancestry і дерево old PR. Новий репозиторій зі snapshot не відновлює ці refs. | Оновлено |
| [PR_RISKS](codex/verified/PR_RISKS.md) | Історичний | Походження ризиків PA01–PA12 і результати targeted fixes. Відкрите у PROJECT_STATE/BACKLOG. | Оновлено |
| [PR_TEST_RESULTS](codex/verified/PR_TEST_RESULTS.md) | Історичний | Матриця Phase 4, command lines і CPU baseline із конкретного хоста. | Оновлено |
| [R02_FAILURE_INJECTION_TESTS](codex/verified/R02_FAILURE_INJECTION_TESTS.md) | Історичний | Попередня серія R02 failure fixtures. Нові MinGW release результати у WINDOWS_QA. | Оновлено |
| [R02_SNAPSHOT_RESTORE_FIX](codex/verified/R02_SNAPSHOT_RESTORE_FIX.md) | Історичний | Первинна зміна restore та lifecycle diagram. Окремий release failure пізніше підтверджено на трьох runtime. | Оновлено |
| [REONBOARDING_AUDIT](codex/verified/REONBOARDING_AUDIT.md) | Історичний | Audit нового Git snapshot і sync v0.36. Цей аудит використовує окремий інвентар. | Збережено |
| [RESOURCES_AND_UI](codex/verified/RESOURCES_AND_UI.md) | Технічний + історія | Assets, UI та desktop scale. Звірено PcPort, HUD і локальний QA, legacy цифри лише в архіві. | Оновлено |
| [RISKS](codex/verified/RISKS.md) | Історичний | Ризики Phase 5 і тодішнє покриття. Поточні в BACKLOG. | Оновлено |
| [RUNTIME_BASELINE](codex/verified/RUNTIME_BASELINE.md) | Історичний | Headless, save, CPU й native extension стан Phase 2. Поточні EXE у WINDOWS_QA. | Збережено |
| [SAVE_FORMAT](codex/verified/SAVE_FORMAT.md) | Технічний + історія | FORMAT1, graph, defaults та restore lifecycle. Джерела Save, Diplomacy і UrbanHold. | Оновлено |
| [SOURCE_COVERAGE](codex/verified/SOURCE_COVERAGE.md) | Історичний · індекс | Пофайловий ledger зі scope і freshness v0.36. Для сучасних claims перевіряй Git і код. | Збережено |
| [TEST_MATRIX](codex/verified/TEST_MATRIX.md) | Історичний · довідник | Матриці Phase 1–5C та опис fixture scope. Поточні результати в WINDOWS_QA і конкретному CI run. | Оновлено |
| [V036_FIX_RESULTS](codex/verified/V036_FIX_RESULTS.md) | Історичний · база v0.36 | Результати інтеграції PR #4, код той самий у beta. Успіх новішого CI звірено окремо. | Збережено |
| [V036_REVIEW](codex/verified/V036_REVIEW.md) | Історичний · база v0.36 | Знахідки до інтеграційних fixes і baseline performance, пояснює V036_FIX_RESULTS. | Збережено |
| [VERSION_041_ANALYSIS](codex/verified/VERSION_041_ANALYSIS.md) | Історичний · відкладено | Інвентар окремого ZIP і тодішні межі доступу до source. | Збережено |
| [VERSION_041_DIFF](codex/verified/VERSION_041_DIFF.md) | Історичний · відкладено | Порівняння стороннього релізу зі старою версією порту, без поточного плану міграції. | Збережено |
| [WINDOWS_BETA_QA_CHECKLIST](codex/verified/WINDOWS_BETA_QA_CHECKLIST.md) | Шаблон + історія | 18 сценаріїв Phase 5C. Для нового run звірити точний комплект і його MANUAL_QA. | Оновлено |
| [WINDOWS_TESTING](codex/verified/WINDOWS_TESTING.md) | Історичний | Інструкція й headless evidence Phase 2. Поточні Windows дії в BUILD_RELEASE та Two-peer QA. | Збережено |
| [WINDOWS_TWO_PEER_QA_PLAN](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md) | Поточний план + архів | План фізичних LAN/Steam peers, перевірено прапорці PowerShell. Архів SHA CI PR #4 збережено. | Оновлено |

Після аудиту додано [звіт R02](codex/verified/R02_RELEASE_RECOVERY.md) і [довідник хоткеїв](codex/verified/WINDOWS_CONTEXT_HOTKEYS_QA.md).

## Локальні джерела поза Git baseline

Перевірені як джерела. Зміни в цих worktree та артефактах збережено. Поточний локальний комплект і шляхи до його доказів наведено в [Windows QA](WINDOWS_QA.md).

| Файл | Джерело / роль |
| --- | --- |
| `R02_RELEASE_RECOVERY.md` | `port-drone-r02-recovery`, root cause і докази release failure recovery |
| `WINDOWS_GUI_UI_QA_RESULTS.md` | `port-drone-ui-qa`, UI-01/02/03 |
| `WINDOWS_KEYBOARD_QA.md` | `port-drone-input-qa`, INPUT-01 і GAME-01 |
| `WINDOWS_INPUT_FOLLOWUP_QA.md` | `port-drone-input-followup`, межі масштабу й попередній статус BUG-01 |
| `WINDOWS_CONTEXT_HOTKEYS_QA.md` | `port-drone-context-qa`, погоджене вирішення BUG-01 |
| `tools/portable_sfx/README.md` | `droneflames-vm-fix-20261122/source`, локальні SFX scripts, startup і кеш |
| `MINGW_RUNTIME_VALIDATION_20261122.md` | `droneflames-mingw-parity-20261122`, operator race, runtime controls і відновлений CPU benchmark |
| `RESTORE_TRIAGE.md` | Той самий локальний каталог, зіставлення failure на різних release runtime |
| `GODOT_VM_RACE_FIX.md` | `droneflames-vm-fix-20261122/source`, upstream race, patch і ранній MSVC benchmark. Артефактний `VERIFICATION_REPORT.md` є побайтовою копією. |
| `SFX_NATIVE_CRASH.md` | SFX worktrees, первинний native crash. Копії у vm-fix і sfx-ready збігаються. |
| `WINDOWS_PORTABLE_SFX.md` | Ті самі worktree, локальне hardening і scoped SFX тести. Копії збігаються. |
| `tools/portable_sfx/diagnostics/README.md` | Пізніша інструкція native fixtures і символів у vm-fix. |
| `RESULTS.md` | `droneflames-sfx-crash-20261122T001101Z`, варіант crash report із локальними шляхами. |
| `tools/portable_sfx/README.md` + `diagnostics/README.md` | Дві старші версії в sfx-ready. Зіставлено native patch follow-up у vm-fix. |
| `MANUAL_QA.md` | Каталог точного Windows-кандидата, таблиця команд і ручні кроки |

## Архівні посилання

103 недійсні посилання в checkout перетворено на 85 унікальних архівних шляхів. Наявність усіх 85 записів звірено за списками `tar -tzf` у `~/projects/droneflames-backups/cleanup-20261120-230519/`. У звітах зазначено назву `port-drone.tar.gz` або `port-drone-pr10-critical.tar.gz` і відповідний шлях під `./dist/`. Архіви залишаються поза Git. 94 посилання на старі PR замінено їхніми архівними номерами, щоб нові PR з тими самими номерами не підміняли джерело. Старі pinned SHA залишено у звітах. Їхню повну доступність у поточному GitHub не підтверджено. [Чинний Git і CI](PROJECT_STATE.md)

## Завершальна перевірка

- Оновлено 32 з 56 наявних документів, 24 збережено, додано чотири. Перевірено 1597 внутрішніх Markdown-посилань у підсумковому наборі, включно з anchors. Недійсних шляхів або anchors не залишилося.
- Повторно перевірено `git diff --check`, docs-only scope, refs, кодові константи, SHA256 кандидата, відновлення його Git trees та прив’язку звітів до PCK.
- `tools/build.py --print-version` повернув `0.36.0`. Official editor і template збіглися з CI-пінами. Обидва PowerShell launchers пройшли синтаксичну перевірку. `test_release.py` пройшов 15/15, `test_ci_policy.py` — 4/4.
- Нову збірку та повну ігрову матрицю для аудиту не запускали. Ручний QA останнього SFX, фізичний LAN/Steam, late-game FPS, майбутній Linux-порт і UI мають окремі статуси у [PROJECT_STATE](PROJECT_STATE.md).
