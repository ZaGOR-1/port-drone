# Аудит десяти PR OKREDU — результат

2026-11-20, latest `96053d66eb984cc24e3acce647a55a195136abd2`, base `af1b4c975564bac916db079d8470c2394d4920e5`. **NOT READY** для інтеграції поточного cumulative head: відтворені authoritative determinism, human consent, carrier ownership/lifecycle і Chronicle errors; див. [PR_RISKS](PR_RISKS.md). Розробку можна продовжувати в окремій candidate, Windows діагностичний build існує. Це не дозвіл merge.

OKREDU зробив значне розширення доступного0.33 порту: tooling/regressions, render/sim оптимізації, Steam/LAN/PC UX, AD/air/economy QoL, nuclear chain/ABM, carrier/airdrop, seasons/ideologies/flags, territory trade і Chronicle. Є backend implementations та meaningful component tests. Водночас integration seams (UI dispatch, Ship owner, death/no-base, render vs simulation, second-human authorization) покриті недостатньо. Якість окремих helpers/cache рішень добра; готовність усього продукту недостатня, без формального «балy якості».

## Що саме входить у PR

| PR | Унікальна зміна | Залежність |
|---|---|---|
|1|Windows harness, commands/trace/hash/delayed queue, Steam cleanup, FX/shader paths|Sibling від baseline|
|2|CoverDraw batching, idle redraw/tree sway skip, shader fetch pruning|Sibling від baseline|
|3|Army/navy/air queries, operations single pass, guide facility index|Sibling від baseline|
|4|PC scale ownership, wider menus, FrontPlan reset, Steam/LAN-only UI|Sibling від baseline|
|5|Merge1–4 + AD priorities, air sell/rebase, bulk economy,11 bots, rename, no-slow/hold|Містить1–4 через octopus merge|
|6|Plutonium, ICBM silo, Zaslon ABM, crater/radiation, nuclear AI/diplomacy|Descendant5|
|7|Carriers/deck jets, escorts/nearest base, airport/transport/paratroops|Descendant6|
|8|Seasons/weather,7 ideologies/monuments, P1 flags,40 emblems|Descendant7|
|9|Chronicle, land deals, cession/highlights + optional sprite-field fix|Descendant8|
|10|Nuclear timing/VFX, adaptive PC controls/UI, late sim/render changes + What’s New/translation|Descendant9|

Повні назви/author/status/branches/SHA/updated dates/commits/files/CI/comments для кожного — [PR_01_TO_10_REVIEW](PR_01_TO_10_REVIEW.md). Усі10 open, non-draft, OKREDU, beta base; mergeable true/clean у API. Жодного check run/workflow run/review/comment для цих heads у отриманому snapshot. Відсутність CI не перетворюється на PASS.

## Історія та розмір

PR10 містить **всі commits1–9**, включно fix84f95c9. Немає older-head commits поза10; немає duplicate patch-id серед12 non-merge commits. Всього13 унікальних commits з одним чотирибатьківським merge.1–4 незалежні,5–10 накопичувальні; це не лінійний ланцюг усіх десяти. [Mermaid/native graph](PR_DEPENDENCY_GRAPH.md) і range-diff підкріплюють висновок.

Cumulative10:129 changed files, +9784/−1209. Runtime game GDScript264→269:6 нових modules і1 видалений signaling server; всього GDScript у repo267→273 з урахуванням нового test suite. Scene-файли та DLL не змінені. Нові ресурси —7 PNG/JSON atlas pairs; додаткових runtime package dependencies немає. Updater/build/workflow не перероблено.

Реальні balance changes: winter farm×0.5 (також farm money), ideology production/prices/speed/recruitment; plutonium45s/cap12, ICBM25000+resources+5Pu/build45s/arm30s/reload90s; blast34cells/crater13cells/fallout168px300s9DPS; new carrier/aircraft prices/stats; AD engagement priorities/caps, land valuation; AI1phase/tick та active-slice/inner-circle expansion shortcuts. Це зміни поведінки, не лише оптимізація. Оригінальну0.41 parity не встановлено.

