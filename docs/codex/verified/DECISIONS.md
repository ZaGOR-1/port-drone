# Нові рішення Phase 5 — 2026-11-20

## D006 — Independent Development Policy

Пряма команда власника: розвивати власну DroneFlames на доступній Godot-базі, main stable, beta integration, feature/*/fix/* від beta. OKREDU довірений співавтор, author attribution зберігати.0.41 migration DEFERRED; повторного пошуку/parity requirement немає. Stable release лише за рішенням власника; version number не підвищувати самовільно. Попередні D003–D005 нижче — історичні decisions, не активна вимога чекати source package.

## D007 — сумісний consent і консервативний carrier loss

Phase5 exception: isolated codex/fix-pr10-critical від verified PR10, який містить1–9. FIX-01 authoritative seasons лише simulation; FIX-02 чинні land_deal/answer_as/t_offers без нового RPC; human gifts також через consent, TTL90s, одна pending пропозиція на пару. Stale terms вимагають нової пропозиції. FIX-03 canonical Ship.c без alias/формату. FIX-04 deck aircraft без сумісної бази DEAD через чинний lifecycle; heli divert лише на вільну справну власну базу. Правила gift/TTL/loss позначені для gameplay review ZaGOR-1/OKREDU.

PROTO7/FORMAT1/native DLL/product source versions не змінено. Оpaque SIM_REV=pr10-critical-1 навмисно відділяє несумісні simulation/hash semantics через існуючі guards. Це не гарантія actual2-peer і не підтримка downgrade new saves у старий код. Terms живуть у чинному serialized Dictionary; нова структура даних явно задокументована. Перевірки й межі — PR10_CRITICAL_FIXES/PR10_REGRESSION_RESULTS.

## D008 — локальна готовність fixes не є дозволом integration

Critical81/regression2476/mechanics309/Python17/Windowsbuild-smoke та Main E2E PASS не перекривають inherited R02 HIGH. Новий diagnostic відтворює failed restore→exec_turn100/net_tick300/go=true/«rejoined». Airport/cooldown/cancel/shutdown лишилися FAIL, live2-peer/GUI NOT RUN, p99 improvement не підтверджений. Рішення NOT READY для merge; code review можливий зараз. R02 та інші дефекти — окремі Phase5B задачі за прямим обмеженням scope; не змішувати їх у великий patch.

Один майбутній primary cumulative PR у beta з reviewed fixes/авторством OKREDU, без повторного застосування1–9; спосіб supersede PR10 вирішує власник зі співавтором. Commit/push/PR/merge/CI/settings/publication не виконували. Local docs/source changes не є Git commits.


---

## Історичний документ / попередній scope (збережено)

# Журнал рішень

## D005 — 2026-11-20: Phase4 read-only PR audit, integration не виконувати

**Контекст:** користувач дозволив API/history/diff review усіх10 PR OKREDU, safe fetch, detached worktrees, ізольовані тести/build і локальну документацію; заборонив production edits, merge/commit/push/CI/publication. OKREDU — дозволений співавтор. Primary af1b4c9/migration branch та rollback треба зберегти.

**Рішення:** зафіксувати10 heads і base, перевірити ancestry/merge-base/range-diff/patch-id, тестувати cumulative10 @96053d66 окремо від primary. Не застосовувати десять overlapping PR diffs. Позитивні regression/mechanics/codec результати відокремити від невдалих targeted invariants; не видавати exit0 діагностичного probe або mergeable=clean за product PASS.

**Обґрунтування:**1–4 siblings,5 містить їх octopus merge,6–10 descendants; older commits поза10 немає.16 Python/2476 regression/309 mechanics PASS співіснують із відтвореними HIGH PA01/02/03/04/06 та compatibility gate PA11; старий failed restore R02 не виправлений. API CI/reviews відсутні. Windows smoke пройшов, але GUI/real MP не перевірені й shutdown leaks лишаються.

**Наслідки:** рішення **NOT READY** для integration нинішнього head; майбутня основа — виправлений descendant10 у beta після targeted/Windows/2-peer gates і review користувача. Main/beta/migration не змінювали;881 source та123 Phase2 hashes збігаються. Phase3 source migration0.41 лишається BLOCKED; нові mechanics не доводять parity оригіналу. Документи/diagram та ignored fixtures/reports/build створені локально, нічого на GitHub не опубліковано. Fixes — наступний окремо дозволений scope, не частина цього рішення. Повний план: PR_AUDIT_OVERVIEW/PR_RISKS/INTEGRATION_STRATEGY/COLLABORATION_WORKFLOW.

## D001 — 2026-11-19: документувати перевірені факти та межі, без змін runtime

**Контекст:** перша ініціалізація за AGENTS.md і CODEX_INITIALIZATION.md; HEAD `af1b4c975564bac916db079d8470c2394d4920e5`, на старті untracked documentation overlay.

**Рішення:** виконати інвентар усіх tracked-файлів, повнотекстовий автоматичний аналіз і поглиблене читання основних потоків; зберігати результати тільки в `docs/codex/verified/` та ignored `dist/codex_audit/`. Відділяти manual FULL/PARTIAL від автоматичного аналізу та binary metadata. Не видавати незавершений ручний review за завершений full semantic audit.

**Обґрунтування:** binary scene/import cache є частиною гри; початкові package notes — гіпотези. Godot4.7.2 у середовищі немає; історичні PASS не замінюють новий запуск. Фіксація доказів/меж дозволяє продовжити без повторного огляду та без змін чужого локального дерева.

**Наслідки:** game/CI/assets/saves/Steam config не змінені; знайдені дефекти перенесені у RISKS/BACKLOG без виправлення. Runtime/Windows/Steam validation NOT RUN. Не встановлювали нових обов'язкових dependencies і не виконували publishing commands. Це рішення про audit workflow, не нова архітектура гри.

**Альтернативи:** оголосити весь codebase прочитаним після regex-інвентарю — відхилено як недостовірне; почати виправляти updater/restore без дозволу на code changes — суперечить scope користувача. Подальші записи додавати лише після реальних погоджених технічних рішень, не за кожну прочитану функцію.

## D002 — 2026-11-19: Phase2 runtime baseline без зміни гри

**Контекст:** користувач явно дозволив локальний pinned engine fetch, тести/build, Windows staging і risk-based audit; формальне перечитування153739 рядків не є метою. Заборони game/protocol/save/native changes, commits/CI/publication збережені.

**Рішення:** використати точний4.7.2 editor/template, звірити кеш із повними authenticated archives; виконати tests через isolated XDG/user directories і build з repo="". Windows artifacts — окрема локальна копія без другого checkout; launcher задає process-local APPDATA та custom namespace. Native binaries залишаються tracked originals.

**Практична корекція:** standalone --script немає в release template. Невдалий probe збережено; audit harness перероблено на normal startup/quit-after/module inspection. Windows SteamMock hardcoded/tmp не виправляємо в game code; SP baseline обходить init через invalid mock ID0 до filesystem/network. Real Steam/2-peer tests лишаються окремим scope.

**Вимірювання:** для p50/raw samples створена ignored копія benchmark tool із додатковими result fields після timed section; tools/performance_benchmark.gd незмінний. PASS functional checks відокремлено від FAIL clean-shutdown diagnostics і NOT RUN GUI/production flows.

**Наслідки:** runtime baseline тепер є; R01–R08 не виправлені, додано R17/R18. Наступні зміни потребують нового дозволеного scope; цей етап не дозволяє commit/push/release. Висновки/commands постійні у verified, артефакти й fixtures — ignored dist.

## D003 — 2026-11-19: Phase3 analysis branch, без binary підміни source

**Контекст:** користувач запросив0.41.4.1 migration за умовою наявності придатного коду/resources і прав, із явним fallback для неповної editable основи. Release ZIP identity перевірена, source tag/main залишаються af1b4c9.

**Рішення:** створити codex/migrate-0.41.4.1 та tracked/history/docs rollback, зберегти Phase2 artifacts, виконати static/read-only analysis. Після encrypted PCK mount failure і відсутності native sources не підміняти game/ prebuilt файлами й не змінювати version labels. Rights підтвердження запитане, поки UNKNOWN; code/resource/build gates незалежно BLOCKED.

**Обґрунтування:** нові native game/net/bridge components і metadata доводять інший runtime contract, але не дають source-level semantic diff чи відтворюваної build. Protocol/FORMAT не встановлені; переносити old7/1 або single-EXE updater було б непідтвердженим.

**Наслідки:**0.33 development база/main/881 hashes незмінні; Phase3 має analysis/diff/migration gates, готова до продовження після matching dev package. New release executables/libraries не запускалися, production/user saves не чіпали, publishing/commit не виконували. Це виконання fallback умови користувача, не оголошення повної міграції.

## D004 — 2026-11-20: продовжити source discovery, зберегти migration gate

**Контекст:** користувач попросив продовжити Phase3 з поточного checkpoint, дослідити publisher history/branches/releases і власні локальні materials та підготувати конкретний запит відсутніх inputs. Production code/native/save/protocol/main/commit/push/release/CI заборонені цим scope.

**Рішення:** перевірити збереження baseline і backup; оновити public refs/metadata, повторно використати вчорашні trees для unchanged publisher heads. Дослідити нові candidates: beta-гілки власного fork, credited community port, Windows Downloads source-labelled і Codex Development Pack ZIP. Після server restart спершу перевірити saved evidence, продовжити лише незавершені дії. Оновити verified checkpoint і точний dev-package checklist; game migration не виконувати без sources/build inputs.

**Обґрунтування:** локальний source ZIP із номером 0.41 містить старі 881 files; Codex pack — 29 documentation/tools files; власні beta-гілки мають 0.33.2.3 manifests, credited port — upstream 0.33.4. Жоден не надав відповідних native game/net/engine/bridge/resource sources 0.41.4.1. Нові branch names не доводять semantic compatibility. Закритий SDK може бути частковою основою, але не виконує вимогу редагування core.

**Наслідки:** 881 tracked, 123 Phase2 і 25 extracted release SHA256 PASS; main/HEAD незмінні, bundle verify PASS. Історичні runtime results не повторювали й не зараховували як 0.41 tests. Вчорашні aggregate validation.json/validation.log відсутні — це явно виправлено у TEST_MATRIX, нові фактичні reports мають окремі шляхи. Повноцінний dev project не отримано. Потрібні materials/доступ і scope прав; готовий запит у MIGRATION_041, нікому не надісланий. Альтернативний розвиток 0.33 або самостійні mechanics потребують окремого scope.


## 2026-11-20 — Phase5B.1 R02

Рішення: failure мережевого snapshot не активує partial world. Structural preflight перед mutation; scoped error observer + epoch/stage guards; після partial failure завершити local session/fresh menu і зберегти seat/checkpoint для явного retry. Success commit тільки після required fog/Main cache cleanup. Не вводити новий packet/FORMAT, не підміняти зміст SIM_REV source hash. Same identity допускає різний код, тому acceptance тільки exact same build. Обґрунтування/тести/limits: R02_SNAPSHOT_RESTORE_FIX.md, R02_FAILURE_INJECTION_TESTS.md. Фізичної повної world rollback немає; політика fail closed потребує owner/OKREDU review. Жодного commit/push/merge.


## 2026-11-20 — Phase5B.2 FIX05–08

Залишити existing airport build route і додати missing dispatch key; target-owned schema validation для build/rebase/airdrop, network free=true не дозволяти, internal spawns не змінювати. REBASE/AIRDROP cancel лише локального placement до submission; canonical command не відкликати, новий refund/abort не вводити. Cooldown явно переносити optional полем FORMAT1 з simulation timestamp, old default empty; canonical hash і prevalidation before mutation. New→old reader loses cooldown — downgrade unsupported, перед поширенням потрібний owner-approved revision gate; SIM_REV/PROTO/product identifiers без дозволу не змінені. Упорядкування simulation/формули upkeep збережено, один lazy fallback без кешу. Profile benefit repeated, global p99 не закрито. Evidence PHASE5B2_FIXES/REGRESSION_RESULTS/PERFORMANCE. Чужу updater branch/worktree виявлено й збережено; жодного publish/commit/merge.

## 2026-11-20 — Phase5C: reviewed Gemini, declared cohort та no automatic publication

- G01 прийнятий зі скоригованою retention: усі .old збережені; whitelist лише actual producer names; symlink/path/Windows guards. Nonempty primary не integrity proof. Actual GDScript RED35/14failed → Linux GREEN35, Windows36 з 3skip/N/A. R03/R04 не закриті.
- G02 частково: targeted gitignore, без untracking game/.godot; baseline881→HEAD903 (+23−1),625 не підтверджено. G03 corrected18manualchecklist, усі NOT RUN. G04 local PR template з beta/human review/N/A/actual attribution.
- Власник прямо погодив SIM_REV pr10-phase5b2-1 у Phase5C. PROTO7/FORMAT1/product number не змінені. Existing gates: hello до rejoin, Steam metadata, saved resume.5actual ENet scenarios +30saved identity checks PASS. Same SIM_REV не crypto identity; QA exact EXE/DLL SHA.
- Local release gate: тільки explicit manual main + publish_release=true + approved version + successful build. Push/PR/build-only не публікують, repository empty для build-only. Actions/Settings не змінювали remote; старий workflow може ще діяти.
- READY FOR FINAL QA лише для ізольованого candidate з updater off. Full GUI/MP не перевірені; R03/R04/R07/R05/shutdown/p99 OPEN. Phase5/R02/5B.2 збережені, backups не перезаписані. Без commit/push/PR/merge/release. [Докази](PHASE5C_INTEGRATION_RESULTS.md).

## 2026-11-20 — Phase7: development integration before manual QA

ZaGOR-1 прямо дозволив logical commits, push Codex branch, один cumulative PR1–10 + Phase5–5C та merge commit лише у beta. Manual GUI/full MP переносяться після integration і залишаються NOT RUN. Main/stable/tags/releases/manual workflows/Gemini/OKREDU не змінювати; required reviews/protection не обходити. Beta-only commits0, усі10heads ancestors96053d66, попередні fixes hash-identical. Backup86files реально відновлений; новий Phase7 backup також. Updater off, OPEN risks не приховані. [Mapping/authorization/evidence](PHASE7_BETA_INTEGRATION.md).

## CI_RESTORE — 2026-11-21, нова Git-історія

За окремою командою власника відновлюється CI у ci/restore-build від actual beta: PR→beta і push main/beta запускають tests/build, без Releases/tags/updater. Existing publication policy tests збережено; reserved release guard неактивний (build output=false), publish commands відсутні. Godot4.7.2 verified hashes, artifact provenance та нові negative artifact tests — [CI_RESTORATION](CI_RESTORATION.md). Commit/push/CI PR та merge beta дозволені лише за успішних Actions і виконаних required review/protection. PR #1 не змінювати; після integration лише повторна перевірка його умов.
