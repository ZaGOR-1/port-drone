# R04 · Детермінізм і регресії

> Історичний матеріал з `toolchain/performance/r04/R04_DETERMINISM.md`. [Реєстр досліджень](../INDEX.md)

Для кожної A/B пари звіряються initial і warm NetHash, проміжні й фінальний NetHash, журнал команд і CRC, кількість тиків, `NetHash.parts`, viewport/camera та sampled workload. Додатковий `movement_hash` отримано з байтів Variant для всіх юнітів після вимірювання. Він включає ID, власника, точну позицію, heading/frame, стан, waypoint, path, blocked_path і retry time. Алгоритм штатного NetHash збережено.

## Цільові перевірки

12/12 assertions в обох точних PCK, витягнутих із Windows EXE. Наявний `Army._advance` виконує крок із дробовою координатою, arrival і zero-length segment, рух із підсиленням та голодом, відхилення через воду, повтор маршруту, прохід мостом, рух recon і повернення на сушу. Результати A/B побайтово збіглися. SHA256 точного trace `46ccb6b1c32523d8c82ed945f8ed04214b3df873c5564ad0d525332b59531770`. Linux editor запускав лише фізичні копії PCK, відомі повідомлення платформних GDExtension і shutdown залишено в логах. Fixture (`test_movement.gd`) · Звіт A (`tests-A/movement.json`) · Звіт B (`tests-B/movement.json`)

## Lockstep — PASS

A/B виконали 600 headless ticks на Windows patched runtime під Wine. Початковий NetHash `acbbe85ac409bd14`, tick 300 `742e462adeb98058`, tick 600 `86913469d718ce57`, CRC команд `1826857750`. Кінцевий unit digest `704:2921a79d`. Точний відбиток позицій, напрямків і маршрутів `495eca44e1fe7623685b59b4bd587fd229e85b73aa0d2665ef673213b9488b9d` збігся. C/D GUI A/B також збіглися. Усі шість D2100 прогонів мають однаковий initial/warm/checkpoints/final, команди й повний відбиток руху.

| Пара GUI | Кінцевий NetHash A = B |
| --- | --- |
| C1200, 285 ticks | `027eb868e1f3c8cd` |
| D1920, 315 ticks | `8b62d0bfcc04e747` |
| D2100, 345 ticks | `c5739ffe0efc213c` |

Lockstep тут проходить реальний виконавець NetSession в одному процесі на прогін. Native Windows GUI, ENet/Steam transport, rejoin і фізичний LAN — **NOT RUN**. Порівняння прогонів (`R04_RESULTS.json`)

## Save/Load і штатна регресія — PASS

- A/B під Wine відновили той самий бінарний snapshot R02 E, SHA256 `5d83751abcc0ab1cfc35141b0133b78d3982b2001dc9b2dbb8320af16131fcda`. Пройшли 120 тиків від 4650 до 4770. Hash після load `c3ba32fe4eed13e3`, фінал `5f57ce96376e0286`, unit digest `1017:b0694690` і точний відбиток руху збіглися.
- Штатна simulation/performance regression A/B з точних PCK — по 2476/2476 assertions, включно з dry/wet path, bridge margins, entity codec й autosave.
- На staged B пройшли snapshot guard matrix 111/111, real loader/repeated restore 49/49 і disk fault recovery 6/6.
- Snapshot A/B (`runs`) · Регресія A (`tests-A/simulation/regression.json`) · Регресія B (`tests-B/simulation/regression.json`) · Restore fixtures (`tests-B/snapshot-restore`)