## Каталог і перевірки

У каталозі **50 можливостей/контрактів**, із них **22 IMPLEMENTED & TESTED**, **12 IMPLEMENTED, NOT RUNTIME TESTED**, **7 PARTIAL**, **8 BROKEN**, **1 UNVERIFIED**. Це визначена гранулярність [FEATURE_CATALOG](FEATURE_CATALOG.md), а не число повністю готових ігрових механік. Positive component PASS не означає Windows GUI/MP readiness; broken contracts виділені окремо.

Фактично відтворено:16 Python tests;2476 regression checks;309 mechanics assertions;269 runtime script loads;883/883 PCK hashes;17 synthetic legacy/new-field save checks; Linux та Windows headless startup;3 Windows DLL loaded;7 atlas bounds;4 same-checkpoint benchmark runs. Failed product probes збережені окремо, exit0 їх harness не зараховано як PASS. Clean shutdown FAIL. [PR_TEST_RESULTS](PR_TEST_RESULTS.md) містить commands/logs/time/limits.

На1024/4bots/seed20261016/dt0.2/300ticks latest mean трохи кращий, але p99 гірший в обох повторах:39.752/47.515ms проти36.125/38.353ms. Full late-game/GPU performance improvement не доведено, autosave pauses слід рахувати окремо.

## Пріоритети та практичне рішення

HIGH runtime: PA01 seasons/frame delta змінює farm output без hash detection; PA02 human land buy/sell/swap без accept; PA03 Ship owner country_id; PA04 Chronicle Ship country_id; PA06 carrier wing без бази. HIGH compatibility gate PA11: PROTO7 не доводить cross-build сумісність; PR10 Menus=v0.34.0, version.cfg досі0.33.2.3. MEDIUM: airport dispatch, land cooldown persistence, cancel modes, upkeep eager fallback, Chronicle duration/MP scope. LOW: nationality defense text vs hook. Успадковані updater R01/R03/R04, failed restore R02, mock/tmp R17 і exit leaks R18 не закриті.

Windows diagnostic build готовий для ізольованого smoke/відтворення, але beta не сертифікована для повного Windows gameplay test як «працююча нова база». Користувач може відкрити тестовий launcher із [PR_TEST_RESULTS](PR_TEST_RESULTS.md); спочатку бажані пріоритетні fixes. Real Steam/2-peer, GPU, keyboard/mouse/DPI/audio і повна save/fault matrix NOT RUN.

Зберегти main0.33.2.3; майбутня основа — виправлений descendant10 у beta після gates. **Поточна remote beta ще baseline**, не накопичувальні нові mechanics. Найменший ризик повторного застосування — одна cumulative integration зі збереженням ancestry, без десяти squash/cherry-pick. [INTEGRATION_STRATEGY](INTEGRATION_STRATEGY.md) — план; [COLLABORATION_WORKFLOW](COLLABORATION_WORKFLOW.md) — feature branches/ownership/review/tests/release guard для двох developers.

Стратегія0.41: не зупиняти розвиток редагованого порту через очікування закритого dev package; запросити matching0.41 sources/build inputs паралельно. Нинішні additions схожі за призначенням на частину0.41.x можливостей, але не доводять точний balance/save/protocol/native contract. [MIGRATION_041](MIGRATION_041.md) лишається BLOCKED і незмінний.

## Що збережено

Primary branch/HEAD/main/migration незмінні;881/881 tracked file hashes та123/123 Phase2 artifacts збігаються. Existing overlay і rollback збережені. Detached worktree clean. Без production edits, merge, commit, push, tags, releases, workflow dispatch, GitHub comments чи реальних user saves/accounts. Створені тільки локальні docs/diagram і ignored audit fixtures/reports/build. Джерела GitHub pinned; фінальна перевірка10/10 heads без змін.

Повторний аудит після fixes має прив’язуватися до нового SHA. До того рішення: **NOT READY** через конкретні відтворені HIGH дефекти, попри позитивні suites та textual mergeability.
