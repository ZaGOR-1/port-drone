# R26 · Пакетне малювання підкладок UnitsLayer

**NO-GO, 2026-11-26.** CPU `_draw_outline` зріс у трьох із чотирьох пар dense D5000, сталий FPS не досяг наперед заданої цілі. Візуальні й симуляційні перевірки пройшли в межах перевірених сценаріїв.

- A — погоджена `beta` `1e912390394e6eafab004eb4d3ff82794dd2baeb`. B — A з експериментом у `game/world/units_layer.gd` (+44/−10). Локальні docs-only cherry-pick R24 і R25 — `360cbd8`, `3bc9b51`. Гілка `perf/r26-outline-rendering`. [R24](../r24/R24_RESULTS.md) · [R25](../r25/R25_RESULTS.md)
- У R23 `_draw_outline` споживав 14,39 мс/кадр у dense D5000 за GPU viewport p50 2,26 мс. R22 вимірював інший підхід із кешем геометрії. [R23](../r23/R23_RESULTS.md#межі-попередніх-підходів)

## CanvasItem і PoC

`_process` визначає необхідність redraw. `_pre_frame` формує видимий список у порядку реєстру з урахуванням камери, fog, типу та UrbanHold. `_draw_outline` виконується на сигналі `draw` дочірнього `UnitOutline` з `show_behind_parent`. Спершу він малює дві напівпрозорі підкладки на кожного неокопаного юніта, потім кольорові atlas regions у початковому порядку. Позицію округлено у world space, масштаб дає transform CanvasItem/камери. Денний і нічний проходи відрізняються alpha та правилами видимості. [UnitsLayer](../../game/world/units_layer.gd) · [Vfx](../../game/world/vfx.gd)

PoC подає підкладки одним `canvas_item_add_triangle_array` на той самий CanvasItem. Два прямокутники, включно з їхнім перекриттям, і порядок юнітів відтворено окремими quad indices. Два packed buffers належать шару. Колір передано одним елементом, атласні спрайти та selection малюються чинними методами. CanvasItem чистить команди при redraw і володіє полігональним ресурсом. Вузол, shader та правила `queue_redraw` лишаються штатними.

У Godot Forward Mobile сумісні прямокутники вже використовують спільний quad batch. Triangle array переходить у полігональний batch, обходить vertices для bounds та створює vertex/index buffers. Це обмін вартості подання дрібних команд на підготовку й upload геометрії. Кількість викликів із GDScript і глобальний лічильник draw calls вимірюють різні рівні. API звірено через Context7 і код пінованого рушія `ed1daf0bf`. [Renderer canvas](https://github.com/godotengine/godot/blob/ed1daf0bf/servers/rendering/renderer_rd/renderer_canvas_render_rd.cpp) · [CanvasItem](https://docs.godotengine.org/en/4.7/classes/class_canvasitem.html)

## Rendered A/B · Profile B

Ubuntu 26.04.1, Ryzen 5 7640HS, RTX 4060 Laptop, Godot 4.7.2 release, X11/XWayland, Vulkan Forward Mobile, 1280×720, VSync і FPS cap вимкнені. Фіксована камера, R23 seed 20261016 і той самий wire stream. Dense D5000 — чотири пари AB/BA/BA/AB, C1200 — дві BA/AB. По 45 warm і 150 виміряних тіків у кожному плечі, dense D5000 мав медіану 4588 видимих живих юнітів. Thread CPU для UnitsLayer охоплює `_process`, `_draw` та окремий `_draw_outline` без подвійного додавання вкладених scopes. GPU time належить viewport, draw calls — глобальний лічильник рушія, RSS — peak процесу, VRAM — peak показника Godot renderer. [Profile B](../performance.md#real-world-gaming-profile-b)

До запуску зафіксовано критерії (SHA256 `7e52cb5fb553805e7dd68c776cc4a9eda6befc8b99d5a41b4f9a43641e880c03`). Dense мав дати ≥10% і ≥1 мс економії outline CPU, ≥3% і ≥1 мс економії UnitsLayer CPU, ≥3% виграшу frame p50 та FPS. Для кожної метрики потрібні ≥3 із 4 пар в очікуваному напрямку і медіанний виграш понад більший MAD плечей. Зростання tick p99 понад +5% неприйнятне в кожному сценарії. Поріг 5% також застосовано до frame p95/p99, GPU p95, FPS/1% low і пам’яті. Таблиця подає медіани плечей і медіанний відсоток попарних змін.

| Метрика | Dense D5000 A → B | Парна Δ | C1200 A → B | Парна Δ |
| --- | ---: | ---: | ---: | ---: |
| Підкладки CPU, мс/кадр | 3,77 → 3,67 | +3,38% | 0,20 → 0,36 | +81,17% |
| Outline CPU, мс/кадр | 16,23 → 15,83 | +1,45% | 1,06 → 1,22 | +15,93% |
| UnitsLayer CPU, мс/кадр | 56,98 → 55,24 | +1,91% | 5,47 → 5,63 | +2,97% |
| Frame p50, мс | 142,17 → 137,33 | −1,43% | 22,73 → 22,85 | +0,59% |
| Frame p95, мс | 233,51 → 208,61 | +5,14% | 39,30 → 39,52 | +0,59% |
| Frame p99, мс | 301,69 → 256,70 | +5,37% | 53,15 → 52,41 | −0,96% |
| Tick p99, мс | 156,62 → 136,15 | +2,46% | 33,87 → 31,84 | −6,06% |
| FPS | 6,56 → 6,93 | −1,41% | 42,13 → 42,34 | +0,52% |
| 1% low | 3,03 → 3,11 | −7,44% | 15,92 → 15,89 | −0,02% |
| GPU viewport p50, мс | 2,30 → 1,85 | −12,79% | 1,08 → 0,64 | −41,55% |
| GPU viewport p95, мс | 2,75 → 2,52 | −4,93% | 1,54 → 1,08 | −29,74% |
| Draw calls/кадр | 613,00 → 611,50 | +0,24% | 391,00 → 391,00 | 0,00% |
| Peak RSS, MiB | 2054,13 → 2041,59 | −0,61% | 2029,83 → 2074,38 | +2,19% |
| Peak VRAM, MiB | 236,64 → 234,74 | −0,80% | 232,51 → 232,67 | +0,07% |

У dense зміни outline CPU в порядку пар становили +1,76%, +3,97%, −16,58%, +1,15%. Третя пара мала найсильніший фоновий дисбаланс на A. Піковий сторонній CPU становив 85,5% A / 21,8% B від 12 логічних CPU, головне runnable wait 55,27% / 0,50%, memory PSI 9,58% / <0,01%. У четвертій парі Node-процеси навантажували обидва плеча, піковий runnable wait був 26,05% / 25,67%. Усі плечі лишилися в аналізі. У двох перших парах зі схожим фоном, а також в обох C1200 економії outline CPU не спостерігалося. Медіанний frame p95/p99 та 1% low у dense перевищили поріг погіршення. Їхній розкид не дозволяє приписати весь зсув PoC. Tick p99 пройшов поріг в обох сценаріях. Глобальний draw-call лічильник не показав відтворюваного скорочення.

## Visual, simulation і regression gates

- **PASS.** 71/71 перевірок у кожному плечі, 15/15 пар PNG з ідентичним RGBA. Перевірено перекриття та entrenched, реальний overlay вибору армії, fog, zoom 0,49/0,52/1,11/1,65, менший viewport, night alpha, fallback без outline texture, hide/re-show, empty і re-entry з вивільненням вузла. Перші fixture-спроби виявили lazy build атласу й потребу дочекатися deferred teardown. Логи спроб збережено.
- **PASS у перевіреному scope.** 150/150 тіків rendered C1200 зі збігом NetHash, RNG, точних хешів позицій/маршрутів і watchdog, усі 8 застосованих команд ідентичні за байтами та порядком. У шести benchmark-парах збіглися кінцеві NetHash, RNG і рух, а також wire stream. Повний `Operations.save_state` мав два різні UI timestamps однієї підказки `select_barracks:f6`. Байти поза цими полями ідентичні. Окремий diagnostic dump і відтворення digest локалізували відмінність до часу показу в `Main._prompt_tick`, який іде за часом кадру. [Main](../../game/game/main/main_strike.gd)
- **PASS.** На PCK A і B без діагностичних хуків пройшли 5/5 targeted unittest без SKIP. Покрито build identity, simulation hash 28/28, HUD/camera та production selection input 36/36.
- **NOT RUN.** Фізичний Windows GUI/Profile B і Windows QA. Linux-пруфи належать пінованому стенду. Відомі teardown resource/RID diagnostics збережено в логах.

PoC `d9cf846c56617e4f8663bdc17427b7c914912af9`, ігрову дельту вилучено в `cc8cc3d51cd6f6989c6b8b917175d20e8febd7ec`. Підсумковий runtime diff з `beta` — порожній. Рекомендація власнику — залишити штатний quad batching.

Сирі докази та відновлювані команди в `~/projects/droneflames-toolchain/performance/r26/`. Архів `DroneFlames-R26-evidence.tar.gz`, SHA256 `ad6130f4c4bc96bc55794bb793fa3229b498105fbbcf0b7f3761e9eee464dc3d`. Після незалежного розпакування звірено маніфест і відтворено benchmark, RGBA та replay summaries.
