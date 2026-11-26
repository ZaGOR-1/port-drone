# Аудит документації DroneFlames

## DOCS-02B — незалежне review

**DOCUMENTATION READINESS: GO** для локального review та погодженого PR у `beta`. **MCP READINESS: DEGRADED.** Git/gh і `rg` покривають GitHub та навігацію за кодом. Підтвердження дійсне для наведеного baseline і документаційного diff.

### Git і незалежна оцінка

- Звірено 2026-11-26. Робоча гілка `docs/docs02-comprehensive-audit` у `~/projects/droneflames-worktrees/docs02` стартувала чистою на `e64c5634136fcd35bd09633fa5e63271f927217b`. Її база, локальна `beta`, `origin/beta` і GitHub ref збіглися на `7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33`. Локальна й віддалена `main` на `172df65e3bd004efed9a5444e90a284d9d69db10`. Fetch і push URL вказують на `ZaGOR-1/port-drone`. У паралельному `performance/source` виявлено ті самі 15 локальних змін. У worktree аудиту паралельних змін не виявлено.
- Повний diff DOCS-02 містив 19 змінених Markdown і один новий CSV. Консолідація identity, правил джерел і handoff корисна. Архівна хронологія збережена в попередньому Git tree, historical anchors і у вихідних QA-звітах. Заявлені вихідні 103 Markdown, 73 `ARCHIVE`, 1 695 локальних посилань, 28 цільових тестів і розмір AGENTS підтверджено відповідними артефактами й повторною звіркою. Попередній INCONCLUSIVE був обґрунтований.
- Економія контексту приховала частину тригерів. Канонічні маршрути показували старі wire/restore твердження поруч із чинним контрактом. BACKLOG призначав Linux і UI наступними етапами, а старий collaboration workflow вимагав прямого дозволу на локальний commit. Для DOCS-02B відновлено обов’язкове читання за scope, короткі активні вступи й чіткі межі історії. Поточні fixtures зібрано у [Development Workflow](DEVELOPMENT_WORKFLOW.md#перевірки-за-scope). Власник зберігає рішення про дозволи та пріоритети.
- Повернуто довгострокові покажчики до R08 DummyTexture, поведінки очищення груп, відкритої Windows перевірки R19 і архівного індексу. Поточна `beta` має чисту продуктову identity 0.36.11, PROTO 7, SIM_REV `v036-integration-1`, FORMAT 1 і точне дерево `game/` `2db4d091f989c8bc7f81f243d5a17f738b8ea3e6`. QA старого SFX і CI цієї `beta` мають різний scope. [Стан](PROJECT_STATE.md) · [Windows QA](WINDOWS_QA.md)

### Семантичне покриття

Машинний розбір DOCS-02B — **103/103**. Семантичний перегляд — **103/103 FULLY REVIEWED**. Після незалежних read-only перевірок і власного читання кожен рядок [наявного інвентарю](DOCUMENTATION_INVENTORY.csv) містить окремі статуси перегляду та доказів, джерела, суперечності, невирішені твердження й рішення. Колонки DOCS-02 відтворюють тодішнє покриття та baseline. Для великих ledger прочитано всю прозу, унікальні твердження, класи й відмінності рядків. Повторювані path/size/hash/range поля звірено машинно. Повнота читання Markdown не підтверджує всі історичні тести, code coverage або поведінку гри.

- FILE_COVERAGE описує 881 blob на `af1b4c9`. Усі 881 шлях і розмір збігаються з історичним publisher tree. 769 SHA256 додатково збігаються з незалежним локальним snapshot `172df65`. Решта хешів залишаються твердженнями архівного ledger. SOURCE_COVERAGE описує 970 blob на `172df65`, усі шляхи й розміри збігаються з Git. Статуси читання цього старого ledger належать його сесії.
- Статуси доказів охоплюють 18 VERIFIED CURRENT, 65 VERIFIED HISTORICAL і 20 HISTORICAL EVIDENCE UNAVAILABLE. В останній групі бракує частини історичних першоджерел. Надалі використовуй додаткові поля CSV. Частина архівних шляхів, зокрема тодішні Phase 4–7 tarballs і Windows Downloads, відсутня в цій сесії. У локальному catalog знайдено 19 непрацездатних symlinks. Індекс, cold storage та розпаковані handoffs мають різну доступність. Точний QA-01 архів і L10N-03 ZIP звірено за SHA256. Для L10N-03 підтверджено додаткові 9 updater і 15 ENet loopback перевірок. Старі цифри залишено як scope першого звіту. [L10N-03](L10N03_QA_SUMMARY.md)
- Нуль побайтових дублікатів і пар із ≥25% спільних 5-слівних послідовностей меншого документа при мінімумі 40 спільних. Чотири групи точних абзаців ≥120 символів належать історичним матеріалам. Семантичні перетини й рішення наведено нижче.

| Кандидат | Унікальні докази, залежності й рішення |
| --- | --- |
| AGENTS / Development Workflow / обидва README | **MERGE** для дубльованих процедур. Права й gates у AGENTS, кроки й тестові точки входу у Development Workflow. README зберігають обидві мови, огляд, credits і права. Identity і статус QA веде PROJECT_STATE. |
| CURRENT_STATE, COLLABORATION_WORKFLOW, DECISIONS, BACKLOG | **ARCHIVE** для тодішніх baseline, ролей, scopes дозволів і triage. **MERGE** чинних процедур у Development Workflow і AGENTS, черги робіт у PROJECT_STATE. Поточні примітки замінено посиланнями, датовані рішення лишено за попередніми шляхами. |
| NEXT_SESSION | **REDIRECT**. Самостійних правил немає. Залишено сумісний шлях через вхідні посилання з CURRENT_STATE, SOURCE_COVERAGE, V036_FIX_RESULTS, V036_REVIEW й аудиту. Поточний маршрут обходить цей файл. |
| ARCHITECTURE / ARCHITECTURE_AND_FLOWS / GAMEPLAY_SYSTEMS / MODULE_INDEX / FEATURE_CATALOG | **KEEP** активний вхід у потоки й gameplay source, **ARCHIVE** датованих карт, назв механік, точних шляхів і результатів. Переміщення змінило б посилання з ledger та PR review і прибрало б provenance. |
| TEST_MATRIX / Phase results / Windows checklist / two-peer QA | **MERGE** нових тестових точок входу в одну таблицю Development Workflow. **KEEP** історичні PASS і точні матриці кандидатів. Шаблон TC-WIN та план двох ПК мають окремі сценарії й точні обмеження. |
| FILE_COVERAGE / SOURCE_COVERAGE / PR_AUDIT_OVERVIEW / PR_01_TO_10_REVIEW | **ARCHIVE**. Ledger стосуються різних дерев. Стислий PR overview містить агреговані ризики й оцінку інтеграції, розгорнуте review фіксує scope та авторство. Посилання між ними збережено. |
| MIGRATION_041 / VERSION_041_ANALYSIS / VERSION_041_DIFF | **ARCHIVE** зі спільним відкладеним scope. Унікальні migration gate, release metadata й порівняння ZIP залишаються на місці. Повторений історичний абзац зберігає обсяг кожного звіту. |

### Покриття правил AGENTS.md

Посилання потрібно відкривати явно. Для Codex CLI 0.171.0 перевірено project root, tracked інструкції, доступні global/override та значення fallback/size у локальній конфігурації. Ланцюжок збирається від global до ближчих до cwd project-рівнів, спочатку override, і має типовий ліміт 32 KiB. У цьому worktree є лише кореневий AGENTS, global/override і налаштованих fallback не виявлено. Markdown-посилання слугують навігацією. [Офіційний порядок](https://learn.chatgpt.com/docs/agent-configuration/agents-md) · [CLI 0.171.0](https://github.com/openai/codex/releases/tag/rust-v0.171.0)

| Оригінал на 7181e88 | Нова локація | Тригер | Вимога | Статус |
| --- | --- | --- | --- | --- |
| Рядок 3, §1–2, scope, мова, джерела, права, ролі | AGENTS · Початок/Пріоритети, README credits | Кожна сесія, особливо погодження розширення scope | Обов’язково | Збережено; факт/гіпотезу/NOT RUN і пріоритет джерел уточнено |
| §3, preflight і вибір довідників | AGENTS · Початок і таблиця, PROJECT_STATE, INDEX | Перед плануванням | Обов’язково | Явний стартовий маршрут, точне джерело перевірки |
| §4, локальний commit, WIP, чужі зміни, приватні дані | AGENTS · Git; Development Workflow | Перед commit/handoff | Обов’язково, PoC/WIP за доречності | Відновлено позначення PoC/WIP та явний контроль перед комітом |
| §4, thematic branch/worktree і cleanup | AGENTS · Git; Development Workflow · Завершення | Створення, handoff, очищення | Обов’язково | Погоджена beta, незалежне відновлення та дозвіл на видалення збережено |
| §4, push, Draft, після публікації, main/beta/release | AGENTS · Git; Development Workflow; Versioning | Push/PR/review/merge/release | Обов’язково | Актуальний конкретний дозвіл; окремий дозвіл на production-дії; CI і фізичний QA мають власний scope |
| §5, Godot, binary/imports, boot, paths, API/ordinals | AGENTS · Godot; Architecture and Flows; Build and Release; Resources and UI | Godot/збірка/зміна контракту | Обов’язково | Фізична ізоляція й tracked imports збережені. Точний source/pin у довідниках |
| §6, SP/MP, ticks, RNG, ordering/threading, hash та peer | AGENTS · Godot; Multiplayer Protocol; fixtures | Simulation, wire, desync | Обов’язково | Відновлено SP adaptive delta, MP 30 тіків/с і 3 тіки/turn, `_sim_step`, thread/order і змінюваний стан |
| §6, authorization і save/restore | AGENTS · Godot; Multiplayer Protocol; Save Format | Wire/UI command, Save/Load або snapshot | Обов’язково | Negative tests, legacy missing defaults, freeze, clean restore, fail closed і migration scope збережено |
| §7, Windows native, SFX, три DLL, R02 та точний комплект | AGENTS · Godot; Windows QA; Build and Release | Native, build, фізичний QA | Обов’язково | SHA256, updater-off, ізоляція, provenance, права й test AppID збережено |
| §8, Profile B, bottleneck, A/B, verdict/QA | AGENTS · Пріоритети; performance.md; Development Workflow | Performance/architecture/native | Обов’язково | Profile B, control evidence і QA після GO збережено. Скасовані suite/preflight/caps підтверджені `086f97c` |
| §9, MCP, Serena/Godot limits, альтернативи | AGENTS · Тести; Development Workflow · Вибір MCP | Підбір або застосування MCP | Контроль scope обов’язковий, вибір MCP за потреби | Active root, shadow, версія та fallback явно доступні |
| §10, scope тестів, reuse, фінальний handoff | AGENTS · Тести; Development Workflow; PROJECT_STATE | До змін, перед інтеграцією, після етапу | Обов’язково | PASS/SKIP/NOT RUN, commands і стан відкритих перевірок доступні |
| §11, product bump і PROTO/SIM_REV/FORMAT | AGENTS · Godot; Versioning Policy; source files | Version/compatibility, інтеграція | Обов’язково | Один bump, provenance, явний дозвіл на contract change. Старий 0.36.0 лишився датованим |
| §12, Loc/PO, fallback, semantic invariants | AGENTS · Тести; Localization Audit/Tests | User-facing text або locale changes | Обов’язково | Відновлено uk fallback check і перевірку прихованих екранів після перемикання |

### Перевірка onboarding

Незалежний read-only субагент пройшов усі вісім маршрутів на DOCS-02. Два незалежні поглиблені проходи перевірили Save/MP/HUD і gameplay/performance/native provenance. Після правок незалежний повторний прохід усіх восьми маршрутів підтвердив достатність для безпечного старту. Продуктові сценарії тут не виконувалися.

| Сценарій | Маршрут після виправлень і джерело | Scoped перевірки й інструменти |
| --- | --- | --- |
| HUD | Architecture → Resources/UI, Loc за наявності тексту. `hud.gd`/extends, Main input, PcPort | Godot API/refs або Git/rg. HUD/camera, hotkeys, масштаби, ru/uk/en та відповідний Windows GUI |
| Army.update | Profile B → Architecture → `_sim_step`, Army/Unit, MP/Save. R23/R19 за дотичності | Профайлер, CLI, replay/target order, `test_r19_acquisition.gd`, restore, порівняння Profile B |
| MP desync | Multiplayer Protocol → NetSession/NetConfig/NetCodec/NetHash і Save для snapshot | Git/rg або свіжий Serena. Admission, authorization negatives, same-seed hash, host/peer та Windows two-peer |
| Save system | Save Format → Save/SaveSlots та NetSession для network restore | Git/rg, PCK fixtures. Legacy Continue, autosave freeze, repeated restore, failure matrix |
| Windows build | Build and Release → CI pin, build.py, Windows QA, version.cfg та Menus.VERSION | Git/gh, build identity, package manifest та SHA256, три DLL і Windows smoke на точному комплекті |
| Нова механіка | Прямий запит → Architecture/Gameplay → owning system і MP/Save/Loc за впливом | Godot/Context7 за потреби, characterization fixture, sim regression/replay, кінцеві Windows сценарії, versioning за gate |
| Rust/GDExtension | Profile B → R23 · Межі NATIVE → Build/Windows QA, код hot path і залежності ABI | Профайлер і frozen fixture. Boundary + marshalling + allocations, differential, matched frames/ticks, перевірка Windows packaging. Чинне рішення — deferred |
| PR іншого агента | Development Workflow → точні head/base та diff, тести за scope, Versioning при інтеграції | Git/gh, CI за точним HEAD, ручний QA в межах diff. Зовнішні дії за чинним дозволом |

Для старту достатні актуальні секції. Датований звіт потрібен, коли задача застосовує його конкретний доказ або досліджує той самий механізм.

### Історичні SHA

Усі 14 об’єктів відсутні в локальному Git і не резолвляться через API `ZaGOR-1/port-drone`. Ті самі 14 SHA підтверджено через endpoint `/repos/frd21313123123/port-drone/commits/<sha>` у publisher-репозиторії. Це узгоджується зі snapshot-рішенням власника. Старі URL лишилися на місці. Git-історію не відновлювали. Ідентифікатори дають provenance, а старі журнали й QA-артефакти мають окремий статус.

| Ідентифікатор | Подія та документи |
| --- | --- |
| [`af1b4c975564bac916db079d8470c2394d4920e5`](https://github.com/frd21313123123/port-drone/commit/af1b4c975564bac916db079d8470c2394d4920e5) | База Phase 1–4, FILE_COVERAGE, MODULE_INDEX, RUNTIME_BASELINE, PROJECT_FACTS та PR review. Publisher tree і 881 path/size підтверджені. Release-тег на цій базі не доводить відповідності executable 0.41. |
| [`d6383064276c13863b3d540ccf4e461408db3d69`](https://github.com/frd21313123123/port-drone/commit/d6383064276c13863b3d540ccf4e461408db3d69) | Старий PR #1 tooling, PR_01_TO_10_REVIEW, PR_DEPENDENCY_GRAPH, PHASE7_BETA_INTEGRATION. |
| [`50efdbac3c860f0a5e8ed63e5c465f2e3f2ddfef`](https://github.com/frd21313123123/port-drone/commit/50efdbac3c860f0a5e8ed63e5c465f2e3f2ddfef) | Старий PR #2 render optimization, ті самі три джерела. |
| [`0a6225c9f6c6c4d7770ce127846b3f65e30cae2c`](https://github.com/frd21313123123/port-drone/commit/0a6225c9f6c6c4d7770ce127846b3f65e30cae2c) | Старий PR #3 simulation performance, ті самі три джерела. |
| [`bb77603d9734ed1b729c3932a9a0ed0267a4a7ad`](https://github.com/frd21313123123/port-drone/commit/bb77603d9734ed1b729c3932a9a0ed0267a4a7ad) | Старий PR #4 Steam/LAN/UI, ті самі три джерела. |
| [`43477a5b3b24e9e81c864e425580c4f4f8cc94ba`](https://github.com/frd21313123123/port-drone/commit/43477a5b3b24e9e81c864e425580c4f4f8cc94ba) | Старий об’єднаний commit #1–4, PR_01_TO_10_REVIEW. |
| [`1806831cd2bcf934e45af7fd89cbf1c64bc262ef`](https://github.com/frd21313123123/port-drone/commit/1806831cd2bcf934e45af7fd89cbf1c64bc262ef) | Старий PR #5 QoL/systems, review, graph і Phase 7. |
| [`f8e42970fe336fcd308fd92ee9e2671293265a7e`](https://github.com/frd21313123123/port-drone/commit/f8e42970fe336fcd308fd92ee9e2671293265a7e) | Старий PR #6 nuclear/Zaslon, review, graph і Phase 7. |
| [`877355144ad6322ac7b00ae4a1de185fe4440b63`](https://github.com/frd21313123123/port-drone/commit/877355144ad6322ac7b00ae4a1de185fe4440b63) | Старий PR #7 carriers/airborne, review, graph і Phase 7. |
| [`299800d9fd2294fa022e84d373969fb6b17160a9`](https://github.com/frd21313123123/port-drone/commit/299800d9fd2294fa022e84d373969fb6b17160a9) | Старий PR #8 seasons/ideology/flags, review, graph і Phase 7. |
| [`4484a53c0a571a1dd56a184c467fde1ced11342e`](https://github.com/frd21313123123/port-drone/commit/4484a53c0a571a1dd56a184c467fde1ced11342e) | Авторський commit chronicle, land deeds, ultimatum, PR_01_TO_10_REVIEW. |
| [`84f95c9c76db802f2774a8201850f3817bfae9e2`](https://github.com/frd21313123123/port-drone/commit/84f95c9c76db802f2774a8201850f3817bfae9e2) | Старий PR #9 chronicle/territory, review, graph і Phase 7. |
| [`508ea94e0402ced83916681ffbf5855f0b580f40`](https://github.com/frd21313123123/port-drone/commit/508ea94e0402ced83916681ffbf5855f0b580f40) | Авторський commit nuclear/VFX/UI/performance, PR_01_TO_10_REVIEW. |
| [`96053d66eb984cc24e3acce647a55a195136abd2`](https://github.com/frd21313123123/port-drone/commit/96053d66eb984cc24e3acce647a55a195136abd2) | Старий PR #10 cumulative і база Phase 5 patches. PR_01_TO_10_REVIEW, PR_RISKS, PR_TEST_RESULTS, FEATURE_CATALOG, CURRENT_STATE та Phase notes. |

Для 13 PR-related SHA альтернативні джерела — exact commit API, датовані numstat/ancestry tables, PR cohort і test summaries. Вказані Phase tarballs, working-tree patches та повні первинні logs цієї серії не були доступні в перевірених місцях. Хеш commit не охоплює тодішні незакомічені patch overlays. Жоден з 14 SHA не є підставою поточного QA PASS або дозволом інтеграції. [PR review](codex/verified/PR_01_TO_10_REVIEW.md) · [Граф](codex/verified/PR_DEPENDENCY_GRAPH.md) · [Phase 7](codex/verified/PHASE7_BETA_INTEGRATION.md)

### Діагностика MCP

У локальній конфігурації дев’ять MCP. У каталозі цієї сесії доступні вісім, GitHub відсутній. Старі smoke стосуються окремих перевірок.

| MCP | Поточний статус, причина та фактичний обсяг | Рішення та дія власника |
| --- | --- | --- |
| Serena | **READY WITH LIMITATIONS** для ізольованої копії, **FALLBACK AVAILABLE** для поточної сесії. Встановлено 2.1.0, backend LSP / gdscript. Сесія активувала `~/projects/port-drone`, тоді як project.godot був у shadow. Editor/LSP на 127.0.0.1:6008 був відсутній, журнал давав connection refused після 30 s. | На окремому свіжому shadow підтверджено symbols для NetConfig і NetSession, тіло `NetConfig.version`, references у NetSession/SteamNet/RTC/UI/LAN discovery. Довгі відповіді скорочено лімітом Serena. Перед навігацією звір root/port/HEAD. Для поточного сеансу Git/rg лишається fallback. |
| Godot | **READY WITH LIMITATIONS**. Спільний shadow має manifest `c91e0e6a7eef831687e6e63550560bba739a6b87` і зайнятий shared lock чинного godot-mcp. Версія engine `4.7.2.stable.official.ed1daf0bf`, addon/server із локально задокументованого OREBRON `20ca9bd083ad`. Окремий shadow зібрано на `7181e88`. Метадані boot/2 autoload, API Node/NetConfig і текстові dependencies пройшли. | Використовуй `project_info`, scoped `project_find` та `class_info` на підтвердженому фізичному shadow. `class_info` може викликати import. Binary scenes мають окремі межі індексації. Shared refresh потребує завершення сесій, що тримають lock. |
| Godot script_check / editor | **READY WITH LIMITATIONS**. Три цільові скрипти дали `checked=3, failed=0, ok=false`, native diagnostics для Linux Device, Steam і WebRTC. Старий parser control з навмисно синтаксичною помилкою повертав файл і рядок. Спільний editor bridge недоступний. На свіжому shadow editor bridge слухав 127.0.0.1:6510, але два smoke дали WebSocket deadline, включно зі спробою після готовності layout. Причину timeout далі не встановлено. Editor API у DOCS-02B не підтверджено. | Повний script PASS потребує придатного runtime. Використовуй pinned CLI/PCK, джерело й Windows QA для відповідного scope. Editor/import та UID/cache лише у фізичній копії. |
| GitHub | **FALLBACK AVAILABLE**, власник потрібен лише для відновлення MCP. Запис увімкнений, transport HTTPS до `api.githubcopilot.com`, `bearer_token_env_var=GITHUB_PAT_TOKEN`. Змінна в перевіреному процесі відсутня, GitHub tools у каталозі сесії відсутні. PAT validity та remote MCP handshake — NOT RUN. | `git ls-remote`, `gh api`, `gh pr view` і `gh run view` працюють. За потреби перед новою локальною сесією завантаж погоджений токен із власного сховища в `GITHUB_PAT_TOKEN`. Переконайся в наявності через `test -n "${GITHUB_PAT_TOKEN:-}"`, запусти `codex -C ~/projects/port-drone` і перевір read-only PR lookup. |
| Context7, Semgrep | **READY WITH LIMITATIONS**. Доступні в каталозі, scoped smoke DOCS-02 повторно використано. | Context7 для pinned API, patch API звіряй із engine. Semgrep для підтримуваних мов, GDScript поза scope. |
| Playwright, Chrome DevTools, draw.io, Figma | **READY** для підтвердженого smoke DOCS-02. Браузерні/дизайнерські робочі сценарії тут **NOT APPLICABLE**. | Playwright/DevTools для browser QA, draw.io для схем, Figma для погодженої UI/UX роботи. Для Godot GUI застосовується Windows QA. |

Локальний `godot-mcp-support/sync-shadow` бере чистий committed baseline `beta`, переносить tracked imports і remaps, перетворює 26 ECFG entries з `override.cfg` у текстовий проєкт лише у фізичній копії. Попередню копію може архівувати повністю. DOCS-02B перевірив механізм на копії підтримувального tooling у `/tmp/droneflames-docs02b/`. Коли спільний lock вільний, штатна команда — `~/projects/droneflames-toolchain/godot-mcp-support/sync-shadow`. Якщо скрипт повідомляє про локальні дельти, переглянь їх. Після підтвердження `--archive-local` збереже попередню копію цілком. Процес і артефакти описані в локальному `godot-mcp-support/README.md`.

Для повторення Serena probe використовуй окремий `SERENA_HOME`, `.serena/project.yml` із `languages: [gdscript]` і `read_only: true` у фізичному shadow. У `$SERENA_HOME/serena_config.yml` задай `ls_specific_settings.gdscript.port: 16008`. Probe із налаштуванням порту лише в project.yml повернувся до 6008. Запуск editor із тим самим портом — `godot --path <shadow> --editor --headless --lsp-port 16008` через pinned editor і приватний XDG. Перевір `ss -lnt` і стартуй `serena start-mcp-server --project <shadow> --context codex --language-backend LSP` у тому самому ізольованому оточенні. Global конфіг, credentials і production не змінювалися. [Serena 2.1.0 backend](https://github.com/oraios/serena/blob/v2.1.0/src/solidlsp/language_servers/godot_language_server.py) · [Godot MCP](https://github.com/orebron/godot-mcp/tree/20ca9bd083ad) · [GitHub MCP](https://github.com/github/github-mcp-server)

### Валідація і передача

- Нові — `git diff --check`, DOCS-02B diff review, машинний inventory 103/103, 1 784 локальних посилань і anchors, окрема перевірка sources та правил. Змінені файли відносяться до Markdown і наявного CSV. `game/`, `libs/`, tools, tests і workflows побайтово ідентичні baseline. Нових секретів у patch не виявлено.
- Нові — build identity 0.36.11, SHA256 pinned Godot editor/template, каталоги з 0 structural/active-literal errors, Python build identity 3/3, CI policy 4/4, artifacts 6/6, release mock 15/15, локалізація 2 PASS + 1 SKIP без engine fixture. Усього 30 PASS, 1 SKIP.
- Повторно використано точний baseline CI `45714307932`: Python і Windows build/regression SUCCESS, release SKIPPED. R23 і Native evidence використано в їхньому первісному scope. Нові Windows GUI/LAN/Steam, R23 replay і повна Godot regression — NOT RUN для docs-only diff. [Baseline CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45714307932)
- Стартовий контекст у байтах **AGENTS сам** 24 587 → 11 491 → 15 550. **AGENTS + PROJECT_STATE** 66 878 → 15 788 → 20 525. **Практичний маршрут з INDEX** 71 271 → 19 225 → 24 210. Колонки відповідають baseline, DOCS-02, DOCS-02B. Тригери додають тематичні секції під задачу. Ці числа вимірюють байти, окремої оцінки токенів немає.
- Власнику — review локального документаційного коміту, звірка нового tip `beta` перед публікацією, окремі рішення про push/PR та merge. Відновлення спільного shadow або GitHub MCP потрібне тільки за фактичного використання. [Правила](../AGENTS.md#git-і-повноваження)

---

## DOCS-02 · 2026-11-26

**INCONCLUSIVE для повного приймання.** Документаційні зміни та локальні перевірки готові до review. Повний Markdown corpus прочитано машинно, розібрано за секціями й класифіковано пофайлово. Зміст і докази переглянуто цільово. Построкова семантична верифікація всіх історичних тверджень і незалежне відтворення всіх старих прогонів залишаються поза підтвердженим покриттям.

### Baseline і scope

- Локальна `beta`, `origin/beta` і GitHub ref збіглися на `7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33`. `main` і його remote ref на `172df65e3bd004efed9a5444e90a284d9d69db10`. Fetch і push URL `origin` збіглися. [PR #21](https://github.com/ZaGOR-1/port-drone/pull/21)
- Гілка `docs/docs02-comprehensive-audit`, worktree `~/projects/droneflames-worktrees/docs02`. До роботи production checkout чистий, у діагностичному `performance/source` 15 наявних змін. В інших зареєстрованих worktrees релевантних незакомічених Markdown не знайдено. Зміни власника й інших задач залишено в їхніх checkout.
- [Інвентар 103 документів](DOCUMENTATION_INVENTORY.csv) містить точний шлях, обсяг, SHA256 блоба, останню зміну, знайдені маркери scope, аудиторію, окремий висновок, Markdown-залежності, історичну цінність, статус, ризик і дію. 103/103 UTF-8 Markdown розібрано й класифіковано. Машинний аналіз охопив увесь текст, Markdown AST, посилання, дати, SHA та сигнали результатів. Цільова звірка охопила тексти за змістом із глибшими перевірками змінюваних контрактів. Вкладених tracked `AGENTS.md` або інших Markdown-розширень не виявлено. Поза `docs/` охоплено README, AGENTS і `tools/qa/r23/README.md`.
- Окремо перевірено локальні індекси MAINT-01–05, R23 і NATIVE-01–02D та індекс cold storage. Це локальні докази поза 103 tracked файлами. Вихідні копії збірок, сторонні пакети, кеші й приватні профілі виключено з інвентарю. MAINT-03/04/05 описують вже виконані merge, backup та очищення, тому старі шляхи й колишні дозволи використовуй лише як історичні відомості.

### Висновки за напрямами

| Статус | Теза й джерело |
| --- | --- |
| VERIFIED_CURRENT | `tools/build.py --print-version` → 0.36.11. `version.cfg` і `Menus.VERSION` синхронні. `NetConfig` дає PROTO 7, SIM_REV `v036-integration-1`, 30 ticks/s, три ticks/turn та identity з повною версією. `Save.FORMAT=1`. [Стан і посилання на код](PROJECT_STATE.md) |
| VERIFIED_CURRENT | `override.cfg` → `pc/boot.tscn`/updater → remapped binary PackedScene → Main. PcPort і SteamNet — autoload. Main створює GameWorld, HUD та NetSession. Extends звірено в `game/game/main/`, `game/game/game_world/`, `game/ui/hud/`. Спільний порядок MP і межі snapshot звірено за `NetSession`, `NetConfig` і `Save`. Реалізацію reconnect/resync підтверджено статично. [Потоки](codex/verified/ARCHITECTURE_AND_FLOWS.md), [Save](codex/verified/SAVE_FORMAT.md) |
| VERIFIED_CURRENT | Нативний Ubuntu 26.04.1, kernel 7.0.0-44-generic, Python 3.14.4, Codex CLI 0.171.0, gh 2.46.0. Офіційний editor `4.7.2.stable.official.ed1daf0bf` і Windows template збіглися за SHA256 з [CI-піном](../tools/ci/godot-4.7.2.json). PE/DLL і пакування описано в [Build and Release](codex/verified/BUILD_RELEASE.md). Локальні SFX і MinGW мають власний provenance. |
| VERIFIED_CURRENT | Workflow запускає Windows x64 build і Python/Godot checks на відповідних PR/push. Релізний guard отримує `release=false`. Для baseline Python/CI policy і Godot/Windows build SUCCESS, release SKIPPED. DOCS-02 CI окремо не запускався. [Workflow](../.github/workflows/build.yml), [run 45714307932](https://github.com/ZaGOR-1/port-drone/actions/runs/45714307932) |
| OUTDATED | README називали 0.36.0 чинним identity; динамічні значення перенесено до PROJECT_STATE. Історичний WSL2 відділено від поточного нативного Ubuntu. L10N-03 і старий handoff називали PR #7 Draft/NOT READY на тому checkpoint. GitHub підтверджує подальший merge, а тодішній результат QA збережено. [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7) |
| CONTRADICTORY | Презентація старого PROJECT_STATE змішувала current baseline зі старим backlog, назвами гілок і ручними gate. Чинний порядок залишено в короткому стані, а датовані факти — в [immutable Git snapshot](https://github.com/ZaGOR-1/port-drone/blob/7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33/docs/PROJECT_STATE.md). Старий опис Steam env уточнено. Непорожній `DF_STEAM_MOCK`, включно з `0`, активує mock, а Steam QA launcher прибирає змінну. |
| VERIFIED_CURRENT | `Loc.PUBLIC_LANGS` має ru/uk/en. QA checker завершився з 0 structural/active-literal errors. Історичні counts і fallback деталі мають власний scope. [Localization audit](LOCALIZATION_AUDIT.md) |
| VERIFIED_HISTORICAL | R23 offline analyzer і validator повторно пройшли на наявному harness: 65 повних GUI-прогонів, 64 matched comparisons і historical snapshots. Контрольні версії, Profile B, незалежні NO-GO R11/R12/R13/R22 і окремі NATIVE висновки збережено. Компіляцію та GUI-прогони тут не повторювали. [R23](r23/R23_RESULTS.md), [команди](../tools/qa/r23/README.md) |
| VERIFIED_HISTORICAL | Перевірено інвентар NATIVE-01 та handoff NATIVE-02–02D. Маніфести NATIVE-02B–02D пройшли повністю на розпакованих файлах. У шести позицій NATIVE-01/02 розпаковані файли відсутні, потоки із cold storage збіглися з маніфестами за SHA256. NATIVE-01 засвідчив технічну можливість, 02 — обмежений дослідницький GO, 02B — витрати маршалінгу acquire, 02C/02D — межу виграшу для Vision/Army. Rust production відкладено. |
| UNVERIFIED / NOT RUN | Фізичний Windows GUI/FPS, кампанія власника, LAN, Steam і reconnect/resync для baseline DOCS-02 не проганялися. Старий SFX acceptance має точний артефакт і сценарій. Авторство та обмеження розповсюдження збережено в README. Tracked standalone LICENSE для гри не знайдено. [Windows QA](WINDOWS_QA.md), [права](../README.md#ліцензія-та-права-використання) |

### Канонічна структура й рішення

- [INDEX](INDEX.md) визначає один маршрут на кожну тему. AGENTS зберігає обов’язкові обмеження. PROJECT_STATE зберігає поточний handoff. [Development Workflow](DEVELOPMENT_WORKFLOW.md) описує Git, тести, MCP та оновлення пам’яті. Build/Windows QA, Profile B, wire/save, локалізація й versioning залишаються в тематичних джерелах.
- `SPLIT` для PROJECT_STATE. Історична хронологія доступна в Git за baseline і в наявних тематичних матеріалах. `REDIRECT` для NEXT_SESSION, який веде до AGENTS і PROJECT_STATE. README обох мов посилаються на одне джерело identity. `CURRENT_STATE` зберігає старий handoff, `BACKLOG` — датовані записи triage, `DECISIONS` — передумови й наслідки рішень. Чинні дозволи веде AGENTS.
- `ARCHIVE` в інвентарі означає історичну роль на наявному шляху. Жоден Markdown не видалено й не переміщено. Немає окремих `MERGE`/`DELETE`: у звітах збережено унікальні результати й provenance. У [INT08](r15/INT08_INTEGRATION.md) виправлено вхідний anchor до INT07. Попередній DOCS audit лишився нижче зі своїм обсягом і якірними посиланнями.
- 103 Markdown до і після. Дії інвентарю: 73 ARCHIVE, 16 UPDATE, 12 KEEP, 1 SPLIT, 1 REDIRECT. Загалом 9 943 → 9 757 рядків і 1 606 596 → 1 577 327 байтів Markdown. CSV-інвентар виміряно окремо: 58 266 байтів. AGENTS — 113 → 37 рядків, 24 587 → 11 491 байт. PROJECT_STATE — 236 → 27 рядків, 42 291 → 4 297 байтів. Обов’язковий стартовий контекст — 66 878 → 15 788 байт (−76,4%). Токени не вимірювалися, відповідного tokenizer локально не виявлено. `project_doc_max_bytes` не задано, global AGENTS і вкладених інструкцій не виявлено. Старий і новий AGENTS окремо нижчі за default 32 KiB. PROJECT_STATE відкривається за посиланням і врахований у метриці старту. [Codex AGENTS.md guide](https://learn.chatgpt.com/docs/agent-configuration/agents-md)

### MCP аудит

У локальному `codex mcp list` дев’ять записів CONFIGURED. Перевірки нижче стосуються доступних інструментів поточної сесії. [Матриця вибору](DEVELOPMENT_WORKFLOW.md#вибір-mcp)

| MCP | Фактична перевірка | Статус |
| --- | --- | --- |
| Serena | Manual і активний проєкт визначено. `get_symbols_overview` для NetSession завершився помилкою підключення до Godot LSP. G07 зі старих звітів не є підтвердженням цього середовища. | AVAILABLE, LSP FAILED |
| Godot | `project_info` визначив shadow, boot та autoload. `class_info` повернув `PackedScene.instantiate`. `project_find` знайшов посилання boot → updater. Editor bridge недоступний, SHA256 shadow NetSession відрізняється. `script_check` для NetConfig повернув `checked=1, failed=0, ok=false` через відсутні Linux GDExtension Device/Steam/WebRTC. Editor scenarios NOT RUN. | AVAILABLE, SMOKE PASS для metadata/API/references, LIMITED для script check |
| Context7 | Lookup і versioned запит повернули upstream docs з гілки 4.7. Patch-specific API звірено через engine class_info. | AVAILABLE, SMOKE PASS |
| GitHub | Є bearer config. У каталозі поточної сесії MCP відсутній, налаштована bearer env-змінна в перевіреному процесі відсутня. PR/CI/refs читали через `gh` і Git. | CONFIGURED, UNAVAILABLE, MCP NOT RUN |
| Semgrep | `get_supported_languages` повернув Python/YAML та інші мови. GDScript відсутній. Скан коду не потрібен для цього scope. | AVAILABLE, SMOKE PASS |
| Playwright | Прочитано список вкладок. Функціональний браузерний сценарій N/A. | AVAILABLE, SMOKE PASS |
| Chrome DevTools | Прочитано список сторінок. Функціональний браузерний сценарій N/A. | AVAILABLE, SMOKE PASS |
| draw.io | `get_drawio_reference` повернув Mermaid довідник. Редагування N/A. | AVAILABLE, SMOKE PASS |
| Figma | `whoami` підтвердив доступ без виведення даних акаунта. Файловий сценарій N/A. | AVAILABLE, SMOKE PASS |

### Валідація й межі

- PASS — build identity 3/3, CI policy 4/4, CI artifact 6/6, release tooling 15/15. Широкий Python discovery без `DF_GODOT` завершився OK з 10 SKIP, включно з class setup. Повну нову Godot regression, Windows GUI і performance suites позначено NOT RUN. Доказ baseline CI наведено окремо.
- PASS — версія та SHA editor/template, `check_l10n.py`, R23 offline, внутрішні Markdown paths/anchors, README language navigation і docs-only diff. Одноразова перевірка використала встановлений MarkdownIt. Постійний checker і зміни CI не потрібні для цього етапу.
- Перевірено current PR через `gh pr list` і чотири явно вказані CI runs. 14 pre-snapshot SHA з GitHub commit/blob-посилань не резолвляться в поточному GitHub API. Старі URL та PR-журнали збережено як історичні посилання. Частина вкладень залежить від оригінальних backups. Номери старих PR не ототожнено з новими. Повну перевірку сторонніх URL і переобчислення всіх історичних серій не виконували.
- Runtime, ресурси, продуктова версія й мережеві контракти збережено. Історичних PASS і NO-GO не переоцінювали. Для наступного приймання потрібне локальне review змін із цим обсягом аудиту та окрема Windows сесія на точному комплекті.

---

## Попередній аудит · 2026-11-22

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
