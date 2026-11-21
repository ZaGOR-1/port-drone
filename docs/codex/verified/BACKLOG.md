# Поточний backlog нового snapshot — 2026-11-21

Докази, priority, reproduction і блокери: [реєстр ризиків](REONBOARDING_AUDIT.md#risk-register). Це план, не дозволи на fixes.

| Наступна робота | Статус |
|---|---|
| Підготувати pinned Godot4.7.2/template, rerun regression/build | OPEN; dependencies відсутні, зараз не завантажували |
| Розібрати missing CI workflow/PR template | CONFIRMED; full unittest FAIL; окрема tooling задача |
| Windows18 cases +2 independent peers, однакові EXE/DLL SHA | NOT RUN; [план](WINDOWS_TWO_PEER_QA_PLAN.md) |
| Доказовий збір turn/hash/RNG на peers | OPEN; launcher не має trace option |
| Updater integrity/atomicity і save durability fault fixtures | OPEN; updater disabled для QA |
| General command schemas/auth/rate limits; Steam admission negatives | OPEN; не всі методи reviewed |
| Shutdown/p99 повторити на нинішньому build | HISTORICAL findings, поточний runtime UNVERIFIED |
| Дочитати INDEXED/PARTIAL sources і великий historical coverage table | OPEN; [точні діапазони](SOURCE_COVERAGE.md), не повторювати весь аудит |

0.41 migration ON HOLD; старі PR не відновлювати. Main/release — лише окреме owner decision.

---

## HISTORICAL backlog попередньої Git-історії

Старі OPEN/FIXED/permissions нижче мають лише свій checkpoint scope; current risk status — у re-onboarding audit.

# Phase 7 → Phase 8 — beta QA backlog

За рішенням власника Windows GUI і full multiplayer виконуються **після** інтеграції в development beta. Вони NOT RUN, не блокують дозволений Phase7 merge самі по собі. Updater download/replacement не використовувати у тестовій beta: DF_NO_UPDATE=1 та repo-empty build. [QA plan](PHASE8_BETA_QA_PLAN.md).

OPEN: updater integrity/atomicity; save durability/deep malformed/downgrade; general network command validation; shutdown resource leaks; global p99; Windows GUI18cases; independent two-peer lockstep/reconnect/resync/host change та Steam/LAN. Не починати нові gameplay features або global audit. Main stable не змінювати. Commit/push/merge authorization цієї задачі не є постійним дозволом на наступні зміни чи stable release.

---

# Phase 5C — актуальні gates

Локально завершено: G01 reviewed startup cleanup; G02 targeted ignore; G03 manual QA plan; G04 PR template; SIM_REV pr10-phase5b2-1 з actual negative admission; safe local CI policy. [Результати](PHASE5C_INTEGRATION_RESULTS.md). Попередні Phase 5 / R02 / FIX05–08 збережені й перевірені. Commit/push/integration не виконувалися.

| Пріоритет | Наступна незалежна задача | Gate / статус |
|---|---|---|
| P0 | Windows GUI та same-build two-peer QA | 18 ручних сценаріїв NOT RUN; commands/hash/RNG/restore/host change; LAN/Steam окремо |
| P0 | R03/R04 updater integrity/transaction | OPEN HIGH; cleanup не робить DLL/EXE replacement атомарним; updater off для QA |
| P1 | R07 general command schemas | OPEN; targeted build/air/land checks не доводять safety всіх ALLOWED |
| P1 | R05 save durability/deep corruption/downgrade | OPEN; FORMAT1 optional field old→new, downgrade new→old unsupported |
| P1 | Human code/gameplay review | OKREDU/owner: gift consent, TTL90, pending pair, directional cooldown, carrier loss, cancel boundary; ancestry зберегти |
| P2 | R18 shutdown leaks | FAIL: 11 CanvasItem / 225 ObjectDB / 44 resources у native Windows; окрема lifetime задача |
| P2 | Whole-game p99 | OPEN; попередні noisy measurements, нового performance висновку в 5C немає |
| P2 | Updater retention / Windows NTFS junction та ACL | Усі .old навмисно retained; capacity policy після integrity proof; Windows symlink fixtures SKIP |

Gate для declared old/new revisions закритий у локальному scope; cryptographic identity не реалізовано. Один exact EXE cohort для QA. Workflow/template підготовлені локально, не змінюють GitHub Settings і не застосовуються remote автоматично.

---

## Історичний checkpoint до Phase5C (збережено)

# Активний backlog — після Phase 5B.2

FIX05/PA05, FIX06/PA07, FIX07/PA09 і FIX08/PA08 виправлені у targeted scope, окремі patches та RED/GREEN збережено. [Результати](PHASE5B2_REGRESSION_RESULTS.md). R02/Phase5 залишаються green у відповідних suites. FIX08 profile benefit підтверджений, але whole-game p99 OPEN.

Наступні задачі — PHASE5B3_PLAN.md: P0revision gate/unsupported downgrade, updater cleanup та integrity; P1Windows GUI/full same-build peers/general network schemas R07/save fault R05; P2shutdown leaks та p99/worker waits. Підтверджений forged free build bypass закрито targeted guard; інші ALLOWED commands не оголошено hardened.

Погодити із власником/OKREDU gift consent/TTL90/one pending pair, directional cooldown, local cancel vs issued-command boundary та loaded troops/refund policy. Не додавати features або0.41 migration. Uncommitted checkpoint треба зберігати; не стартувати новий fix/* від голого96053. Окрема updater-гілка/worktree вже з'явилася в спільному Git, не дублювати/не переписувати її роботу.

---

## Історичний checkpoint (збережено)

# Активний backlog overlay — Phase 5B.1

R02 local implementation завершена в targeted scope: [fix](R02_SNAPSHOT_RESTORE_FIX.md), [результати](R02_FAILURE_INJECTION_TESTS.md). Повний real-peer acceptance лишається gate, а не автоматично PASS. Не повторювати весь PR audit або пошук0.41.

Наступні незалежні задачі та порядок — [PHASE5B_PLAN](PHASE5B_PLAN.md). P1: airport dispatch; territory cooldown persistence; REBASE/AIRDROP cancellation; updater cleanup/integrity; upkeep fallback. P2: shutdown lifetimes, p99 профіль і загальна save fault hardening. Full two-peer reconnect/resync/host transfer та Windows GUI — обов'язкові перед beta integration. Mixed-build content identity policy — окремий review; SIM_REV тепер реально перевірено для admission, але не є hash source.

Усі поточні fixes незакомічені. До дозволеного checkpoint commit не відгалужуватися від голого HEAD96053 і не вважати, що він містить Phase5/R02. Використовувати поточний worktree та окремі контрольні patches; після схваленої інтеграції стандартні feature/*/fix/* від beta.

---

## Історичний checkpoint (збережено)

# Активний backlog — Phase 5/5B

Стратегія незалежної DroneFlames прийнята;0.41 DEFERRED і не активна задача. Нижче збережена історія, яка не скасовує нову політику.

| Стан | Поточна задача |
|---|---|
| DONE у local uncommitted candidate | FIX-01–04 / PA01/02/03/04/06: seasons+hash, human consent, Ship.c purchase, fleet Chronicle, safe carrier loss.81 targeted checks PASS; [результати](PR10_REGRESSION_RESULTS.md). |
| DONE | AGENTS Independent Development Policy; main stable/beta integration; history/backups preserved; Windows build/smoke, regression, E2E та3-way benchmark. |
| P0 NEXT | Окремий fix/snapshot-restore-failure: R02 HIGH відтворений навіть після fixes; failed wrapper не повинен advances clocks/go/rejoin. |
| P0 GATE | Actual2-peer determinism/version admission/reconnect/resync та Windows GUI acceptance, code/gameplay review з OKREDU. |
| P1/P2 NEXT | Airport/cooldown/REBASE-AIRDROP/upkeep/updater/shutdown/mock portability — [PHASE5B_PLAN](PHASE5B_PLAN.md), окремі fix/* branches. |
| REVIEW, НЕ MERGE | [INTEGRATION_STRATEGY](INTEGRATION_STRATEGY.md): один cumulative PR10+fixes→beta після gates/дозволу, зберегти авторство; не повторювати cumulative squash. |
| DEFERRED |0.41 matching-source migration; не витрачати поточний цикл на пошук або parity. Історичні gates не видалені. |

Рішення integration **NOT READY** через R02/мережеві gates, а не відсутність dev package0.41. Source edits дозволені лише в current isolated candidate; commit/push/merge/PR/publication не дозволені. Детальний handoff — CURRENT_STATE/PR10_CRITICAL_FIXES/PR10_REGRESSION_RESULTS.


---

## Історичний документ / попередній scope (збережено)

# План подальшої роботи

## Поточний пріоритет Phase4 — виправити integration blockers

2026-11-20 read-only audit усіх10 PR OKREDU **виконано**; результат **NOT READY** для merge latest96053d66. Primary/main/migration і remote beta лишаються af1b4c9. Немає production fixes або дозволу автоматично продовжити code changes. Докази/плани: [PR_AUDIT_OVERVIEW](PR_AUDIT_OVERVIEW.md), [PR_RISKS](PR_RISKS.md), [PR_TEST_RESULTS](PR_TEST_RESULTS.md), [INTEGRATION_STRATEGY](INTEGRATION_STRATEGY.md).

| Priority | Задача після узгодження development scope | Acceptance |
|---|---|---|
| P0 | PA01: gameplay seasons відділити від render delta, hash authoritative state | Два same-build peers з різним FPS/stall schedule мають однакові snow/farm output/full state/hash; simulation tick єдине джерело gameplay updates |
| P0 | PA02: human land buy/sell/swap потребує згоди контрагента | Без його авторизованого accept команда не змінює ownership/money; replayed/expired/forged offers відхиляються |
| P0 | PA03/PA06: Ship ownership і carrier wing lifecycle | NetCodec→_exec купує літак лише на own Ship; sunk carrier з airborne/parked wing,0/full/incompatible bases не дає null-base errors |
| P0 | PA04: Chronicle mixed naval match | Ships використовують правильний owner accessor; кадри/disk/viewer записуються за живих і sinking кораблів |
| P0 | PA11 + inherited R02: compatibility/build identity та restore failure | Mixed incompatible builds відхиляються; failed restore не advances clock/rejoin-success; FORMAT1/new enums/downgrade policy явні |
| P1 | PA05/PA09: airport action та cancel REBASE/AIRDROP | HUD→mode→map build працює; RMB/Esc очищують нові режими/refs/preview |
| P1 | PA07: land cooldown roundtrip |90s gate зберігається через disk save та network snapshot з backward default для старих saves |
| P1 | PA08: eager upkeep fallback | Старий tally не викликається за наявного key; усі amounts і reaction timing узгоджені; paired perf profile |
| P1 | PA12: Chronicle scope/duration | Узгоджені SP/MP та >30min правила; останній кадр не губиться; не називати snapshot viewer command replay |
| P1 | Actual Windows GUI/input/native/save і2-peer tests | Pinned exact candidate SHA, logs/checklist, жодних реальних saves/accounts без погодженого scope; current headless smoke не заміна |
| P2 | PA10 і partial catalog features | Погоджений nationalism defense spec; AI carrier wing, evacuation parking/navigation, pixel editor UX окремо перевірені |
| P2 | Same-checkpoint full-frame/GPU/late-war profile | p50/p99/max/autosave pauses; current p99 regression не оголошувати загальним speedup |

На latest PASS16 Python/2476 regression/309 mechanics/269 scripts/883 pack hashes/17 save checks не перекривають відтворених failures.50 catalog rows мають явні статуси. Майбутня integration основа — виправлений descendant10, не десять cumulative squash/cherry-pick.1–4 siblings,5 включає їх,6–10 stacked. Поточний beta branch ще baseline. Порядок роботи двох авторів — [COLLABORATION_WORKFLOW](COLLABORATION_WORKFLOW.md).

## Збережений напрям Phase3 — development основа0.41

Гілка codex/migrate-0.41.4.1 створена; rollback/Phase2 baseline збережені. ZIP integrity PASS, інший native runtime підтверджений; source migration **BLOCKED**. Поточний game/ усе ще0.33.2.3. Не підміняти його binaries чи лише version label.

**Продовження 2026-11-20 виконано:** актуальні public refs/releases/history publisher, додаткові гілки власного fork, credited community port manifests/trees/releases, шість локальних ZIP перевірені. Matching dev package не знайдений; Codex Development Pack є документацією, GitHub source ZIP із номером 0.41 має старі 881 files. Baseline 881/881, Phase2 123/123, extracted release 25/25 hashes PASS. Runtime checks не повторювали. Подробиці/точний запит матеріалів/межі пошуку — MIGRATION_041; evidence — `dist/phase3_041/continuation_20261120/`.

**Наступний input:** matching source/project/build archive або доступ до нього від publisher/правовласника чи точний шлях до іншого власного backup, плюс scope прав за наявності. Запитання користувачу поставлені; відповіді на момент checkpoint немає. Повторний такий самий public search без нових materials/refs не є наступною задачею.

| Priority | Наступна задача | Acceptance |
|---|---|---|
| P0 | Отримати matching game/net dev sources і права локальної адаптації |Source/commit відповідають release build і image hashes; permission evidence зафіксована; не прирівнювати public URL до license |
| P0 | Отримати resource project/nonencrypted dev catalog і engine/bridge build inputs |Project/scenes/descriptors/assets/locale inputs; custom4.7.2 patchset, native toolchain/SDK/ABI; reproducible staging compile |
| P0 | Встановити фактичні0.41 Save FORMAT/PROTO та міграції |Source schemas + synthetic round-trips/replay/2 peers; pc34-v1 не підставляється як numeric FORMAT, protocol7 не наслідується |
| P1 | Source-built Windows0.41 і functional comparison |Ізольована збірка з нових sources, не repack; зіставлення з pinned publisher ZIP/контрольними input |
| P1 | Переносити PC features лише за confirmed interfaces |Window/input/scale/Steam/update paths, compatibility tests. WebRTC identity підтверджена тільки на рівні bytes |

Повний gate/список materials/варіанти: [MIGRATION_041](MIGRATION_041.md); фактичний diff: [VERSION_041_DIFF](VERSION_041_DIFF.md). Старі задачі нижче належать rollback0.33 і залишаються актуальними для її розвитку; вони не оголошені дефектами непрочитаної native0.41 реалізації.

Phase4 виконав рекомендований read-only review beta-phase*/beta-step* і тести detached latest96053d66; результати вище. У migration branch зміни гри не переносили, merge не робили. Наявність цих implementations не доводить0.41 parity і не надає відсутніх native/project sources. Розвиток доступного порту після fixes — практичний окремий напрям паралельно запиту matching0.41 dev package.

## Збережений backlog0.33 / Phase2

На `af1b4c9`, 2026-11-19, після Phase2. Усе нижче **TODO**, якщо явно не зазначено інакше. Game/protocol/save behavior не змінена. P0 — baseline/критичний контекст; P1 — захист даних і correctness; P2 — gameplay/UX/maintainability; P3 — подальше вдосконалення. Priority не є дозволом на code changes чи публікацію.

**Виконано Phase2:** exact engine/template integrity,18 Python tests,2458 regression checks,264 runtime scripts compile/load,863-file PCK/main scene, Windows EXE+DLL load/headless startup,7 synthetic save checks, same-checkpoint CPU benchmark. GUI/audio/FPS/2-peer/real Steam лишаються NOT RUN; clean-shutdown FAIL, Windows mock portability defect R17. Докладно RUNTIME_BASELINE.

## Топ-10

| № | Priority | Задача | Acceptance criteria |
|---|---|---|---|
| 1 | P0 | Продовжити risk-based audit: bootstrap/updater → save/codec → deterministic simulation → lockstep → validation/reconnect/restore → build | Читати залежності конкретного ризику/зміни, фіксувати фактичні ranges і side effects; formal100% перечитування всього source не є вимогою Phase2 |
| 2 | P0 | Закрити залишок baseline: Windows GUI/save-load/audio/FPS та2-peer сценарії | Ручний WINDOWS_TESTING checklist із логами; portable isolated mock peers, exact build/config/seed, compare command/tick/state; integrity/headless частина вже PASS |
| 3 | P1 | Звузити updater cleanup (R01) — рекомендована перша невелика code change | Тільки явно owned EXE/DLL temporary names; сторонні `.old/.new/.tmp`, директорії й сторонні файли незмінні; temp-dir Godot tests |
| 4 | P1 | Failed snapshot restore не повинен продовжувати матч (R02) | Invalid bytes/restore=false не пересуває turn/tick, не показує success; контрольований retry/leave; валідний2-peer resync/rejoin PASS |
| 5 | P1 | DLL update як узгоджена validated transaction (R03/R04) | Manifest/digest, complete+unique whitelist, bounded extraction, checked writes, atomic/staged activation і rollback; failure на2-й DLL лишає попередній набір |
| 6 | P1 | Надійність EXE download/swap/relaunch (R04) | Trusted HTTPS origin policy, обов'язковий integrity contract, finite timeout/cancel, checked rollback/relaunch, isolated fake API negative cases |
| 7 | P1 | Save durability/failure matrix (R05/R13) | Fresh/manual/auto/legacy/MP при ENOSPC/rename/crash залишають recoverable copy; UI metadata читання під autosave без race; migration на copies |
| 8 | P1 | Protocol validation + transport admission (R07/R08) | Per-command schema/arity/ranges/nested ownership/rate budget; bounded snapshots; modulo collision і outsider HELLO відхилені без втрати чинної сесії;2+ peers |
| 9 | P1 | Посилити release gates без автоматичної публікації під час перевірок (R06/R10/R11/R16) | PR/local parse/startup/regression, verified artifacts/dependencies, explicit documented publication policy; права й ABI metadata; workflow change окремим review |
| 10 | P2 | Desktop scale/localization matrix (R09/R12) | Один визначений precedence UI scales; restart/settings/ctrl keys consistency; 960×540…ultrawide; ru/uk/en/es/pseudo, fallback і clipping tests |

## Перший невеликий diff — план, ще не реалізація

Кандидат: `game/pc/updater.gd::_cleanup_old`, без download/install/protocol changes.

1. Перечитати updater повністю й усі місця створення temp/backup artifacts; визначити **точний** список cleanup-owned names, включно з фактичним exe basename і відомими DLL. Не видаляти всі файли за suffix.
2. Додати ізольований Godot test fixture поруч із окремим тестовим executable location; не підміняти єдину робочу інсталяцію. Case: `notes.tmp`, `backup.old`, `draft.new`, піддиректорія, власні EXE/DLL temp, відсутній каталог, denied delete.
3. Змінити лише deletion predicate/owned artifact enumeration; зберегти запуск гри/offline paths.
4. Run release unit, targeted cleanup fixture, Windows cold-start/update smoke у копії; docs/RISKS decision update.
5. Оцінка: save/network wire не змінюються; updater filesystem behavior навмисно звужується. Не робити push/release без окремої команди.

Cleanup мав конкретний trigger і малий compatibility surface; current0.33 runtime baseline тепер є. Після Phase3 це кандидат саме для0.33, якщо обрано її розвиток; для0.41 спочатку виконати source gates вище.

## Подальші P2–P3

- P2: R17 portable SteamMock temp directory/session namespace і Windows2-peer tests; current invalid-ID bypass не є справжнім mock test.
- P2: R18 clean-shutdown lifetime audit з verbose objects/resources, repeated new-game/load/quit; відокремити test-owned cleanup і gameplay ownership, не прибирати diagnostics.
- P2: 2-peer deterministic replay із recorded command stream, different frame/worker delays, NetGuard, hash і повною state comparison; disconnect/capture/creative/save/AI cases.
- P2: economy warehouse invalidation tests build/destroy/capture/demolish/load; repair/upgrade-by-kind regression для останніх HEAD commits.
- P2: formal Save FORMAT1 fixtures: aliases/entity cycles/enums/defaults/Ship fields/future-format/corrupt fallback; не відновлювати приватні saves без копій.
- P2: відновити відсутні dev harness entrypoints або показати чіткий dev-only error (R15).
- P2: зафіксувати effective balance tables і control cases по diplomacy/army/air/naval/supply; решта формул поки NEEDS INSPECTION.
- P2: профілювати full frame Windows CPU/GPU окремо від `_sim_step`; порівняння p50/p99/max/sample counts на однаковому checkpoint.
- P3: deterministic pack order, provenance/license/ABI manifest, clean install reproduction; editor-friendly source project лише окремим планом і за наявності вихідних assets.
- P3: невеликі extraction/refactor великих UI/gameplay scripts після тестів, без зміни RPC names, class_name, node paths чи simulation scheduling.

## Критерій завершення саме аудиту

Наявність документів або compiler PASS не означає review всіх gameplay branches. Після steering Phase2 критерій практичного прогресу — закриті критичні потоки/залежності, чесні ranges, невідоме позначене, runtime checks виконані або мають явний FAIL/BLOCKED/NOT RUN, binary metadata окремо, tracked code unchanged. Не перечитувати194 AUTO scripts лише заради100%; повертатися до них за ризиком/завданням. Exhaustive inventory/static index збережений у FILE_COVERAGE; поточний baseline у RUNTIME_BASELINE/CURRENT_STATE.
