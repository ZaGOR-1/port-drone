# Наступна сесія Codex

2026-11-21. Нова Git-історія `ZaGOR-1/port-drone`, checkout `/home/zagor/projects/port-drone`. На початку re-onboarding локальні й remote main/beta = `172df65e3bd004efed9a5444e90a284d9d69db10`. Це baseline аналізу, не постійний HEAD: поточні refs і PR перевір через Git/GitHub. Гілка документації `docs/codex-reonboarding` створена від origin/beta.

Окрема команда власника дозволила завершити документаційний етап: commit, push цієї гілки, один PR у beta та merge лише за успішних checks/review без обходу protection. Перевірка GitHub перед публікацією: workflows=0, beta protected=false, active branch rules порожні. Через відсутній CI й відомий FAIL policy tests PR слід залишити відкритим. Результат публікації й точний SHA брати з `gh pr list --state all --head docs/codex-reonboarding --base beta` та Git; не приписувати merge за самим існуванням PR. Цей дозвіл не поширюється на наступні fixes/main/releases.

Спочатку прочитай [AGENTS](../../../AGENTS.md), [CURRENT_STATE](CURRENT_STATE.md), [REONBOARDING_AUDIT](REONBOARDING_AUDIT.md). Далі за задачею: [архітектура та flows](ARCHITECTURE_AND_FLOWS.md), [coverage з реальними діапазонами](SOURCE_COVERAGE.md), [Windows/two-peer plan](WINDOWS_TWO_PEER_QA_PLAN.md). Історичні Phase5–7/PR звіти описують попередній репозиторій; їхні SHA, worktrees, дозволи й PASS не поточні.

Найближче окреме завдання — відновлення CI та підготовка Godot Windows x64 build: гілка fix/* від actual beta, повернути tests/build workflow без автоматичної публікації й без послаблення policy tests; підготувати Godot4.7.2 editor/template з перевіркою SHA256; після regression отримати один тестовий EXE/PCK + три наявні DLL, manifest, launchers і logs із конкретного commit, updater off. Критерій: CI policy tests більше не падають через missing workflow, реальні checks мають явні PASS/FAIL/SKIP, артефакти мають source/engine/DLL hashes. Це лише опис наступної задачі — CI/build зараз не реалізуються. Далі 18 GUI-сценаріїв і два незалежні Windows peers. Нові features — feature/*, документація — docs/* від actual beta; main/stable publication вирішує власник окремо.

Відкриті питання:

- У snapshot немає `.github/workflows/build.yml` і PR template. Загальний Python discovery реально FAIL: 26 tests, 10 errors (4 CI methods/subtests), 7 Godot skips; release-only 15 PASS. Не виправляти це вимкненням тестів. Відновлення CI — окрема code/tooling задача.
- Немає `godot_dl/godot` і Windows export template у цьому checkout; Godot у PATH також відсутній. Потрібні перевірені editor/template **4.7.2**; автоматично не завантажувалися.
- Native PowerShell та draw.io Desktop знайдені поза PATH у Windows; PowerShell AST двох launchers PASS. Це не Windows runtime/GUI QA.
- Updater: optional EXE digest, DLL ZIP без digest, неповні activation/rollback; **updater off**, repo empty для QA.
- Save durability/deep malformed data та general network schemas відкриті; clean shutdown і p99 — історичні findings, поточний runtime не відтворений.
- `PROTO=7`, `SIM_REV=pr10-phase5b2-1`, `FORMAT=1`; optional cooldown збережений. Не змінюй identifiers; нові saves не віддавати старому reader. Однаковий SIM_REV не доводить однаковий код.
- Повний семантичний аудит усіх 182509 рядків GDScript не завершений. Coverage розрізняє FULL/PARTIAL/INDEXED; не називай цю сесію 100% аудитом. Один великий історичний Markdown FILE_COVERAGE має часткове ручне читання таблиці, повний автоматичний облік; решта47 прочитані повністю.

Доступні перевірки:

```bash
git status --short
git ls-remote --heads origin main beta
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_release.py' -v
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tools/build.py --help
python3 tools/check_performance.py --help
```

Після підготовки engine, в окремо дозволеному test/build scope: `DF_GODOT=<pinned-editor>` для unittest wrappers; `check_performance.py --godot <editor> --mode regression --out <fresh-output>`. Точний build та manual QA — у Windows plan. Performance CLI дозволяє bots1..7; UI має окремий custom-bots контракт, не передавай `--bots 11` цьому runner.

Локальні докази: `dist/codex_audit/reonboarding-172df65/` (ignored): `static.json`, `source-index.json`, `python-discovery.log`, `tests.json`, порівняння старого coverage. Вони можуть не перейти в наступний checkout; основні висновки збережені в Markdown.

Без нового дозволу: жодних commit/push/PR/merge/tags/releases/dispatch, production GDScript/DLL/protocol/save-format edits, реальних updater/accounts/saves. Не відновлюй старі PR/branches, не чіпай старий репозиторій, не починай 0.41.x migration. Для малого fix читай повні його залежності й продовжуй за конкретним scope.
