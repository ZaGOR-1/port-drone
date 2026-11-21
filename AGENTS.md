# AGENTS.md — DroneFlames PC port

Працюй як відповідальний співрозробник Godot/GDScript-проєкту. Пояснюй українською; назви й коментарі — за стилем конкретного файла.

## Проєкт і джерело істини

- Власний PC-порт DroneFlames; відповідність сторонній 0.41.x не є метою. Міграція 0.41.x — DEFERRED; не відновлювати пошук без нової прямої задачі та належних матеріалів/прав.
- ZaGOR-1 — власник, координатор і приймає stable release рішення; OKREDU — довірений співавтор. Codex допомагає з аналізом, реалізацією, review і тестами; Gemini — ізольованими задачами. Зберігай людське авторство й обґрунтовані механіки.
- Репозиторій `https://github.com/ZaGOR-1/port-drone` має навмисно створену власником нову Git-історію зі snapshot. Старі PR/SHA/worktrees не є поточними залежностями. Не вимагай старої ancestry й не відновлюй попередні branches або історію.
- Пріоритет: фактичні файли/status/HEAD і тести поточного запуску → актуальні verified docs із зазначеним scope → README → історичні звіти. Назва verified не сертифікує весь продукт.

## Onboarding checklist кожної сесії

1. `pwd`, `git rev-parse --show-toplevel`, `git status --short`, `git branch -vv`, `git remote -v`, `git log -1 --format='%h %s'`, `git worktree list`. Не припускай старий шлях або чисте дерево.
2. Прочитай [NEXT_SESSION](docs/codex/verified/NEXT_SESSION.md), [CURRENT_STATE](docs/codex/verified/CURRENT_STATE.md), README та документи цільової системи.
3. Архітектура: [ARCHITECTURE_AND_FLOWS](docs/codex/verified/ARCHITECTURE_AND_FLOWS.md); факти й прогалини: [REONBOARDING_AUDIT](docs/codex/verified/REONBOARDING_AUDIT.md), [SOURCE_COVERAGE](docs/codex/verified/SOURCE_COVERAGE.md); Windows: [WINDOWS_TWO_PEER_QA_PLAN](docs/codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md).
4. Перевір актуальну beta без переміщення shared refs: `git ls-remote --heads origin main beta`. Нові `feature/*`, `fix/*`, `docs/*` — від перевіреної beta. За dirty checkout не перемикай гілки з ризиком втрати чужих змін.
5. Перед конкретною зміною прочитай повністю змінювані файли, батьківські extends, залежності, тести й serialized contracts. Попередній coverage не замінює цей крок. Не повторюй увесь історичний PR audit; працюй за конкретним scope і відкритими прогалинами.

Старих `docs/codex/01_ARCHITECTURE.md`, `04_BUILD_RELEASE.md`, `05_TESTING.md`, `06_GUARDRAILS.md` і `tools/codex/repository_audit.py` у snapshot немає. Не запускай відсутній auditor і не припускай наявність старих dist/Godot cache.

## Git safety і review

- main — прийнята основна база власника; beta — активна розробка й тестування. Не редагуй main для експериментів; beta→main лише після тестування й окремого дозволу.
- Дозвіл редагувати файли **не дозволяє commit, push, PR, merge, tags, release або workflow dispatch**. Потрібна пряма команда в поточній задачі. Історичний Phase7 дозвіл не діє на нові задачі.
- Не переписуй shared/чужі/OKREDU branches; без force push, автоматичного reset/rebase/clean. Конфлікти — явний review; ownership великих спільних файлів узгоджуй.
- Звичайний PR: base beta, мінімальний diff, поведінка/compatibility/фактичні тести/NOT RUN; людський review. Required checks/protection не обходити. PR template не встановлює default branch.
- У snapshot немає `.github/`, workflow і PR template; CI policy tests падають через відсутній файл. Не вважай історичні release gates чинними. Відновлення CI — окрема задача, policy не послаблювати.

## Технології й структура

