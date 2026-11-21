# DroneFlames — поточний технічний стан

Оновлено 2026-11-21 після integration PR #4. **READY TO START WINDOWS TWO-PEER QA**; це готовність до тестування, не сертифікація gameplay/multiplayer. Цей документаційний етап не повторює повного аудиту й не запускає GUI/Steam/LAN.

## Repository identity

| Поле | Перевірений checkpoint |
|---|---|
| Repository | https://github.com/ZaGOR-1/port-drone.git |
| Primary root | /home/zagor/projects/port-drone; не припускати шлях іншої сесії |
| main | `172df65e3bd004efed9a5444e90a284d9d69db10`, не змінюється цією задачею |
| v0.36 code integration у beta | `0f26040994043827a7c14913d945a3df02e00fdd`, merge PR #4 |
| Reviewed integration head | `0c92d4c216a281a70fa21869408190b83b42aded` |
| Beta CI | [push run 44937756401](https://github.com/ZaGOR-1/port-drone/actions/runs/44937756401) — PASS для цього exact commit |
| Docs PR #1 | `docs/codex-reonboarding` → beta, синхронізовано звичайним merge з v0.36; кінцевий стан і SHA брати з Git/GitHub |

`0f26040994043827a7c14913d945a3df02e00fdd` — зафіксований code/QA checkpoint, **не обіцянка вічного HEAD beta**. Документаційний merge змінить beta SHA без зміни code tree. Кожна сесія: git fetch/status/ls-remote; перевірити actual HEAD і PR. main — прийнята stable база; beta — активна розробка й QA; feature/fix/docs створюються від актуальної beta. Старі SHA/Phase5–7 дозволи не відновлювати.

## Поточні контракти й виправлення

- Godot **4.7.2.stable.official.ed1daf0bf**, editor/template pin та digest у `tools/ci/godot-4.7.2.json`. CI перевіряє actual version/hashes. Локальний cache не tracked: його наявність перевіряти, не припускати й не встановлювати іншу версію.
- UI `v0.36.0`, `pc/version.cfg=0.36.0`, PROTO **7**, SIM_REV **v036-integration-1**, Save.FORMAT **1**. `build.py --print-version` перевіряє згоду source UI/updater; --version є assertion, не довільною підміною. SIM_REV не content fingerprint; QA exact EXE/DLL SHA256.
- CI відновлено [PR #2](https://github.com/ZaGOR-1/port-drone/pull/2), merge `145f23418a9a07420a15d6c350ac62c7633e2765`. Workflow PR→beta, push beta/main: tests/build only; release job неактивний, updater repo empty. PR template відсутній.
- [PR #4](https://github.com/ZaGOR-1/port-drone/pull/4) інтегрував 8 author commits OKREDU/CAFAIML +10 commits fixes/docs, без squash/rebase. PR #3 GitHub автоматично позначив MERGED через включення його head, окремої команди merge/close #3 не було; branch cleanup не переписує ancestry.
- П’ять HIGH **FIXED**: compatibility identity; повний autosave graph freeze; Navy current-threat routing та repeated-restore scratch reset; UrbanHold far_fail persistence/default/clear/preflight; power priority wire/schema/ownership. Деталі й tests — [V036_FIX_RESULTS](V036_FIX_RESULTS.md).
- Hash охоплює нові nuclear/EMP/T3/power/convoy/hold/route поля, canonical dictionaries; upgrades filter не ховає VBox; tooltip EMP75s/MIRV2decoys. Це не доказ exhaustive hashing або повного semantic review.
- Project: binary `game/project.binary` + override.cfg; PcPort/SteamNet → pc/boot → updater bypass → remapped binary main scene → Main/World/Net/Menus. `game/.godot/` потрібний; `game/project.godot` не створювати. Editor/import — лише disposable copy.
- Save optional land/UrbanHold cooldown: old→new missing defaults перевірені, **new→old downgrade unsupported**. LAN/Steam transport існує; online-only automatic handover не обіцяється LAN/Steam. Chronicle — адаптивні SP keyframes/events, не command replay.

## Фактичні перевірки та межі

| Перевірка | Доказ / статус |
|---|---|
| v0.36 final local suite | PASS43; new behavioral fixture108 assertions; це попередня implementation session |
| CI beta `0f26040` | PASS43 з Godot /179.738s, simulation2476 PASS, Windows x64 build + artifact integrity + packaged identity PASS; release SKIPPED |
| CI job без Godot | 36 tests,9 engine-dependent skips; не видавати skips за engine PASS |
| Actual Main restore/legacy/defaults/replay continuation | PASS у targeted fixtures, hash/RNG з різним render schedule |
| ENet compatibility | PASS двох loopback processes з контрольними cohort identities; не full cross-version match |
| Native Windows headless | PASS попереднього PR #4 CI package: exit0/48.792s,3 DLL loaded; не GUI/Steam |
| Windows GUI / real two-PC LAN/Steam / GPU | **NOT RUN** |

PR #1 CI і post-merge CI його нового HEAD — окремі runs; їх перевіряти на GitHub, не успадковувати PASS run вище за самою назвою гілки. [План одного точного Windows комплекту](WINDOWS_TWO_PEER_QA_PLAN.md).

## Відкриті ризики й покриття

1. CPU: current early-world fixed mean0.264–0.313ms/p99=2.084–2.396ms проти beta до v0.36 mean0.197–0.241/p99=1.614–1.810. Workload0units,19–20facilities/SP async variability; загального gain не підтверджено, це не FPS/GPU claim. Потрібний late-war profile.
2. Inherited clean shutdown **FAIL/OPEN**:10 CanvasItem RID,224 ObjectDB,44 resources-at-exit. Exit0 не закриває leaks.
3. Windows GUI/Shift/scale/render batching, same-build real LAN/Steam, disconnect/rejoin/resync та довга робота — NOT RUN; це наступний QA.
4. Updater integrity/atomicity, OS-level save durability/deep corruption та general command schemas/rate budgets поза power guard — OPEN. QA updater off, synthetic/copied saves.
5. Початковий onboarding при172df65 мав FULL33/PARTIAL16/INDEXED235 GDScript,11886/182509 рядків (6.51%). Ці цифри **історичні**; v0.36 зміни не успадковують старий FULL. [SOURCE_COVERAGE](SOURCE_COVERAGE.md) має dated ledger та freshness overlay; full semantic audit усіх scripts не заявляється.

[Архітектура](ARCHITECTURE_AND_FLOWS.md), [початковий audit і актуалізація](REONBOARDING_AUDIT.md), [backlog](BACKLOG.md), [NEXT_SESSION](NEXT_SESSION.md). Документація й agent rules не надають постійного дозволу на наступні commit/push/merge/main/releases.

---

## HISTORICAL — попередня Git-історія, текст збережено



Усе нижче описує колишні checkpoints/worktrees/SHA/результати. Це не активний workflow і не дозвіл на Git або release дії. Current facts — вище.

# Поточний checkpoint — Phase 7, integration authorization

2026-11-20. Власник змінив порядок: **спершу інтеграція cumulative PR1–10 + Phase5–5C у development beta, потім Windows GUI/full multiplayer QA**. Дозволено local commits, push Codex branch, один PR і merge виключно в beta без bypass protections. Main/release/tags/manual dispatch/Gemini лишаються недоторканними.

[Ancestry mapping, backup та integration plan](PHASE7_BETA_INTEGRATION.md), [Phase8 QA](PHASE8_BETA_QA_PLAN.md). Усі10актуальнихheads включені, origin/beta не має незалежних commits. Phase5C archive86files verified, новий Phase7 backup verified. Gameplay/updater/CI вже закомічені окремими наборами; актуальні HEAD/status брати з Git, не припускати uncommitted стан з історичних документів.

Під час створення цього checkpoint PR/merge ще не оголошені виконаними. Точний результат після операції — GitHub PR, origin/beta та `dist/phase7_20261120-224516/PHASE7_FINAL_REPORT.md`. GUI/full MP залишаються NOT RUN; known updater/save/network/shutdown/p99 — OPEN. Updater **off**, repo-empty QA builds; один exact build на peers.

Нижче — історичні checkpoints, їхні старі заборони/порядок QA superseded поточним рішенням Phase7. Наступному агенту не повторювати повний аудит; перевірити фактичний Git і продовжити Phase8.

---

# Поточний checkpoint — Phase 5C, 2026-11-20

**READY FOR FINAL QA**, не beta merge. [Повні результати](PHASE5C_INTEGRATION_RESULTS.md), [Gemini review](PHASE5C_GEMINI_REVIEW.md), [18 ручних Windows-сценаріїв](WINDOWS_BETA_QA_CHECKLIST.md).

Worktree `/home/zagor/projects/port-drone-pr10-critical`; branch `codex/fix-pr10-critical`; HEAD `96053d66eb984cc24e3acce647a55a195136abd2` + **uncommitted Phase 5 / R02 / 5B.2 / 5C**. Загалом 18 dirty tracked files, із них 15 production; AGENTS/docs/tests/template також untracked. Голий HEAD не містить fixes. Не checkout/reset/stash/clean/rebase; commit/push/PR/merge/release/dispatch потребують окремої команди.

G01 прийнято зі звуженням whitelist та збереженням усіх `.old`. Runtime checks: Linux 35 PASS; native Windows 36 PASS, 3 skip/N/A (два symlink creation unavailable, POSIX permission). G02: targeted gitignore без видалення ресурсів. Baseline 881 tracked → HEAD 903 (+23−1); Gemini 625 не підтвердилося. G03: corrected checklist, усі 18 manual NOT RUN. G04: local PR template. Gemini worktree/status/updater/6 transfer files незмінні.

Погоджений власником **SIM_REV=pr10-phase5b2-1**: exact identity gates для hello/rejoin/Steam/saved resume. Actual two-process ENet 5/5 PASS: same-build приймається; PR10/5B.2/R02 та reverse old host відхиляються. Saved identity 30 checks PASS. Рядок не є code fingerprint: для QA потрібен exact same EXE/DLL SHA. PROTO 7 / FORMAT1 number / DLL / command ordering / restore implementation не змінені. Optional cooldown field із 5B.2 та unsupported new→old downgrade залишаються.

Final PASS: 26 Python; 2476 Godot regression; 309 mechanics; 81 critical; R02 111+41; airport 21 / cooldown 41 / REBASE 33 / AIRDROP 33 / upkeep 26; Main/HUD save→load→continue 23+23; 269 scripts / 883 source та Windows embedded hashes. Native Windows startup exit 0, усі три original DLL loaded/hash match. **Shutdown FAIL/OPEN**: 11 CanvasItem RIDs, 225 ObjectDB, 44 resources. Linux native extensions BLOCKED. Windows GUI / full real multiplayer / Steam NOT RUN; whole-game p99 OPEN. R02 fault injection має очікуваний intentional script error; не називати всі logs «без помилок».

Source PCK: `dist/phase5c_20261120-220811/candidate_review.pck`, SHA256 `5ed8822e33cf9d59dd033f9ad2391ac4b0cb566123d060d586aa5d6452f8e35e`. Windows EXE: `dist/phase5c_20261120-220811/windows-release/DroneFlames.exe`, SHA256 `53d73aa29733efd46d962cdb3ae2a2a3af6cdd7b46ac30f300e6f06a191887f6`. Existing v0.34.0 label не є затвердженим stable. SP `Run-DroneFlames.ps1 -Mode Gui` ізолює user paths, вимикає updater, обходить Steam. `Run-MultiplayerQA.ps1` має LAN default / explicit Steam option; лише підготовлений і AST-validated, не запускався.

Local CI: beta/main push + PR — tests/build only; release лише explicit manual main + publish_release + approved version. Offline policy/YAML checks PASS; actual Actions NOT RUN. Remote може ще мати старий auto-release, бо push не було. Перед beta потрібні Windows GUI / full two-peer / human review і рішення щодо R03/R04 updater, R07 network schema, R05 save durability, shutdown та p99. Main — stable; 0.41 — DEFERRED.

Новий backup 70 файлів з actual extraction/hash proof у `dist/phase5c_20261120-220811/backup/`; попередні rollback/PCK незмінні. Final patch/archive/restore proof і `final_results.json` там само. Із 883 game files порівняно з 5B.2 відрізняються тільки updater/net_config. Усі локальні refs, зокрема main/beta/OKREDU/migration, незмінні; remote актуальність перевірити перед майбутньою інтеграцією. Наступна сесія продовжує з цього checkpoint, без повторного повного аудиту.

---

## Історичний checkpoint до Phase5C (збережено)

# Поточний checkpoint — Phase 5B.2, 2026-11-20

**READY FOR NEXT STAGE** для локальних FIX05–08; готовність усієї beta не підтверджена. [Fixes/root causes](PHASE5B2_FIXES.md), [фактичні тести](PHASE5B2_REGRESSION_RESULTS.md), [performance](PHASE5B2_PERFORMANCE.md), [наступні задачі](PHASE5B3_PLAN.md).

Worktree `/home/zagor/projects/port-drone-pr10-critical`, branch `codex/fix-pr10-critical`, HEAD `96053d66eb984cc24e3acce647a55a195136abd2` + **uncommitted** Phase5/R02/FIX05–08.14dirty tracked production files загалом,7productionfiles змінені саме Phase5B.2;4newtest sources. Не checkout/reset/stash/clean/rebase. Ці fixes не існують у голому HEAD і не потраплять у нову гілку від HEAD автоматично.

FIX05 airport dispatch+network build schema/free=true guard; FIX06 optional `sys.diplo.land_cooldowns` persistence+prevalidation+hash; FIX07 Esc/RMB REBASE/AIRDROP+targeted command schemas; FIX08 lazy fallback,2500→0extra calls/profile. Попередні Phase5/R02 tests і restore functions збережено. Python20/Godot2476/mechanic309/critical81/R02111+41/savecontinue23+23/нові21+41+33+33+26 PASS.269scripts/883source&Windows embedded hashes PASS; native Windows headless exit0. GUI/full multiplayer NOT RUN, shutdown FAIL/OPEN, whole-game p99 OPEN.

PROTO7/FORMAT1/SIM_REVpr10-critical-1/source product identifiers/native DLL незмінні. Serialized state **розширено optional полем**, не називати schema повністю незмінною. Old→new default empty history; new→old real reader втрачає cooldown, downgrade unsupported. R02/current однаковий identity admit, тому окремий owner-approved revision/build gate обов'язковий перед network розповсюдженням. Поки що лише exact same build для test peers.

Exact review PCK `/home/zagor/projects/port-drone-pr10-critical/dist/phase5b2_20261120-181631/candidate_review.pck`, SHA256 `b113844ea3f41635e0fa2fc6df6ffd8c39d2f257ebb86f43cc061ac7047e5bbc`. Before-R02/Phase5 artifacts у primary збережені. Pre-stage60files backup/extraction proof — `/home/zagor/projects/port-drone-pr10-critical/dist/phase5b2_20261120-181631/backup/`; FIX05.patch/FIX06.patch/FIX07.patch/FIX08.patch реально реконструюють7sourcefiles. Full final review checkpoint — PHASE5B_PROGRESS.md та final_results.json. Усі нові docs/artifacts тут, primary docs не mirror-ились.

Існуючі main/migration/candidate refs незмінні; remote main/beta=af1b4c975564bac916db079d8470c2394d4920e5, PR10head96053d66 незмінний на read-only перевірці. Під час роботи з'явилися чужі local `fix/updater-cleanup-isolation` та `/home/zagor/projects/port-drone-gemini-updater` від96053d66; ми їх не створювали/не редагували. Не видаляти і не припускати, що вони містять uncommitted Phase5/R02. Потрібна координація updater scope перед Phase5B.3. Жодного commit/push/merge/PR/release/CI dispatch.

Нижче — збережена історія; свіжі результати вище мають пріоритет.

---

## Історичний checkpoint (збережено)

# Поточний checkpoint — Phase 5B.1 / R02, 2026-11-20

R02 реалізовано локально поверх збереженого Phase5. [Root cause і lifecycle](R02_SNAPSHOT_RESTORE_FIX.md), [тести](R02_FAILURE_INJECTION_TESTS.md), [точний checkpoint і наступні дії](PHASE5B_PROGRESS.md). Активний worktree **/home/zagor/projects/port-drone-pr10-critical**, branch **codex/fix-pr10-critical**, HEAD **96053d66eb984cc24e3acce647a55a195136abd2**; код/тести/документи **uncommitted**. Не checkout/reset/stash/clean/rebase! Початковий backup50files і окремий R02 incremental patch збережені поза worktree.

Production delta R02: save.gd, net_session.gd, main.gd; разом із Phase5 тепер12 dirty tracked production files. Нових R02 test files4. main/beta/OKREDU/migration refs не змінювалися. У primary repository нові R02 docs НЕ mirror-ились: читати саме цей worktree. Незалежний розвиток, міграція0.41 DEFERRED.

R02: checked success після всіх load/cleanup stages, fail closed із явним retry, epoch cancellation/reconnect/promotion, bounded metadata/chunks, idempotency. PROTO7/FORMAT1/SIM_REVpr10-critical-1 незмінні. Admission різних SIM_REV перевірено двома loopback processes; той самий SIM_REV НЕ гарантує однаковий код. Для матчів exact same candidate.

Наступний етап — Phase5B.2 та review R02; це НЕ оголошення готовності всієї beta. Windows GUI/full two-peer lockstep/reconnect/resync/Steam лишаються NOT RUN. Shutdown diagnostics і p99 regression OPEN. Нижче збережений історичний Phase5 checkpoint; свіжі результати мають пріоритет.

---

## Історичний checkpoint (збережено)

# Поточний стан — Phase 5, 2026-11-20

**Нова стратегія прийнята:** власна незалежна DroneFlames на доступному Godot-порті. main=stable, beta=integration/development, звичайні feature/* та fix/* від актуальної beta; stable release тільки за рішенням ZaGOR-1. OKREDU — довірений співавтор.0.41.4.1 migration **DEFERRED / ON HOLD**, без повторного пошуку й вимоги parity.

Активний runtime candidate — **/home/zagor/projects/port-drone-pr10-critical**, branch **codex/fix-pr10-critical**, HEAD96053d66eb984cc24e3acce647a55a195136abd2 + **uncommitted** fixes/tests/docs. Не створювати branch повторно й не скидати dirty tree. Primary /home/zagor/projects/port-drone лишається codex/migrate-0.41.4.1 на af1b4c975564bac916db079d8470c2394d4920e5; у ньому лише docs/policy mirror, production code незмінний. Main/beta/OKREDU refs не пересувалися. Commit/push/merge/PR/release/CI dispatch НЕ дозволені/НЕ виконані.

FIX-01 seasons render vs simulation + hash; FIX-02 human consent через existing offers/answer_as; FIX-03 Ship.c ownership і Chronicle (два regressions); FIX-04 deterministic carrier wing loss/diversion.10 production files,3new tests; features OKREDU не видалені. Exact PCK SHA `8151308b855c0a2390ac4ccad1c89d94dcd43a539a1a335cc8becce0142beb40`, working patch SHA `7b38c272a9927b4977a069fb9a8b7f4d76a16d59618eb8d0865894e36d2ca277`. Source manifest і review diff — dist/phase5_stabilization у primary. Сам HEAD ще не містить fix.

**Перевірено:**17 Python,2476 regression,309 mechanics,81critical assertions;269 scripts/883 PCK hashes, Windows embedded pack; Main/HUD actual save/load/continue23×2 legacy+22fresh; різний render cadence дає однаковий hash/RNG/snow після320ticks; Windows x64 build/native headless smoke PASS.3×3 same-checkpoint benchmark виконано, p99 improvement НЕ підтверджений. Shutdown FAIL, Linux native extensions BLOCKED; actual2-peer/GUI NOT RUN.

**NOT READY для integration:** inherited HIGH R02 runtime-відтворений: failed restore turn99 все одно advances exec_turn100/net_tick300/go=true і повідомляє rejoined. PA05airport, PA07cooldown, PA09cancel також лишаються FAIL; updater/upkeep/shutdown окремо Phase5B. Не оголошувати beta multiplayer-compatible лише за compile/локальними hashes. PROTO7/FORMAT1/DLL незмінні, але opaque SIM_REV=pr10-critical-1 відділяє нові semantics; actual admission ще не перевірений. New→old saves не сертифіковані.

**Далі:** [critical fixes](PR10_CRITICAL_FIXES.md), [exact tests/benchmark/checklist](PR10_REGRESSION_RESULTS.md), [Phase5B](PHASE5B_PLAN.md), [integration](INTEGRATION_STRATEGY.md), [collaboration](COLLABORATION_WORKFLOW.md). Спочатку review з OKREDU й окремий R02 fix; потім2-peer/WindowsGUI gates. Один cumulative result PR10+fixes→beta, не десять squash/cherry-pick. Старий PR10 не закривали, successor PR не публікували.

Preservation PASS881baseline/123Phase2/250Phase4/5rollback. Повний docs-before tar збережений. Root verified mirror і candidate docs узгоджені; відносні code links у Phase5 docs стосуються **candidate worktree**, primary runtime лишається старим. Історичний Phase4 verdict/feature catalog нижче та в audit docs не описують новий working diff. Не повторювати весь аудит без зміни умов.


---

## Історичний документ / попередній scope (збережено)

# Поточний стан — Phase4 PR audit, 2026-11-20

HEAD і локальний `main`: `af1b4c975564bac916db079d8470c2394d4920e5`. Активна гілка — `codex/migrate-0.41.4.1`. Checkout залишається редагованою основою **0.33.2.3**. Game code/assets/CI/protocol7/Save FORMAT1/native DLL незмінні. Tracked diff порожній; попередній untracked overlay збережений, verified-документація теж untracked. Commit/push/tag/release/CI не виконувалися.

## Поточний результат Phase4

**NOT READY для merge cumulative PR10 @96053d66eb984cc24e3acce647a55a195136abd2.** Усі10 PR OKREDU досліджені через GitHub API, фактичні diffs/source, Git ancestry та ізольовані тести. Primary checkout/main/migration залишилися af1b4c9; remote beta також baseline. Safe fetch додав audit refs; detached worktree `/home/zagor/projects/port-drone-pr-audit-96053d66` clean. Production code/формати/DLL не змінені, commit/push/merge/CI/comments не виконувалися.

- **Історія:**1–4 незалежні від baseline, merge43477a5 включає їх у5; далі5→6→7→8→9→10. Усі older heads — ancestors10; відсутніх older commits0, duplicate patch-id0. У10 —13 унікальних commits,129 changed files,+9784/−1209. Compile runtime GDScript264→269; six new modules, standalone signal_server видалений. Деталі: [PR_DEPENDENCY_GRAPH](PR_DEPENDENCY_GRAPH.md), [кожен PR](PR_01_TO_10_REVIEW.md).
- **PASS на latest:**16 Python tests,2476 regression checks,309 mechanic assertions,269 runtime script loads,883/883 packaged hashes/main scene instantiate,17 synthetic legacy/new-field save checks,7 atlas JSON/PNG bounds, Linux і Windows headless startup. Windows smoke22.616s/exit0,3 оригінальні DLL loaded. Це не GUI/Steam acceptance.
- **FAIL продукту:** PA01 frame-dependent seasons/farm/hash; PA02 human land deals без accept; PA03 Ship ownership accessor; PA04 Chronicle з кораблем; PA05 airport action; PA06 carrier wing без бази після sinking; PA07 lost land cooldown save/load; PA08 eager upkeep fallback; PA09 REBASE/AIRDROP cancel. Діагностичний exit0 не приховує script errors. PA10 missing defense bonus, PA11 cross-build compatibility gate, PA12 Chronicle duration/MP limits — static findings. [PR_RISKS](PR_RISKS.md) має ranges/repro/fixes.
- **Performance:**1024/4bots/seed20261016/dt0.2, той самий1200s checkpoint,4 runs×300ticks. Latest mean трохи кращий, але p99 **39.752/47.515ms проти36.125/38.353ms**; загальний late-game/GPU improvement не підтверджений. Clean shutdown FAIL: Windows11 CanvasItem RID/226 ObjectDB/44resources at exit.
- **NOT RUN:**Windows GUI/input/DPI/audio/manual save-load, live2-peer/Steam/LAN/reconnect, повна fault matrix/GPU. Native Linux Steam/WebRTC BLOCKED через відсутні .so. Author PR Verification відокремлено від фактично виконаних checks; GitHub head check/workflow runs відсутні, reviews/comments0.
- **Каталог:**50 можливостей/контрактів:22 IMPLEMENTED & TESTED у component scope,12 implemented/not runtime tested,7 partial,8 broken,1 unverified. Це не50 готових механік. [FEATURE_CATALOG](FEATURE_CATALOG.md).
- **Preservation:**881/881 baseline source hashes,123/123 Phase2 artifacts збігаються; rollback збережений,10/10 GitHub heads/base незмінні при фінальній звірці. Нові докази лише `dist/phase4_pr_audit/`; старі Phase2/3 logs не перезаписані.

Огляд: [PR_AUDIT_OVERVIEW](PR_AUDIT_OVERVIEW.md); tests/commands/Windows launcher: [PR_TEST_RESULTS](PR_TEST_RESULTS.md). Локальний Windows diagnostic build — `dist/phase4_pr_audit/windows-x64/`, окрема Temp копія `C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase4-96053d66-20261120`, updater off/mockID0/isolated user namespace.

Рекомендація: main лишити0.33.2.3; майбутня development основа — **виправлений descendant10 у beta після gates**, одна cumulative integration зі збереженням ancestry. Нинішня beta ще не містить нових features. [INTEGRATION_STRATEGY](INTEGRATION_STRATEGY.md), [COLLABORATION_WORKFLOW](COLLABORATION_WORKFLOW.md). Аналіз завершений, code fixes/merge не дозволені цим етапом.0.41 source migration залишається BLOCKED; matching dev package не з’явився від цього PR-аудиту.

## Збережений результат Phase3

**Доступного повного dev-пакета 0.41.4.1 у перевірених джерелах не знайдено. Міграція залишається BLOCKED через відсутність game/net sources, редагованого resource project і matching build inputs.** Готовий ZIP збережений як reference; його runtime у межах аудиту не запускали. Шифрування PCK не обходили. Наявність можливості запуску не підтверджує можливість розробки.

19 листопада підготували Phase2 baseline, migration branch, rollback, перевірили publisher ZIP і виконали static PE/ELF/PCK analysis. На ранньому етапі Phase3 20 листопада продовжено саме пошук development основи; engine/regression/benchmark/mount тоді повторно не запускали. Пізніші тести cumulative PR10 належать окремому Phase4 вище.

- **PASS сьогодні:** 881/881 SHA256 checkout, 123/123 Phase2 artifacts, 25/25 extracted release files; release ZIP hash незмінний; rollback bundle verify exit0, tar-каталоги 881 tracked files і 18 Phase2 documents. Докази: `dist/phase3_041/continuation_20261120/integrity.json`, `backup_catalogs.json`.
- **GitHub:** у publisher залишаються ті самі 10 branch heads; 12 tags/12 releases, tag 0.41.4.1 і main — старий `af1b4c9`. Усі 28 commits public main доступні локально; перевірка їхніх дерев не знайшла native source/build package. Учорашні 10 unchanged branch trees не завантажували повторно.
- **Нові кандидати:** у власному `ZaGOR-1/port-drone` — 12 public branches, з них 10 додаткових дерев перевірено read-only; усі 12 version.cfg містять 0.33.2.3. `beta-phase*`/`beta-step*` мають інші GDScript trees, але не matching native dev package 0.41. Їх не checkout/fetch/merge і не тестували. У credited `makkaX2/DroneFlames-PC-Port` master/test manifests вказують основу 0.33.4; серед 74 releases немає 0.41. Це окремий порт, не встановлений source релізу 0.41.4.1.
- **Локальні архіви:** Downloads `port-drone-0.41.4.1.zip` і `port-drone-main.zip` містять по 881 файлу, всі збігаються з baseline 0.33. Два `DroneFlames_Codex_Development_Pack*.zip` — однаковий 29-file documentation/tools overlay; його manifest прямо виключає game code/assets. Два `DroneFlames-PC-0.41.4.1*.zip` — однакові publisher binaries. Desktop-папка має release layout; не запускалася.
- **Межі:** не перевірено всі диски, приватні репозиторії або невказані користувачем backup locations. Права на adaptation ще не підтверджені. Публічні metadata/read-only пошук не доводять відсутності private sources.

Повні результати, шість development capabilities, перелік потрібного dev-пакета з призначенням компонентів і контакти для запиту — [MIGRATION_041](MIGRATION_041.md). Наступний крок: отримати від publisher/правовласника matching project/source/build package або точний шлях до власного архіву. Повідомлень авторам не надсилали.

Нові докази — окремий `dist/phase3_041/continuation_20261120/`; старі Phase2/Phase3 artifacts збережені. Після перезапуску сервера використано вже записані JSON responses; втрачений aggregate transport log не відтворювали як виконаний. Виявлено, що вчорашні `dist/phase3_041/validation.json` і `logs/validation.log`, згадані TEST_MATRIX, відсутні; сьогоднішня integrity перевірка є окремим реальним доказом, не відновленням відсутнього журналу.

## Збережений результат Phase2 — 2026-11-19

**Pinned середовище та локальний runtime baseline підготовлені. Windows GUI/audio/FPS/ручний save-load і2-peer/real Steam ще NOT RUN.** Phase1 exhaustive inventory/static index збережений; manual100% не є метою за steering Phase2. Подальший аудит — за критичним потоком і залежностями, не формальним лічильником рядків.

- Ubuntu26.04.1 WSL2 x86_64, Python3.14.4, Git2.53.0,6 VM logical CPUs. Windows11 Pro x64 build26300; PowerShell/interop працюють.
- `godot_dl/` на початку Phase2 уже містив binaries. Наявний fetch виконав cache reuse PASS. Exact editor/template **4.7.2.stable.official.ed1daf0bf**; повні official ZIP/TPZ SHA256, ZIP CRC і cached member hashes збіглися. Apt/pip/native updates не було.
- **PASS:**18 Python tests;2458 Godot regression checks/0 failures;264 runtime GDScript loads +3 executed tool scripts;863/863 PCK hashes, main-scene load/instantiate;7 synthetic disk/core save checks; normal Linux і Windows headless startup; Windows3 DLL loaded; same-checkpoint benchmark/raw samples.
- **FAIL:** clean-shutdown diagnostics (ObjectDB/RID/resources-at-exit); initial Windows standalone-script probe harness; valid-ID Windows SteamMock hardcoded/tmp. Невдалі результати/логи збережені. Це не загальний FAIL gameplay suite.
- **BLOCKED:** native Linux Steam/WebRTC — .so відсутні. Наявний allowlist runner не розширювали; extension-list/native не підміняли.
- **NOT RUN:** GPU rendering/audio/GUI UX/Windows manual save-load,2-peer lockstep/reconnect/real Steam/ranked, updater failure matrix, legacy migration/OS fault injection. Production backend/accounts/real saves не використовували.

## Артефакти й запуск Windows

Primary build: `dist/phase2_baseline/windows-x64/DroneFlames.exe`,214642580 bytes; embedded PCK105374088 bytes/format4. Repo="", version0.33.2.3. EXE SHA256 `47aa45832766b0e4cb804e66016ffbbcf8730a535f139653e8f56be77592ffff`. DLL і libs.rev1 поруч; inspection PCK у `dist/phase2_baseline/game.pck`.

Verified local Windows copy:
`C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase2-af1b4c9-20261119`

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase2-af1b4c9-20261119\Run-DroneFlames.ps1"
```

Launcher задає process-local APPDATA/LOCALAPPDATA під test-user, custom namespace DroneFlames-Phase2-af1b4c9, updater disabled, uk/no intro, Steam init bypass через mock ID0. Windows smoke реально створив тільки test user directory й завантажив3 DLL, exit0 за23.617s. Це SP fixture, Steam функціональність не перевірена. Temp копія може бути очищена ОС; primary dist у Ubuntu залишається джерелом. Повний комплект можна перенести разом із launcher/override. Не запускати --script у release template: цього option немає.

## Вимірювання та save scope

Benchmark512/2, seed20261016, dt0.0333333333333333, warmup60, requested sample20s. Checkpoint495152 bytes, SHA256 `a69159e71aca98e7d83e992fe689989ff281bd185f1256b8be41827b20ec3c91`. Replay A/B по601 samples: p50=0.349/0.382ms, p99=4.982/4.444ms, max=23.479/23.136ms.0 samples>50ms,3 autosaves/run. P50/raw збирала ignored копія benchmark tool, змінений лише result після timed loop; tracked tool незмінний.

Це early-world CPU _sim_step,10 cities/12 facilities/0 units, не GPU/FPS/бойовий2048 benchmark. Decimal dt+ceil дає601, не600 samples. Розкид не improvement: code change немає; SP worker timing і OS scheduling не доводять lockstep determinism.

Save fixture7 PASS: manual write/read, core+systems restore, NetHash/owners/biome/flags/time/counts і player identity, corrupt payload rejection, invalid net wrapper без sampled-state mutation. Не тестував Main UI load_slot, старі saves, failure windows чи NetSession R02. Реальні user saves не читали/міняли. Regression також перевірив frozen body/thumbnail під live mutation.

## Аудит і ризики

881 files:598 text/283 binary;267 .gd/174121 lines. Manual coverage тепер **75 FULL,25 PARTIAL+AUTO,498 AUTO,283 METADATA**; GDScript48 FULL/25 PARTIAL/194 AUTO,21276 прочитаних lines. Нові FULL: Bridge150, Opening239, LangPicker505. Runtime compiler PASS не підвищує manual status.

Bootstrap уточнення: `LangPicker.SHOW_ES=false`; ES каталог неповний, але звичайний picker його приховує. Headless пропускає first-language/intro; GUI checklist лишається потрібний. Save/protocol змін не було. Найважливіші відкриті ризики — R01 broad updater cleanup, R02 failed restore advance, R03–R05 update/save durability, R06 release gate, R07/R08 network validation/admission. Нові R17 mock/tmp portability та R18 exit leaks. Усі confidence/paths/acceptance — RISKS/BACKLOG.

## Документація й докази

Починати з [ENVIRONMENT_SETUP](ENVIRONMENT_SETUP.md), [RUNTIME_BASELINE](RUNTIME_BASELINE.md), [WINDOWS_TESTING](WINDOWS_TESTING.md), [TEST_MATRIX](TEST_MATRIX.md). Архітектура/формати: [PROJECT_FACTS](PROJECT_FACTS.md), [ARCHITECTURE](ARCHITECTURE.md), [SAVE_FORMAT](SAVE_FORMAT.md), [MULTIPLAYER_PROTOCOL](MULTIPLAYER_PROTOCOL.md), [GAMEPLAY_SYSTEMS](GAMEPLAY_SYSTEMS.md), [BUILD_RELEASE](BUILD_RELEASE.md), [RESOURCES_AND_UI](RESOURCES_AND_UI.md). Навігація: [FILE_COVERAGE](FILE_COVERAGE.md), [MODULE_INDEX](MODULE_INDEX.md). Робота: [RISKS](RISKS.md), [BACKLOG](BACKLOG.md), [DECISIONS](DECISIONS.md).

Ignored `dist/phase2_baseline/`: exact argv/environment/time/exit JSON, logs, integrity manifests, original failed probe evidence, fixture scripts, checkpoint/raw samples, build, Windows copy metadata; official archives близько1.36GB. `dist/codex_audit/` зберігає Phase1 hashes/index/manual ledger. Якщо dist очищений — використовувати persistent docs, а не вважати старі PASS автоматично новими.

## Що Codex повинен перечитати наступного разу

1. Повний AGENTS.md, цей CURRENT_STATE, git status/HEAD; перевірити source freshness, зберегти чужі зміни. Середовище вже є; не завантажувати заново без checksum/version проблеми.
2. MIGRATION_041/VERSION_041_ANALYSIS/DIFF/BACKLOG і continuation_20261120: перевірити, чи надано новий matching dev package. За відсутності нового input не повторювати весь пошук, hashes, mount чи зелені runtime checks.
3. Якщо package отримано — почати з provenance/commit/build mapping і resource/native inventory у staging. Не переносити protocol7/FORMAT1 за припущенням. Не обходити PCK encryption.
4. Для продовження development прочитати PR_AUDIT_OVERVIEW/PR_RISKS/PR_TEST_RESULTS/INTEGRATION_STRATEGY/COLLABORATION_WORKFLOW/BACKLOG, звірити actual PR head. Не повторювати completed audit без нових commits/ризику. Першими — PA01/02/03/04/06 і inherited R02 у майбутньому окремо дозволеному fix scope; поточний етап дозволяв лише аналіз.
5. Не публікувати/комітити/міняти main. Windows GUI scripts у dist — audit artifacts; реальний Steam/account/production не чіпати автоматично.
