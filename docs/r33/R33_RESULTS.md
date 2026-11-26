# R33 · Повторний nearest scan укріплень у Army._advance

**NO-GO на feasibility.** База `acd976086e6833306d3b6c3d711b72df425204de`, 0.36.11. П’ять docs-only комітів перенесли дерево документації R30–R32 з `adc18fb`. Критерії та порядок пар зафіксовано до вимірювань у `42b65d7`. R13 у своїх вікнах D2100/C1200 не спостерігав fort scan. R23 виміряв inclusive `_advance` як один scope без атрибуції ціни nearest scan. [Критерії](FEASIBILITY_GATE.md) · [R13](../research/r13/R13_RESULTS.md#джерела-витрат) · [R23](../r23/R23_RESULTS.md#актуальні-вузькі-місця-у-03611) · [R30](../r30/R30_RESULTS.md#3-army--застосовувати-шкоду-до-вже-знайденої-клітини-укріплення)

## Послідовність та межа еквівалентності

- `_advance` доходить до fort scan лише на гілці руху, для `not u.foot()` і непорожнього `fort_cells`. Він читає кожен слот 3×3 у порядку y, потім x. Після пошуку в dictionary обидва типи teeth з непорожнім `f.cells` ставлять slowdown ×0,4. Фільтру за owner, war чи HP у цій точці немає. Закріплене `tq` перетворюється в координату центра, а `damage_line` повторно обходить увесь масив `f.cells`. [Army](../../game/game/army.gd)
- Якщо `tq` входить у **поточний** `f.cells`, його центр має точну нульову квадратну відстань на підтримуваних розмірах карти. Інша координата має додатну відстань. Дубль тієї самої координати дає той самий ключ HP і видалення. Загальний caller `Army._damage` передає довільну точку або `f.center_px()`, тому загальне API має зберегти повний fallback і перший запис за strict `dd < bd`. Soft teeth проходять той самий скан, а його результат використовується лише для hard teeth. [Military](../../game/game/military/mil_build.gd)
- Для hard teeth зберігається `cell_hp.get(best, TEETH_HP)`, віднімання того самого `TEETH_CRUSH * dt` і видалення при `hp <= 0`. `remove_line_cell` знімає map entry, клітину, HP і occupancy, оновлює nav, за видимості викликає dust VFX, перераховує bounds та синхронно викликає `forts_changed`. Поточне штатне підключення ставить redraw. VFX і підписники можуть виконувати синхронні callbacks. Тому кожний наступний слот читається заново після попереднього damage/removal. Збережений список сусідів переносив би lookup через мутацію. [Military](../../game/game/military/mil_build.gd) · [GameWorld](../../game/game/game_world.gd) · [Межі callbacks R27C](../r27/R27_RESULTS.md#r27c--відновлення-коректності)
- `_dig_done` вставляє завершену клітину і в `f.cells`, і в `fort_cells`. Pending використовує `dig_cells`. Build/join перевіряє геометрію та ownership, скасування pending і demolition використовують свої шляхи. Strike, гранати та projectiles можуть видалити клітини між викликами. Save серіалізує поля Military через `Save.dump`, включно з індексом, і graph refs до Facility. У restore `Save.fill` відновлює поля, але цей шлях не доводить взаємної відповідності legacy dictionary й геометрії. Наявність HP теж її не доводить. Щоб змінити gameplay path, потрібні доказ membership або guard і чинний fallback на кожній неоднозначності. [Save](../../game/game/save.gd) · [Military restore](../../game/game/military.gd) · [ArmyFire](../../game/game/army_fire.gd)

## Feasibility на живому бою

INT-12 Linux QA, Godot 4.7.2 `ed1daf0bf`, RTX 4060 Laptop, Vulkan Mobile, 1280×720, seed 20261016 та 150 simulation ticks від старту replay. Діагностична фізична копія додала штатні `build_line` з типовим початковим HP і стартовим розгортанням змішаних військ. Heavy D2100 мав три фронти, по два hard і одному soft ряду по 26 клітин на фронт. C1200 мав один фронт, два ряди по 18 клітин. Після setup діяли чинні рух, стрільба й wire orders. CPU nearest включає ініціалізацію `best` і дистанційний цикл усередині crush. HP, ruin/nav, VFX, callback і запис лічильників поза цим scope. Час CPU inclusive `_advance` включає можливу плату інструментації. Дані знято через наявний thread CPU clock.

| Сценарій | Виклики `_advance` | Nearest hard / soft | Відвідини клітин | Inclusive `_advance`, мс/тік | Nearest CPU, мс/тік | Частка inclusive |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| D2100, fortified | 142 323 | 1 659 / 903 | 65 118 | 4,533 | 0,0319 | 0,703% |
| C1200, fortified | 109 260 | 0 / 108 | 1 944 | 3,701 | 0,00127 | 0,034% |

- У heavy є **750 / 798 / 1 014** контактів на трьох фронтах. Виміряно 44 тіки з контактом, середній nearest на них **0,1087 мс**. Пік **0,2145 мс** на тику 9 при 66 пошуках і inclusive `_advance` 8,497 мс. Максимум кількості пошуків за один тик — 106. Відомі ряди почали з 26 клітин, найкоротший live scan обійшов 2. Звідси нижня межа втрати геометрії становить 24 клітини принаймні в одному ряду. Жодне видалення у виміряному вікні не було завершене самим crush, конкретне зовнішнє джерело видалень не атрибутовано.
- **Оптимістична межа економії** для цього бою — **0,0319 мс/тік і 0,703%** за вилучення всього nearest loop у hard і soft. Вартість guard, fallback та підтримки лише зменшує цей бюджет. Навіть пік нижче абсолютного порога **≥1 мс/тік**, середнє нижче обох порогів **≥1 мс/тік і ≥5%**. Концентрацію на довших лініях або більшу частку hard у пізній грі не перевіряли.
- У heavy медіана та максимум стороннього CPU від усіх логічних CPU становили 9,15% / 19,68%, main runnable wait — 0,29% / 0,83%, memory PSI — 0,00% / 0,43%. Збережено raw CPU, metrics і scheduler telemetry обох прогонів.

## Перевірки й рішення

- **PASS, live selection check.** Усі **2 670** сканів на двох реплеях повернули саме клітину з `fort_cells` у момент crush. Це спостереження для цих двох сценаріїв. Кінцеві NetHash і RNG збережено разом із CRC команд, heavy `a2c159340ede9421` / `40559950`, light `9c00b717f1e4a136` / `789249786`.
- **PASS, baseline adversarial 10/10.** Fixture виконав strict tie довільної точки, нульову відстань від члена лінії, default HP, soft teeth без шкоди, stale dictionary entry з наявним ключем HP, синхронне видалення й заміну наступного слота, порядок `forts_changed` та незмінний RNG. Контрприклад показав, що `fort_cells[tq]` і `cell_hp.has(tq)` можуть співіснувати з відсутністю клітини в `f.cells`. Штатний пошук у такому разі завдає шкоди іншій клітині. Callback fixture підтвердив, що при руйнуванні наступний слот читається після синхронної заміни.
- **NO-GO.** Штатний runtime збережено. Runtime PoC, paired A/B, candidate NetHash/replay, restore, host/peer, guards tick/frame p99, FPS, RSS/VRAM і Windows QA — **NOT RUN** після провалу feasibility. `game/`, `tests/` і `tools/` збігаються з `acd9760`. Версія 0.36.11, PROTO 7, SIM_REV `v036-integration-1`, Save FORMAT 1.

## Відтворення і збереження

Канонічний архів `~/projects/droneflames-archive/R33/`. Маніфест `SHA256SUMS` містить 146 записів, SHA256 `ff55b934732a95fb253a1bf21b472ae6965774707d8f0197449d24bbedde8e39`. Збережено три точні діагностичні PCK, патчі, fixture, counterexample, raw JSONL, CPU/telemetry та журнали спроб. Перший replay не створив укріплень, а наступна перевірка setup виявила ранній вихід. Після явного створення типізованого списку рядів і верифікації кількості укріплень обидва final-плечі завершилися. Перші спроби виключено з оцінки та збережено в архіві.

```bash
set -o pipefail
archive="$HOME/projects/droneflames-archive/R33"
cd "$archive"
sha256sum -c SHA256SUMS
run=$(head -1 launch.log)
python3 summarize.py "$run/raw" | cmp summary.json -
./run-fixture.sh "$run/stage-bench-r33"
./reproduce.sh /path/to/r33-checkout
```
