> Історичний матеріал з `toolchain/int06.ruEDaqvC/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## INT-06 · R10 / beta 0.36.5

- `85d76a1` відсікає віддалених кандидатів у наземному циклі `ArmyFire._impact`. `8509ddb` додає differential fixture. `a2bcdb0` оновлює source version, Menus.VERSION, локалізовані release notes і build guard до 0.36.5.
- Цільовий review підтвердив еквівалентність включних меж шкоди, suppression і pin, порядок кандидатів, чистоту `_hostile` і незмінну послідовність RNG. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1, 30 тіків/с, три тіки на turn, NetHash і wire payload збережено. Мережевий допуск звіряє повну версію. R11 має рішення NO-GO і лишається локальним.

## Вимірювання та ризики

- D2100 на Ubuntu наявні A/B дали 19,181 → 20,838 FPS (+8,64%), 1% low 6,701 → 6,911 (+3,12%) і p95 кадру 95,909 → 83,012 мс. Inclusive `_impact` 8,81 → 4,94 мс/кадр (−44,0%), exclusive 8,60 → 4,75 мс (−44,8%), наземний обхід 707,17 → 203,33 мс за інтервал (−71,2%).
- p99 кадру 136,692 → 142,135 мс за медіанами (+3,98%), погіршення у двох із трьох пар. У детальних прогонах пізні кадри переважно визначав `ArmyFire._spot`. На чотирьох повторюваних пікових тиках `_impact` зменшився у 10 з 12 зіставлень. Точна причина p99 у мінімальних прогонах лишається відкритою. Host telemetry й окремі профільні прогони не дозволяють приписати цей ефект шуму.
- Синтетичний щільний контроль без відсікань дав +4,6–14,4% вартості влучання у трьох парах. Цей локальний ефект вимірював час влучання. Вплив на FPS щільного фізичного Windows бою лишається відкритим. Medium tick p99 зріс за медіанами з 23,057 до 26,352 мс. [Вимірювання R10 і цільовий review](../../r10/INT06_INTEGRATION.md)

## Перевірки кандидата

- Python discovery 49/49 без SKIP, simulation 2476/2476, watchdog 101/101, ring 8/8, HUD/input 36/36, differential A/B по 49/49 з однаковими слідами. L10N, build identity, Linux native smoke, official Windows x64 build і Wine headless smoke пройшли. Windows і Linux дали однаковий PCK. Використано DEV-02 та official Godot 4.7.2.
- C1200, D2100 і Late E збіглися по 150/150 тіках. Late E `4693 f19767f333c29101`, `4746 c9301a1dcbcd76e8`, `4800 3c338abc3ec9d5c7`. RNG `1940658711`. Активний D2100 Save/Load пройшов 66/66 тіків з обома save. ENet admission, reconnect і resync пройшли. Пара 0.36.5/0.36.5 допущена, змішані 0.36.4/0.36.5 відхилені в обох напрямках.
- `Physical Windows user acceptance: PASS — owner-reported`. Власник повідомив про покращення FPS R10. `Quantitative Windows A/B metrics: NOT PROVIDED`. У виданому комплекті був Candidate B 0.36.4 від `8509ddb`. Власник не надав SHA запущеного EXE або числові логи. Фізичне приймання нового пакета 0.36.5, LAN та Steam — NOT RUN. DummyTexture RID issue відкритий.

Merge commit до `beta` після проходження CI. Відкат окремим revert PR від першого батька merge-коміту.

## Підсумок інтеграції

Звичайний merge commit `8c83d91d06989cc3857c7560c4690188bf88a964` має повне дерево перевіреного кандидата `4dc315c9a3a53f554bab031fed39bf3bfe481474`. Перед merge і на новому `beta` Python policy та Godot regressions / Windows x64 build пройшли. Release job пропущено за чинною політикою. [CI PR](https://github.com/ZaGOR-1/port-drone/actions/runs/45502518012) · [CI beta](https://github.com/ZaGOR-1/port-drone/actions/runs/45503403181)

Windows x64 ZIP і Linux x86_64 TAR.GZ 0.36.5 зібрані з merge SHA й мають ідентичний PCK. Перевірки SHA256, Linux native smoke та Wine headless smoke після розпакування пройшли. Main звірено на `172df65e3bd004efed9a5444e90a284d9d69db10`. Нові releases, tags і deployments відсутні.
