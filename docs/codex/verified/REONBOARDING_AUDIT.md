# Актуалізація re-onboarding після v0.36 — 2026-11-21

Поточний стан — [CURRENT_STATE](CURRENT_STATE.md); code checkpoint `0f26040994043827a7c14913d945a3df02e00fdd`. CI відновлено PR #2, v0.36/fixes інтегровано PR #4 звичайним merge зі збереженням8+10commits. Beta [CI 44937756401](https://github.com/ZaGOR-1/port-drone/actions/runs/44937756401) PASS43 Godot tests/2476 regression checks/Windows build/identity/integrity, release SKIPPED. Full Windows GUI і два фізичні LAN/Steam peers NOT RUN. Цей docs sync не повторює code audit й не запускає QA.

- Identity тепер v0.36.0/7/v036-integration-1, FORMAT1; старий pc/UI mismatch і missing workflow усунуті.
- П’ять HIGH v0.36 FIXED: identity, snapshot aliases, Navy restore, UrbanHold cooldown, power auth. Hash/upgrades/tooltips виправлені. [Source-backed implementation/test results](V036_FIX_RESULTS.md).
- Native headless startup мав PASS, але shutdown leaks10/224/44 залишаються CONFIRMED/inherited; CPU early-world mean/p99 гірші за pre-v0.36 beta, без загального gain. Поточний risk register — CURRENT_STATE/BACKLOG; updater integrity, save durability, general schemas і full real MP OPEN.
- Початковий ledger FULL33/PARTIAL16/INDEXED235 GDScript та6.51% рядків залишається **історичним**. Змінені v0.36 blobs не успадковують FULL; SOURCE_COVERAGE має current freshness/additions overlay. Увесь GDScript не був повністю прочитаний/семантично перевірений; compiler/runtime tests цього не доводять.
- Початковий R01 missing CI — RESOLVED; C01 version mismatch — FIXED, exact-build cohort requirement лишається. R13 shutdown і R14 CPU risk вже мають нові measurements, а не лише історичні підозри. Chronicle тепер adaptive4..64s з compaction, не fixed4s capture до зупинки.
- Remote main не змінюється. PR #1 завершується цією окремою документаційною задачею; фактичний final head/merge/CI визначати GitHub. Попередні дозволи/заборони в reports не застосовувати як current workflow.

## Перевірка фінального docs sync PR #1

Порівняння з origin/beta:23 paths (22 Markdown +1 original drawio), production game/libs/tools/tests/CI tree byte-identical. Один additive BACKLOG conflict розв’язано зі збереженням обох dated sections. PASS:UTF8/newlines/fences,1345 local links із Markdown/HTML anchors,988 tracked paths accounted,3 diagram pages/IDs/endpoints, credential-pattern scan, git diff --check. Credits/license README byte-identical до першого docs commit; build commands актуалізовані до source version assertion. 28 light Python tests PASS; release-related output mocked, реальних публікацій немає.

Ці checks не є full source audit або manual reading кожної inventory row. PR #1 current-head CI, merge, beta push CI та cleanup визначаються після GitHub операцій і не оголошуються наперед. Evidence локально ignored dist/docs-pr1-final/; runtime GUI/LAN/Steam не запускався.

## HISTORICAL — первинний аудит172df65 і перевірка першого docs commit

Усі таблиці, статуси CURRENT/PARTIALLY OUTDATED та висновки «немає CI/engine», «no publication», «PARTIALLY READY», SHA172df65 і числа нижче стосуються **початкового snapshot до PR #2/#4**, а не поточної beta. Вони збережені як докази й межі первинного читання. Поточні flows/build/tests див. у документах вище.

# DroneFlames — re-onboarding нового репозиторію

2026-11-21; baseline `172df65e3bd004efed9a5444e90a284d9d69db10`. **PARTIALLY READY.** Інвентар охоплює весь tracked snapshot, критичні startup/simulation/command/save/restore/updater/build потоки досліджено; повний семантичний аудит усіх текстових файлів НЕ завершений. Обмеження не підміняються старими звітами або автоматичним індексом. [Пофайлове покриття](SOURCE_COVERAGE.md) дозволяє продовжити без повторного великого discovery.

