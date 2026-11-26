> Історичний матеріал з `toolchain/int10.GjFgeuwy/github/pr-body.md`. [Реєстр досліджень](../INDEX.md)

## Зміна

R18A перенесено на beta 0.36.8 з інтегрованим R17. Lookup зберігає ordinal у реєстрі юнітів і порядок застосування ефектів. Розв’язано один конфлікт у `Army.save_state`, збережено виключення `units_revision` та `_impact_units`. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1, 30 тіків/с.

Production commit `b33d49c`. Другий commit фіксує рішення і докази в PROJECT_STATE.

## Profile B · GO

За трьома парними вимірами D5000 повна impact CPU-вартість зменшилася на 40,97%, simulation CPU на 14,60%, FPS зріс на 10,09%, 1% low на 13,37%. У щільному D5000 impact CPU −24,71%, simulation CPU −7,42%, FPS +3,12%, frame p99 +1,33%, tick p99 −7,43%, peak RSS +1,19%. Виміряно 981 457 рангів у 866 сортуваннях, 72,72 мс CPU за медіаною.

Усі чотири короткі контролі вклалися в −5% для FPS і 1% low. У щільному D2100 зафіксовано +11,01% impact CPU та +9,16% frame p95, при −0,20% FPS і зниженні frame/tick p99. VM була активна в усіх heavy плечах і в A контрольного D2100. Результат характеризує виміряну Linux-сесію.

## QA

- PASS: R18 core 42/42, city callback 7/7, ArmyFire differential 59/59, R17 33/33 на A/B, 330 покрокових зіставлень, repeated restore.
- PASS: simulation regression 2476/2476, спільний і власний дискові сейви з ідентичним 66-тиковим продовженням, ENet reconnect/resync, 360-тіковий lifecycle control.
- PASS: official Linux/Windows x64, побайтова PCK identity, Linux native і Wine headless smoke. Локальний Windows A/B комплект готовий.
- NOT RUN: фізичний Windows A/B, LAN на двох ПК і Steam.

## INT-10 · 0.36.9

PATCH синхронізує version.cfg, Menus.VERSION, build identity, локалізовану примітку та PROJECT_STATE. Початковий R18B production PoC звірено побайтно. На official PCK бази й кандидата відтворено 33/33 перевірок R17 fixture. Типізація порожнього Array діє лише у fixture й зберігає тестове присвоєння та assertions.

Фінальний CI пройшов. ENet 0.36.9/0.36.9 допускається, змішані 0.36.8/0.36.9 відхиляються в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с збережено. Власник відклав фізичний Windows A/B, LAN і Steam, статус NOT RUN. NATIVE-01 зафіксовано як наступний окремий напрям дослідження.
