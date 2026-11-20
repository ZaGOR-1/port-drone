# AGENTS.md — DroneFlames PC port

> Працюй як відповідальний співрозробник Godot/GDScript-проєкту. Пояснення — українською, назви змінних/коментарі — за існуючим стилем конкретного файла. Не стверджуй, що це Pygame.

## DroneFlames Independent Development Policy

- За рішенням ZaGOR-1 від 2026-11-20 розвиваємо власний PC-порт на доступній Godot-кодовій базі. Відповідність сторонній 0.41.x не є метою або acceptance criterion.
- ZaGOR-1 — власник і приймає рішення про stable releases; OKREDU — довірений співавтор. Codex допомагає з реалізацією, review, тестами й документацією та зберігає авторство й обґрунтовані механіки людей.
- `main` — остання прийнята stable версія. Не використовувати для експериментів; перенесення з beta — тільки після стабілізації й прямого дозволу власника. Локально підготовлений workflow Phase5C дозволяє release лише explicit manual main+publish_release+version; remote policy перевіряти перед дією.
- `beta` — integration/development. Звичайні PR спрямовувати сюди після review та необхідних checks. Merge, commit, push, tags, release і workflow dispatch потребують окремої явної команди; дозвіл редагувати код не є дозволом на ці дії.
- Незалежні задачі: `feature/*` або `fix/*` від актуальної beta. Виняток Phase5: `codex/fix-pr10-critical` від PR10 head96053d66, який уже містить PR1–9. Не застосовувати cumulative PR окремими squash/cherry-pick; attribution та ancestry зберігати.
- Не переписувати й не пересувати спільні гілки або гілки OKREDU без узгодження. Конфлікти вирішувати явним review, без автоматичних reset/rebase/force-push. Узгоджувати ownership спільних великих файлів.
- Оригінальна міграція 0.41.4.1 — **DEFERRED / ON HOLD**. Історичні документи й rollback зберігати; не повторювати source discovery без нової прямої задачі та matching materials/прав.
- Перевіряти deterministic simulation, network authorization, compatibility і save/load наслідки змін. Не змінювати protocol7, FORMAT1 або native DLL без окремого погодження. Нові командні semantics/state hash документувати й відділяти несумісні builds.
- Не підвищувати version number без фактичної зміни продукту та рішення власника. Права на сторонній код/ресурси залишаються обов’язковими незалежно від власної назви чи стратегії.
- Phase5 дозволяє production edits лише в ізольованому worktree робочої гілки; primary/main/beta/migration і backups зберігати. Тести й fixtures використовують окремі user paths, не реальні saves/accounts.

## 0. Джерело істини й пріоритети
1. Поточні файли checkout, `git status`, фактичний HEAD, успішні тести.
2. Верифікована документація `docs/codex/verified/` та генерований `dist/codex_audit/` (перевірити свіжість).
3. `README.md`, `docs/performance.md`, `tools/`, тести, CI workflow.
4. Початкова документація `docs/codex/` — **гіпотези та навігація**, а не гарантія вичерпного аналізу.
5. Пропозиції й припущення — завжди позначай як припущення.

## 1. Обов'язкова ініціалізація нової сесії
- Прочитай цей файл; `README.md`; `docs/codex/01_ARCHITECTURE.md`, `04_BUILD_RELEASE.md`, `05_TESTING.md`, `06_GUARDRAILS.md`; переглянь `git status --short` і `git log -1 --format='%h %s'`.
- Запусти `python3 tools/codex/repository_audit.py --repo . --out dist/codex_audit`, якщо інвентар відсутній або застарів.
- Перш ніж робити конкретну зміну, прочитай **повний вміст усіх файлів**, причетних до неї, включно з батьківськими `extends` файлами, залежностями, відповідними тестами і serialized форматами.
- Для першої сесії виконай поетапний глибокий аудит ЗАВСІХ текстових джерел (не тільки топових), карти сценаріїв, стану, потоків мережі, можливих технічних проблем. Великі файли читай частинами до повного покриття. Бінарні ресурси інвентаризуй за розміром/типом/хешем, не вигадуй їхню семантику.
- Ніколи не вважай наявну документацію повнішою за код. Знайдені розбіжності виправляй в `docs/codex/verified/`.