Нижче Git status/«publication не виконано» та test results фіксують первинний етап аналізу до документаційного commit. Подальша команда власника дозволила публікацію документаційного PR; її scope, перевірка remote policy та спосіб визначити актуальні refs — [CURRENT_STATE](CURRENT_STATE.md#repository-identity). Це не змінює coverage або статус runtime перевірок і не оголошує PR merged.

## Repository identity і метод

Git root `/home/zagor/projects/port-drone`, origin `https://github.com/ZaGOR-1/port-drone.git`. `pwd`, rev-parse, status, branch -vv, remote -v, log -5, ls-files, worktree list та read-only `ls-remote --heads origin main beta` перевірені. Local/remote main/beta = повний SHA вище; один root commit `feat: add game files`, один worktree. Initial status clean beta; створено **локальну docs/codex-reonboarding від origin/beta**, HEAD незмінний. Fetch/pull старої історії, commit/push/PR/merge/tags/release/dispatch не виконувалися.

LFS3.7.1 встановлений, але `git lfs ls-files` порожній; .gitattributes/.gitmodules/submodules не знайдені. Жодних приватних saves/accounts/config/token не читали. Поточні docs diff і source safety — у CURRENT_STATE та фінальному звіті.

| Baseline inventory | Значення |
|---|---:|
| Tracked files / bytes |970 /115159619|
| Text / binary |680 /290|
| Text bytes / lines |10951776 /354461|
| GDScript files / bytes / lines |284 /6307192 /182509|
| Markdown files / bytes / lines |48 /922022 /5432|
| Python / JSON / PO / import+remap |14 /93 /4 /210|
| class_name / cached class paths / lexical functions |130 /130 /7600|

Рахували tracked paths baseline до edits; нові Markdown і .drawio додаються окремо, не змінюють baseline count. Рядки — splitlines UTF8; `.import` із trailing NUL класифіковано текстом після in-memory strip; файли не переписувалися. Text volume включає документацію/локалізації/import metadata, не лише executable code. 7600 functions — lexical index, не compiler/call graph proof.

Інструменти: Git/rg/Python stdlib; Serena initial/activate успішні, GDScript symbols недоступні через LSP127.0.0.1:6008 — використано звичайне читання; Context7 `/godotengine/godot-docs/__branch__4.7` для PCKPacker; native Windows PowerShell AST; draw.io для editable документаційної схеми. Playwright/Chrome/Figma не застосовували: вони не підміняють Godot Windows QA. Стиль документації узгоджено з наданими українськими інструкціями; сторонні writing samples не отримували.

У checkout немає `tools/codex/repository_audit.py`, початкових `docs/codex/01_ARCHITECTURE.md`, `04_BUILD_RELEASE.md`, `05_TESTING.md`, `06_GUARDRAILS.md`. Аудит виконано тимчасовими stdlib scripts; ignored evidence `dist/codex_audit/reonboarding-172df65/` містить source-index.json, static.json, historical-coverage-comparison.json, python-discovery.log, tests.json. Основні висновки нижче збережені незалежно від ignored artifacts.

## Головні source-backed висновки

1. Це Godot/GDScript PC-порт з binary project/resources, не Pygame. Відсутність текстового main.tscn не означає missing scene: remap веде до tracked672-byte RSRC PackedScene. Усі210 import/remap targets існують; game/.godot не видаляти.
2. Godot4.7.2 pinned у [fetch_godot.py](../../../tools/fetch_godot.py), project feature4.7. **CI workflow відсутній**, тому старе «workflow pins/manual main publication gate» не підтверджене в цьому snapshot. Remote branch protection/settings не досліджено й не змінено; локальна policy не доказ remote enforcement.
3. `pc/version.cfg=0.33.2.3`, `Menus.VERSION=v0.34.0`; build temp copy підміняє обидва. PROTO7/SIM_REV pr10-phase5b2-1/FORMAT1 залишаються фактичними. Однаковий SIM_REV не гарантує однаковий build.
4. SP simulation залежить від frame delta/budget; MP має fixed1/30 tick,3 ticks/turn і host canonical command order. Global RNG, workers, Dictionary/float/shared static впливи не всі семантично reviewed. Fixed timestep сам по собі не доводить determinism.
5. LAN/Steam доступні у normal PC UI. Online/WebRTC/API/ranked source лишився, UI online_ok=false. Online-casual host handover не є LAN/Steam host migration.
6. Command dispatch має ownership і targeted schemas, зокрема build/free, Ship.c і land recipient consent. Broad allowlist без повних per-method schemas/rate budget залишається hardening gap. Реальний airport action простежений від UI до build/hash.
7. Restore failure/epoch/chunk bounds/local-player cleanup guards є в source і мають targeted fixtures. Старий R02 не слід повторно оголошувати безумовним поточним дефектом. Загальна атомарність world rollback відсутня; partial failure freeze/leave і rebuild menu — явна поведінка.
8. Optional land cooldown persist/preflight/hash present. Нові→старі saves мають semantic downgrade incompatibility навіть з тим самим FORMAT1. Disk save durability і deep malformed handling не вичерпні.
9. Updater cleanup звужено до власних expendable temp names зі збереженням .old. Повна activation/rollback/integrity transaction **не забезпечується цим cleanup**. QA лише з updater off.
10. Chronicle — bounded SP frames/events і viewer/archive; не full deterministic command replay. Frozen-river navigation не підтверджена Seasons class; текст UI не доказ. Ідеологічний defense bonus потребує окремого damage review.

Детальні ownership/extends/init/order/system state/serialization/callers/limitations — [ARCHITECTURE_AND_FLOWS](ARCHITECTURE_AND_FLOWS.md). Тут не дублюється велика карта.

## Markdown: інвентар, статус, відповідність коду

Усі48 baseline Markdown доступні й автоматично прочитані/проіндексовані; **47 повністю прочитані агентом**, один — FILE_COVERAGE — prose/table початок прочитані, вся таблиця881rows машинно зіставлена, але ручне читання решти не завершене. Не заявляємо виконання literal «повністю кожний документ». Нові5 Markdown і edits перевірені окремо. Схожі reports не називаємо DUPLICATE без тотожності: вони мають різні checkpoint scopes; exact duplicates не встановлено.

Статус таблиці стосується змісту baseline, «дія» показує результат цього re-onboarding. UNVERIFIED claims усередині historical report не роблять його current. Старі dist links/SHA зберігаються як provenance, їх існування зараз не гарантоване.

| Документ (verified/, якщо не вказано інше) | Призначення / baseline status | Відповідність і дія |
|---|---|---|
| ../../../AGENTS.md | Active rules; PARTIALLY OUTDATED | Старі Phase5/7 authorizations/paths прибрані; поточні компактні правила CURRENT |
| ../../../README.md | Ukrainian entry; PARTIALLY OUTDATED | Старий PR11/Git attribution/current test claims виправлені, missing template link прибраний |
| ../../../README.en.md | English entry; PARTIALLY OUTDATED | Ті самі factual corrections; збережено bilingual content |
| ../../performance.md | Benchmark guide/results; PARTIALLY OUTDATED | Скрипти існують; old benchmark numbers не rerun, CLI bots≤7; не змінено |
| ARCHITECTURE.md | Baseline architecture; PARTIALLY OUTDATED | Main/World chain підтверджено, old inventory/code refs не повна current map; замінює new flows |
| BACKLOG.md | Task/risk queue; PARTIALLY OUTDATED | Додано current tasks; старі checkpoints явно HISTORICAL |
| BUILD_RELEASE.md | Build/publication guide; PARTIALLY OUTDATED | build/fetch/pack present; workflow відсутній; new Windows plan current |
| COLLABORATION_WORKFLOW.md | Active workflow; PARTIALLY OUTDATED | Нові branches/scope/review/Git safety; старий текст під HISTORICAL |
| CURRENT_STATE.md | Session checkpoint; PARTIALLY OUTDATED | Новий current state зверху; весь старий текст збережено під HISTORICAL |
| DECISIONS.md | Decision journal; PARTIALLY OUTDATED | Додано нове owner scope/history decision; попередні task permissions historical |
| ENVIRONMENT_SETUP.md | Old installed engine/tool paths; HISTORICAL | Нинішнього engine/template немає; WSL/native PowerShell перевірені заново |
| FEATURE_CATALOG.md | Baseline feature assessment; PARTIALLY OUTDATED | Реальні classes є; newer seasons/land/Chronicle/fixes описані у new flows |
| FILE_COVERAGE.md | Old881-file hash/read inventory; HISTORICAL |769 identical/110 changed/2 missing проти snapshot **до edits**; не успадковуємо FULL; new coverage all970 |
| GAMEPLAY_SYSTEMS.md | Baseline mechanics; PARTIALLY OUTDATED | Ряд систем існує; current state/callers/save/test matrix у new flows; full helper semantics ще UNVERIFIED |
| INTEGRATION_STRATEGY.md | Old cumulative PR integration; HISTORICAL | Додано explicit historical notice, жодних old branch/SHA actions |
| MIGRATION_041.md | Deferred migration/source gates; HISTORICAL | ON HOLD, matching materials не шукали; не next stage |
| MODULE_INDEX.md | Old paths/symbol index; PARTIALLY OUTDATED | Paths/extends lexical checked, нові/видалені files є; new source coverage актуальний |
| MULTIPLAYER_PROTOCOL.md | Protocol/restore/admission notes; PARTIALLY OUTDATED | PROTO7/SIM_REV confirmed; new flow уточнює fail-close/chunks/host change; runtime не rerun |
| PHASE5B2_FIXES.md | Airport/cooldown/cancel/upkeep fixes; HISTORICAL | Відповідні code/tests present; старі PASS не current |
| PHASE5B2_PERFORMANCE.md | Old before/after profile; HISTORICAL | Results не відтворені, p99 не certified |
| PHASE5B2_REGRESSION_RESULTS.md | Old regression evidence; HISTORICAL | Target suites present, зараз SKIP |
| PHASE5B3_PLAN.md | Old follow-up checkpoints; HISTORICAL | Не чинна інструкція restore/worktrees |
| PHASE5B_PLAN.md | Old stabilization task; HISTORICAL | Не authorization на нові production edits |
| PHASE5B_PROGRESS.md | Old evolving checkpoint; HISTORICAL | Не current HEAD/uncommitted-state proof |
| PHASE5C_GEMINI_REVIEW.md | Review of old cleanup/CI; HISTORICAL | Cleanup present; reviewed CI artifact не перенесений |
| PHASE5C_INTEGRATION_RESULTS.md | Old acceptance report; HISTORICAL | Старі branch/main refs, engine/PASS не поточні |
| PHASE7_BETA_INTEGRATION.md | Old PR11/merge record; HISTORICAL | За owner нова історія intentional; не вимагати old merge SHA |
| PHASE8_BETA_QA_PLAN.md | Old build/two-peer plan; PARTIALLY OUTDATED | Launcher concepts reused; new Windows plan замінює old paths/build identity |
| PR10_BETA_PR_DRAFT.md | Old PR draft; HISTORICAL | PR не створювали; не current proposed integration |
| PR10_CRITICAL_FIXES.md | Old critical patch rationale; HISTORICAL | Consent/Ship/render/carrier guards code exists; test runtime pending |
| PR10_REGRESSION_RESULTS.md | Old regression/build logs; HISTORICAL | Не new snapshot PASS |
| PROJECT_FACTS.md | Old identity/resources/legal facts; PARTIALLY OUTDATED | Rights caution still relevant; current count/version refs інші |
| PR_01_TO_10_REVIEW.md | Cumulative PR source review; HISTORICAL | Повністю прочитано; старі open statuses/PA01–09 не нинішній status |
| PR_AUDIT_OVERVIEW.md | Old PR audit summary; HISTORICAL | Не повторювали GitHub PR audit/source discovery |
| PR_DEPENDENCY_GRAPH.md | Old ancestry graph; HISTORICAL | Нова історія без цих ancestors, не переносити cumulative PR |
| PR_RISKS.md | PA risk evidence; HISTORICAL | Useful reproduction context, current classifications нижче |
| PR_TEST_RESULTS.md | Old candidate checks; HISTORICAL | Не execution evidence цієї сесії |
| R02_FAILURE_INJECTION_TESTS.md | Old injected/real restore tests; HISTORICAL | Fixtures прочитані; зараз не запущені |
| R02_SNAPSHOT_RESTORE_FIX.md | Restore lifecycle fix; HISTORICAL | Source guards verified; no full transactional rollback claim |
| RESOURCES_AND_UI.md | Baseline import/UI survey; PARTIALLY OUTDATED |210 mappings130 cache checked; UI behavior NOT RUN; new atlases present |
| RISKS.md | Baseline R01–R18; PARTIALLY OUTDATED | Окремі fixes наявні; current register нижче, не автоматично всі OPEN |
| RUNTIME_BASELINE.md | Old Godot/Windows/perf results; HISTORICAL | Old installed tool artifacts unavailable; не current tests |
| SAVE_FORMAT.md | Format1/persistence design; PARTIALLY OUTDATED | Current Save/Slots fully read; optional cooldown + fail-close path уточнено у new flow |
| TEST_MATRIX.md | Layered old test reports; PARTIALLY OUTDATED | Current warning/result/link added; all old counts historical |
| VERSION_041_ANALYSIS.md | External release analysis; HISTORICAL | Не matching source/codebase, повторно не досліджували |
| VERSION_041_DIFF.md | Old comparison limits; HISTORICAL | Не незалежний PC port acceptance criterion |
| WINDOWS_BETA_QA_CHECKLIST.md |18 manual cases; PARTIALLY OUTDATED | Reused, current warning/plan link; cases не виконані |
| WINDOWS_TESTING.md | Old manual environment plan; PARTIALLY OUTDATED | New paths/peer/exact hashes plan current, old steps не rerun |

Критичні суперечності: active AGENTS вимагав відсутні files/старий worktree і переносив Phase7 permissions; README посилався на відсутній PR template і описував старі contributions як current Git ancestry; reports приписували missing CI manual release gate; version labels розходяться. Виправлено активні AGENTS/README/workflow/state/backlog/journal/test-entrypoints, історичні reports масово не переписувалися й не видалялися.

## Build/resources і environment

WSL Ubuntu26.04, Python3.14.4, Git2.53.0. Godot/godot4/Wine/pwsh у PATH відсутні; `godot_dl` editor/template немає. Native PowerShell доступний у Windows System32, draw.io Desktop — у Windows user installation; відсутність PATH command не вважається відсутністю інструменту взагалі. Нових залежностей не встановлювали, Godot не завантажували.

[build.py](../../../tools/build.py) temp-copies game/, patches version/repo, запускає [pack.gd](../../../tools/packproj/pack.gd), додає PCK до Windows template з alignment/footer. ZIP містить3 tracked DLL із libs/; SHA256SUMS — EXE+ZIP. Launchers копіюються окремою cp командою. Немає Godot export-presets pipeline/.github workflow у snapshot. Packer бере hidden files/наявні imports; editor cache modifications можуть вплинути на package. [fetch_godot.py](../../../tools/fetch_godot.py)/remote_unzip мають no-digest cache/download boundary; не вважати downloaded binary verified без зовнішньої checksum звірки.

Binary inventory:114oggvorbisstr/89ctex/67ogv/8png/4fontdata/3dll/2mp3str/1scn/1bin/1binary. Import/resource paths підтверджують роль texture/audio/font/PackedScene; media contents/якість не переглянуті. project.binary ECFG metadata прочитано stdlib parser; DLL PE AMD64 і hashes перевірено, actual load NOT RUN. .bin semantics не вгадували. Точні paths/sizes усіх binary — SOURCE_COVERAGE; тільки3 DLL hashes винесені в Windows plan, не тисячі hashes у Markdown.

PCKPacker API звірено через Context7 з [офіційною Godot4.7 class reference](https://github.com/godotengine/godot-docs/blob/4.7/classes/class_pckpacker.rst); це не перевірка availability/authenticity editor4.7.2 і не runtime test. Власна реалізація append/footer підтверджується локальним build.py. [Точні підтримувані команди](WINDOWS_TWO_PEER_QA_PLAN.md) підготовлені, build не виконували.

<a id="test-map"></a>
## Тести: файл → система → запуск → обмеження

Позначення U=`PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p '<file>.py' -v`; engine wrappers знаходять **DF_GODOT або godot_dl**, не довільний PATH godot. Локальні artifacts: static.json/tests.json/python-discovery.log; 15 release tests також запущено окремо до full discovery. Godot skips не означають assertions PASS.

| Файл / тип | Система й що перевіряє | Запуск / реальний статус цієї сесії | Межі |
|---|---|---|---|
| tests/test_release.py / Python unit | Numeric version/event/PR selection, mocked API draft/publish/retry/checksums | U(test_release) **15 PASS**, exit0 | FakeGitHub, production publication не було; helper success не CI policy enforcement |
| tests/test_ci_policy.py / static unit | Manual release/main/input combinations, workflow strings | U у full discovery **FAIL**,10 error reports |4 methods/subtests missing `.github/workflows/build.yml`; не game failure, не ignore |
| tests/test_godot.py → test_godot_suite.gd / regression | Cmd field/static, hash/codec/delayed/RNG, FX/shader, step1..6 backend | U(test_godot) **SKIP** | Suite lexical index; не вся реалізація вручну дочитана, не live multiplayer |
| tests/test_pr10_critical.py → test_pr10_critical.gd | Render farm/hash, human consent/land validation, Ship.c, Chronicle ship, carrier loss | U(test_pr10_critical) **SKIP** | Component/command tests, не full UI/backend soak |
| tests/test_phase5b2.py → test_phase5b2_gameplay.gd | Main airport route05, cooldown persistence06, rebase07R/airdrop07A cancellation | U(test_phase5b2), gameplay **SKIP** | One Main/Net fixture, без actual transport |
| той самий wrapper → test_upkeep_fallback.gd | Lazy tally call count/reference economics/RNG after mutations | U(test_phase5b2), upkeep **SKIP** | Synthetic3 countries, не full sim p99 |
| tests/test_sim_revision.py → test_sim_revision.gd | Current SIM_REV та incompatible saved match reject before mutation | U(test_sim_revision) **SKIP** | Не universal exact EXE identity/admission test |
| tests/test_snapshot_restore.py → test_snapshot_restore.gd | Injected loader lifecycle, epoch/queue/idempotence/timeout/overflow/failure retain | U(test_snapshot_restore) **SKIP** | Loader stub; timeout handler викликається без180s wait |
| той самий wrapper → test_snapshot_restore_integration.gd | Real Save/Main decode, malformed/refs/system data, injected UI error, retry/hash/RNG/command continuation | той самий test, **SKIP** | Local ticks/different render schedules, не два network peers; expected errors окремі |
| tests/test_updater_cleanup.py → run_updater_cleanup.gd + test_updater_cleanup.gd | Real cleanup whitelist/.old/symlink/permissions/idempotence | U(test_updater_cleanup) **SKIP** | Updater не add_child/_ready; немає download/activation/fault rollback; Windows deny-delete частково conditional |
| tests/test_pr10_save_continue.gd / standalone | Main/HUD→save/load/continue restored refs/UI/world | Editor/PCK standalone script з isolated users; **NOT RUN** | Немає unittest wrapper; не запускати release EXE --script за старим невдалим harness |
| tests/test_network_admission.gd / standalone2-process | Host/guest version admission | Editor+one PCK `--script <file> -- --role=host\|guest --port=... --ready=... --stop=... --host_version=... --out=...`; **NOT RUN** | Orchestrator не tracked; host_version лише expected text, mismatch потребує distinct identity fixture; не rejoin/full game/Steam |
| tools/check_performance.py → performance_regression.gd | Inventory/spatial/water/land/colony/reference codec/save isolation | `python3 tools/check_performance.py --godot <editor> --mode regression --out <fresh>` **NOT RUN** | Native/shutdown diagnostic allowlist має вузький scope; не full behavior acceptance |
| tools/performance_benchmark.gd | Same checkpoint `_sim_step` timings/RNG/config/autosave | `check_performance.py --mode benchmark ...` **NOT RUN** | Не FPS/GPU; p50 не записує, p99/p95/max/samples; long runs не потрібні тут |
| tests/benchmark_upkeep_fallback.gd | Focused upkeep cost distribution | Standalone editor script isolated **NOT RUN** | Не whole simulation; old reports historical |
| tools/build.py/packproj + imports/PE | Windows artifact package/native structure | `--help` **PASS**; build **NOT RUN** | No editor/template, no EXE/PCK generated |
| tools/qa/Run-DroneFlames.ps1, Run-MultiplayerQA.ps1 | Windows native/GUI/log/user isolation launch | Native PowerShell **AST PASS**, execution **NOT RUN** | Parser не тестує APIs/startup/Win11 responsiveness |
| WINDOWS_BETA_QA_CHECKLIST.md |18 GUI/manual gameplay scenarios | **NOT RUN**, next Windows plan | No Playwright substitution, TC14 requires human peers |
| Windows native headless / LAN/Steam two PCs | DLL load/lockstep/RNG/disconnect/rejoin/resync | **NOT RUN** | AppID480 test only; host migration LAN/Steam N/A |

Full discovery:26 methods,15 pass,7 skip,4 methods with errors (10 error reports через subtests), exit1. Повторний запис логів не є новим runtime scope. Shell commands `tools/build.py --help`, `tools/check_performance.py --help` exit0. Static checks:14 Python AST,93 JSON,4 PO syntax/no duplicate keys,210 targets,130 classes PASS. Це не Godot parser/import/compile validation.

PO structural counts en6619 entries/222 empty, uk6628/244, es4380/4284, ru23/0; counts не є відсотком UI translation coverage (включають catalog metadata/obsolete conventions). Binary/video/audio/translation UX NOT RUN.

PowerShell AST виконано через Windows `powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File <temporary parser> -RepoRoot <WSL UNC root>`, без запуску launchers чи зміни global execution policy. Початкові спроби harness мали policy/path помилки, після process-local bypass і UNC path обидва AST PASS; це не product defect і не запуск гри.

<a id="risk-register"></a>
## Актуальний реєстр ризиків

CONFIRMED static означає доведений code gap; runtime incident/exploit окремо UNVERIFIED, якщо не відтворено. P1 — перед публікацією/покладанням на функцію; P2 — цільовий QA/fix після reproduction. QA blockers нижче стосуються безпечного isolated testing, не stable release acceptance.

| ID / статус / priority | Доказ та вплив | Відтворення / потрібна перевірка | Windows / MP QA blocker |
|---|---|---|---|
| N01 CONFIRMED P1 | tests/test_ci_policy.py читає missing workflow; повний suite FAIL | Actual full discovery log; окрема задача відновлення policy/checks без bypass | Не блокує manual build технічно; блокує заяву «усі checks green» |
| N02 CONFIRMED P1 | Editor/template unavailable у checkout/PATH; runtime unknown | Підготувати pinned4.7.2 з digest; compile/load/regressions/build | Так, build/runtime до dependency preparation |
| R03 CONFIRMED static P1 | updater._do_update: EXE digest optional, libs ZIP no digest/completeness/per-file check | Fake HTTPS release/assets: bad/missing digest, partial ZIP, write failure; disposable install only | Ні при DF_NO_UPDATE1 + repo empty; updater QA окремо |
| R04 CONFIRMED static P1 | updater replacement multi-file/nontransactional, unchecked rollback/process launch, timeout0 | Interrupt/locked DLL/permission/rename fail між кожним кроком, atomic integrity proof | Ні при updater off; publication risk лишається |
| R05 CONFIRMED static P1 | SaveSlots.before_write fresh clears previous copies до rename; rotation/meta unchecked; NetConfig.save_match remove-before-rename | ENOSPC/deny-write/power loss fixtures на копіях; fallback after interrupted first save/rotation/MP checkpoint | Ні, лише isolated saves; failure matrix не закрита |
| R06 CONFIRMED scope gap P2 | Save._sound disk narrow vs full nested schema; net preflight сильніший, staged restore не full rollback | Deep malformed signed/corrupt data, old/optional fields, continuation with all systems/Cad344 | Не блокує isolated QA; compatibility не certified |
| R07 CONFIRMED gap / exploit UNVERIFIED P1 | NetSession.ALLOWED broad, targeted validators лише частині; `_owns` direct args; no explicit command-rate budget | Per-method malformed arity/types/NaN/nested-owner/oversized/rate/replay commands isolated hostile peer | Normal trusted QA можливий, malicious acceptance не закрита |
| R08 SUSPECTED runtime / mapping CONFIRMED P2 | SteamPeer peer_id modulo low32 can collide; wants_session no lobby-membership check | Synthetic colliding IDs/nonmember HELLO, stale nonce/session churn, packet caps | Не блокує2 trusted peers; real Steam NOT RUN |
| R09 NEEDS MANUAL QA P1 | Fixed ticks/explicit RNG/hash є; full helper/RNG/Dictionary/worker data flow incomplete, digest aggregate | Exact binaries, same turn/hash/RNG under different FPS/stalls, load+continue across peers | Це предмет MP QA; не claim deterministic-certified |
| R10 CONFIRMED diagnostic gap P2 | NetConfig.trace false; launcher без trace, CLI guard згадується comments, handler не знайдений | Підготувати окремо дозволений diagnostic harness, verify actual logs/turn identity | Блокує доказове hash/RNG acceptance до collection method |
| R11 NEEDS MANUAL QA P1 | Reconnect/resync/host saved resume code present; online-only handover | Disconnect guest/host, late chunks, retained tokens, explicit retry, packet loss; LAN/Steam two PCs | QA purpose; LAN/Steam automatic host migration N/A |
| R12 HISTORICAL issue / static fix present P2 | Save.apply_ui_scale delegates PcPort; old double-scale finding не current confirmed | Windows DPI/resize/fullscreen/input mapping з18cases | No; manual UI NOT RUN |
| R13 HISTORICAL P2 | Old ObjectDB/resources/RID at exit reports; RefCounted/backrefs можливі | New pinned engine normal quit/repeated new/load/soak, measure leaked objects and retain stderr | No; не замовчувати logs або називати resolved |
| R14 HISTORICAL P2 | Old p99 regressions; upkeep lazy fallback exists/test present | Same seed/dt/checkpoint/config before/after, raw samples+p50 externally/p99/max | No; довгий benchmark не виконували |
| R15 PARTIAL / NEEDS MANUAL QA P2 | LandTrade._withdraw reassigns forces/base; all parking/type/path cases не доведені | Full/foreign/incompatible base, blocked land route, carrier cargo under transfer | No; targeted gameplay QA |
| R16 CONFIRMED bounded behavior P2 | Chronicle.step skips net_driven,450 frame cap; Seasons only farm/visual freeze; ideology helper lacks defense function | Long match/archive finalframe, MP expected no Chronicle, defense damage differential | No; не рекламувати full replay/frozen navigation/bonus без proof |
| R17 HISTORICAL / runtime UNVERIFIED P2 | Old valid-ID Windows SteamMock `/tmp` finding; bypass0 code present | Portable mock fixture у копії; real Steam окремо | SP/LAN launchers bypass0; mock portability не вважається tested |
| C01 CONFIRMED contract P1 | SIM_REV constant не fingerprint, version labels mismatch, FORMAT1 optional fields | Manifest exact EXE/DLL/engine + incompatible admission/save downgrade fixtures | Обидва peers один exact комплект; source/old build mixing заборонено |
| C02 UNVERIFIED rights P1 | README no standalone LICENSE/rights confirmations; imported DLL/media provenance неповний | Owner provenance/permissions review перед distribution; binaries не замінювали | Не local analysis; publication окремо й без дозволу не виконувати |

Old PA/R02 defects: airport command, human consent, Ship owner, cooldown persistence, input cancel, render-driven snow мають відповідні code paths/fixes/fixtures у snapshot. Вони **HISTORICAL, runtime rerun pending**, не автоматично CONFIRMED current failures. Без фактичного reproduction не присвоюємо BROKEN усій механіці. Жоден ризик не виправляли production edits у цьому scope.

## Persistent knowledge та acceptance

Створено NEXT_SESSION, REONBOARDING_AUDIT, ARCHITECTURE_AND_FLOWS, SOURCE_COVERAGE, WINDOWS_TWO_PEER_QA_PLAN і editable reonboarding-flows.drawio. CURRENT_STATE використано повторно; AGENTS/обидва README/активний collaboration workflow/test matrix/backlog/decision journal/Windows18 checklist/old integration entry оновлені. Інші historical reports збережені; mass rewrite не робили.

| Acceptance group | Стан |
|---|---|
| Correct repo/main/beta/local docs branch/inventory/Git safety | DONE |
| All Markdown available/indexed, classified, contradictions found | DONE; literal full manual read **47/48**, FILE_COVERAGE table gap |
| All tracked text accounted and structural index | DONE680; **full semantic read NOT COMPLETE** |
| Critical architecture/mechanics/network/save/build reconstruction | DONE у зафіксованих boundaries; helper semantics PARTIAL/UNVERIFIED |
| Runtime proof/full Windows build/GUI/live multiplayer | NOT RUN за scope; Godot missing |
| Safe Python/static tests with failures retained | DONE; full discovery FAIL recorded |
| Active AGENTS + six persistent docs + next QA plan | DONE |
| Documentation-only tracked diff/no Git publication | DONE; final verification перевіряє hashes/refs/diff |

Прогалини: після фокусного читання критичних потоків лишається великий обсяг INDEXED helpers/tests/localization/JSON/shader/resource metadata; один historical Markdown table не дочитаний вручну. Це обмеження поточного аудиту, не доказ браку функціональності. Next session має дочитати лише релевантні gaps перед зміною механіки; не потрібно відновлювати стару історію чи повторювати весь inventory/discovery.

Можна готувати prerequisites Windows build за окремою новою задачею. Для обґрунтованого статусу READY бракує pinned engine/template, actual regression/build result і способу збору peer hash/RNG; для двох людей — один exact комплект, два Windows ПК/тестові Steam accounts за потреби та виконання cases. Повне re-onboarding acceptance за вимогою «усі текстові джерела повністю» ще не досягнуте.

## Фінальна перевірка документаційного результату

- PASS: усі970 baseline files на місці; SHA256 усіх922 non-Markdown files незмінні. Змінено15 baseline Markdown, додано5 Markdown +1 drawio; production code/config/resources/DLL без змін.
- PASS: HEAD/main/beta/origin refs лишилися172df65; повторний remote ls-remote підтвердив main/beta172df65. Commit/push/PR/merge/release/dispatch не виконано.
- PASS: git diff --check;1061 local links у нових документах/AGENTS/README ведуть до наявних paths. Це перевірка existence, не всіх heading anchors/історичних dist links.
- PASS: SOURCE_COVERAGE містить рівно970 unique baseline paths, без missing/extra. Markdown matrix охоплює48 baseline documents; FILE_COVERAGE лишився PARTIAL.
- PASS: drawio XML3pages/27vertices/24edges, unique IDs/valid endpoints/geometry; усі3pages експортовані native Desktop і переглянуті. Перший CLI page0 не підтримується встановленою версією (потрібен1-based), libavoid layout теж недоступний; ручне компонування виправлено, фінальні exports exit0. Це не runtime перевірка гри.
- PASS: повторний PowerShell AST двох launchers збережено у powershell-ast.log, без виконання launchers. Full Python suite не повторювали після documentation-only edits; попередній FAIL лишається чинним.

Локальні machine proofs: final-validation.json, diagram-export.json/PNG, powershell-ast.log, coverage-summary.json у ignored evidence directory. Вони не є опублікованими artifacts.

## Перевірка перед документаційним PR — 2026-11-21

За окремою командою власника перевірено всі21 файла документаційного diff:20 Markdown і одну drawio. Нового source audit або refactoring не проводили; FULL104/PARTIAL17/INDEXED559/BINARY290 лишилися статусами первинного baseline, не оцінкою runtime готовності.

- PASS: UTF8, кінцевий newline, збалансовані fences, структура таблиць нових документів,1186 локальних посилань із перевіркою Markdown anchors, git diff --check. Diagram XML:3pages/27vertices/24edges, valid IDs/endpoints/geometry.
- PASS: SHA256 усіх922 baseline non-Markdown files незмінні. У двох README ліцензійні секції та code blocks запуску/збірки byte-identical до baseline; attribution оригінальних авторів, ZaGOR-1 і OKREDU збережено.
- Повторно виконано release tests:15 PASS. Full Python discovery:26 methods,10 errors через missing workflow,7 Godot skips — **FAIL**, не green CI. Godot/Windows build/GUI/live multiplayer не запускалися.
- GitHub read-only inspection: main/beta172df65 перед публікацією,0workflows, beta protected=false, active branch rules=[]. За відсутнього CI PR лишається відкритим; merge/protection bypass не виконувати. Main/releases поза дозволеним scope.

Докази цієї перевірки: ignored dist/codex_audit/reonboarding-docs-review/documentation-validation.json, release.log і python-discovery.log. Публікаційний стан визначати через Git/GitHub за CURRENT_STATE; цей запис не оголошує merge.
