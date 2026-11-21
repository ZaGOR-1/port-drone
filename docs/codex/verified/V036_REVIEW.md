# Review v0.36 — 2026-11-21

> Історичний review початкової feature до виправлень. Поточні integration fixes і нові результати — [V036_FIX_RESULTS](V036_FIX_RESULTS.md).

**NEEDS FIXES. Не інтегровано в beta.** Це цільовий review feature, не повторний аудит проєкту й не сертифікація multiplayer.

Опубліковано [REQUEST_CHANGES review у PR #3](https://github.com/ZaGOR-1/port-drone/pull/3#pullrequestreview-6007002682), включно з п'ятьма inline comments. PR OPEN, reviewDecision CHANGES_REQUESTED. Останній read-only `ls-remote` підтвердив незмінні beta/main/feature SHA нижче. Branch protection beta на час перевірки не ввімкнений, rules порожні; merge зупинений через code-review defects, а не відсутні CI checks.

## Ідентичність і межі

- Repository: https://github.com/ZaGOR-1/port-drone.
- Beta / merge-base: `145f23418a9a07420a15d6c350ac62c7633e2765`.
- Main: `172df65e3bd004efed9a5444e90a284d9d69db10`.
- Feature: `feature/v0.36-perf-shift-ux`, HEAD `151264b38c335b55df4e62bdaff346f27ed92970`.
- Існуючий [PR #3](https://github.com/ZaGOR-1/port-drone/pull/3), target beta. 8 комітів OKREDU (Git author CAFAIML), 93 змінені файли, +9989/-1101; 90 GDScript і 3 PO.
- Primary checkout beta збережено чистим. Окремі worktrees: `/home/zagor/projects/port-drone-v036-baseline` (detached beta) і `/home/zagor/projects/port-drone-v036-review` (локальна `fix/v036-review-integration`, від feature, beta є предком).
- Гілка автора, main, beta та PR #1 не змінювались. Виправлень production-коду, нових commits/push/merge/releases/tags не виконано. Цей звіт — локальний незакомічений файл у review worktree.
- PR #1 залишався OPEN, head `66b975ace94c7fc194598eba6feeb0bc3468b258`. Нові NEXT_SESSION/CURRENT_STATE звідти використовувалися read-only; історичні Phase5–7 reports з beta не є поточними результатами.

Охоплено змінені ділянки gameplay, economy, army, nuclear/defense, diplomacy, save, network whitelist, Main/Shift, PC settings, HUD/replay та render batching з вибірковим читанням залежностей. **Не заявляється повне ручне читання всіх 90 файлів і всіх їхніх залежностей.** Всі 90 змінених scripts завантажені реальним Godot, усі 3 PO завантажені й структурно перевірені; це не дорівнює повному аналізу їх поведінки. `dist/v036-review/coverage.json` враховує кожен із 93 файлів. Приймальний review після виправлень ще потрібний.

## Що зробив OKREDU

Це ширший scope, ніж оптимізація та Shift:

- Два етапи МБР по 120 секунд, платне виробництво боєкомплекту «Заслона», MIRV/decoy та EMP; перегрів/аварійний стоп АЕС, стратегічний захист і новий upkeep.
- Grey Zone, реакції дипломатії на ядерну програму, ultimatum/pledge, спеціалізації Т3, фізичні паливні конвої та пріоритет електромережі.
- Shift construction без повторного підтвердження, резервування pending MP builds у preview, Shift multi-select та RMB routes, пакетна купівля літаків, hotkeys/focus reset, PC preferences, HUD та переклади.
- Адаптивна хроніка, відновлення виходу з replay, часовий scrubber і virtualized event feed.
- Індекси facilities, плоскі spatial grids, кеші AI/navigation, atlas/outline packing, batching і redraw throttling; зміна freeze autosave.

Модулі загалом залишені у поточній архітектурі. Основні проблеми тут — життєвий цикл mutable state/кешів і пропущені наскрізні тести; додавання нового архітектурного фреймворку їх не розв'язує.

## Підтверджені дефекти

### V036-01 — HIGH: CI artifact не відокремлений від старої симуляції

**Файли/функції:** `.github/workflows/build.yml:28`, `tools/build.py::main`, `game/net/net_config.gd::version`, `game/net/net_session.gd::_hello/resume_host`.

CI задає `BUILD_VERSION: 0.34.0`. Build script переписує `Menus.VERSION`, а `SIM_REV` feature залишився `pr10-phase5b2-1`. У source identity `v0.36.0/7/pr10-phase5b2-1`, але у справжньому CI EXE **`v0.34.0/7/pr10-phase5b2-1`**, так само як у beta до feature. Exact string gate не розрізняє ці несумісні симуляції. Сирий source build із v0.36 має іншу product identity; висновок про колізію стосується CI artifact.

**Відтворення:** run `44910451496`, artifact source `c8913536821ddc743c53bfc238c4fb04b38329dd` (synthetic PR merge), game tree `12ae1c064fa4e2ee0ae25d85735a7896ed634f73`, що дорівнює feature game tree. Реальний embedded pack прочитаний pinned Linux Godot через `--main-pack DroneFlames.exe`, результат у `dist/v036-review/artifact-identity.log`. Мережевий mixed-build матч не запускався.

**Вплив:** несумісні клієнти/збережені network sessions проходять identity comparison. **Рекомендація:** відокремити нові simulation semantics новим SIM_REV; узгодити version source/build та додати тест identity саме запакованого EXE, включно з rejection старого build. PROTO7/FORMAT1 не потрібно змінювати для виправлення цієї колізії.

### V036-02 — HIGH: autosave записує mutable entity buffers після snapshot

**Файли/функції:** `game/game/save.gd::_queue_write` (921–943), `_entity_dump/_complex`, `_write_job`.

Заміна `body.duplicate(true)` на shallow copy захищає перелік core arrays, але лишає packed fields у `ents` спільними з live entities. `_entity_dump` не проганяє scalar-classified packed fields через `enc`. Worker отримує буфер, який main thread продовжує змінювати. Приклади реальних mutators: `gw_infra.gd` додає `Country.city_ids`, `Defense.set_ad_rule/set_ad_preset` змінює `Country.ad_rules`.

**Відтворення:** `dist/v036-review/save_freeze.gd`: `_ent_fields(Facility)` з `obj_ids=[10]`, реальний `_queue_write`, live mutation `obj_ids[0]=99`, wait worker, читання через `Save._read`. Padding 32 MiB перед entity дає worker час серіалізувати наступні поля; всі writes ізольовані. **Beta PASS: written=10; feature FAIL: written=99.** Це фактичний запис/читання файлу, а не лише порівняння посилань. Логи `save-freeze-baseline.log`, `save-freeze-review.log`.

**Вплив:** змішаний у часі snapshot/можлива гонка читання буфера, семантично некоректний Continue. Наявний regression має порожній `ents` і завчасно `Save.enc(core)`, тому дефект не ловить. **Рекомендація:** явно freeze усіх mutable entity packed fields до передачі worker або повернути повне freeze; тестувати реальний snapshot entity graph, живі city_ids/ad_rules/path та thumbnail. FORMAT1 не змінювати.

### V036-03 — HIGH: морські маршрути розходяться після restore

**Файл/функції:** `game/game/navy.gd::_threats` (1174), `sea_path` (1197), `save_state/load_state` (3193/3203).

Нові `_thr_cache` (1.5 s) та `_tcache` (15 s, ключ враховує лише кількість загроз) впливають на результат authoritative navigation. Їх немає у `save_state`, а `load_state` очищає обидва. Host зберігає старий обхід, відновлений peer обчислює інший шлях зі свіжих позицій.

**Відтворення:** `dist/v036-review/navy_restore.gd`; світ 512×512 water, ворог у (1024,1024), маршрут grid (4,64)→(120,64), початковий час 100. Отримати шлях, перемістити ворога у (1024,1750), час 101, відновити Navy через реальні `save_state/load_state`, порівняти `sea_path` обох instances.

- Beta PASS: host і peer мають однаковий прямий маршрут.
- Feature FAIL: host проходить через (840,1480)/(1224,1496), peer через (840,1032)/(1224,1032).

Логи `navy-restore-baseline.log`, `navy-restore-review.log`. Це component convergence test із реальними AStar/Ports/Navy; не два транспортні клієнти.

**Вплив:** desync після resync/reconnect/save restore. **Рекомендація:** зробити navigation результатом повністю відновленого simulation state: серіалізувати потрібний history state або змінити cache/invalidation так, щоб він не змінював результат. Просто чистити кеш лише у відновленого peer недостатньо. Потрібні round-trip + наступні однакові команди, hash/RNG і рух кораблів після restore.

### V036-04 — HIGH: cooldown UrbanHold не входить до snapshot

**Файл/функції:** `game/game/urban_hold.gd::_auto_city` (509–515), `save_state/load_state` (991/1015), `Save._load_systems`.

`_far_fail[home:city]` на 30 секунд забороняє повторну dispatch/nav спробу. Це впливає на simulation decisions. Serializer його не записує, loader не відновлює й навіть не очищає попередній local value. `hold` не входить у `Save.GENERIC`, тому generic dump це не компенсує.

**Відтворення:** у `targeted_review.gd` зберегти `_far_fail={"1:2":120.0}`, завантажити через `Save._load_systems(..., {"hold":Save.enc(save_state)})` у новий і у вже заповнений hold. Обидва assertion **FAIL**: новий лишає `{}`, reused лишає stale `{"99:99":999}`.

**Вплив:** різний момент відправлення підкріплень після restore, зокрема після відновлення дороги до закінчення cooldown. **Рекомендація:** зберігати й валідувати decision-affecting cooldown, детерміновано default/reset для старих saves; перевірити old optional-absent state та repeated restore. Тест вище перевіряє реальний serializer/restore dispatch; повний бій двох peers не запускався.

### V036-05 — HIGH: MP команда електромережі падає в authorization

**Файли/функції:** `game/net/net_session.gd::ALLOWED` (75), `_owns` (2146), `game/game/main.gd::_on_action` (704), `gw_states.gd::cmd_power_prio`.

UI передає `[world.player, priority]`, wrapper очікує Country, але whitelist значення `0` означає country **ID** у args[0]. `_owns` виконує `int(Country)` → `SCRIPT ERROR: Invalid call. Nonexistent 'int' constructor.` Команда не виконується. Наявний тест викликає wrapper прямо і перевіряє лише наявність whitelist key.

**Відтворення:** реальний `NetCodec.encode([issuer,1])` → `NetSession._exec({k:"call",s:0,o:"",m:"cmd_power_prio",a:...})` у `targeted_review.gd`; пріоритет залишається 0, очікування 1 **FAIL**, stack trace `_owns`→`_exec`.

**Рекомендація:** узгодити whitelist із Country contract (entity ownership guard, як для інших Country actions) або узгоджено перейти на ID. Додати тести дійсного UI command через `_exec`, чужої країни та malformed args; не прибирати authorization загалом.

### V036-06 — MEDIUM: hash не бачить нового authoritative state

`game/net/net_hash.gd::of` не змінено; воно не включає нові warhead/spec/power-priority/EMP/production timers/refinery buffer. На незміненому світі зміна `Facility.nuke_warhead` MONO→EMP дає той самий hash — **FAIL** у `targeted_review.gd`. Це підтверджена прогалина діагностики, не доказ окремого джерела desync. Частковість digest існувала і раніше; висновок стосується доданого state.

Рекомендація: охопити новий decision-affecting state канонічним digest та targeted mutation/round-trip tests разом із новим compatibility gate. Не вважати поточний однаковий hash доказом однакового нового state.

### Інші зауваження та прогалини

- **LOW, підтверджено кодом:** `hold_tip.gd` / silo card обіцяють 90 s EMP та 3 decoys, тоді як `Nuclear.EMP_DUR=75` і `MIRV_DECOYS=2`. Узгодити тексти/переклади з затвердженими механіками.
- **MEDIUM, source finding; GUI NOT RUN:** `hud_keys.gd:127–130` і відповідний type filter ховають `crow.get_parent()`/`row.get_parent()` — спільний VBox усіх rows. `_window` повертає inner VBox у ScrollContainer, окремого wrapper категорії немає. Якщо один owned category недоступний, «ТІЛЬКИ ДОСТУПНІ» може сховати весь список. Потрібний окремий row wrapper/skip і UI regression з одночасно affordable та unaffordable categories.
- **NEEDS GUI QA:** batching `_ground_units` групує sprites за atlas замість початкового порядку `_vu`; перевірити перекриття піхоти/техніки, shadows, LOD та вибір. Це ще не підтверджений візуальний дефект.
- Позначки часу й Input у новому preview є UI state; сам факт їх використання не оголошено simulation desync. Підтверджені desync risks вище мають конкретний decision flow.
- Не підтверджено повний old-save→new→Continue gameplay, нові механіки після reconnect, дві реальні Windows машини, Steam/LAN, довгий late-war benchmark або GPU frame pacing.

## Реально виконані перевірки

Godot `4.7.2.stable.official.ed1daf0bf`, engine/template hashes відповідають чинному CI pin. Нові dependencies не встановлювалися. Godot Editor на tracked game не запускався: source пакувався через `tools/packproj`, `user://` перенаправлявся у тимчасові директорії. Native smoke використовував лише package-local test-user/test-logs; updater disabled, Steam mock ID0 (без реального Steam).

| Перевірка | Результат | Scope |
|---|---|---|
| Python unittest discover з DF_GODOT, beta | PASS 32/32 | 109.840 s, із реальними Godot fixtures |
| Та сама команда, feature | PASS 32/32 | 113.196 s; це ще не покриває знайдені дефекти |
| `tools/check_performance.py --mode regression`, feature | PASS 2476 | differential checks; не повний MP determinism |
| Змінені GDScripts / PO | PASS 90 / 3 | load + can_instantiate, Translation load; без Editor import |
| Нові review reproductions | FAIL | 4 assertions targeted + autosave + Navy; докази дефектів вище |
| Git diff whitespace | PASS | `git diff --check origin/beta...HEAD` |
| GitHub Actions PR #3 | PASS | run 44910451496: Python + Godot/Windows build, release SKIPPED |
| Завантажений Windows artifact | PASS integrity | SHA256, PE AMD64, embedded PCK, pinned template, exact native ZIP/sidecars/launchers |
| Фактична artifact identity | FAIL compatibility | v0.34.0/7/pr10-phase5b2-1 |
| Windows native headless beta/feature | PASS startup/exit 0 | launcher Smoke; 83.856 / 62.086 s, час UNC/host не benchmark |
| Clean shutdown | FAIL / inherited | beta: 11 CanvasItem RID, 226 ObjectDB, 44 resources; feature: 10/224/44. Не нова приписана feature регресія |
| Windows GUI, LAN/Steam two-peer | NOT RUN | native headless не підміняє ці перевірки |
| Semgrep GDScript | SKIP | GDScript відсутній серед supported languages |
| Serena LSP | unavailable | endpoint 127.0.0.1:6008 не відповів; G07 не змінювався |

Mock release tests друкують `Published https://github.com/owner/game/...`; це mocked unit output, реальні releases не створювалися.

CI EXE SHA256: `84dc4edb8163f48e3d1e13a5adbaa8910f3274bfe22e0dd807c47d771f991cf1`.
PCK 106064124 bytes, offset 109268480. Exact package у `dist/v036-review/ci-windows/`; metadata у `ci-diagnostics/build-verification.json`. Два native DLL зафіксовані module poll feature; steam_api64 перевірений hash, окреме завантаження його module poll не засвідчило.

## Вимірювання продуктивності

Порівняння виконувалось послідовно на одному host/pinned engine, common beta checkpoint, map512/bots2/seed20261016, warmup0, 180 simulated seconds, dt=1/30, 5400 samples. Початковий прогон генерації checkpoint не використано як A/B вимірювання. Після replay beta має 20 facilities, feature 19: змінилися semantics/порядок, тому це workload comparison, не equivalence test.

| `_sim_step` | Beta | Feature |
|---|---:|---:|
| Mean ms | 0.1857 | 0.2199 |
| p95 ms | 0.538 | 0.599 |
| p99 ms | 1.572 | 1.656 |
| Max ms | 5.912 | 32.456 |

Цей early-world workload має 0 units. Загального прискорення він не підтвердив. Один pair/host noise не встановлює універсальної performance regression або GPU FPS. Autosave main-thread calls були 8.4–11.6 ms beta проти 6.2–7.9 ms feature, але це не приймальний виграш за наявності V036-02.

Додатковий вузький benchmark Army spatial grid: 4000 units, 130 rebuild samples після warmup, 4800 query samples; ABBA order. Усі runs дали однаковий candidate count 1039642. Beta query p50 7/7 μs, p99 27/25 μs; feature p50 8/10 μs, p99 35/60 μs. Build p50 beta 3651/5344 μs, feature 4079/6144 μs. Великий міжпрогоновий розкид; стабільного виграшу не встановлено. Це general-near query, не benchmark усіх hostile-mask/render optimizations. GPU/late-war claim **UNVERIFIED**.

## Докази й повторення

Локальні логи/scripts/checkpoint: `dist/v036-review/`. Файли evidence ignored, не є committed fixtures. Наступний Codex має перевірити їх існування; якщо їх немає, старий PASS/FAIL не видавати за новий запуск.

```sh
DF_GODOT=/home/zagor/projects/port-drone/godot_dl/godot \
  DF_NO_UPDATE=1 DF_STEAM_MOCK=0 DF_NO_OPENING=1 \
  python3 -m unittest discover -s tests -p 'test_*.py' -v

python3 tools/check_performance.py \
  --godot /home/zagor/projects/port-drone/godot_dl/godot \
  --mode regression --out dist/v036-review/regression

# У review worktree. Expected exit 1 на поточній feature через знайдені дефекти.
python3 dist/v036-review/run_fixture.py --repo . \
  --godot /home/zagor/projects/port-drone/godot_dl/godot \
  --script dist/v036-review/navy_restore.gd \
  --log dist/v036-review/navy-restore-review.log
# Інші scripts: targeted_review.gd, save_freeze.gd, grid_benchmark.gd.
```

## Наступна дія

Виправити V036-01–05 у власній інтеграційній гілці зі збереженням усіх 8 комітів OKREDU. Перед змінами прочитати повні змінювані файли й безпосередні dependencies; перенести reproductions у нормальні regression suites, не просто замінити очікування FAIL на PASS. Перевірити V036-06 і UI filter. Нова transport layout/save FORMAT/native DLL не потрібні за припущенням — спочатку мінімальні узгоджені виправлення й compatibility assessment.

Повторити actual EXE identity, old/current admission, all-peer snapshot continuation (включно Navy/hold), save freeze, всі автоматичні тести, CI та приймальний review решти змін. Лише після відсутності HIGH/BLOCKER і виконання protection/reviews — звичайний merge commit у beta. Main/PR #1/гілку автора не чіпати. Для двох людей використовувати один точний виправлений EXE/DLL SHA, updater disabled; поточний artifact не готовий до acceptance multiplayer QA.
