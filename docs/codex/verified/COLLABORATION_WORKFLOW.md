# Співпраця в новому репозиторії DroneFlames

CURRENT, 2026-11-21. Source of truth: actual Git/code/tests, [AGENTS](../../../AGENTS.md), [CURRENT_STATE](CURRENT_STATE.md), [NEXT_SESSION](NEXT_SESSION.md).

- ZaGOR-1 — власник і release decision maker; OKREDU — довірений співавтор. Зберігати авторство і погоджені механіки людей.
- main — прийнята база; beta — development/integration/testing. Нові feature/*, fix/*, docs/* від актуальної beta. Не переписувати спільні branches/історію; великі shared files — погодити ownership.
- Перед зміною: статус/HEAD/контекст, повне читання залежностей/extends/tests/serialization, лаконічні acceptance/risk criteria. Мінімальний diff і review на correctness, authorization, determinism, save compatibility та side effects.
- Перед PR: перевірити diff, relevant checks і непроведені ручні cases; явно вказати target beta. CI PR #2 існує: PR→beta/push beta/main tests/build без release; PR template відсутній. Branch protection/required reviews перевіряти фактично.
- Commit, push, PR creation, merge, tags, release/dispatch — лише за прямою командою на відповідну дію. Старі Phase7 task-specific дозволи більше не чинні. main/stable потребує окремого рішення власника після QA.
- Scope кожної нової задачі визначає власник. PR #4 уже інтегрував v0.36; завершення PR #1 — документація й branch cleanup без production edits. Старі одноразові дозволи не є поточним workflow.
- Наступний Windows/two-peer QA — [план](WINDOWS_TWO_PEER_QA_PLAN.md), updater off, isolated users, exact EXE/DLL SHA. Жодних реальних updater/production accounts/data без scope/approval.

---

## HISTORICAL — колишні правила й task-specific винятки

Нижче збережено старий документ для attribution/decision context. Його old worktrees/SHA/permissions/PR instructions не застосовувати до нової історії.

# DroneFlames — спільна незалежна розробка

Політика власника, 2026-11-20: ZaGOR-1 — власник, OKREDU — довірений співавтор, Codex — технічний AI-агент. Розвиваємо власний PC-порт на доступній Godot-базі. Відповідність0.41.x не є метою; міграція DEFERRED без повторного пошуку. Права на сторонні ресурси/код зберігають значення; сама нова стратегія не надає прав публікації.

## Постійний workflow

- main: остання прийнята stable версія. Жодних щоденних/експериментальних edits; beta→main, теги й release — окреме рішення власника.
- beta: єдина звичайна integration/development основа. Обидва автори починають нову задачу від актуальної beta після safe fetch/status/base SHA.
- feature/*: одна незалежна можливість. fix/*: одне обмежене виправлення. PR base=beta, опис поведінки/contracts, фактичних tests/NOT RUN. Великі механіки узгоджувати до integration.
- Phase5 exception: codex/fix-pr10-critical від PR10, який ще не інтегрований. Залежні задачі до integration явно називають candidate, не дублюють десять cumulative PR.
- Один реалізує, інший review важливої зміни. Protocol/save/simulation semantics мають окремий compatibility review, великі gameplay/economy рішення — узгодження обох.
- Green checks не є автоматичним дозволом merge/release. Phase7 прямо дозволяє cumulative commits/push/PR/merge лише в beta; майбутні task/release потребують власного дозволу. Права GitHub/branch protection не змінені.

## Ownership і конфлікти

Узгодити людських відповідальних за gameplay/economy, network/save, rendering/PC UX, tooling/docs. Це рекомендація, не встановлений CODEOWNERS. Hotspots: game_world.gd, main.gd/main chain, navy.gd, air.gd, defense.gd, net_session.gd, save.gd, великі HUD/menus. Перед паралельною роботою називати конкретні методи/контракти; уникати двох широких edits того самого файла.

Codex поважає функції й авторство друга, пояснює root cause та мінімальне виправлення. При конфліктах прочитати обидві реалізації й узгодити результат. Без автоматичних reset --hard, force-push чи rebase shared/чужих branches. Синхронізація shared history — узгодженим merge base після дозволу; нові задачі простіше починати від вже актуальної beta.

Для нової сутності: spawn→UI→command→simulation→death→save/load→continue→hash. Ownership, RNG, порядок команд і ticks authoritative. Не міняти enum/serialized refs/RPC лише заради refactor.

## Пропозиції branch protection і CI

Нижче рекомендації для окремого погодження, не вже застосовані GitHub Settings. Phase5C workflow підготовлений лише локально; remote не змінений.

| Гілка | Рекомендований захист |
|---|---|
| beta | PR required, review іншого розробника, required safe checks, resolved conversations, без force-push/delete/auto-merge. Protocol/save зміни — review обох. |
| main | PR із reviewed beta/release candidate, required review/checks та explicit owner release approval, без direct/force push. Publish із main винести в погоджений release flow/protected environment. |

Майбутні непублікаційні checks: python-unit без Godot skips, godot-regression pinned4.7.2, mechanics-critical, pck-load, save-continue; network додатково two-peer-determinism; Windows build/smoke окремо від GUI checklist. Назви умовні: не ставити required до створення й перевірки workflow. PR CI не має release secrets/publication side effects. Manual Actions не запускати.

Перед PR: exact tested SHA або working diff hash, source manifest, suite outputs і stderr diagnostics, compatibility/downgrade limits, порівнювані benchmark. Offline FakeGitHub «Published» у release unit log не є реальною публікацією. AppID480 — test integration.

## Документація та передача контексту

AGENTS.md — постійна політика, CURRENT_STATE — поточний worktree/branch/tests/blockers, BACKLOG — задачі, DECISIONS — обґрунтовані рішення. Функціональна зміна оновлює відповідний system doc і tests; старі результати зберігають дату/scope. Migration docs не видаляти, позначити DEFERRED. Product version без фактичної зміни продукту й рішення власника не підвищувати.

Наступна сесія читає AGENTS/CURRENT_STATE/Phase5 docs, перевіряє status/HEAD/refs і продовжує існуючий uncommitted candidate. Не відновлювати стару стратегію й не повторювати повний аудит без причини. Untracked overlay включати у майбутній commit тільки після дозволу, не втрачати при зміні worktree.

## Phase 5C — передача Gemini та final QA

- G01–G04 reviewed без зміни Gemini worktree; known patch base та actual runtime tests. Людське авторство не підміняється AI assistance. [Review](PHASE5C_GEMINI_REVIEW.md).
- Local `.github/pull_request_template.md`: обирати beta вручну, розділяти automated/manual statuses та N/A. Template не змінює default branch/protections.
- Local CI: push beta/main та PR — tests/build only; publication лише explicit manual main + publish_release + approved version. До integration remote auto-release може діяти. Required check names/protection вмикати лише окремим рішенням після перевірки workflow.
- SIM_REV pr10-phase5b2-1 — declared gate; exact EXE/DLL SHA на обох peers. GUI/headless/admission не є full multiplayer proof. [18 manual cases та MP acceptance](WINDOWS_BETA_QA_CHECKLIST.md).
- Поточні shared hotspots: net_config/updater/workflow. Не застосовувати старий Gemini patch поверх 5C вдруге; source/test payload і preservation в PHASE5C_INTEGRATION_RESULTS.
- Власник/OKREDU review: land consent/TTL/pair, cancel boundary, carrier loss, updater integrity, shutdown/p99 перед beta. Codex не виконує merge/publication без прямої команди.

## Phase7 owner override / Phase8

Власник дозволив development integration до manual QA. Це не waive required GitHub reviews/checks і не оголошення GUI/MP PASS. Beta — testing, main — stable. Один cumulative PR зі збереженням історії OKREDU; no force push або rewriting. Старі PR не закривати вручну. Updater off для beta QA; наступні features/fixes від фактичної інтегрованої beta в окремих branches. [Integration evidence](PHASE7_BETA_INTEGRATION.md), [QA](PHASE8_BETA_QA_PLAN.md).
