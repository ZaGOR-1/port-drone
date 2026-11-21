> **2026-11-21 — 18 сценаріїв перевикористовуються.** Старі SHA/каталоги/build results нижче HISTORICAL. Для нового exact beta build застосовувати [WINDOWS_TWO_PEER_QA_PLAN](WINDOWS_TWO_PEER_QA_PLAN.md); усі18 cases зараз NOT RUN, updater off. TC-WIN-14 потребує human peers.

# Windows Beta QA — Phase5C candidate

Стан усіх 18 ручних сценаріїв: **NOT RUN**. Code review та headless assertions нижче — підстава очікувань, а не GUI PASS. Походження: reviewed Gemini G03; оригінал у Gemini worktree збережений. Цей checklist замінює його для приймання поточного кандидата.

## Підготовка та докази

1. Взяти комплект із `dist/phase5c_20261120-220811/windows-release/` цього worktree. Це локальний кандидат, не затверджений stable v0.34.0; наявний UI label не є рішенням про новий випуск. Не завантажувати автоматично сторонній release.
2. Зберегти SHA256 EXE, три DLL, `SIM_REV`, ОС, CPU/GPU/RAM, driver, monitor resolution/refresh, UI scale та параметри світу/seed. `windows_integrity.json` і `windows_manifest.json` задають очікувані артефакти. Не змішувати fixture `windows-cleanup` із ігровою збіркою.
3. Для SP відкрити PowerShell і виконати `& '.\Run-DroneFlames.ps1' -Mode Gui` у каталозі комплекту. Launcher ізолює APPDATA/LOCALAPPDATA, вимикає updater і **обходить Steam initialization** через `DF_STEAM_MOCK=0`; це не Steam offline або multiplayer тест. Використовувати його тестові saves, а не особисті.
4. Результати: PASS / FAIL / BLOCKED / NOT RUN / N/A з причиною. Для кожного зберегти кроки, screenshot/video, engine/stdout/stderr, save-copy, seed/config та час. Не перезаписувати попередній невдалий лог повторним запуском: скопіювати `test-logs` перед наступним запуском.
5. Немає погодженого FPS/startup/exit budget. Записувати фактичні величини й умови; 30 FPS, 60 FPS чи 1–2s не є автоматичною межею PASS. Для performance висновку потрібні порівнювані повтори.

| ID | Сценарій | Ручний статус |
|---|---|---|
| TC-WIN-01 | Запуск і меню | NOT RUN |
| TC-WIN-02 | Світ / боти / політичні параметри | NOT RUN |
| TC-WIN-03 | Камера й навігація | NOT RUN |
| TC-WIN-04 | Контекстні клавіші | NOT RUN |
| TC-WIN-05 | Fullscreen та UI scale | NOT RUN |
| TC-WIN-06 | Економіка та будівлі | NOT RUN |
| TC-WIN-07 | Сезони / графіка | NOT RUN |
| TC-WIN-08 | ППО / авіація | NOT RUN |
| TC-WIN-09 | Airport dispatch | NOT RUN |
| TC-WIN-10 | REBASE / AIRDROP cancel | NOT RUN |
| TC-WIN-11 | Авіаносець та ownership | NOT RUN |
| TC-WIN-12 | Ядерні системи | NOT RUN |
| TC-WIN-13 | Дипломатія | NOT RUN |
| TC-WIN-14 | Територіальні угоди / cooldown | NOT RUN |
| TC-WIN-15 | Chronicle | NOT RUN |
| TC-WIN-16 | Save / load / continue | NOT RUN |
| TC-WIN-17 | Довгий матч і tail latency | NOT RUN |
| TC-WIN-18 | Завершення / ресурси | NOT RUN |

## TC-WIN-01 — запуск

Запустити GUI launcher; пройти splash/наявний «що нового» і меню, відкрити налаштування та повернутися. Зафіксувати фактичний label, мову, тривалість запуску й логи. Очікується доступне меню без script errors/зависання/спроб updater; наявність тексту v0.34.0 не засвідчує stable release. Пакет уже містить DLL; production updater не випробовувати.

