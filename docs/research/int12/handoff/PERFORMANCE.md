# INT-12 · Умовний gate R21

> Історичний матеріал з `toolchain/int12.7iX78x0s/handoff/PERFORMANCE.md`. [Реєстр досліджень](../../INDEX.md)

**GO** для інтеграції PR #20. Додаткові D2100 restore Profile B A/B та B/A, по 120 тіків, на тих самих PCK, snapshot та runtime. В обох парах кінцевий NetHash `8d54b0405897a70a`, ідентичні RNG, wire-команди та впорядковані виклики wd_exit. Перевірені production diff і SHA256 R21 handoff.

Поза watchdog виміряний CPU змінюється в обох напрямках, зокрема до першого виклику зміненої функції. У додаткових парах CPU поза Operations змінився на −113,46 і +183,63 мс на вікно. У всіх п'яти парах однакові 38 wd_exit, 422 army_path, 340 nav_path, 1361 _army і 4 lockstep-команди. CPU двох watchdog-тіків разом зменшився на 3,46–80,66 мс у всіх парах. Зміна production обмежує нові читання та відсікання межами wd_exit. Дані не підтвердили перенесення роботи. Причина CPU поза watchdog відкрита.

У нових парах FPS +8,27%/−7,18%, 1% low +20,18%/+1,18%, watchdog CPU −44,06%/−37,93%. У п’яти парах FPS нижче порога −5% у двох, 1% low у жодній. Медіанні зміни FPS −4,86%, 1% low +3,12%, simulation CPU +4,48%, tick p99 −16,40%. Погіршення p95 у частині вікон, командний batch, D5000 siege і фізичний Windows лишаються відкритими. Джерело варіації FPS не встановлено.

Сирі заміри, точні вікна й аналіз фаз — `../performance/`. Відтворення JSON: запустити `python3 report.py`, `python3 review.py` і `python3 phases.py` у `performance/` зі збереженим сусіднім R21 handoff. Хеші вхідних файлів — `../evidence/profile-inputs.sha256`.
