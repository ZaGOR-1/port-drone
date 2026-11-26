> Історичний матеріал з `toolchain/int11.KkAMcCZr/github/pr-body.md`. [Реєстр досліджень](../INDEX.md)

## R19 · Army target acquisition

База `93bd6af`, DroneFlames 0.36.9. У великих змішаних buckets `Army._acquire` повторно використовує впорядковані піднабори за живою маскою ворогів протягом одного scan. Порядок, дублікати, tie-breaking та живі перевірки збережено. Зміни власності й перебудова grid інвалідують локальні списки. Guard, grey zone та звичайні бої проходять початковим шляхом.

## Profile B · GO

| Сценарій | Пари | Acquire CPU, мс/тик | FPS, медіана парної зміни | 1% low, медіана парної зміни | Frame / tick p99 |
| --- | ---: | ---: | ---: | ---: | ---: |
| Щільний D5000 | 3 | 19,06 → 8,46 | +7,63% | +15,69% | −18,51% / −37,62% |
| D5000 | 3 | 10,34 → 10,38 | −2,24% | +0,74% | −2,82% / +1,29% |

Медіанна економія у щільному D5000 — **10,68 мс/тик**, повна acquire CPU **−56,73%**. Відвідування кандидатів 3 838 525 → 1 097 587 або 1 203 488 з побудовою списків. Медіанні парні зміни peak RSS −0,79% / +0,86%. Одна коротка пара D2100 показала −7,66% 1% low, одна пара Late E показала +9,77% tick p99. У цих сценаріях кеш не активувався.

## QA

- Differential 24/24. У чотирьох replay збіглися всі 420 тіків за NetHash, RNG, станом, цілями й командами. Фінальні snapshots збіглися побайтно.
- Regression 2476/2476, Save/Load 22/22, snapshot restore, ENet admission і reconnect/resync, official Linux/Windows x64 builds, native Linux/Wine smoke і PCK parity — PASS.
- PROTO 7, SIM_REV `v036-integration-1`, формат save 1, 30 тіків/с і версія 0.36.9 збережено.

Фізичні Windows GUI/FPS, LAN на двох ПК і Steam — NOT RUN. [Методика, детальні заміри й handoff](../../r19/R19_RESULTS.md)


## INT-11 · 0.36.10

PATCH синхронізує version.cfg, Menus.VERSION, build identity, примітку ru/uk/en та PROJECT_STATE. Production-код R19 побайтно збігається з перевіреним кандидатом. Докази Profile B і детермінізму звірено з вихідним деревом. D2100 і Late E залишаються відкритими для фізичного Windows QA.

Фінальний CI PASS. ENet допускає 0.36.10/0.36.10 та відхиляє змішані 0.36.9/0.36.10 в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с збережено. Фізичні Windows FPS, LAN і Steam мають статус NOT RUN за рішенням власника. Відомі дефекти вивільнення ресурсів Godot відкриті.
