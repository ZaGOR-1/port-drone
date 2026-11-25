# R21 · Watchdog exit search

База `3298af5878501d458920b41dc5738f60571ac551`, версія 0.36.10. Worktree `/home/zagor/projects/port-drone-r21`, гілка `perf/watchdog-lockstep-latency`. Результат Profile B — **GO**.

## Джерела затримок

D2100 restore з R17 відтворив `Operations.wd_exit` на тіках 4816 і 4864. У першому A це 60,78 і 70,85 мс exclusive CPU. `Operations._army` на 4816 мав 916 викликів і близько 13 мс exclusive після R17. `_wd_orders`, `_wd_tick` та `Operations.update` містять вкладені scopes. `wd_units` займав близько 2,4 мс CPU на подію. У Late E на 4746 `wd_exit` займав 102,27 мс CPU. У D5000 restore пік 1057 зосереджений в `Army._sieges`.

Найдовший кадр D2100, 4813, має окрему причину. У деталізованому A чотири lockstep-команди зайняли 450,49 мс inclusive CPU, зокрема 84 435 викликів `Army.safe_point` із 15 434 вкладеними `Economy.land_point`. Simulation tick у тому самому кадрі зайняв близько 14,8 мс. Таймер на кожному геометричному виклику додає overhead. У двох легших A ці чотири команди коштували 184–203 мс. Така сама група команд домінувала на 4693 у Late E і на 973 у D5000. Це залишкові обчислювальні піки, окремі від оптимізованого watchdog.

## Зміна

У `wd_exit` для кільця, яке повністю лежить у карті, чотири кандидати одного k пропускаються разом, якщо всі належать території виходу. `_wd_legal` завжди відхиляє її до інших перевірок. Для решти клітин збережено порядок top, bottom, left, right, крок радіуса, граничні перевірки, вагу нейтральної землі, strict comparison, land component і заглиблення. Поточні власники читаються з того самого масиву в межах виклику. Додаткових структур або роботи між тіками немає. Порядок зовнішніх викликів і мутацій лишається чинним.

## Profile B

Official Godot 4.7.2 з Linux runtime INT-11, 1280×720 Vulkan Forward Mobile, RTX 4060 Laptop, без VSync і cap. D2100 snapshot tick 4800, D5000 snapshot tick 945, Late E snapshot tick 4650. Вікна 120, 120 і 150 фіксованих тіків. D2100 має screening A/B з детальними геометричними scopes і дві підтверджувальні пари B/A та A/B без цих таймерів. Налаштування всередині кожної пари однакові. Одна контрольна пара D5000 і Late E у детальному режимі. Сирі відліки містять p95/p99/max, scheduler і PSI. Preflight не застосовувався.

| D2100, медіани плечей | A | B |
| --- | ---: | ---: |
| `wd_exit` inclusive CPU за 120 тіків, мс | 135,15 | 80,22 |
| `wd_exit` inclusive CPU на 4816, мс | 62,87 | 37,50 |
| `wd_exit` inclusive CPU на 4864, мс | 72,28 | 42,72 |
| Tick p95 / p99 / max, мс | 39,06 / 121,40 / 169,85 | 45,79 / 101,49 / 167,63 |
| Frame p95 / p99 / max, мс | 58,11 / 191,33 / 234,34 | 71,61 / 183,10 / 233,37 |
| Turn execution wall p99 / max, мс | 247,69 / 255,83 | 243,98 / 252,84 |
| Turn completion wall p99 / max, мс | 319,71 / 326,01 | 333,51 / 344,58 |
| Simulation CPU, мс/тик | 22,48 | 23,67 |
| FPS / 1% low | 23,09 / 4,62 | 21,28 / 4,77 |
| Peak RSS, MiB | 1671,85 | 1675,85 |

Медіанні зміни всередині пар. `wd_exit` inclusive CPU −41,49%, діапазон −42,82…−33,89%. Економія на 4816 21,32–26,88 мс і на 4864 23,59–30,99 мс. Tick p99 −16,40%, frame p99 −4,30%, FPS −4,86%, 1% low +3,12%, peak RSS +0,43%. Simulation CPU +4,48%. Послідовність і кількість усіх 38 `wd_exit` збіглася, як і 422 `army_path`, 340 `nav_path` та чотири команди. `_wd_tick` сумарно знизився в кожній парі. Фоновий CPU по парах 18,31→32,57%, 31,56→33,50% і 20,09→29,51%. Runnable wait був нижче 0,52% у всіх шести плечах. Перший FPS −10,15% не повторився. Cumulative simulation CPU і p95 лишаються ризиками. Дані не встановлюють причину їхніх коливань.

Spikes D2100 понад 100/200 мс залишилися однаковими у кожній парі. Для кадрів 4/2, 4/1, 4/1, для тіків 2/0 у кожній парі. Turn execution wall сумує elapsed трьох `NetSession._run` із локально поданими пакетами. Completion включає кадри й pacing між завершеннями turn. Мережевий RTT у цих вікнах відсутній. Окремі thread CPU та wall scopes показують, що піки watchdog і команд переважно обчислювальні. Реальне мережеве очікування в цих GUI прогонах має статус NOT RUN.

Late E на 4746: `wd_exit` −26,80 мс CPU, tick max 150,27→122,87 мс, tick p99 −22,51%, FPS +0,40%, 1% low +5,50%. D5000: tick max 243,69→264,79 мс на 1057, де домінує siege. Tick p99 −0,65%, FPS +4,31%, 1% low +6,51%. Контролі мають по одній парі.

## Детермінізм

576/576 прямих A/B порівнянь координат і послідовності запитів land component. 37/37 на кожному плечі для Operations, retreat, reinforcement, transport, spawn/destruction і repeated restore. 390/390 покрокових зіставлень D2100, D5000 і Late E. NetHash, RNG, порядок команд, wire bytes, позиції, стан Operations та фінальні snapshots збіглися. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с.

Локальні сирі результати й SHA256 у `/home/zagor/projects/droneflames-toolchain/performance/r21/`. Фізичні Windows FPS, LAN і Steam — NOT RUN.

## QA

Simulation regression 2476/2476 і Save/Load 22/22 пройшли. Snapshot restore, admission, два процеси ENet із turns/reconnect/resync, build identity і release policy — PASS. Official Linux x86_64 та Windows x64 зібрані з перевіреного дерева гри `78e744532de3afd6a6545a4bfbaec1aafe980dcc`. PCK SHA256 `71eae8ac68795e6626795a359e328b6ee012f03f402a6bc3f40a382a4d5a948b` збігся в обох пакетах. Linux native і Wine headless smoke — PASS із відомими попередженнями Godot на виході.
