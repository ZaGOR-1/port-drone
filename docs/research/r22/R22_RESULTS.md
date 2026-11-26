# R22 · Unit render geometry · NO_GO

> Історичний матеріал з `toolchain/performance/r22/handoff/R22_RESULTS.md`. [Реєстр досліджень](../INDEX.md)

База `f629882296a3419b2e1dc298619f83072c1320f9`, версія 0.36.11. Ізольований worktree `/home/zagor/projects/port-drone-r22` і гілка `perf/unit-rendering-batching`. PoC прискорює частину CPU підготовки, проте повний земний прохід із контурами не досяг 20% скорочення CPU. Screening завершено після однієї пари на сцену.

## Межі й вибір

R16 локалізував витрати в симуляції та підготовці спрайтів на головному потоці. R12 повторно використовував source rectangles та anchors у словниках, які створював на кожному ground pass. Його gate був NO_GO. У нових обох D5000 вимірах усі видимі наземні юніти вміщалися в одну групу atlas texture (у середньому 1596,74 і 4790,20 видимих; A/B збіглися). У baseline повторні обчислення в shadow і body submission забирали разом 4,23 і 15,01 мс/кадр inclusive. Outline із повторним sprite selection та anchor lookup займав 5,22 і 18,36 мс/кадр.

У B метадані чотирьох фіксованих ground atlases перетворюються при завантаженні на 186 типізованих описів anchor і 1766 frame rectangles. Shadow і body беруть готові rectangles. Outline використовує той самий anchor. Для відсутнього запису або кадру поза індексом діє чинний шлях. Живий вибір atlas, типу, кадру, position, visibility, tint та draw order збережено. Підготовка коштувала сумарно 0,9276 і 0,9290 мс CPU на завантаження. Кеш живе стільки, скільки atlas. Щокадрових побудов та очищень структур не додано. Деструктор atlas окремо не таймовано. RSS/VRAM виміряно для цілісного процесу.

