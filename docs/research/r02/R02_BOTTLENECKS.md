# R02 · Підтверджені витрати

> Історичний матеріал з `toolchain/performance/R02_BOTTLENECKS.md`. [Реєстр досліджень](../INDEX.md)

Рейтинг D2100 за середнім **wall time на кадр**. Тут один tick на sampled frame. Вкладені scopes наведені як пояснення витрат батьківського scope.

| № | Джерело | Середнє, мс | Спостереження |
| ---: | --- | ---: | --- |
| 1 | `game/game/army.gd:458` `Army.update` | 16,43 | max 162,95 мс. Вкладено рух 4,35 мс/кадр, impacts артилерії 2,25, acquisition 1,49, artillery spotting 1,04. |
| 2 | `game/world/units_layer.gd:202` `UnitsLayer._draw` | 5,26 | max 16,67 мс. У це входить `_ground_units`; витрати окремого atlas batching не ізольовано. |
| 3 | `game/game/operations.gd:1687` `Operations.update` | 4,18 | max 94,28 мс у D2100 і 249,72 мс у E. У E черги й вартість помітно зростали. |
| 4 | `game/net/net_session.gd:2301` `NetSession._run` поза `net_step` | 1,20 | Різниця таймерів, включає виконання turn commands і службову роботу. На D2100 tick 1813 із пачкою команд ця різниця становила 230,30 мс. |
| 5 | `game/world/units_layer.gd:94` `UnitsLayer._process` | 1,00 | max 5,52 мс за кадр. Military.update наступний — 0,96 мс, max 34,17 мс. |

`game/game/army_fire.gd:123` `ArmyFire._spot` — конкретне джерело CPU tail у щільному бою. У D2100 max 125,32 мс. Із 371,89 мс кадру ramp-1800 на tick 187 виміряно 106,85 мс у turn executor, з них 104,01 мс в Army і 92,92 мс у spotting. Малювання юнітів додало 12,13 мс виміряного wall time. Більша частина цього кадру не атрибутована. `ArmyFire._impact` досяг 57,53 мс сумарно за один кадр D2100. `nav_path` викликано 3 829 разів, середня сума 1,84 мс за кадр, максимальна 24,32 мс; це вкладені витрати різних систем. Цей scope не покриває всю пачку `Army.order_attack` або fallback.

На D2100 root viewport CPU render p95 2,45 мс і GPU p95 2,37 мс. Це GPU timestamps одного viewport, з можливою затримкою, без full present і worker/scheduler атрибуції. CPU симуляція перетинала 33,33 мс і темп тиків реально відставав. Насичення GPU не доведено, затримки queue/driver/compositor лишаються відкритими. `job_ready` instrumented wait у підсумку D2100 не був зареєстрований; конкуренція CPU worker, інші шляхи очікування та native stalls лишаються можливими. Алокації і lifetime поза RSS/extent counters — NOT RUN.

В E кадр 286,73 мс на tick 4336 мав 271,57 мс `net_step`, з яких 249,72 мс у `Operations.update`. Внутрішній підетап Ops ще потребує атрибуції. У D2100 кадр 271,95 мс на tick 1813 мав 248,53 мс `_run`, з них лише 18,23 мс `net_step`. Це різні механізми довгих кадрів.
