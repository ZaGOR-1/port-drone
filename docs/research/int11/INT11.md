# INT-11 · R19 у beta 0.36.10

> Історичний матеріал з `toolchain/int11.KkAMcCZr/handoff/INT11.md`. [Реєстр досліджень](../INDEX.md)

[PR #19](https://github.com/ZaGOR-1/port-drone/pull/19) інтегровано з бази `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035` у `3298af5878501d458920b41dc5738f60571ac551`. Кандидат `881eb7a1f407b3820d4d6915209d3383aa31c7cc` зберігає production-код R19 `868b2b8e43fc1aa45d3cfbf7b9be492faa1207f8`. Основний checkout `/home/zagor/projects/port-drone` синхронізовано fast-forward.

## Приймання

- Піднабори bucket-ів живуть один scan. Зміна власності, rebuild або restore інвалідують піднабори. Маска живих ворогів читається для кожного запиту, історична spatial mask зберігає вибір bucket-ів, а внутрішній цикл перевіряє актуальну hostility. Порядок рядків, колонок і вставки, дублікати та tie-breaking збережено.
- R19 Profile B GO та QA PASS перенесено за ідентичністю production-коду й SHA256 доказів. Differential 24/24, 420/420 зіставлених тіків, Save/Load 22/22, snapshot restore і ENet reconnect/resync. У щільному D5000 acquire CPU −56,73%, медіанна економія 10,68 мс/тик, FPS +7,63%. [R19_RESULTS.md](../../r19/R19_RESULTS.md)
- Фінальний кандидат CI пройшов 50/50 тестів із Godot, simulation regression 2476/2476 та Windows x64 build verification. Локально build identity 3/3, localization lint і примітка в PCK ru/uk/en PASS. [Початковий CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45682722867) · [CI PATCH-кандидата](https://github.com/ZaGOR-1/port-drone/actions/runs/45683816204)
- ENet loopback допускає 0.36.10/0.36.10 та відхиляє 0.36.9/0.36.10 в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с.
- Official Windows x64 ZIP і Linux x86_64 tar.gz зібрано з merge-коміту на наявному Godot 4.7.2. Linux native та Wine headless smoke PASS. SHA256 PCK однаковий для Windows EXE, Linux і перевірок admission та локалізації: `89c23fc4e0c5ff0a1571263e0834a587707195165213d2927cc1f80d594f4929`. SHA256 архівів (`../packages/SHA256SUMS`) · PCK parity (`../post/parity.json`)
- У коротких D2100/Late E контролях кеш не активувався. D2100 1% low −7,66%, Late E tick p99 +9,77% (+3,82 мс). У B було більше стороннього CPU, причинність відкрита. Фізичний Windows GUI/FPS, LAN і Steam — NOT RUN. В обох фінальних smoke Godot повідомив про 17 CanvasItem RID, 238 ObjectDB instances і 44 ресурси під час виходу. Відомі дефекти teardown відкриті.

## Відновлення

`beta-0.36.9-to-0.36.10.increment.bundle` вимагає стару beta. В окремому репозиторії без alternates перевірено bundle, fast-forward, HEAD, повне дерево, версію, чистий status і `git fsck --full`. Журнал відновлення (`../evidence/bundle-restore.log`) · SHA256 bundle (`SHA256SUMS`)

CI merge-коміту на beta — PASS. [GitHub Actions](https://github.com/ZaGOR-1/port-drone/actions/runs/45684947917)
