# R32 · Повторне використання команд UnitsLayer

**NO-GO на feasibility для фіксованих груп у порядку малювання.** Baseline `acd976086e6833306d3b6c3d711b72df425204de`, 0.36.11. Точне дерево документації R30–R31 перенесено комітами `f426c3b`, `c1c0251`, `7aebfdc`. Критерії до вимірювань у `58db491`. [Критерії](FEASIBILITY_GATE.md) · [R30](../r30/R30_RESULTS.md#2-unitslayer--зберігати-draw-команди-незмінних-груп) · [R31](../r31/R31_RESULTS.md)

## Межа збереження команд

- CanvasItem вже зберігає команди до redraw. `_process` веде pause snapshot і ставить `queue_redraw` для основного item та `UnitOutline`. У day `Army.busy()` повертає true, якщо реєстр юнітів непорожній. Це охоплює нерухомих юнітів. Night має окремі alpha, visibility, cadence badge, zoom і redraw. `_pre_frame` заново формує впорядкований `_vu[0:_nv]` із живих не-FPV юнітів за camera bounds, fog і UrbanHold. Заміна або зсув списку під час spawn/death, fog, camera pan чи hold може інвалідувати всі наступні групи. [UnitsLayer](../../game/world/units_layer.gd) · [Army](../../game/game/army.gd) · [Vision](../../game/game/vision.gd) · [Vfx](../../game/world/vfx.gd)
- `UnitOutline` створюється в `_ready` з одним shader material і `show_behind_parent`. Усі підкладки йдуть перед усіма atlas outlines. Порядок у проходах збігається з `_vu`. Напівпрозорі rect та fallback offset sprites мають зберігати кількість, порядок і перекриття. Мінімальний outline-підхід міг би розмістити впорядковані групи під тим самим outline item зі спільним material і transform. Renderer cost і точні пікселі залежать від layout CanvasItems, shader, texture sampling і композиції. R26 вже показав погіршення outline CPU у трьох із чотирьох dense пар для triangle-array batching. [R26](../r26/R26_RESULTS.md#rendered-ab--profile-b)
- Ground проходить trucks → dug trenches → shadows за atlas order → bodies за тим самим atlas order → faction/HP → selected unit brackets → SPAAG. Блок ground вплетений у `_draw` між іншими командами того самого CanvasItem, включно з вибором армії та ефектами. Child item може бути перед або за item батька. Для вставки шару в середину потрібне розділення canvas-стадій, збереження clip/material, transform і точного порядку. Atlas groups визначаються texture RID і порядком першої появи, тому зміна atlas membership може переставити підгрупи незалежно від руху. Штатна geometry lookup і atlas batching залишаються. [UnitsLayer](../../game/world/units_layer.gd) · [SpriteAtlas](../../game/core/sprite_atlas.gd)

| Залежність | Вимога для retained commands |
| --- | --- |
| Позиції, кадри та atlas | Обчислення `pos.round()` передане в DST. `frame`, allegiance/ownership, visual school, тип, ID parity, salvo й fallback змінюють atlas/name, rect, anchor, texture та порядок. Для lazy outline і texture replacement потрібна валідність ресурсу і source rect. Зберігати ті самі inherited transform, sampling і shader. [SpriteAtlas](../../game/core/sprite_atlas.gd) |
| Selection, HP, colors | Selection bracket/army overlay залишаються в їхньому проході. Ground markers залежать від country, player, palette, HP, `max_hp` і zoom gate, dug/entrenched визначають geometry та shadow. Outline залежить від country/tint, night alpha й порогів visibility. [UnitsLayer](../../game/world/units_layer.gd) |
| Camera, fog, visibility | Навіть коли округлена позиція та атлас збігаються, камера, viewport, zoom, fog або UrbanHold можуть змінити видимий список і порядок buckets. Day/night мають незалежні items, hierarchy й lifetime. Повна зміна alpha вимагає інвалідації відтінку або доведеної RGBA-еквівалентності іншого способу застосування alpha. [Vision](../../game/game/vision.gd) · [Vfx](../../game/world/vfx.gd) |
| Lifecycle | Empty/hide, повторний вхід, заміна текстури, new world, restore і teardown вимагають вилучити або очистити застарілі команди та вивільнити RIDs. `Save` створює новий world state, тому ID юніта чи RID з попереднього покоління сам собою недостатній. Похідні render keys мають жити тільки в presentation, без записів у RNG чи simulation. [GameWorld](../../game/game/game_world.gd) · [Save](../../game/game/save.gd) |

## Live feasibility

INT-12 Linux QA, Godot 4.7.2 `ed1daf0bf`, RTX 4060 Laptop, Vulkan Mobile, 1280×720, seed 20261016, dense camera R26, 45 warm + 150 тіків. Два окремі діагностичні replay на сценарій. Перший знімає чисті CPU scopes, другий записує точні ordered payloads примітивів, включно з texture RID та всіма RGBA components. В обох викликаються штатні draw-команди. Pending draws зіставлено в тому самому шарі й фазі з попереднім draw. Стабільність груп вимагає точного складу, послідовності, payload і ordinal у межах atlas bucket. Холодний draw входить у знаменник. У вікні активні day scope й zoom 1,111; night і переходи visibility проаналізовано статично, live timing для них — NOT RUN.

| Сценарій | Розмір | Стабільні групи | Частка команд у стабільних групах | Проєкція gross CPU outline / всі шість фаз |
| --- | ---: | ---: | ---: | ---: |
| Dense D5000 | 1 | 28,56% | 28,59% | 4,114 / 8,494 мс |
| Dense D5000 | 8 | 1,20% | 1,23% | 0,171 / 0,358 мс |
| Dense D5000 | 16 | 0,16% | 0,17% | 0,022 / 0,048 мс |
| Dense D5000 | 32 | 0,009% | 0,006% | 0,001 / 0,002 мс |
| C1200 | 1 | 67,24% | 67,20% | 0,695 / 1,361 мс |
| C1200 | 8 | 25,29% | 25,29% | 0,261 / 0,512 мс |
| C1200 | 16 | 23,30% | 23,23% | 0,240 / 0,472 мс |
| C1200 | 32 | 23,30% | 23,04% | 0,238 / 0,468 мс |

На dense записано **4 233 250 примітивів за 150 draw frames**. Склад outline змінився у **111 із 149** переходів. У C1200 записано 427 764 примітиви за 195 frames. У 45 переходах `net_tick` повторився. Trench-фаза не дала жодної команди в обох вікнах, але її спільний sprite preparation CPU лишився. Night не дав команд. Частки груп і команд агрегуються сумами по шести виміряних фазах.

Окремий CPU replay виміряв **39,122 мс/кадр** ground + outline та **126,083 мс** frame p50 у dense. Такі самі scopes у R23 давали 24,50 і 14,39 мс/кадр exclusive в окремому профілі. У C1200 R32 виміряв 2,977 мс/кадр ground + outline і 21,192 мс frame p50. Gross у таблиці є проєкцією `Σ(phase CPU × частка стабільних команд фази)` без витрат кешу. Це оптимістична оцінка усунення також спільної підготовки всередині фаз за пропорцією, а не точна верхня межа CPU. Щоб досягти 10% у виміряному dense, потрібно **3,912 мс/кадр**. Frame p50 потребує покращення близько **3,782 мс**. Командна проєкція для 8/16/32 має великий відрив від обох порогів. Вона не прогнозує незалежно frame p50. [R23](../r23/R23_RESULTS.md#актуальні-вузькі-місця-у-03611)

### Ціна точного ключа та групування

В окремому 60-тіковому probe під час rendered replay виконано поділ актуального packed payload, exact byte comparison, збереження попередніх ключів, додавання/вилучення груп і оновлення метаданих. Це CPU головного потоку на одну форму кешу. Самі ключі збиралися до цього scope, затрати на renderer і нові RIDs відсутні. Порівняння з gross є екраном потенціалу, оскільки вибірки мають різну довжину.

| Розмір | Dense розбиття + звірка + оновлення, outline / усі | C1200, outline / усі |
| --- | ---: | ---: |
| 1 | 7,472 / 17,776 мс | 0,610 / 1,486 мс |
| 8 | 3,798 / 8,454 мс | 0,315 / 0,724 мс |
| 16 | 2,532 / 5,539 мс | 0,219 / 0,484 мс |
| 32 | 2,175 / 4,601 мс | 0,190 / 0,412 мс |

Для 1 юніта на group навіть outline коштує **7,472 мс/кадр** проти **4,114 мс** projected gross до збору ключів. Окремий trace replay як діагностична обгортка збільшив ground + outline scope з 39,12 до 65,89 мс/кадр. Це містить збір, запис і trace overhead. Для production така різниця не оцінена як чиста плата. На dense один набір packed payloads досягає **4,12 MiB**, у C1200 **0,33 MiB**, плюс старі/поточні масиви, таблиці, CanvasItems, command buffers і ресурсні черги. Варіант із одним outline item на group потребував би в середньому близько **9 350** phase-local items ще до інших проходів. Renderer upload, зміна draw calls, точні RSS/VRAM і repaint на dirty для кандидата залишилися невиміряними. Їхня ціна не потрібна, щоб відсіяти виміряну форму кешу. Це рішення охоплює фіксовані групи й точні ключі зі знятих примітивів. Adaptive runs, дешеві source-derived keys і нове розкладення ground-проходів не перевірялися.

Збережено process CPU, runnable wait і PSI з усього replay. Для dense-time медіана/максимум стороннього CPU від усіх логічних CPU становили 9,60% / 32,38%, main runnable wait 0,09% / 1,40%, memory PSI 0,00% / 1,91%. Ці дані описують діагностичні запуски на звичайному desktop, без приймальних A/B висновків.

## Коректність і verdict

- **PASS у діагностиці.** Кінцеві NetHash, RNG, movement hash і orders CRC збіглися у timing/trace та історичному R26 baseline для кожного сценарію. NetHash `dc7497677c9781bf` для dense і `0cc10c41e0c992af` для C1200. Обидва діагностичні пакети використовували штатні draw calls.
- **PASS 3/3 для аналізатора.** Контрприклади охоплюють перестановку прозорих примітивів у тій самій позиції, зміну позиції й texture, bucket reorder, empty/re-entry і truncated trace. Це перевірки детектора стабільності. Production RGBA, NetHash/RNG кандидата, restore і lifecycle ресурсів — **NOT RUN**. Історичний RGBA R26 належить тому PoC.
- **NO-GO.** Production retained PoC, парний A/B, frame/tick p99, FPS, RSS/VRAM acceptance та Windows GUI — **NOT RUN**. Фінальні `game/`, `tests/`, `tools/` і version відповідають `acd9760`. Розмір для runtime не обрано.

## Відтворення і збереження

Канонічний архів `~/projects/droneflames-archive/R32/`. Маніфест `SHA256SUMS` має 132 записи, його SHA256 `62f103df370560ec4e38f2f9ed385eab53bb25bed24fdcf7984f16f91caaf835`. Збережено точні PCK, fixture, діагностичні патчі, сирі примітиви, CPU, телеметрію та команди відновлення. Перший cost launcher запросив 18 тіків. Harness застосував мінімум 60, dense завершив усі 60 і результат збережено, launcher зупинився на assert довжини. Light запущено з 60 на тому самому PCK, скрипт відтворення тепер явно задає 60. Raw спроби й лог залишилися в маніфесті.

```bash
set -o pipefail
archive="$HOME/projects/droneflames-archive/R32"
cd "$archive"
sha256sum -c SHA256SUMS
run=$(head -1 launch.log)
cost=$(head -1 launch-cost.log)
PYTHONDONTWRITEBYTECODE=1 python3 analyze.py "$run/raw" \
  "$HOME/projects/droneflames-toolchain/performance/r26/raw" | cmp summary.json -
PYTHONDONTWRITEBYTECODE=1 python3 summarize_cost.py "$cost/raw" | cmp cost.json -
PYTHONDONTWRITEBYTECODE=1 python3 test_analyze.py -v
./reproduce.sh /path/to/r32-checkout
DF_R32_MODES=cost ./reproduce.sh /path/to/r32-checkout
```
