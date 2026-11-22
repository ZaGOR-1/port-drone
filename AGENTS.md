# AGENTS.md — DroneFlames PC port

Працюй як відповідальний співрозробник Godot/GDScript-проєкту. Відповідай українською; назви, коментарі та стиль коду зберігай відповідно до файлу. Розрізняй перевірені факти, гіпотези й NOT RUN. Не проводь повний аудит репозиторію на кожному завданні.

## 1. Мета та пріоритети

- **Зараз лише Windows x64.** Першочергове: стабільна гра й portable **один `DroneFlames.exe` для користувача**, реальний GUI/LAN/Steam QA, усунення native crashes та падіння до **2–3 FPS у late-game**. Нативний Linux-порт і cross-play з Linux — **DEFERRED** до прямої задачі.
- **Продуктивність і масштабованість — ключові цілі.** Профілюй великі бої з юнітами, ракетами й вибухами на Windows; спочатку доведи bottleneck, потім оптимізуй і вимірюй до/після. Орієнтири: 30+ FPS у визначеному важкому сценарії, 60 FPS у звичайних; це не гарантовані результати.
- **Архітектуру покращуй поетапно:** Clean Architecture, SOLID, DRY, KISS, YAGNI, data-oriented design і патерни тільки за потреби. Без великого rewrite, зайвих абстракцій і регресій. Спочатку characterization/regression tests, потім вузькі зміни.
- Нові gameplay-функції, великий редизайн та міграція сторонньої 0.41.x — не пріоритет; лише за прямим запитом. Пошук/перенесення сторонніх матеріалів потребує відповідних прав.

## 2. Джерела істини й відповідальність

- Репозиторій: <https://github.com/ZaGOR-1/port-drone>. Власник навмисно почав **нову Git-історію зі snapshot**. Не вимагай старої ancestry, не відновлюй старі branches/PR.
- ZaGOR-1 — власник і координатор, ухвалює stable/release рішення; OKREDU — співавтор; Codex — основний агент; Gemini — допоміжні ізольовані задачі. Зберігай авторство та provenance.
- Порядок джерел: **фактичні files/HEAD/status і поточні тести → verified docs з урахуванням scope → README → історичні звіти**. `verified` не означає сертифікацію всього продукту.
- Поточні SHA, результати QA і статус локальних патчів веди в [PROJECT_STATE.md](docs/PROJECT_STATE.md) та відповідних звітах.

## 3. Початок сесії

1. Прочитай цей файл і [PROJECT_STATE.md](docs/PROJECT_STATE.md).
2. Звір корінь repo, `git status --short`, branch, HEAD і `git worktree list` зі станом у документі. За потреби перевір `git ls-remote --heads origin main beta`. Створюй нові гілки від актуальної `beta` та бережи незакомічені зміни.
3. За [INDEX.md](docs/INDEX.md) відкрий документацію поточної задачі. Точково перевір реалізацію, прямі залежності, контракти й тести перед редагуванням. Для фактичного стану пріоритет мають Git, код і докази.

## 4. Git safety

- `main` — стабільна база, `beta` — активна інтеграція/QA. **Дозвіл на редагування не дозволяє commit, push, PR, merge, workflow dispatch, tag або release** без прямого дозволу в поточній задачі. Старі дозволи не переносяться.
- Експерименти — в окремій гілці/worktree; PR → `beta`, мінімальний diff, review, реальні tests/NOT RUN. `beta → main` лише після acceptance QA й рішення власника.
- Не переписуй shared/OKREDU branches; без force push, руйнівних `reset --hard`/`git clean`, неочікуваного видалення гілок/worktrees. Не обходь required reviews/CI/protection.
- `.github/workflows/build.yml` перевіряє PR→`beta` й push `beta`/`main` та збирає Windows; CI PASS **не** дорівнює Windows GUI/Steam/LAN PASS.

## 5. Структура, Godot і ресурси

- Godot **4.7.2**; перевір точну версію editor/export template/source/toolchain. **`game/project.binary` + `game/override.cfg` — штатні.** Не створюй `game/project.godot`. Не видаляй, не untrack і не ігноруй глобально `game/.godot/`: там tracked binary scenes та потрібні imports.
- `game/game/` — simulation/entities/Main/save; `game/world/` — world/render; `game/ui/` — HUD; `game/net/` — session/codec/hash/LAN; `game/pc/` — boot/Steam/updater; `libs/` — Windows DLL; `tools/`, `tests/` — build/regression/QA. Перевір структуру фактично.
- Boot: `pc/boot.tscn` → updater → `game/main.tscn.remap` → binary PackedScene → `game/main.gd`; autoload PcPort і SteamNet. Основні ланцюги `extends` звіряй у source, не за пам'яттю. Не змінюй `class_name`, signals, scene/node paths, RPC, enum ordinals без аналізу наслідків.
- Godot Editor/import і будь-які інструменти, що генерують UID/cache, запускай **тільки в ізольованій фізичній копії**. `.import` з кінцевим NUL — можливий mapping; відсутність вихідного PNG/OGG не обов'язково означає відсутність runtime resource.

## 6. Детермінізм, multiplayer, saves

