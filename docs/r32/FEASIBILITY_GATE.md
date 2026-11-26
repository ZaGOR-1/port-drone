# R32 · Критерії до вимірювань

База `acd9760`, 0.36.11. [R30 shortlist](../r30/R30_RESULTS.md#2-unitslayer--зберігати-draw-команди-незмінних-груп) · [Profile B](../performance.md#real-world-gaming-profile-b)

## Feasibility

Один rendered replay dense D5000 і один C1200 на пінованому Linux QA runtime, seed 20261016, fixed camera R26, Vulkan Mobile, 1280×720, 45 warm + 150 виміряних тіків. Діагностика у фізичній копії без зміни команд renderer. Вимірювати day/night окремо і підсумовувати тільки після зіставлення. Записати впорядковані примітиви для шести ділянок: trench, per-atlas shadow, per-atlas body, markers/HP, outline plates, outline regions. Truck, SPAAG, brackets, badges та інші команди лишаються на їхніх місцях у базовому проході.

Порівнювати послідовні виклики draw в межах того самого шару й фази, зокрема повтори без simulation tick. Фіксовані групи 8/16/32 command-bearing units зі збереженням порядку й меж atlas buckets. Точно рівна впорядкована послідовність payload, texture і контексту CanvasItem означає потенційно стабільну групу. Окремо показати вагу стабільних команд і стабільність одиничних записів як верхню межу форми групування. Порожня попередня фаза не є cache hit. Показати пари redraw, зміни складу й випадки, коли чинний CanvasItem узагалі не перемальовувався. Частка примітивів сама по собі не є відсотком CPU.

Для CPU скрину звірити baseline CPU ground + outline за R23/R26 та окремо порахувати витрати кешу. Виміряти exact-перевірку й групування в діагностиці. Для чистої оцінки врахувати побудову ключів, зміни порядку і складу, dirty submission, CanvasItem clear/visibility/order, ресурси, пам’ять, lifecycle і додану роботу renderer. Спочатку дозволено оптимістично занулити неперевірені витрати: якщо кандидат уже не дає **≥3 мс/кадр і ≥10%** чистої економії або **≥3%** frame p50, зупинитися. Так само зупинитися, якщо для точного порядку потрібні глобальні зміни. Оцінки проєкції й виміри зазначати окремо. У разі близького результату уточнити витрати вузьким діагностичним probe до production PoC.

## Умовне приймання PoC

До A/B потрібні exact RGBA й ordered compositing для перекриття, day/night, fog, fallback atlas, різних zoom і viewport, мутацій між draw, selection, empty/hide, повторного входу, restore і звільнення ресурсів. Потрібні однакові wire, NetHash, RNG та рух у matched replay.

По **4 послідовні пари для кожного сценарію** dense D5000 і C1200, чергування AB, BA, AB, BA. Однакові input, камера, runtime і вікно за конфігурацією вище. Усі плечі зберігати. Спочатку абсолютні й відносні парні різниці, потім медіана і min/max. Для dense потрібні всі три пороги з feasibility. Для обох сценаріїв guard **+5%** у несприятливому напрямку для tick p99, frame p95/p99, 1% low, FPS, peak RSS, VRAM і GPU p95. Зберігати p50/p95/p99/max, CPU, draw calls, сторонній CPU, runnable wait і memory PSI. Атрибуція неможлива через фон → INCONCLUSIVE. Фізичний Windows QA після локального GO.
