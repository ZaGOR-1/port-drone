# NATIVE-01 · Rust + GDExtension

> Історичний матеріал з `toolchain/native-01/NATIVE-01-handoff.tar.gz::handoff/source/research/native-01/README.md`. [Реєстр досліджень](../INDEX.md)

Локальний PoC від `beta` 0.36.9, `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035`. Один crate. radius.rs (`src/radius.rs`) обробляє звичайний Rust slice, lib.rs (`src/lib.rs`) реєструє `NativeRadius`, harness.gd (`harness/harness.gd`) містить GDScript reference, differential checks і мікрозаміри. Експеримент не підключено до гри.

## Контракт

- Вхід `PackedFloat64Array` з парами x/y, а також окремі f64 для центра і радіуса. Результат `PackedInt32Array` містить нульові індекси за порядком входу, включно з окремими індексами для однакових координат. `[]` означає відсутність збігів, `[-1]` — помилку аргументів. Непарна довжина, понад `i32::MAX` записів, NaN, Inf, координати за межами ±1e100 або радіус поза [0, 1e100] відхиляються. Помилка відкидає часткові результати.
- Обидва алгоритми порівнюють `dx*dx + dy*dy <= r*r` у binary64 із включною межею. Межа 1e100 прибирає переповнення цієї формули. Округлення й можливе underflow на дуже малих значеннях належать до семантики f64. Немає fast-math, явно керованого SIMD чи потоків. Скалярна формула має іншу семантику, ніж production `Vector2.distance_to`.
- Вхідний packed array передається через gdext. Rust позичає його read-only через `as_slice()` на час виклику без копіювання елементів. Ядро формує `Vec<i32>` із ростом за потреби. Адаптер виділяє Godot packed array і переносить у нього індекси з окремого буфера Rust. Жоден slice чи engine object не зберігається між викликами. `unsafe impl ExtensionLibrary` потрібен для реєстрації gdext, з типовими lifecycle hooks. Release `panic = "abort"` виключає unwind через FFI. Неочікувана паніка в release завершує процес. Reload вимкнено. [Реалізація PackedArray у gdext 0.5.6](https://github.com/godot-rust/gdext/blob/v0.5.6/godot-core/src/builtin/collections/packed_array.rs)

## Відтворення

Rust **1.100.0 stable**, Cargo **1.100.0**, `godot`/gdext **0.5.6**, `gdextension-api` **0.5.1**, `Cargo.lock` і опція `api-4-7`. Використано мінімальну генерацію bindings із API 4.7 stable. Ініціалізація gdext підтвердила `API v4.7.stable.official, runtime v4.7.2.stable.official` на обох платформах. Мінімальна версія Rust для crate — 1.94. Rust/Cargo встановлено через rustup у спеціальні `CARGO_HOME` і `RUSTUP_HOME` без sudo та змін системного PATH. Windows target `x86_64-pc-windows-gnu`, наявні MinGW GCC 13-win32 і Wine 10.0. [rustup](https://rust-lang.github.io/rustup/installation/) · [Реліз gdext 0.5.6](https://github.com/godot-rust/gdext/releases/tag/v0.5.6) · [Сумісність API/runtime](https://godot-rust.github.io/book/toolchain/compatibility.html) · [Official Godot 4.7.2](https://github.com/godotengine/godot-builds/releases/tag/4.7.2-stable)

З каталогу цього crate, із Rust 1.100.0 в PATH. `official` вказує на каталог із Linux editor і Windows release template, перевіреними за `tools/ci/godot-4.7.2.json` базового репозиторію. Команди використовують фізичну копію harness.

```bash
set -euo pipefail
official=/home/zagor/projects/droneflames-toolchain/official-4.7.2
run=$(mktemp -d)
export CARGO_TARGET_DIR="$run/target"
export DF_NO_UPDATE=1 XDG_DATA_HOME="$run/data" XDG_CONFIG_HOME="$run/config" XDG_CACHE_HOME="$run/cache"

cargo fmt --check
cargo test --locked --release
cargo build --locked --release
cp -r harness "$run/project"
mkdir -p "$run/project/bin" "$run/project/.godot"
cp "$CARGO_TARGET_DIR/release/libnative01.so" "$run/project/bin/"
printf '%s\n' res://native01.gdextension > "$run/project/.godot/extension_list.cfg"
timeout 30 "$official/godot" --headless --path "$run/project"
# Під звичайною desktop-сесією, у вікні
timeout 30 "$official/godot" --path "$run/project" --resolution 640x360 -- --benchmark \
    2>&1 | tee "$run/benchmark.log"
python3 summarize.py "$run/benchmark.log"

# Windows cross-build та Wine smoke після завершення замірів
rustup target add x86_64-pc-windows-gnu
cargo build --locked --release --target x86_64-pc-windows-gnu
cp "$CARGO_TARGET_DIR/x86_64-pc-windows-gnu/release/native01.dll" "$run/project/bin/"
mkdir -p "$run/windows/bin"
timeout 30 "$official/godot" --headless --path "$run/project" \
    --export-pack Windows "$run/windows/Godot.pck"
cp "$official/windows_release_x86_64.exe" "$run/windows/Godot.exe"
cp "$run/project/bin/native01.dll" "$run/windows/bin/"
(cd "$run/windows" && timeout 90 env WINEPREFIX="$run/wine" WINEARCH=win64 \
    WINEDEBUG=-all wine ./Godot.exe --headless)
```

Логи harness мають містити `NATIVE01_CHECKS 34/34` (або `139/139` для замірів). Обидва release-бінарники лишаються у копії проєкту під час Linux-експорту Windows PCK. Це дозволяє редактору зареєструвати `NativeRadius` своїм .so під час імпорту. Windows template завантажує DLL із `bin/` поряд із sidecar PCK. Перший запуск Windows template з `--path` відхилено через його build flags. Фінальний smoke використовує PCK та завершується з кодом 0.

## Результати

**PASS** для PoC. Три Rust release unit tests. Official Linux x86_64 та official Windows x64 release template під Wine пройшли по 34/34 перевірок із коректним виходом. Для 5 000 записів обидва повернули SHA256 `d69fd7d2b13ddd746f1878b3953feb5492637356d4a17e4ab57ac74509009ad7` від 1 368 впорядкованих індексів. Перевірено фіксовані результати, включну межу, precision loss на f32, некоректні дані, 16 повторних запитів і незалежне володіння результатом. Фізичний Windows, production MP/determinism і повний regression suite — NOT RUN.

### Мікрозаміри Profile B

У desktop-сесії Ubuntu, вікно 640×360, після першого намальованого кадру. 16 warm-up, сім груп по 128 викликів для кожного розміру. Reference і round-trip чергуються за порядком. Вхід і розміщення точок однакові, центр (7, −9), радіус 300. Без host preflight чи закриття програм. Це мікрозаміри часу виклику за звичайного навантаження desktop.

Медіани, мкс на виклик (по 7 груп).

| Записи | Збіги | GDScript | Rust core | Round-trip | Підготовка | Підготовка + round-trip | Вхідний slice | Вихідний packed array |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 000 | 276 | 113,078 | 1,202 | 1,500 | 7,977 | 9,703 | 0,036 | 0,084 |
| 2 000 | 545 | 225,781 | 2,231 | 2,586 | 15,914 | 19,805 | 0,037 | 0,099 |
| 5 000 | 1 368 | 554,219 | 5,277 | 5,914 | 39,078 | 46,453 | 0,039 | 0,165 |

У 5 000 записів round-trip становив 5,672–6,555 мкс, а з пакуванням входу — 45,430–48,703 мкс. Саме перетворення вхідного масиву домінувало у повному native шляху. Harness пройшов 139/139 перевірок із контролями замірів.

16 інтервалів семплера. Сторонній CPU 3,70–23,82% (медіана 13,54% доступних CPU), runnable wait головного потоку 0–0,53%, memory PSI some 0–4,14%. Працювали VS Code, Chrome, Discord, Steam та інший процес `godot`; один інтервал з активністю `winedevice.exe`. У вибірках не зафіксовано VM або компілятора. Mesa повідомила про невдалий DRI3 для NVIDIA, контекст OpenGL фактично створився на AMD Radeon 760M. Таймери вимірюють elapsed time викликів у цьому сеансі.

`prepare` міряє конвертацію готового `Array[float]` у packed array з його алокацією та звільненням. Побудова синтетичних вихідних даних поза таймером. `core` включає валідацію, геометрію та формування `Vec<i32>`. Діагностичний виклик окремо заміряє доступ до вхідного slice та створення/копіювання вихідного packed array. Дуже короткі фази включають витрати читання годинника. Звичайний round-trip охоплює передачу аргументів, обчислення, повернення та споживання розміру результату, включно зі звільненням тимчасових значень. Обгортки FFI не хронометровано всередині gdext. Різниця окремих таймерів лише наближено відображає їхню вартість. `prepare + round-trip` виміряно одним таймером. Сирі вибірки містять кожну групу. Ці виміри не дають прогнозу FPS.

## Кандидат для NATIVE-02

Виміряти **збір рангів із bucket-ів і сортування за початковим порядком** у `ArmyFire.ImpactUnits.candidates()` як одну фазу. Використано три candidate-плеча інтеграційного R18B Profile B після R17. `army_fire.gd` між `b33d49cf0a70ed01cd36d0aae79b93497475ab31` і production `93bd6af` має той самий Git blob. У щільному D5000 медіана фази 135,54 мс CPU за 90 тіків (129,85–144,23 мс), 866 запитів і 981 457 рангів. Медіана частки 2,00% simulation CPU головного потоку та 7,32% повного impact CPU. У D5000 без ущільнення — 41,09 мс і 0,77% simulation CPU. У Late E фазу не зафіксовано. Це ціль для щільних боїв. Саме сортування в dense D5000 становить 72,72 мс, тому оцінювати слід і збір рангів. [Production код](../../../game/game/army_fire.gd#L46)

У фазі можна працювати з цілочисельними межами комірок і впорядкованими рангами. Після наявної побудови індексу фаза не потребує `Unit` або викликів Godot objects. Пакування bucket-ів доцільно вимірювати з урахуванням повторного використання в межах чинного lifetime індексу. Варіант із повним копіюванням bucket-ів на кожен impact може втратити виграш. Саме повернення 981 457 i32 за 90 тіків становить близько 3,74 MiB без накладних витрат межі. Ризик для детермінізму задають точний порядок, дублікати `Unit` під різними рангами і чинна інвалідація при reentry. Кандидат зберігає побудову/інвалідацію, fallback, `Vector2.distance_to` і callbacks у GDScript. Це обмежує поверхню підтримки Rust до одного запиту за scalar data. Придатність такого перенесення потребує окремого парного заміру повної вартості та authoritative differential QA.

Рекомендація спирається на заміри R18B, які повторно використано з `/home/zagor/projects/droneflames-toolchain/performance/r18b-profile-b.gFaqgQ6i/reports/profile-b.json`. Вимірювальний PCK був інструментований. Це повторне використання доказу на тому самому gameplay-коді, з відмінностями версії, UI й локалізації після інтеграції. Фізичне Windows профілювання та повторний production прогін у NATIVE-01 — NOT RUN.

## Handoff

Джерела, lockfile, перевірені .so/.dll, fixture PCK, сирі вибірки, логи й SHA256 у `/home/zagor/projects/droneflames-toolchain/native-01/handoff/`. Там же збережено вимірювальний R18B звіт і перевірений manifest Godot. Для відтворення підстав відповідні official Godot binaries.
