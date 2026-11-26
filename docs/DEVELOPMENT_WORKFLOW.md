# Development Workflow

[AGENTS.md](../AGENTS.md) визначає повноваження, обов’язкові перевірки перед комітом і джерело бази. Для нового worktree обери тематичну гілку `feature/*`, `fix/*`, `perf/*`, `research/*`, `build/*` або `docs/*`. Пов’язані етапи можуть мати кілька комітів у тій самій гілці.

1. Для погодженого push звір fetch і push URL `origin`, гілку, worktree, commit history, відсутність секретів і випадкових бінарних артефактів. Якщо remote ref уже існує, перевір fast-forward.
2. Перед створенням або review PR звір точні head/base і повний diff. Звичайний target — `beta`. Draft потрібен, поки відкритий критичний QA. В описі вкажи мету, зміни, коміти, фактичні перевірки, невиконаний ручний QA й ризики.
3. Після дозволеної публікації звір локальний і віддалений HEAD, base та стан PR. Результати CI бери для того самого source SHA. Дотримуйся review, CI й branch protection. Для review чужого PR оцінюй зміни за їхнім scope та фіксуй висновки локально до дозволеного зовнішнього запису.

## Завершення тимчасового завдання

1. Зафіксуй head, відповідні refs і стан checkout. Заверши [постійне збереження доказів](#постійне-збереження-доказів) перед очищенням.
2. Після merge звір ancestry та фактичний вміст, зокрема для squash/rebase. Перевір, що worktree чистий і його шляхи вільні від активних залежностей. Після дозволу власника виконай `git worktree remove <path>`, потім `git branch -d <branch>` для гілки, чия вершина інтегрована. Розбіжну історію, dirty worktree чи remote ref розглядай окремо.

## Постійне збереження доказів

Політика обов’язкова для кожного дослідження, виправлення, оптимізації та суттєвого рефакторингу, включно з GO, NO-GO, INCONCLUSIVE і перерваними спробами. Для вузького виправлення може вистачити запису в чинному довіднику з посиланням на regression test і результат.

1. Зафіксуй питання, baseline і кандидат, рішення, фактичні PASS/FAIL/SKIP/NOT RUN, обмеження та відкриті питання. Збережи команди, налаштування, версії build і toolchain, seed/checkpoint та умови запуску, потрібні для відтворення.
2. Збережи сирі результати, конфігурації, критерії приймання, тестові скрипти й fixtures. Для benchmark збережи всі плечі, телеметрію, перервані спроби й скрипт аналізу. Для дефекту збережи виконуваний контрприклад, очікування й фактичний результат. Збережи важливі PoC patches, унікальні коміти та staged, unstaged, untracked і ignored дельти, потрібні для відновлення. Для відсутніх матеріалів вкажи причину й межу висновку.
3. Веди один канонічний handoff. Усю доступну унікальну Markdown-документацію про дослідження, виправлення, оптимізації, тестування й технічні рішення зберігай у `docs/` на `beta` через погоджений PR. Це охоплює історичні звіти, негативні результати, інструкції відтворення й рішення, які існують лише в локальних архівах. Зберігай походження матеріалу та посилайся на наявний текст, коли він уже в Git. Перед очищенням звір, що незалежний клон `beta` містить документацію і маршрут до доказів у [реєстрі](research/INDEX.md). Великі докази зберігай у постійному сховищі поза тимчасовими worktrees. В індексі `~/projects/droneflames-archive/INDEX.md` зафіксуй канонічний шлях, маніфест із SHA256, джерело й команди відновлення. Якщо потрібні точні бінарні збірки або fixtures, збережи їх чи вкажи перевірений шлях і SHA256. Бережи приватність артефактів. Для додавання великого файлу до Git документуй потребу та права.
4. Перед видаленням перевір контрольні суми й віднови унікальні матеріали в незалежній копії. Переконайся, що після видалення refs і worktrees доступні код, контрприклад і результати. Прийнятні Git-об’єкти з постійно доступним ref, перевірений Git bundle або патч з доступною базою. Reflog, недосяжний SHA і тимчасові CI artifacts не є постійним сховищем. Перед масовим очищенням перевір окрему резервну копію на іншому носії. Якщо артефакт, гілка або worktree містить єдину доступну копію унікального доказу, тесту чи результату, видалення заборонено.
5. Додай маршрут до доказів у `INDEX.md` або чинному тематичному звіті. У `PROJECT_STATE.md` залиш короткий актуальний стан і посилання. Якщо контрприклад має стати підтримуваним regression test, зафіксуй scope і додай тест окремою зміною від docs-only PR.

[Постійні правила](../AGENTS.md) · [Версіонування](VERSIONING_POLICY.md)

## Перевірки за scope

- Для документації перевір повний diff, Markdown-посилання з anchors та case-sensitive шляхами, команди й межі тверджень. Відокремлюй успадковані проблеми історичних посилань від нових.
- Build identity — `python3 tools/build.py --print-version`. Release tooling — `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_release.py' -v`. Для Python discovery використовуй `-p 'test_*.py'`. SKIP є окремим результатом. `DF_GODOT` дає доступ до engine fixtures, якщо наявний точний editor.
- Godot regression — `python3 tools/check_performance.py --godot <editor> --mode regression --out <fresh-output>`. Runner працює з тимчасовим PCK. Перед UI/network/save/native змінами вибери відповідні fixtures і фізичні сценарії. Старі результати зберігає [історична матриця](codex/verified/TEST_MATRIX.md). [Windows QA](WINDOWS_QA.md) фіксує артефакти й межі ручного приймання.
- Для продуктивності фіксуй build, seed/checkpoint, settings і кількість samples. Вимірюй CPU/GPU frame time, simulation/physics, AI/pathfinding, render/effects, draw calls, nodes, allocations, RAM і p50/p95/p99/max за [Profile B](performance.md). Порівняй однакові сценарії та зафіксуй різницю toolchain.

Чинні точки входу для цільових перевірок. Перед запуском звір wrapper, вимоги `DF_GODOT` та потрібний build. Для standalone GDScript переглянь аргументи самого fixture і виконуй через тимчасовий PCK та ізольований профіль.

| Scope | Fixtures і приймання |
| --- | --- |
| HUD, camera, hotkeys та масштаб | [test_v036_regressions.py](../tests/test_v036_regressions.py) запускає HUD/camera fixture. Для відповідних змін перевір [keyboard](../tests/test_keyboard_controls.gd) і [UI scale](../tests/test_ui_scale.gd). Ручні Windows focus, діалоги, tooltips і DPI за [Windows QA](WINDOWS_QA.md). |
| Loc, каталоги та UI-текст | `python3 tools/check_l10n.py`, [test_l10n.py](../tests/test_l10n.py) і [ручний checklist](LOCALIZATION_TESTS.md). |
| MP identity, wire, hash та restore | [test_network_identity.py](../tests/test_network_identity.py) перевіряє ENet admission loopback. [test_sim_revision.py](../tests/test_sim_revision.py) перевіряє saved-match gate. [test_mp_checkpoint.py](../tests/test_mp_checkpoint.py) перевіряє дискову публікацію MP checkpoint і retry. [test_snapshot_restore.py](../tests/test_snapshot_restore.py), [test_v036_regressions.py](../tests/test_v036_regressions.py), негативні сценарії змінених schemas, replay і [Windows two-peer QA](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md). |
| Save/Load та autosave | [test_snapshot_restore.py](../tests/test_snapshot_restore.py) для failure matrix, [test_v036_regressions.py](../tests/test_v036_regressions.py) для autosave, Navy та hold. Для зміни формату або lifecycle перевір legacy disk Save/Continue, repeated restore й уражені failure paths. |
| Army та gameplay | [test_r19_acquisition.gd](../tests/test_r19_acquisition.gd) для target acquisition, [test_v036_regressions.py](../tests/test_v036_regressions.py) для impact/spot, [test_phase5b2.py](../tests/test_phase5b2.py) і [test_pr10_critical.py](../tests/test_pr10_critical.py) для відповідних gameplay transitions. Симуляційні зміни потребують детермінованого replay і релевантної регресії. |
| Build, packaging, updater | [Build and Release](codex/verified/BUILD_RELEASE.md), [build identity](../tests/test_build_identity.py), [CI policy](../tests/test_ci_policy.py), [CI artifacts](../tests/test_ci_artifacts.py) і release tooling. Для updater cleanup є [test_updater_cleanup.py](../tests/test_updater_cleanup.py). Артефакт і фізичний Windows smoke мають окремий scope. |

## Вибір MCP

Викликай інструмент, якщо він поліпшує перевірку. Почни з `codex mcp list` для локальної конфігурації або з каталогу інструментів цієї сесії. Список конфігурації та фактично доступні сервери можуть різнитися. Результати smoke мають дату й scope. [Діагностика DOCS-02B](DOCUMENTATION_AUDIT.md#діагностика-mcp)

| Задача | MCP | Резерв і межі |
| --- | --- | --- |
| GDScript symbols, залежності | Serena | `git`, `rg`. Перед навігацією перевір активний проєкт, Godot LSP і свіжість shadow. Редагуй у worktree задачі. |
| Godot API та ресурси | Context7, Godot MCP | Пінована версія документації, CLI та код. `project_info` визначає project path і editor bridge. `script_check` розрізняй missing native extensions і parse errors. Генерацію UID/cache запускай у фізичній копії. |
| Git refs, PR, CI | GitHub MCP | `git ls-remote`, `gh pr view`, `gh run view`. Звір SHA й номер в актуальній історії. Зовнішні записи лише з окремим погодженням. |
| Python, YAML, інші підтримувані мови | Semgrep | Локальний `semgrep`, unittest, `rg`. Перевір список підтримки. GDScript поза семантичним покриттям. |
| Браузерний QA | Playwright або Chrome DevTools | Один браузерний інструмент за потреби. Для фізичної гри використовуй Godot/Windows fixtures і GUI QA. |
| Схеми та UI/UX | draw.io або Figma | Локальна схема або Markdown. Файли Figma потребують доступу й авторизації. Приватні код і ресурси передавай тільки з дозволом. |
| Godot runtime та performance | За потреби Godot MCP для діагностики | Godot CLI, Python/PowerShell fixtures, CDB/WinDbg і профайлери. Міряй на потрібній платформі. |

Для Serena, Godot, Context7, Semgrep, Playwright, Chrome DevTools і draw.io у звіреній локальній конфігурації застосовано stdio. GitHub налаштовано через bearer env, Figma через OAuth. Стан авторизації перевіряй у поточному середовищі, без виведення конфігурації з credentials і без інсталяції нових компонентів без дозволу.

## Підтримання документації

1. Після суттєвої роботи онови лише зачеплений канонічний документ і короткий стан проєкту. Чинний стан замінюй новим із перевіреним SHA, handoff і відкритим QA.
2. Деталі, вимірювання, неуспішні експерименти й винятки власника лишай у датованому джерелі. Для заміненого тексту вкажи незмінний Git commit і шлях або перевірений локальний handoff.
3. Додай маршрут до INDEX, якщо змінилася відповідальність документа. Збережи language navigation README і сумісні шляхи старих посилань. Повний Markdown-аудит залишай окремою задачею.