2D batching Forward Mobile вже групує команди. Тестований hot path має одну texture group на проході. Злиття атласів не усуває виміряний group cost всередині цього шляху. MultiMesh потребував би окремого дизайну UV, порядку прозорих спрайтів, outline/selection, culling і буферів інстансів. Вимірів, які доводять їх виграш, немає. [Godot 2D batching](https://docs.godotengine.org/en/4.7/engine_details/architecture/internal_rendering_architecture.html) · [MultiMesh](https://docs.godotengine.org/en/4.7/classes/class_multimesh.html)

`_pre_frame` спочатку фільтрує за viewport, fog, станом та hold. У щільній сцені більшість юнітів видима. Пошук у grid симуляції потребував би доказу свіжості позицій та порядку. Ці вікна мають по одному simulation tick на кадр. Збереження всього проходу за dirty-time не отримало підстав. Новий кеш обмежено вхідними atlas metadata. Драйверні texture switches і wait на GPU fence окремо не вимірювалися. Для висновку використано групи в production, загальні draw calls, окремі CPU/GPU viewport таймери та telemetry VRAM.

## Profile B

Official Godot 4.7.2, Linux runtime INT-12, RTX 4060 Laptop, Vulkan Forward Mobile, X11, 1280×720, camera (2629,199; 1236,892), zoom 1,111111, VSync/cap off. Для кожного плеча 45 warm-up та 90 виміряних тіків. Однакові A/B seed, wire commands, стан, viewport і камера. Preflight не застосовувався. CPU scopes використовують thread CPU clock, містять алокації, culling, підготовку, командні submissions і знищення локальних структур у виміряних функціях. `UnitsLayer` total складається з inclusive `_process`, `_draw` і `_draw_outline` без подвійного рахунку дочірніх scopes. CPU viewport і GPU viewport наведено окремо. Це renderer timers, вони не додаються до script scopes для відновлення frame wall.

| Показник | D5000 A → B | Щільний D5000 A → B |
| --- | ---: | ---: |
| UnitsLayer CPU, мс/кадр | 21,58 → 20,30 | 65,51 → 57,89 |
| `_ground_units` + `_draw_outline`, мс/кадр | 14,38 → 13,07 (−9,11%) | 49,61 → 42,98 (−13,36%) |
| `_ground_units`, мс/кадр | 9,16 → 8,09 | 31,25 → 26,17 |
| `_draw_outline`, мс/кадр | 5,22 → 4,98 | 18,36 → 16,81 |
| `_pre_frame`, мс/кадр | 3,86 → 3,96 | 9,77 → 9,21 |
| `_draw`, мс/кадр | 12,41 → 11,26 | 37,26 → 31,76 |
| Simulation CPU, мс/тик | 58,72 → 57,86 | 71,32 → 66,24 |
| Render frame setup CPU p50, мс | 0,044 → 0,042 | 0,047 → 0,043 |
| Viewport CPU / GPU p50, мс | 2,24 / 1,70 → 2,43 / 1,50 | 4,63 / 2,25 → 4,62 / 2,28 |
| Draw calls p50, весь кадр | 445 → 449,5 | 609,5 → 607 |
| FPS / 1% low | 8,94 / 3,31 → 8,98 / 4,07 | 5,46 / 2,70 → 5,96 / 2,36 |
| Frame p95 / p99 / max, мс | 212,09 / 242,29 / 302,47 → 193,62 / 231,04 / 245,58 | 300,80 / 357,37 / 370,77 → 236,51 / 286,05 / 423,67 |
| Tick p95 / p99 / max, мс | 143,18 / 174,30 / 232,29 → 140,42 / 152,18 / 166,35 | 134,70 / 177,38 / 199,42 → 127,42 / 138,69 / 145,43 |
| Peak RSS, MiB | 1988 → 2049 | 2044 → 2081 |
| GPU VRAM p50, MiB, NVIDIA global | 555 → 557 | 557 → 557 |
| Сторонній CPU p50 | 22,51% → 25,27% | 33,58% → 23,50% |

Головний висновок — у цих сценах велика вартість CPU підготовки та симуляції при суттєво нижчому GPU time. Скриптовий geometry-path (shadow, body, outline) скоротився на 13,45% і 15,78%. Повна економія ground+outline 1,31 і 6,63 мс/кадр. Навіть сам `_ground_units` дав приблизно 11,62% і 16,24%, менше 20%. У щільному single pair FPS +9,03% і 1% low −12,49%. Варіація шуму та CPU системи обмежує причинну інтерпретацію FPS. Вища RSS у B є спостереженням single pairs. RenderingServer video allocation близько 236,39 MiB у чотирьох прогонах. VRAM NVIDIA включає інші процеси.

Відповідно до gate, додаткові performance пари, D2100/Late E controls, після-GO regression suite, ENet, official QA builds/smoke та PR — NOT RUN. Фізичні Windows, LAN і Steam — NOT RUN. Відомі Godot teardown warnings лишаються у логах.

## Цільова коректність

- Visual 43/43 на плечі. Вісім PNG A/B збіглися попіксельно разом із ordered ground draw traces. Сцени покривають fog, outline, night tint, legacy atlas, viewport edge, zoom, resize, layering, рухові фази, faction colors і selection.
- Реальний lifecycle 10/10 на плечі. Новий unit входить у render list, DEAD виходить, zoom/resize і дисковий Save/Load відновлюють відображення. Populated teardown R12 warnings відтворилися в A та B.
- Детермінізм 180/180 тіків. Ідентичні NetHash, RNG, траси команд, wire bytes, покрокові позиції й маршрути та фінальні snapshots. D5000 `e217255c133ec9fb`, щільний D5000 `498b24b5e913463d`. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1, tick rate 30 і версія 0.36.11 збережені.

HEAD лишився на базі. PoC та локальний запис стану збережено у робочому дереві. SHA256 та diff є у handoff. `beta` і `main` збережені, stash `40a9f64` на місці.
