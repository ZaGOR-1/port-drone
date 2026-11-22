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
- **Контекст на 2026-11-22, не незмінний pin:** `beta` `e1e435511e715b3c1216c7f5128090af69818217`, v0.36.0, CI PASS, PR #1/#4 merged, remote `main`/`beta`. Перед дією перевір актуальний стан; локальні SFX/native experiments не обов'язково інтегровані.

## 3. Початок сесії

1. Перевір `pwd`, `git rev-parse --show-toplevel`, `git status --short`, `git branch -vv`, `git worktree list`, `git log -1 --format='%h %s'`, `git remote -v`. Не припускай чисте дерево або постійний шлях.
2. Прочитай [NEXT_SESSION](docs/codex/verified/NEXT_SESSION.md), [CURRENT_STATE](docs/codex/verified/CURRENT_STATE.md), релевантний README і docs цільової системи. Для v0.36: [V036_FIX_RESULTS](docs/codex/verified/V036_FIX_RESULTS.md); архітектура: [ARCHITECTURE_AND_FLOWS](docs/codex/verified/ARCHITECTURE_AND_FLOWS.md); coverage: [SOURCE_COVERAGE](docs/codex/verified/SOURCE_COVERAGE.md), [REONBOARDING_AUDIT](docs/codex/verified/REONBOARDING_AUDIT.md); Windows: [WINDOWS_TWO_PEER_QA_PLAN](docs/codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md).
3. За потреби `git ls-remote --heads origin main beta` (без переміщення refs). Нові `feature/*`, `fix/*`, `docs/*` — від **актуальної** `beta`, не від історичного SHA. За dirty checkout користуйся окремим worktree, не чіпай чужі зміни.
4. Перед редагуванням прочитай повністю змінювані файли, їх `extends`, прямі залежності, тести та serialization contracts. Попередній частковий source coverage не замінює перевірку.
5. Старих `docs/codex/01_ARCHITECTURE.md`, `04_BUILD_RELEASE.md`, `05_TESTING.md`, `06_GUARDRAILS.md` і `tools/codex/repository_audit.py` у snapshot немає: не запускай відсутні інструменти.

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
- У Godot 4.7.2 виявлено **GDScript operator-cache race** (upstream Issue #124010, native `0xC0000005`). Локальний C++17 patch `df-godot472-operator-side-cache-v1` (aligned side-cache, acquire/release, writer-only mutex) пройшов concurrent reproducer і Windows startup matrix. Але **custom runtime ще не прийнято**.
- MSVC patched vs офіційний Windows runtime: близько **+21,5% mean/+26,4% p99** CPU у контрольному сценарії, тоді як patch overhead проти того самого MSVC toolchain близько **+0,02% mean**. Наступна перевірка — optimized **MinGW Windows template** з патчем, same-toolchain controls, runtime regressions і performance parity. Не припускай, що патч сам спричинив регресію; не приймай повільний runtime без обґрунтування.
- Окремий **restore failure (4 assertions)** є також у original runtime; потрібен triage. Успадковані shutdown leaks не закрито. Native dumps/символи приватні; не приховуй crash чи exit code.
- SFX tooling і діагностичні EXE могли залишитися локальними у `feature/windows-portable-sfx`/scratch. Не припускай, що вони в `beta`. Updater для QA вимкнений (`DF_NO_UPDATE=1`, build `--repo ""`); перевір фактичну поведінку. Профілі/сейви ізолюй, чужі дані не видаляй.
- **NOT RUN, доки не протестовано:** Windows GUI/audio/input, звичайний non-admin account, фізичні LAN/Steam peers, WebRTC, Defender/SmartScreen GUI, signing. Headless startup і тестовий Steam init їх не замінюють.

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
- До змін: scope, короткий план, ризики, acceptance. Після: що/чому/змінені шляхи; PASS/FAIL/SKIP/NOT RUN із доказами; FPS/CPU до/після; save/MP/compatibility наслідки; залишкові ризики. Актуалізуй verified docs і DECISIONS/BACKLOG за зміною поведінки; історичні звіти не переписуй як поточні.
- Не публікуй tokens, `account.bin`, rejoin seats, Steam secrets, приватні dumps/дані. Авторські права code/art збережені; публічний доступ не дорівнює праву розповсюдження.