## TC-WIN-02 — світ

Створити тестовий світ 512 з явно записаними seed/map/bot/ideology settings, зафіксувати фактичні доступні варіанти. Заснувати столицю через UI, якщо гра очікує вибір; не вимагати auto-capital. Повторити доступний великий сценарій і конфігурацію 11 ботів. Очікуються працездатні меню та продовження симуляції; не приписувати жодному боту/ідеології неперевірені правила. Перелік ідеологій брати з цієї збірки (не вигадувати Technocracy).

## TC-WIN-03 — камера

Перевірити mouse drag/pan, wheel zoom, mini-map і кнопку центрування; після заснування столиці — H. На краях карти перевірити, що кліки UI не наказують юнітам і не зсувають карту випадково. Записати фактичні bindings та edge cases, якщо input context блокує дію.

## TC-WIN-04 — клавіші

У SP без текстового фокуса: Space — pause; Q/E — сусідня HUD page; H — center; X — наступний speed index. F1–F7: Map, Cities, Military, AD, Army, Politics, Navy (`Hud` page definitions; Politics — F6). `[`/`]` змінюють індекс speed у SP: список `[1,2,5,10,20,0.5]` не монотонний, тому не вимагати «] завжди швидше». Перевірити input з відкритими panels і текстовим полем: gameplay hotkeys не повинні заважати введенню. Esc спочатку закриває верхній UI; наступний може скасувати placement. У MP Space і brackets не є локальним керуванням швидкістю; X проходить чинне узгодження. MP-кроки виконати окремо з двома peers.

## TC-WIN-05 — екран і scale

F11 та Alt+Enter: toggle fullscreen/windowed. Ctrl+Plus/Minus: scale, Ctrl+0: default; фактичні значення `.7/.8/.9/1/1.15/1.3`. Перевірити 16:9 та інший доступний aspect ratio, OS scaling, довгі українські рядки, модальні вікна/кнопки й карту після resize. Очікуються доступні controls без clipping/невідповідних click regions. Не вимагати exclusive fullscreen або конкретної мінімальної FPS без budget.

## TC-WIN-06 — економіка

На контрольному SP save записати ресурси/доходи/upkeep та sim-time. Побудувати доступні економічні споруди, перевірити ціни, виробництво/дефіцит і лише реально доступні repair/upgrade actions. Порівняти UI зі змінами стану після ticks; виконати save/load/continue. Не створювати очікування балансу з назви PR: ціни й правила беруться з коду/поточної UI та погоджуються з OKREDU.

## TC-WIN-07 — сезони й графіка

Продовжити матч через зміну сезону/погоди; спостерігати сніг, ферми, шейдери й HUD. Перевірити pause, згортання/повернення, різні refresh/FPS, зробити save/load. Очікуються відсутність script errors і узгоджений видимий стан. Ці GUI спостереження **не доводять determinism**: його перевіряють fixed-tick/hash/RNG harness та два peers. SP frame scheduling не прирівнювати до MP fixed lockstep ticks.

## TC-WIN-08 — ППО й авіація

Побудувати доступні radar/AD/airbase, придбати дозволений літак, задати ціль та rebase між сумісними власними базами. Перевірити range/боєзапас/стан і відмову чужій базі. Спостерігати виявлення/перехоплення за чинними правилами; не вимагати 100% interception або непідтверджених гарячих клавіш. Повторити save/load під час польоту; критерій — валідні refs/states, продовження матчу без script errors.

## TC-WIN-09 — airport dispatch, FIX05

На чинній Military UI натиснути кнопку будівництва Airport (`build_airport` pathway), вибрати дозволений власний terrain і підтвердити. Це dispatch **дії будівництва**, не автоматична відправка літака. Перевірити створення об'єкта, списання показаної ціни й UI результат. Недостатні ресурси/заборонена територія/чужий actor не мають створювати airport. У MP повторити тим самим command pathway; forged-command authorization покриває автоматичний negative harness, GUI цього не заміняє. Не обіцяти непідтверджених пасивних airport income/aircraft rules.

## TC-WIN-10 — cancel, FIX07

