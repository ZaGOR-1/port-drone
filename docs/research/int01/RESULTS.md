# INT-01 · Результати перевірки

> Історичний матеріал з `toolchain/integration-qa-v0.36.1/RESULTS.md`. [Реєстр досліджень](../INDEX.md)

**PARTIAL**. Windows QA ZIP зібрано, архів і SHA256 перевірено, автоматичні та доступні runtime-перевірки пройшли. Native Windows QA, DPI, фізичний LAN і Steam мають статус NOT RUN. [Windows checklist](../../INT01_WINDOWS_QA.md)

- Інтеграційний SHA `f3db608d77a8d7f78af22c6122108962e5f3c75f`, дерево `game/` `26dd6975cf20e987d4db703f1cabde4e85483cb0`. Усі три вихідні SHA залишаються предками.
- Git об’єднав #7, #8 і #9 без ручних конфліктів. Спільні зміни `game/game/main.gd` та `game/ui/menus.gd` переглянуто. Кожен інший змінений ігровий файл збігається з відповідним PR. Додаткові коміти після merge змінюють документацію та QA fixture.
- Локаль, HUD, Settings, миша, OTRK preview й підтвердження перевірені в інтеграції. Додатковий fixture подав scroll на кнопку підтвердження та клік над картою під відкритими Settings з активним чернетковим залпом на 200 цілей. Камера, цілі й кнопка підтвердження зберегли стан. Після закриття Settings zoom знову працював.
- `beta` `c91e0e6a7eef831687e6e63550560bba739a6b87`, `main` `172df65e3bd004efed9a5444e90a284d9d69db10`. GitHub підтвердив ті самі refs після публікації, PR #7–#9 лишаються Draft. [Гілка QA](https://github.com/ZaGOR-1/port-drone/tree/integration/qa-v0.36.1)

| Перевірка | Результат |
| --- | --- |
| Python discovery та CI/release policy | 47/47, без SKIP. Публікацію release перевірено через mocks. |
| Godot | L10N 125/125, HUD/миша 36/36, keyboard 130/130, scale 26/26, Windows UI 20/20, simulation 2476/2476. Контроль активних ключів і структури каталогів — 0 помилок. |
| Save/Load, updater, multiplayer UI | Save/Load edge cases 11/11, mock updater 42/42. ENet host uk і guest en пройшли localhost lobby, reconnect і snapshot/resync у мережевому namespace. |
| Build identity | `v0.36.1`, `PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1`, `SIM_DT=1/30`. Official та patched пройшли `df run --check`. |
| Wine 10.0 | Official headless exit 0 після worldgen. Official GUI показав українське головне меню `v0.36.1`. Patched headless exit 0. EXE і DLL побайтово збігаються з перевіреними комплектами відповідних профілів. |
| Linux | Скопійований runtime L01 та PCK, витягнутий з official EXE. Українське меню → Settings → New Game → HUD → Save → головне меню → Continue відновив країну. У OpenGL зареєстровано `mesh is null`. Після запиту закриття X11 у відновленій партії процес лишився активним, QA завершено через SIGTERM. Причину не встановлено. В інших runtime-прогонах є попередження про ресурси при завершенні. |

## Детермінізм

- FIX06 replay збігся у ru, uk, en на кожному з 30 fixed ticks. Final NetHash `787a72dc394849ab`, RNG `3605423648`. Порівняно також усі `NetHash.parts`.
- SP ОТРК на 200, 300 і 500 цілях збігся з PR #9 за чергами, порядком цілей, розподілом установок, першою хвилею, RNG і NetHash після 105 кроків. Хеші `cb4a6a9d6e2218c1`, `a72f51f055913276`, `a72f51f055913276`.
- MP ОТРК на 500 цілях збігся з PR #9 і між усіма трьома локалями. NetHash `e1ac3fe366391da7`, RNG `2404697176`, wire SHA256 `9e39e45eea953642101cb47dd864b3bb0c93e74d8450d6823e0c6c7e6a04dd2f`. Наказ застосовано перед першим кроком turn 0, перший пуск на кроці 92. Повторний клік і неавторизована команда перевірені fixture.

## Performance smoke

Пари baseline PR #9 → INT-01, один Linux runtime, seed, instrumented fixture і профілі. Headless додає відтворюваний CPU preview за 48 кадрів. GUI p95 з 26 hover-кадрів виміряно на Xvfb і llvmpipe. Одиниці в таблиці — мілісекунди.

| Цілі | Додавання, медіана останніх 20 | Підтвердження | Fixed preview CPU на кадр | GUI p95 |
| ---: | ---: | ---: | ---: | ---: |
| 200 | 0,298 → 0,301 | 10,37 → 17,38 | 0,99 → 1,02 | 87,26 → 83,91 |
| 300 | 0,320 → 0,338 | 14,67 → 12,67 | 1,36 → 1,69 | 235,27 → 128,15 |
| 500 | 0,370 → 0,438 | 14,74 → 16,32 | 1,93 → 2,39 | 329,27 → 159,92 |

Зворотна пара підтвердження на 200 цілях дала 7,97 → 8,34 мс, на 500 — 21,02 → 14,64 мс. Fixed preview у повторі на 500 цілях 2,69 → 2,38 мс/кадр. Очевидної втрати прискорення за цими короткими парами не виявлено. На всіх трьох розмірах підтвердження викликало планування один раз. Для фізичного Windows A/B використати official ZIP PR #9 і ті самі налаштування. 83,82 мс при дефіциті боєзапасу й 420 ракетах із 500 цілей зафіксовано як залишкову затримку. Важкі R01–R06 — NOT RUN.

Докази у `evidence/`. Порівняння й хеші зведено у `evidence/perf-summary.json`, перевірку ZIP — у `evidence/zip-verification.json`. Локальні logs і синтетичні профілі збережено у каталозі QA. Windows ZIP містить лише portable EXE, три DLL, SHA256, provenance та інструкцію.
