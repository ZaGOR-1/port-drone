# INT-01 · Кандидат DroneFlames 0.36.1

Worktree `/home/zagor/projects/port-drone-integration-qa`, гілка `integration/qa-v0.36.1`. Base `c91e0e6a7eef831687e6e63550560bba739a6b87`.

| Draft PR | Перевірений head | Merge у QA |
| --- | --- | --- |
| [#7 · L10N і стандарти](https://github.com/ZaGOR-1/port-drone/pull/7) | `0bf7d5a2fb1be152d038a9b9dceedb2109d4d891` | `373543e` |
| [#8 · HUD і миша](https://github.com/ZaGOR-1/port-drone/pull/8) | `56b0d205060fc6902a52866e3e237aef1b3886df` | `300505c` |
| [#9 · ОТРК і PATCH](https://github.com/ZaGOR-1/port-drone/pull/9) | `c2cbb9086cad700a34ab03f978267633d2427602` | `5df1503` |

Git автоматично об’єднав усі три PR. У `main.gd` залишилися локалізація мережевого повідомлення та routing жестів. У `menus.gd` збережені локалізовані підписи, ізоляція scroll і `v0.36.1`. `main_input.gd` та армійські панелі відповідають PR #8. RouteOverlay, планування й застосування залпу відповідають PR #9. Каталоги, `Loc`, updater і Git Workflow v2 походять із PR #7. `bc78ed6` додає інтеграційні assertions для вводу з активною чернеткою ОТРК.

Контракти кандидата `v0.36.1`, `PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1`, `SIM_DT=1/30`. Точний Git HEAD, tree ID і SHA256 Windows пакета наведені в handoff. [Windows checklist](INT01_WINDOWS_QA.md)

## Перевірки кандидата

- Python discovery 47/47, включно з CI/release policy, build identity, admission і Save/Load. Godot simulation 2476/2476, L10N 125/125, HUD/миша 36/36, keyboard 130/130, UI scale 26/26, Windows UI fixture 20/20. Каталоги дали 0 помилок. Save/Load edge cases 11/11, локальний mock updater 42/42. ENet loopback пройшов lobby, reconnect і resync.
- FIX06 з одним snapshot у ru/uk/en збігся покроково протягом 30 ticks. Final NetHash `787a72dc394849ab`, RNG `3605423648`. MP ОТРК на 500 цілях дав `e1ac3fe366391da7` у всіх трьох локалях, з однаковим wire payload, чергами та RNG. Наказ застосовано у turn 0 до першого кроку, перший пуск на кроці 92.
- Цільовий PERF smoke зроблено на 200, 300 і 500 цілях, з однаковим інструментованим Linux runtime та fixture PR #9. На 500 цілях підтвердження 14,64–16,32 мс, fixed preview CPU 2,38–2,39 мс/кадр. Зафіксовано одне планування на підтвердження. У контрольованому сценарії дефіциту 420 із 500 цілей отримали ракети, окремий прогін підтвердження 83,82 мс. Windows FPS і DPI потребують фізичного QA.
- Wine official пройшов headless startup і показав головне меню. Patched перевірено через `df` та Wine headless з наявним runtime. Linux GUI з PCK official пакета відкрив Settings, створив партію, показав HUD, зберіг і відновив її через Continue. У Linux OpenGL зафіксовано діагностику null mesh. У headless-журналах є завершальні повідомлення про ресурси. Нативні Windows, фізичний LAN і Steam мають статус NOT RUN.

## Порядок майбутньої інтеграції

1. Дочекатися приймання Windows за чеклістом і рішення власника. Злити #7 → #8 → #9. Перед кожним merge звірити поточну `origin/beta` і точний head PR. Гілки зберігають оригінальне авторство. Поточний порядок пройшов без конфліктів.
2. Після #7 перевірити каталоги, L10N runtime, replay ru/uk/en, Save/Load, нативні UI та updater, CI й Windows package identity. Після #8 додати HUD/layout, DPI, mouse routing, keyboard і scale. Повторно звірити `main.gd`, `menus.gd` та `PROJECT_STATE.md`.
3. Після #9 перевірити один PATCH `0.36.1` у `game/pc/version.cfg`, `Menus.VERSION` і build fixture. Повторити discovery, simulation, Save/Load, масовий залп SP/MP, NetHash, UI routing і короткий performance smoke. Повторити фізичний Windows/LAN/Steam QA, якщо змінився EXE або DLL.
4. Якщо з’явиться потрібна правка, перенести тільки її коміт у PR, який володіє відповідною поведінкою. Для assertions спільної роботи HUD і ОТРК використати `bc78ed6` після #8 або додати його до #9 як QA-коміт після оновлення бази. Для конфлікту поєднати окремі поведінкові зміни, зберегти наявні assertions і записати рішення в PR. Залишити bump у #9.
5. Після #9 порівняти `git rev-parse origin/beta:game <QA_SHA>:game` та `git diff <QA_SHA> origin/beta -- game libs tools tests .github`. Якщо runtime tree або DLL різняться, перевірити diff, зібрати від фінальної beta та повторити зачеплені QA. Документаційні й тестові відмінності перевірити окремо. Збіжне дерево може мати інший commit і SHA EXE через provenance.
6. Зберегти SHA кожної прийнятої сходинки. Якщо виявлено регресію, ізолювати PR, підготувати reviewable revert від актуальної beta в окремій гілці. Для merge commit використати `git revert -m 1 <merge-sha>` після перевірки батьків. Для кількох залежних проблем відкочувати в зворотному порядку. Перевірити version, exports, Save/Load та MP перед повторним прийманням.