Для власного сумісного літака увійти окремо в REBASE, потім AIRDROP; **до вибору map target** натиснути Esc і RMB у двох окремих спробах. Якщо спершу закривається panel, повторити Esc. Перевірити вихід із placement, відсутність команди/списання/дублікатів. Повторний cancel безпечний. Save/load у pending UI скидає локальний transient mode; не зберігає stale pointers. Після target submission команда вже authoritative: cancel UI її не відкликає, refund/abort не додані. Перевірити штатне продовження issued action та save/load у польоті; знищену base/aircraft перевірити як negative scenario.

## TC-WIN-11 — флот, FIX03/FIX04

Створити власний авіаносець, купити дозволений deck aircraft через UI (і окремо MP command), відкрити Chronicle за наявності ships. Перевірити ownership, відсутність `Ship.country_id` errors, save/load. На копії тестового save втратити carrier: поточна консервативна поведінка — пошук **власної живої сумісної наземної бази з місцем**, інакше aircraft DEAD. DECK_JET не може приземлитися на звичайну land base; перенаправлення на інший carrier не обіцяється. Очікуються відсутність null-base error та чужого ownership, продовження симуляції. Правило втрати крила потребує gameplay review.

## TC-WIN-12 — ядерні системи

За допомогою UI/ізольованого пізнього save перевірити фактично наявні uranium/plutonium/nuclear readiness, ICBM, ABM Zaslon, launch restrictions/cooldown, VFX і наслідки. Записати config/ціну/дальність/ціль та стан до/після. Перевірити відмову при відсутніх передумовах, save/load під час cooldown/польоту. Не вигадувати research tree і не вимагати гарантованого перехоплення. Нестачу відтворюваного fixture позначати BLOCKED з причиною.

## TC-WIN-13 — дипломатія

На тестовому матчі пройти реально доступні відносини/угоди/альянс/ультиматум/peace UI; записати пропозицію, правила прийняття, повідомлення й зміну стану. Перевірити reject/скасування/повтор та save/load. Не називати кнопку працездатною лише через її наявність. Угоди з людськими peers перевірити окремим MP сценарієм; AI має власні чинні правила відповіді.

## TC-WIN-14 — territory, FIX02/FIX06

Два human peers: A пропонує землю/обмін B. До згоди B ownership не змінюється; gift також потребує human recipient consent. Відхилити, повторити, прийняти валідний offer, повторити stale accept; сторонній C не може передати територію A. Pending TTL — 90 **simulation** секунд, одна pending на unordered pair. Чинний cooldown 90 sim-seconds є directional і стосується human initiator, не універсального AI embargo. Save/load/continue на тестовій копії не скидає cooldown; repeated load теж. AI recipient може виконати чинний прямий valuation/transfer path: не оголошувати це обхідним consent для людини. TTL/gift/pair правила лишаються для узгодження власником/OKREDU. Автотести додатково перевіряють optional FORMAT1 persistence.

## TC-WIN-15 — Chronicle

Після матчу з літаками/ships/територіальними подіями відкрити Chronicle, перемотати й повернутися. Це snapshot/keyframe viewer, **не** deterministic command replay. Код має KEYFRAME_DT=4 sim-seconds та MAX_FRAMES=450; не вимагати запису кожні 4 wall-clock seconds, безмежної історії чи непідтвердженого MP playback. Перевірити коректний owner корабля, читабельність і відсутність зміни live simulation від перегляду; ліміти/персистентність записати фактично.

## TC-WIN-16 — saves

У launcher-isolated user:// використати штатні save slots у `saves/`; записати фактичні filenames. Зберегти → вийти в меню → load/continue → продовжити однаковий контрольний інтервал. Зіставити ресурси, ownership, aircraft refs/actions, pending/cooldown. Старий fixture читати з копії; зіпсований/обрізаний тестовий save має дати контрольовану відмову. FORMAT1 номер незмінний, але optional cooldown field новий: old→new default empty history; downgrade new→old не підтриманий, старий reader губить cooldown. Не тестувати downgrade на єдиному save. Saved network match з попереднім SIM_REV очікувано відхиляється до restore.