## 2. Архітектурні інваріанти
- Godot 4.7.2 (сумісність з pinned editor/template з workflow; не міняти версію мимоволі).
- Startup за README: `game/override.cfg` -> `res://pc/boot.tscn` -> `pc/updater.gd` -> `res://game/main.tscn`; перевір існування фактичної основної сцени, зокрема можливі бінарні ресурси.
- `PcPort` і `SteamNet` — autoload; не міняти імена/ініціалізацію без аналізу.
- `game/game/main.gd` — entry script; успадкування йде через `game/game/main/main_input.gd` -> `main_strike.gd` -> `main_core.gd` -> `main_base.gd` (звіряти actual extends при зміні).
- Підхід `GameWorld`, `NetSession`, `Hud`, `Menus`, `MapCamera`, економіка, армія, авіація, флот, AI, save, localization з'ясувати на коді, не насаджувати новий фреймворк.
- Стан симуляції у multiplayer має бути детермінований; зміна порядку ітерацій, RNG, часу, tick scheduling, інтерполяції, ID або команд може розсинхронізувати клієнтів.
- НЕ ламати старі save-файли і формат serialization. Для змін формату — план міграції та round-trip тест.
- Обережно з `user://` (налаштування, збереження), async роботою, потоками Godot й об'єктними посиланнями.
- Зміна версій, лобі, мережевих пакетів або simulation protocol вимагає явної оцінки сумісності.

## 3. Захист користувачів і релізів
- **Не роби `git push`, merge у `main`, `gh release`, manual workflow_dispatch, теги або публікацію збірок без явної команди користувача.** Phase5C локально прибирає auto-publication; доки цей workflow не інтегровано, remote може все ще публікувати після push до `main`.
- Ніколи не розповсюджуй чужий код/графіку/закриті бета-збірки без підтверджених прав власників; `README.md` прямо попереджає про похідний код із closed-beta APK.
- Steam AppID 480 — тестовий Spacewar; не вважай готовою комерційною Steam інтеграцією.
- Updater завантажує бінарні артефакти. Під час змін перевіряти origin, HTTPS, контрольні суми, zip-пути, rollback, атомарність заміни, version rollback, тайм-аути, permissions. Ніколи не випробовуй на єдиній робочій інсталяції користувача.
- Не зливай токени, секрети, приватні збереження, конфігурацію Steam та особисті дані в логи, issue чи коміти.
- Збереження/міграції тестуй на КОПІЯХ; перформанс-тести запускай з ізольованими `user://` шляхами.

## 4. Правила змін
- Спочатку контекст, план, ризики, acceptance criteria; для дрібної задачі — лаконічний план.
- Мінімальний diff, прагматичні модулі; SOLID/DRY/KISS без «великого переписування» відновленого коду.
- Не перейменовуй `class_name`, signal, node paths, `res://` paths, RPC/API без перевірки всіх референсів.
- Не замінюй детерміноване планування на wall-clock або хаотичний `await`/threading.
- Не змінюй UI, Steam, updater, saves чи economy side effects без відповідних цільових тестів і ручної перевірки.
- Залежності, натівні dll, артефакти, великі ассети — не додавай і не оновлюй без явної потреби та обліку походження.
- Не додавай обов'язкових Python dependency, якщо завдання вирішується стандартною бібліотекою.
- Не прибирай чи не замовчуй наявні помилки для «зелених» тестів; окремо відокремлюй уже відомі несумісності headless Linux зі Steam/WebRTC.

