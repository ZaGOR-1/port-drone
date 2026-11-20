# Phase 7 — поточне рішення власника

Спочатку один cumulative merge PR1–10 + Phase5–5C у beta, після нього manual Windows/MP QA. Дозвіл на commits/push/PR/merge beta надано прямо; main/release/tags/manual workflows не дозволені. Required reviews/checks не обходити. [Mapping і план](PHASE7_BETA_INTEGRATION.md), [Phase8](PHASE8_BETA_QA_PLAN.md). Попередні pre-merge GUI gates нижче історичні й superseded для development integration, а не оголошені пройденими. Updater off; дефекти лишаються backlog.

---

# Phase 5C — final QA перед інтеграцією

Один результат: PR10 head96053d66 + Phase5 + R02 + 5B.2 + reviewed5C, не десять squash/cherry-picks. Людське авторство OKREDU збережено; усі fixes uncommitted. [Candidate та логи](PHASE5C_INTEGRATION_RESULTS.md).

Declared revision gate та R01 cleanup локально закриті; CI publication policy / PR template підготовлені, Settings незмінні. Full Windows GUI / two-peer acceptance і R03/R04/R07/R05/shutdown/p99 review лишаються gates. Same SIM_REV не є fingerprint: для QA використати однаковий EXE SHA. Updater вимкнений.

Після manual QA/human review повторно read-only перевірити actual remote beta/PR10 heads і conflicts; обрати один cumulative PR route разом з OKREDU, без конкуруючих PR. Немає дозволу на commit/push/PR/merge. Main — лише за окремим stable рішенням. READY FOR FINAL QA не є дозволом на integration.

---

## Історичний checkpoint до Phase5C (збережено)

# Phase 5B.2 — integration gates

Один cumulative PR10+Phase5+R02+FIX05–08, без дублювання10PR, зі збереженням attribution/ancestry OKREDU. Exact uncommitted candidate і patches у PHASE5B_PROGRESS.md. Local tests PASS не є дозволом commit/push/PR/merge і не робить beta ready.

До integration: окремий owner-approved build/revision gate для нового cooldown/hash (same SIM_REV допускає старий код), explicit unsupported-downgrade policy, code/gameplay review, full same-build two-peer reconnect/resync/host transfer та Windows GUI. Updater/integrity/general network HIGH gates окремо; whole-game p99 і shutdown OPEN. Локальну updater-гілку іншої сесії не перезаписувати; вона від96053, не містить наших uncommitted fixes автоматично. main/beta не змінювати.

---

## Історичний checkpoint (збережено)

# Phase 5B.1 integration gate overlay

Один cumulative результат PR10+Phase5+R02 зберігає історію/авторство OKREDU;10PR окремо squash/cherry-pick не інтегрувати. R02 local tested, але Windows GUI/full two-peer restore та інші відкриті HIGH gates не закриті. Точний checkpoint — PHASE5B_PROGRESS.md. Немає commit/push/новогоPR/merge. Незакомічені fixes не існують у HEAD96053, це важливо для наступних гілок. Будь-яка майбутня PR публікація/merge тільки після окремого дозволу власника; main stable недоторканна.

---

## Історичний checkpoint (збережено)

# Інтеграція DroneFlames — Phase 5

Оновлено 2026-11-20. Власник обрав незалежний розвиток доступного Godot-порту. main — stable, beta — integration/development. Міграція 0.41.4.1 DEFERRED; matching dev package не є умовою розробки нашої гри. Пошук не продовжуємо.

## Консолідована основа

Гілка codex/fix-pr10-critical, worktree /home/zagor/projects/port-drone-pr10-critical, створена від PR10 **96053d66eb984cc24e3acce647a55a195136abd2**. Fixes uncommitted: користувач заборонив commit. HEAD сам по собі ще не ідентифікує виправлену збірку; потрібні working diff, source manifest і PCK SHA з [PR10_REGRESSION_RESULTS](PR10_REGRESSION_RESULTS.md).

