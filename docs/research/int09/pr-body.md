> Історичний матеріал з `toolchain/int09.svwoLWvo/github/pr-body.md`. [Реєстр досліджень](../INDEX.md)

## Зміна

R17 перевикористовує впорядкований підбір юнітів за `Unit.home` у синхронній фазі `Operations.update`. Індекс інвалідується при зміні реєстру чи home, а ігрові фільтри читають поточний стан. Версія 0.36.7, PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 та 30 тіків/с.

## Вимірювання

Late E **GO** за Real-World Gaming, 4 пари, 150 тіків на плече, official Godot 4.7.2, RTX 4060, Vulkan Forward Mobile. Медіани парних змін: +3,11% FPS, +3,81% 1% low, −2,82% frame p99, −22,86% tick p99, −0,75% CPU-часу процесу. FPS і tick p99 поліпшилися в усіх парах. Frame p99 змінився від −8,59% до +3,34%. Усі плечі збіглися за NetHash, RNG і wire payload. VM працювала у всіх плечах. Абсолютні значення характеризують виміряну Linux-сесію, а для Windows потрібен ручний A/B.

Попередні D2100/D5000 gates, differential 37/37 і repeated restore перенесено за ідентичністю коду та артефактів.

## QA

- PASS: simulation regression 2476/2476, дисковий Save/Load 22/22, ENet admission та двопроцесні reconnect/resync, 600-тіковий lifecycle control.
- PASS: official Linux і Windows x64, побайтова PCK parity, Linux native та Wine headless smoke. У логах лишилися відомі Godot resource warnings на виході.
- NOT RUN: фізичний Windows A/B, LAN на двох ПК і Steam. Локальний Windows x64 A/B комплект готовий.
- Production commit `617c580`. Другий коміт фіксує докази приймання в PROJECT_STATE.

## INT-09 · 0.36.8

PATCH синхронізує version.cfg, Menus.VERSION, build identity, локалізовану примітку та PROJECT_STATE. Результати R17 вище отримані на 0.36.7 з тим самим production PoC. Повний Godot-набір для фінального кандидата і Windows x64 CI пройшли. Два ENet peers 0.36.8 допускаються, змішані 0.36.7/0.36.8 відхиляються в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с збережено. Фізичні Windows A/B, LAN і Steam відкладені власником, статус NOT RUN.
