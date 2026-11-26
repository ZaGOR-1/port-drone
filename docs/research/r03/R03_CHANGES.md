# R03 · Локальна зміна та відтворення

> Історичний матеріал з `toolchain/performance/r03/R03_CHANGES.md`. [Реєстр досліджень](../INDEX.md)

Мінімальний patch (`R03_OPTIMIZED.patch`) змінює тільки `game/game/army_fire.gd` відносно production HEAD. Вилучено `_spot_u` та матеріалізацію списку Unit для кожного спостерігача. `_spot` ітерує наявні бакети безпосередньо. Буфер facilities і звичайний `Army._near_hostile_into` цілком збережені.

Межі, маска й напрям обходу повторюють вирази `Army._near_hostile_into`. Послідовність `cid → eye → cy → cx → Unit` збігається з послідовністю розгорнутого масиву. Перевірки й записи `done_u`, розрахунок квадратів дистанцій, `is_rec`, порядок append, naval і facilities лишилися на тих самих логічних місцях. У межах цього синхронного обходу функція читає сітку. Вона не створює кешу між викликами. Зміни геометрії або порядку обходу Army grid потребуватимуть звірки з цим циклом.

Усунено один reusable Array `_spot_u` на ArmyFire і копіювання його елементів. Точні native heap allocations та capacity changes не виміряні. Гру, мережеві команди, частоту тиків, RNG і формат saves не змінено. Контракти залишаються `0.36.0 / 7 / v036-integration-1 / 1`.

## QA staging

`source/` — незалежний локальний клон на `perf/r03`, без remote. `build-A/source` і `build-B/source` — фізичні staging trees. Перенесено R02 lockstep fixture й таймери. SP fixed-delta hook і LAN hook не перенесено. Папки `build-{A,B}/` містять повний staged patch, baseline commit, tree SHA, package manifests і SHA256. Єдина відмінність у staging game/ — `army_fire.gd` і відповідний лічильник копій у ньому.

`build-r03.sh` використовує штатні `tools/build.py`, pinned editor/template і patched verifier з локального `df-windows`. Стандартний CLI пакує чисті commit revisions. R03 використовує staged tree без commit, а знімок точно відтворюється через `complete-pck-source.patch`. У provenance `source_sha` і `game_tree` вказують на базовий HEAD; `source_dirty=true`, а точний вміст дають `STAGED_TREE` і staged patch.

| Артефакт | SHA256 |
| --- | --- |
| A EXE | `99e85be22a7473f82b21fcaef43b4066c65b21a255fb1d384288d5c7520a6081` |
| B EXE | `6cc86a5379175ca938afac0f7974c421b4eb8cc2feec9b7bfeae62a38481cf0f` |
| Shared patched template | `8af875561fbaf0b38151cca25dcad67e8cfcd27dc2cd920a4faa988ade8f1f93` |

Команди з кореня R03 у свіжому каталозі для результатів.

```bash
./build-r03.sh A     # staging з базовим spotting і спільним R02/R03 instrumentation
./test-r03.sh A
./suite-r03.sh baseline
./suite-r03.sh audit-a
# Після застосування зміни B та відповідного audit hook до source/
./build-r03.sh B
./test-r03.sh B
./suite-r03.sh paired
./suite-r03.sh audit-b
./suite-r03.sh locks-a
./suite-r03.sh locks-b
./suite-r03.sh snapshot
python3 summarize-r03.py
```

Після повтору `test_spot.gd` читає PCK безпосередньо з кожного EXE. 828 assertions на кожному варіанті. Порожній і один кандидат, фракції та союз, рівні дистанції та порядок бакетів, поза колом, stale/rebuilt movement, мертвий запис, зміна власника, окопи, дим, jammed recon, розширена дальність, 321 юніт, повторний виклик. `spotted`, `seen`, selected ID, `_pick`, RNG і незмінність параметрів юнітів перевірено справжніми методами. JSON A/B однакові. Під Linux editor очікувані повідомлення про відсутні платформні GDExtension і shutdown-ресурси лишилися в логах.

## Повтор із контрольованим кадром

Першу GUI серію збережено в `runs/`. У частині пар `ground_in_view` відрізнявся й одна з них завершилася з несподіваним cap 60. Для виправленої серії додано ізольовані `fixed/build-{A,B}`. Спільний QA hook блокує введення, клавіатурний pan, camera update та shake, фіксує центр і zoom. HUD, viewport і simulation render лишаються активними. В обох fixed пакетах повний staged diff відносно бази збережено. Усередині пари відрізняється тільки `army_fire.gd`.

| Артефакт | SHA256 |
| --- | --- |
| Fixed A EXE | `86027388b9ead0469751fbd8cf0e252a7dbeb5694d6157b589b903c7d9f2a65a` |
| Fixed B EXE | `fd9b2c0cab4d2ceba0f877d459b8009abb34d00947c4b1af148658da0ff45764` |

Запуск fixed-view серії (`fixed/suite-r03.sh`) · Контрольна конфігурація (`fixed/lock-camera.py`)