- Godot/GDScript; fetch/build tooling вимагає Godot 4.7.2, fetch default `4.7.2-stable`. Editor і Windows release template мають відповідати одне одному; pin не оновлювати мимоволі. Engine перевіряй фактично.
- `game/game/`: simulation/entities/Main/save; `game/world/`: генерація/камера/rendering; `game/ui/`: HUD/Menus/UI24; `game/net/`: session/codec/hash/LAN/backend; `game/pc/`: PC/Steam/updater; `libs/`: три Windows DLL; `tools/`, `tests/`: build/release/regression/QA.
- Конфігурація — binary `game/project.binary` + `game/override.cfg`. Startup: `pc/boot.tscn` → updater → `game/main.tscn.remap` → tracked binary PackedScene → `game/main.gd`.
- Autoload PcPort і SteamNet; RPC Node Main/Net. Не міняй імена/class_name/signals/node paths/res paths/RPC/enum ordinals без перевірки референсів і serialized наслідків.
- Main: main.gd → main/main_input.gd → main_strike.gd → main_core.gd → main_base.gd. GameWorld: game_world.gd → game_world/gw_states.gd → gw_infra.gd → gw_map.gd → gw_base.gd. Перед зміною звір actual extends.

## Simulation, multiplayer і saves

- SP використовує адаптивний frame delta; MP — SIM_DT=1/30, три ticks/turn, canonical host command order. Не прирівнюй режими й не замінюй operation-count scheduling на wall-clock/довільні await/threading.
- Порядок RNG draws, ітерацій, ID, commands і `_sim_step` є частиною determinism. Shared caches/static state теж можуть впливати на світ. Не кожний unsorted Dictionary є bug: простеж authoritative наслідок.
- Поточні PROTO=7, SIM_REV=pr10-phase5b2-1, Save.FORMAT=1 змінюються лише за окремим погодженням. SIM_REV не fingerprint; QA peers мають один точний EXE/DLL комплект з однаковими SHA256.
- UI-команди MP мають проходити NetSession queue/authoritative ownership/schema checks. ALLOWED не доводить повну validation всіх methods. LAN/Steam не отримують автоматично online host migration.
- Не ламай старі saves. Property/class/enum/reference layout — контракт; новий формат потребує migration plan і round-trip tests. Optional `sys.diplo.land_cooldowns` уже є: missing→empty history, new→old downgrade не підтриманий.
- Failed network restore не має false success/turn advance. Partial world завершує local session, повного world rollback немає; перевіряй epoch/await/cleanup/explicit retry.

## Ресурси, native та дані користувачів

- **Не видаляй, не untrack і не ігноруй глобально `game/.godot/`.** Там потрібні textures/audio/fonts і основна сцена. `.import` із кінцевим NUL — текстовий mapping; missing original PNG/OGG не доводить missing runtime resource.
- DLL не змінюй/не оновлюй без окремого погодження та provenance. Три наявні Windows x64 DLL не забезпечують Linux Steam/WebRTC; missing .so не маскуй заради green tests.
- QA: DF_NO_UPDATE=1, build `--repo ""`. Не запускай updater download/EXE/DLL replacement на робочих інсталяціях. Cleanup зберігає .old; integrity/atomicity відкриті.
- Steam AppID480 — тестовий Spacewar. Production backend/accounts/data не використовуй і не змінюй без дозволу. Fixtures — synthetic/copies, ізольовані user paths, не реальні saves.
- Не виводь tokens/rejoin seats/account.bin/Steam config/особисті дані в logs/docs/issues. Права оригінальних авторів code/art зберігаються; відкритий URL не надає права розповсюдження.

## Зміни, перевірки й завершення

- Спочатку контекст, короткий план, ризики та acceptance; мінімальний diff, без великого переписування. Не додавай обов'язкові Python dependencies, якщо вистачає stdlib. Version number без рішення власника не підвищувати.
- Легка перевірка: `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_release.py' -v`; повний discovery — з `-p 'test_*.py'`. Skips не є PASS.
- Із pinned Godot: `python3 tools/check_performance.py --godot <editor> --mode regression --out <fresh-output>` та профільні tests. Build/manual QA — за Windows plan. Без engine — NOT RUN; залежності не встановлюй неконтрольовано.
- Simulation/economy/UI/Steam/updater/save changes потребують відповідних цільових checks і ручних сценаріїв. Benchmarks: один checkpoint/seed/dt/config/build, p50/p99/max/samples; CPU headless не є Windows FPS.
- Serena — символи, якщо GDScript LSP працює; інакше Git/rg/Python. Context7 — version-specific API. Playwright/Chrome не замінюють Godot Windows GUI. MCP використовуй за доречністю, звітуй про реально використані інструменти.
- Після імплементації: що/чому/шляхи; PASS/FAIL/SKIP/NOT RUN і причини; compatibility/save/MP ризики; залишок. Оновлюй verified docs, DECISIONS/BACKLOG за зміною поведінки/policy. Історичні звіти зберігай з датою/scope; старі PASS не стають поточними.