- SP — adaptive frame delta; MP — `SIM_DT = 1/30`, три ticks/turn, canonical host command order. **Authoritative simulation незалежна від FPS, камери, visibility та wall-clock.** Не вводь недетермінований threading/RNG/порядок обробки.
- RNG draws, ID/command order, `_sim_step`, mutable/shared caches, маршрути й snapshot state — частина MP determinism. Не кожен unsorted `Dictionary` є дефектом: доводь authoritative вплив. Для змін: same-seed replay, state hash, Save/Load, repeated restore, host/peer tests.
- Перевірена v0.36 identity: `v0.36.0`, `PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1`; **завжди звіряй актуальний source**. Не збільшуй без погодження. `SIM_REV` не fingerprint; peers QA мають один точний EXE/DLL комплект із однаковими SHA256.
- MP UI commands → `NetSession` queue, host authorization, schema/wire validation; негативні кейси обов'язкові. Не обіцяй host migration, якщо його не реалізовано.
- Legacy saves мають залишатися читабельними; new→old downgrade не гарантовано. Optional `sys.diplo.land_cooldowns`, `sys.hold.far_fail`: missing→empty. Autosave ізолює encoded graph перед worker; Navy не залежить від unsaved TTL caches. Repeated restore очищає stale state; failed network restore не має false success/turn advance.

## 7. Windows native runtime, SFX та ризики

- **One-file для користувача = SFX**, який містить Godot runtime + PCK та розпаковує DLL до приватного versioned cache. Це не «бездисковий» EXE. Для two-peer діагностики зберігай також portable ZIP з EXE + DLL. Не називай prototype production-ready.
- DLL: `libgodotsteam.windows.template_release.x86_64.dll`, `libwebrtc_native.windows.template_release.x86_64.dll`, `steam_api64.dll`. Зміни — лише з дозволом, provenance/ліцензійною перевіркою. Steam AppID `480` — тестовий, не доказ production Steam.
- Native race, патч MinGW, SFX provenance, CPU benchmark, R02 та межі перевірок веди в [Windows QA](docs/WINDOWS_QA.md). Розрізняй tracked офіційний CI-процес і локальні QA-комплекти.
- Для QA вимикай updater (`DF_NO_UPDATE=1`, `--repo ""`) та ізолюй профілі. CI і headless startup підтверджують лише перевірені сценарії. Ручний Windows GUI, Steam/LAN, non-admin, SmartScreen, DPI й FPS прив’язуй до конкретного EXE.

## 8. Performance + архітектура

- Критична скарга — **2–3 FPS у late-game**. Ранні headless `_sim_step` benchmarks не вимірюють загальний FPS. Windows GUI profiling: однакові build/checkpoint/seed/settings, GPU/CPU frame time, physics, AI/pathfinding, effects, draw calls, nodes, allocations, RAM, p50/p95/p99/max і повтори.
- Spatial hashing, `MultiMeshInstance2D`, pooling, visual-only culling, typed GDScript, data-oriented buffers і GDExtension — **гіпотези** до вимірювань. Spatial hash не робить всю фізику O(1); Godot має batching; pooling потребує reset; **камерний culling не зупиняє simulation**; GDExtension додає native ABI/packaging ризики.
- Для кожного оптимізаційного/архітектурного PR: baseline → доказ вузького місця → малий PoC → determinism/save/network tests → повторний benchmark → review. Не приймай регресію продуктивності заради «чистішого» коду без окремого рішення.

## 9. MCP та інструменти

- Налаштовано **9 MCP**: Serena, Godot MCP, Context7, GitHub, Semgrep, Playwright, Chrome DevTools, draw.io, Figma. Вмикай за потреби; не витрачай токени на формальні виклики всіх. Локальна конфігурація `~/.codex/config.toml` — не комітити, секрети не показувати.
- Serena/GDScript: G07 read-only shadow + Godot LSP; **перевір актуальність shadow**. Returned absolute paths можуть указувати в `tmp`; редагуй тільки правильні production файли.
- Godot MCP: project/dependencies/class API PASS; `script_check` може повертати `ok=false` через missing Linux Steam/WebRTC/Device `.so`, а не синтаксис GDScript. Повний Godot check PASS лише після коректних нативних залежностей. Не встановлюй editor addon у production без дозволу.
- Context7 — version-specific Godot API; Semgrep — лише підтримувані мови, не повний GDScript scan; GitHub/`gh` — PR/CI; Playwright/Chrome — браузер, не Godot GUI. Godot CLI, Python, PowerShell, CDB/WinDbg і профайлер потрібні незалежно від MCP.

## 10. Тести, звіт і завершення

- Release tests: `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_release.py' -v`; повний discovery: `-p 'test_*.py'`. `SKIP` ≠ `PASS`.
- Godot regression: `python3 tools/check_performance.py --godot <editor> --mode regression --out <fresh-output>`; build identity: `python3 tools/build.py --print-version`. Export template має відповідати editor/runtime, build `--version` — source. Godot Editor/import тільки в shadow-копії.
- Відповідні UI/simulation/network/save/native зміни перевіряй відповідними fixtures, Windows native tests і ручним QA. На відсутній platform/engine став `NOT RUN`, не імітуй PASS. Benchmark: однакове навантаження, кількість samples та відмінності toolchain фіксуй.
- До змін визнач scope і критерій перевірки. У звіті вкажи фактичні результати, докази, сумісність і відкриті питання.
- Після суттєвої роботи перевір документацію в остаточному checklist. Онови зачеплені документи про поведінку, API, архітектуру, налаштування, збірку чи тести. У [PROJECT_STATE.md](docs/PROJECT_STATE.md) зафіксуй завершене, перевірене, відкриті проблеми, точний worktree та наступні кроки.
- Зберігай один основний документ на тему. Посилайся на докази замість копіювання логів. Позначай непроведені перевірки як NOT RUN. Зберігай історичні звіти з їхніми датами й межами. Дрібні команди та локальні експерименти без зміни стану документації не потребують.
- Не публікуй tokens, `account.bin`, rejoin seats, Steam secrets, приватні dumps/дані. Авторські права code/art збережені; публічний доступ не дорівнює праву розповсюдження.
