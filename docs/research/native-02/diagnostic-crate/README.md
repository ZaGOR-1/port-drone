# NATIVE-02 · ArmyFire.ImpactUnits.candidates()

> Історичний матеріал з `toolchain/native-02/diagnostic-crate/README.md`. [Реєстр досліджень](../../INDEX.md)

Дослідницький PoC зі збирання й сортування рангів. База 0.36.9, `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035`. Toolchain і параметри gdext успадковано з NATIVE-01 `b19c66c80e1d93e7546f3f2d3ed79fd7470bd9cc`.

## Контракт

- GDScript будує індекс R18 та визначає межі й порядок обходу клітинок. GDScript перетворює відібраний bucket на `PackedInt32Array` при першому використанні в поточному поколінні індексу. Всі копії packed buckets очищаються в `invalidate()` або разом зі звільненням `ImpactUnits` наприкінці batch.
- Один виклик `NativeImpactRanks.gather` на індексований impact передає `Array[PackedInt32Array]`. gdext отримує packed handles, Rust позичає їхні slices і копіює ранги в один вихідний `PackedInt32Array`. Ядро сортує цілі ранги на місці. Однакові значення залишаються в результаті. Повторення одного `Unit` у registry зберігається як окремі ранги.
- На межі виклику є лише ранги та packed handles. Native-об'єкт не зберігає handles, slices чи стан симуляції між викликами. GDScript читає `Unit` за поточним registry, перевіряє відстань, застосовує ефекти й відновлює обхід суфікса при вкладеному виклику. За відсутності класу працює початковий GDScript-збір і сортування. Якщо R18 повертає `null`, виконується чинний повний обхід.
- У базовому `game/` клас опційний. Для експерименту його реєструє окремий manifest у фізичній копії гри. Reload вимкнено. Release використовує `panic = "abort"`, тому помилка всередині native бібліотеки може завершити процес.

## Локальна збірка

Використати готові Rust/Cargo 1.100.0 та Windows GNU target з NATIVE-01 і офіційні Godot 4.7.2 runtime з INT-10. З каталогу `research/native-02`, з `CARGO_HOME`, `RUSTUP_HOME` і `PATH` NATIVE-01 та окремим `CARGO_TARGET_DIR`:

```sh
cargo fmt --check
cargo test --offline --locked --release
cargo build --offline --locked --release
cargo build --offline --locked --release --target x86_64-pc-windows-gnu
```

Для копії `game/` додати manifest `native02.gdextension` в `native-02/` і рядок `res://native-02/native02.gdextension` в `.godot/extension_list.cfg`. Запакувати копію штатним `tools/packproj` із фізичної копії інструмента. Поруч з runtime/PCK покласти `native-02/libnative02.so` або `native-02/native02.dll` відповідно до платформи. Скрипт `prepare.py` у handoff відтворює тестові Linux PCK з R18B harness. Варіант A збирається з заданого коміту beta, B з цієї гілки, варіант fallback з цієї гілки без manifest.

## Кандидати для окремого дослідження

Попередні заміри взято з R16, таблиця `detail-heavy` для D5000. Це історичний профіль. Залишкову вартість кожної підфази у production 0.36.9 треба спочатку оновити на відповідному сценарії.

| Кандидат | R16, exclusive | Пакет і ризик |
| --- | ---: | --- |
| `Army._acquire`, геометрія запиту і підбір із просторових buckets | 6,48 мс/тик, 8,18 inclusive | Багато кандидатів і повторні просторові обходи. Варто дослідити компактні координати, packed flags і стабільний порядок row/column/insertion. Дипломатію, smoke й остаточний вибір залишити в GDScript на першому етапі вимірювання. Перевірити свіжість живих даних і рівні дистанції. Пакет має амортизувати передачу, не додаючи FFI на кандидата. |
| `Vision.update`, пакетне заповнення масок у `_recompute` | 3,16 мс/тик | Однорідні компактні входи й дві маски. Можна замінити серію `Image.blit_rect_mask` однією операцією над буферами. Потрібні побайтова рівність масок обох шарів, clipping і вартість завантаження текстур. Перевірити всіх споживачів visibility і не змінювати cadence. |
| `Army._advance`, окремий вимірюваний геометричний підкрок | 11,28 мс/тик, 16,57 inclusive | Повний метод тісно пов'язаний з `Unit`, шляхами, повторним маршрутом і пошкодженням укріплень. Розглядати окремий пакет для чистої арифметики лише після доказу стабільної фази читання, достатньої частки CPU та еквівалентності Godot `Vector2`. Очікуваний виграш залежить від вартості збору розкиданих полів і синхронного commit у registry order. |

Джерела історичних замірів у `/home/zagor/projects/droneflames-toolchain/performance/r16.Z7ODtxEb/reports/` (`tables.md`, `ARCHITECTURE.md`).