main/beta/migration при preflight — af1b4c975564bac916db079d8470c2394d4920e5. Гілки OKREDU не змінені. PR1–4 siblings, їхній merge у5; 6–10 descendants. Кожен head1–9 ancestor10;13 унікальних commit objects включно з merge, старих комітів поза10 немає. Докази: [PR_DEPENDENCY_GRAPH](PR_DEPENDENCY_GRAPH.md), Phase4 history.json і Phase5 preflight.

**Не інтегрувати десять cumulative PR окремими squash/cherry-pick.** Один результат: повна історія PR10 + reviewed fixes. Авторські commits OKREDU зберігаються; Codex не переприсвоює авторство. Перейменовувати дозволену гілку не потрібно.

## Gates перед PR та merge

Цільові FIX-01–04 оцінювати окремо від незакритого inherited HIGH **R02 failed snapshot restore**. Зелені suites не знімають цей blocker. Поточне рішення й точні статуси — [PR10_REGRESSION_RESULTS](PR10_REGRESSION_RESULTS.md).

1. Review diff ZaGOR-1 та OKREDU: human consent buy/sell/gift/swap, TTL90s/одна pending угода на пару; консервативна втрата deck jet без сумісної бази. Механіки збережені.
2. Окремий R02 fix із negative restore tests та valid restore; [PHASE5B_PLAN](PHASE5B_PLAN.md) відділяє наступні задачі.
3. Actual same-build 2-peer command/hash/determinism/reconnect/resync із різним FPS/stalls; mixed-build rejection. Локальні _exec і два незалежні replay runs не сертифікують транспорт.
4. Windows GUI/input/DPI/audio/save-load UX та LAN/погоджений Steam smoke. ID0 launcher обходить Steam init, це не Steam PASS.
5. Exact-candidate Python/Godot/regression/mechanics/PCK/save checks, stderr review, benchmark p50/p99/mean/max. Не запускати manual CI.
6. Safe fetch актуальних beta/PR10 refs. Якщо beta ancestor10 — історія має fast-forward relationship; uncommitted fixes ще не mergeable commit. Якщо beta просунулась — read-only merge-tree/тимчасова candidate і tests combined result, без переписування shared branches.
7. Після окремого дозволу — commits fixes/tests/docs з чесним attribution, один PR base=beta, CI та peer review. Після наступного явного дозволу — merge. Нічого з цього зараз не опубліковано.

## Один primary PR

PR10 уже відкритий. Рекомендація після погодження: один консолідований PR codex/fix-pr10-critical → beta зі збереженням ancestry10; PR10 позначити superseded з посиланням на successor,1–9 закривати узгоджено після підтвердження inclusion. Це майбутні дії: Codex нічого не закривав і не коментував.

Альтернатива: OKREDU погоджує перенесення лише fix commits на власний head, і PR10 лишається єдиним integration PR. Codex не змінює його гілку самостійно. Не лишати два конкуруючі PR «можна merge» і не squash cumulative diff двічі.

Локальний текст: [PR10_BETA_PR_DRAFT](PR10_BETA_PR_DRAFT.md); це документ, не GitHub PR.

## Compatibility та release

PROTO=7, FORMAT=1, Ship.FIELDS і DLL незмінні. Нові kind=land terms містяться у вже серіалізованому t_offers; старі saves без цих offers перевірені у synthetic scope. **New→old downgrade не підтриманий/не сертифікований**: старий код не знає land offers/carrier enums. Використовувати копії й окремий namespace.

Hash/consent semantics змінюють simulation compatibility. NetConfig.SIM_REV=pr10-critical-1 додається до чинного opaque identity Menus.VERSION/7/pr10-critical-1. PROTO, RPC names і packet layout не змінені; існуючі equality guards відокремлюють builds, але actual admission ще потребує 2-peer test. Product number у source не підвищували; локальний build бере вже наявну PR10 Menus-версію0.34.0, updater repo порожній.

Beta стане щоденною основою після gates. Main лишається стабільною0.33.2.3, migration branch — збереженим checkpoint. Beta→main/stable release тільки за окремим рішенням власника. Чинний main push може publish release; «push лише для CI» неприйнятний.
