# R03 · Детермінізм і регресії

> Історичний матеріал з `toolchain/performance/r03/R03_DETERMINISM.md`. [Реєстр досліджень](../INDEX.md)

## Lockstep у Wine — PASS

Рівно 600 тиків при `SIM_DT=1/30`, seed карти 20261016 і глобальний seed 91234. Чотири scripted factions, два боти. R02 fixture передає канонічні пачки до реального `NetSession._run`. Кожен рядок означає два незалежні запуски на зазначених A/B EXE.

| Режим | Початковий NetHash A = B | Tick 300 A = B | Tick 600 A = B | CRC команд | Кінцеві units |
| --- | --- | --- | --- | ---: | --- |
| GUI uncapped | `acbbe85ac409bd14` | `742e462adeb98058` | `86913469d718ce57` | 1826857750 | `704:2921a79d` |
| GUI cap 60 | `acbbe85ac409bd14` | `742e462adeb98058` | `86913469d718ce57` | 1826857750 | `704:2921a79d` |
| Headless | `acbbe85ac409bd14` | `742e462adeb98058` | `86913469d718ce57` | 1826857750 | `704:2921a79d` |

Порівняно також канонічні пакети команд, повні звіти `NetHash.parts`, фінальний count і відбиток усіх позицій, HP та станів юнітів. Хеші 600-tick серії збігаються з опублікованим результатом R02. Звичайні GUI пари R03 на 765 тиках зі збереженим workload також мали тотожні initial/warm/checkpoints/final хеші. Дані й автоматична звірка (`R03_RESULTS.json`)

## Цілі й RNG

828 assertions для кожної контрольної збірки на витягнутому з EXE PCK. Обидва JSON побайтово однакові. Використано справжні Army, ArmyFire, Diplomacy, Unit. Фіксуються порядок spotted, належність до seen, nearest ID, реальний `_pick`, recon-прапорець, стан RNG і відсутність мутацій юнітів від spotting. Fixture (`test_spot.gd`) · A (`tests-A/spot.json`) · B (`tests-B/spot.json`)

Шестипрогонний replay використовує один процес на прогін. Нативні Windows lobby/match, транспортний MP desync, фізичний LAN, Steam і cross-platform зареєстровані окремо як **NOT RUN**. Нативний Windows GUI та зовнішній present trace також **NOT RUN**.

## Save/Load і короткий replay E

Обидва Windows пакети відновили той самий історичний snapshot R02 E з SHA256 `5d83751abcc0ab1cfc35141b0133b78d3982b2001dc9b2dbb8320af16131fcda`. Продовжили від тика 4650 до 4770. Початковий хеш після restore `c3ba32fe4eed13e3`, фінальний `5f57ce96376e0286`, units `1017:b0694690` однакові. Це парне продовження старого checkpoint. Свіжий довгий E від початку **NOT RUN**.

- A та B на точних PCK пройшли по 2476/2476 assertions штатної simulation regression, зокрема entity codec, background save і просторові сценарії.
- B пройшов 111/111 у snapshot guard matrix, 49/49 у повторному real loader і 6/6 у disk fault recovery. Відомі очікувані повідомлення fault injection в логах.
- Дані E (`runs`) · Регресія A (`tests-A/simulation/regression.json`) · Регресія B (`tests-B/simulation/regression.json`) · Restore fixtures (`tests-B/snapshot-restore`)

Двопроцесний localhost ENet **PASS для admission**. Штатний Linux headless fixture на staged B підтвердив прийом сумісного peer і відмову в трьох несумісних конфігураціях версій. Бойовий Windows ENet match, Steam і фізичний LAN лишаються **NOT RUN**. Звіт admission (`tests-B/network-runner.log`) · Дані по парах (`tests-B/network-identity`)

## Контрольована fixed-view серія

У кожній парі збіглися 45 warm-up + 450 measured ticks, CRC команд, NetHash і `NetHash.parts`, у тому числі стан усіх юнітів. Послідовності видимих юнітів на всіх sampled ticks збіглися.

| Сценарій | Hash після warm-up | Hash на 300 | Hash на 495 | Кінцеві units |
| --- | --- | --- | --- | --- |
| C1200 | `c0fc24fd8c20f3f0` | `742e462adeb98058` | `b3acce2373630492` | `806:903737ca` |
| D1920 | `c5a227700e6f7d57` | `5fea781ade3441a7` | `409503b484110767` | `1320:61f47e60` |
| D2100 | `acdbda3ae7f4f39c` | `707e1905f8cfb0f3` | `acf36745b8d5c4a2` | `1425:f2de7285` |