## TC-WIN-17 — тривалий матч

30+ хв на записаному scenario, з AI/economy/air/naval/nuclear навантаженням за можливості. Записати CPU simulation p50/p99/average/max окремо від rendering FPS, memory trend та save/load pauses. Повтори й порівняння — лише однакові map/seed/checkpoint/bots/ticks/hardware/Godot. Погіршення whole-game p99 з попередніх фаз лишається OPEN; не оголошувати оптимізацію успішною за одним GUI запуском. Crash/script error/desync — FAIL незалежно від FPS.

## TC-WIN-18 — вихід

Штатно закрити меню, потім окремо навантажений матч; перевірити завершення власного процесу, логи, повторний старт і читання тестового save. Exit0 не дорівнює відсутності витоків. Попередня автоматика вже виявила ObjectDB/RID/resources-at-exit: це **відомий FAIL/OPEN**, не приховувати. Сам ручний сценарій тут NOT RUN. Зафіксувати elapsed та залишкові процеси без непогодженого 1–2s budget.

## Окреме multiplayer приймання — все NOT RUN

Це необхідний наступний етап із двома незалежними peers; admission-only loopback не заміняє його.

- Той самий точний EXE+DLL комплект на обох машинах, записані SHA256 і `Menus.VERSION/7/pr10-phase5b2-1`. Однаковий SIM_REV не доводить ідентичність коду.
- Окремо LAN/ENet та real Steam Spacewar/AppID480; за потреби online/WebRTC окремо. Launcher SP навмисно обходить Steam. Підготовлено `Run-MultiplayerQA.ps1`: LAN — `& .\Run-MultiplayerQA.ps1 -Transport LAN -Peer host` (на іншій машині `-Peer guest`); Steam — лише власноруч `& .\Run-MultiplayerQA.ps1 -Transport Steam -Peer playerA` з дозволеним тестовим акаунтом, на іншій машині — інший акаунт/peer label. Цей launcher має окремі `mpqa-user/<peer>` та `mpqa-logs/<peer>`, updater off; тільки явний `-Transport Steam` прибирає mock bypass. Обидва launchers пройшли PowerShell AST parse, MP launcher **не виконувався** й не означає PASS реальної мережі. Codex не входив у Steam і не запускав Steam mode.
- Create/join/invite → старт → команди UI обох гравців → однаковий order/turn/tick, RNG і state hashes. Economy/seasons/air/navy/territory/save-load-continue перевірити разом; GUI сходження не є доказом hash equality.
- Старий Phase5B2/R02 identity з тим самим Protocol7 повинен бути відхилений; однаковий candidate — прийнятий. Перевірити обидва напрями та відмову resume старої network save.
- Disconnect → reconnect → valid snapshot → continue; corrupted/truncated/incompatible snapshot → контрольована failure діагностика, **без false success/advance**; manual retry. Resync, late/duplicate commands, host disconnect/rotation/termination — окремі кроки з логами обох peers.
- Зберегти результати R02 lifecycle та exact build identity. Без цих перевірок усю гілку READY FOR BETA не позначати.

## Bug record та рішення

Для кожного FAIL: ID, exact EXE SHA, scenario/seed/save copy, expected/actual, найкоротші кроки, логи обох peers за потреби, screenshot/video і відтворюваність N/M. Секрети/реальні saves/Steam config у звіт не вкладати. Перед beta потрібні review cumulative fixes, manual QA, рішення щодо updater integrity/shutdown/p99 і окремий дозвіл на commit/push/PR/merge. Цей checklist нічого не публікує.

Підстави очікувань: `game/game/main.gd::_pc_hotkey`, `game/pc/pc_port.gd::_input`, `game/ui/hud.gd` page definitions; [FIX05–08](PHASE5B2_FIXES.md), [Phase5 critical rules](PR10_CRITICAL_FIXES.md), [R02 lifecycle](R02_SNAPSHOT_RESTORE_FIX.md), [Phase5C results](PHASE5C_INTEGRATION_RESULTS.md).