## 5. Тестова матриця
1. `python3 -m unittest discover -s tests -p 'test_release.py'` — version/build/release logic.
2. `python3 tools/check_performance.py` — headless deterministic regressions (потрібен Godot).
3. Профільний benchmark на однаковому checkpoint, seed/dt/config, порівнювати p50/p99/max, samples.
4. Windows GUI smoke: меню, гра, камера, звук, UX 16:9/інші роздільності, навантаження, save/load, updater на тестовому release/source.
5. Steam mock 2+ peer + реальний Steam smoke — invite, join, disconnection/reconnect, version mismatches, desync, packet limits.
6. При змінах конкретної механіки — контрольні кейси на економіку/країни/війська/AI.
Не стверджуй PASS без реального запуску; збирай команди, статуси, логи й обмеження.

## 6. Завершення роботи
Кожна відповідь після імплементації повинна містити: (а) що змінено і чому; (б) конкретні шляхи; (в) тести PASS/FAIL/NOT RUN і причини; (г) ризики compatibility / save / multiplayer; (д) що лишилося. Онови відповідний verified-документ, журнал рішень `docs/codex/verified/DECISIONS.md` та backlog, якщо змінена поведінка. Тримай git working tree прозорим, не чіпай чужі локальні зміни.

## 7. Інструменти (за наявності)
- Serena — навігація по символах, референсах, структурі коду; якщо підтримує GDScript у поточній конфігурації.
- Context7 / офіційна документація — Godot/GDScript API з урахуванням версії.
- Git/GitHub CLI — локальна історія, PR, CI. Публікаційні дії — тільки за дозволом.
- draw.io — архітектурні схеми за встановленим кодом; Playwright/Chrome DevTools не основний шлях тестування Godot GUI.

## Phase5C checkpoint rules

- Читати свіжий CURRENT_STATE.md і PHASE5C_INTEGRATION_RESULTS.md; не повторювати повний PR audit. Історичні Phase5–5C fixes були uncommitted; Phase7 дозволяє їх commit/integration. Актуальний стан перевіряти Git, не припускати його з історичного report.
- SIM_REV=pr10-phase5b2-1 погоджено для поточного кандидата. Protocol7/FORMAT1 незмінні; optional cooldown fields мають попередньо задокументовану downgrade несумісність. SIM_REV не fingerprint коду; QA peers використовують однаковий exact build+SHA256.
- Updater cleanup: лише доведені власні expendable temp names; не видаляти .old без доказу committed integrity. Не тестувати updater download/replacement на робочих інсталяціях. Native DLL не змінювати.
- Tracked game/.godot містить потрібні імпортовані ресурси. Не untrack/delete; .gitignore лише targeted caches. AGENTS/docs мають увійти до майбутнього review, не ховати їх ignore-правилами.
- .github/pull_request_template.md не змінює GitHub default branch/settings; target beta обирається явно. CI policy перевіряти offline, workflow не dispatch без команди.

## Phase7 owner decision — integration before manual QA

- Поточна явна задача дозволяє commits, push codex/fix-pr10-critical, один integration PR та звичайний merge commit виключно у beta. Manual Windows GUI/full multiplayer проводяться після merge; лишаються NOT RUN. Не вимагати їх повторно як precondition цієї інтеграції.
- Не обходити required review/checks/protection. Main, OKREDU/Gemini branches, tags/releases/manual workflow dispatch не змінювати; force push/rewrite заборонені. Цей task-specific дозвіл не є дозволом на stable publication чи довільні наступні merges.
- Beta QA: DF_NO_UPDATE=1, updater repo empty, не запускати production updater download/activation через OPEN R03/R04. Same exact EXE/DLL SHA на peers, SIM_REV не code fingerprint.
- Після інтеграції нові задачі від actual beta у feature/* або fix/*; власник окремо вирішує stable release. Прочитати PHASE7_BETA_INTEGRATION та PHASE8_BETA_QA_PLAN, перевірити GitHub merge/remote SHA.
