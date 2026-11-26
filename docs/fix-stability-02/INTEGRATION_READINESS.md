# FIX-STABILITY-02B — готовність до інтеграції

2026-11-26. Baseline `beta f15224268ae6f4be06b5372ff5b7c99d5635793b`, вхід review `d84e72c61d5069ff919d6a5ebd8ca7261727b565`, runtime `6ebedf4092f09959a97b75baf232827e10ea9274`, дерево `game/` `8a140427aee1b1961b16edca467375f90d1727a9`. **GO для Draft PR і фізичного Windows QA. Merge очікує успішний QA та рішення власника.** Build identity `v0.36.11/7/v036-integration-1`, Save.FORMAT 1. [Початкові результати](FIX_STABILITY_02_RESULTS.md) · [PR summary](PR_SUMMARY.md) · [Windows QA](WINDOWS_QA_HANDOFF.md)

## Review

- **P1 · Колізія з legacy під час відкриття меню.** На `d84e72c` валідний `slot_1.save.tmp` замінювався, якщо залишився `match.save`. `231fb78` відкладає виклик штатної міграції до відсутності придатних копій під час відкриття меню або Continue. Контрприклад і логи до/після в `review/`. Код міграції та шлях її виклику під час нового save лишаються поза scope.
- **P1 · Recoverable слот виглядав вільним.** На `bd2c3da` Continue показував `.tmp`, але Saves і вибір слота нової гри вважали його порожнім. `6ebedf4` показує придатний `.tmp` як зайнятий слот із рядком для явного завантаження. Непридатний `.tmp` позначається пошкодженим.
- **P2 · Старий `.meta` змінював порядок актуальних копій.** Після заміни primary й autosave застарілі seq/date дозволяли завантажити старішу копію. Обидва шляхи тепер будують порядок зі свіжих заголовків. Якщо від завершеного слота лишився `.tmp`, ознака завершення зберігається, і глобальний Continue його пропускає. Контрприклад для трьох останніх випадків дав 7 FAIL із 161 на `bd2c3da`. [Fixture](../../tests/test_sp_continue.gd)

`SaveSlots.load_order()` збирає заголовки в порядку завантаження. Явно обрана наявна копія йде першою. Штатний порядок — звичайні копії за seq/date, `.bak`, потім `.tmp`. Глобальний Continue порівнює timestamps **перших придатних** копій незавершених слотів. Верхня межа за заголовками дозволяє пропустити тіла старіших слотів. `Save._slot_candidate()` і `Save._validated_save()` спільні для доступності, опису та фактичного завантаження. `_open()` перевіряє envelope, формат, довжини й MD5, `_decode_save()` розпаковує тіло, `_sound()` перевіряє preflight. Cache підтвердженої придатності звіряє SHA256 стисненого тіла й raw length. Після кліку loader чекає локальний writer, повторно вибирає копію й передає в restore вже прочитаний snapshot.

Read-only probe зберіг наявність і SHA256 усіх файлів fixture. Якщо всі копії зникли чи стали непридатними, Continue повертає false, а Main показує штатне повідомлення. Явне завантаження вичерпаного слота позначає його `bad`. Пізня відмова staged restore усе ще можлива після успішного preflight. Такий restore повертає false, а резерв перевіряється на етапі відбору. Атомарний спільний знімок каталогу або координація двох процесів зі спільним профілем лишаються поза контрактом. [Save](../../game/game/save.gd) · [SaveSlots](../../game/game/save_slots.gd) · [Main](../../game/game/main.gd)

## Час відкриття меню

Цільовий rendered Profile B на Ubuntu, офіційний Godot `4.7.2.stable.official.ed1daf0bf`, X11/Vulkan Mobile, RTX 4060 Laptop, 1280×720, VSync і cap off. Seed `159331`, симуляція заморожена в меню. Один штатний слот 512×512 (183 KiB) і п’ять слотів із dense D5000 snapshot (по 1,04 MiB), різні timestamps, однакові байти й видимість Continue у двох плечах. Пороги зафіксовано до прогонів у `latency/criteria.json`. Чотири пари AB/BA/BA/AB, по сім повторних відкриттів і два розігріви на сценарій та плече. Основна метрика — synchronous wall time `Menus.show_main()`. Парний Δ — медіана різниць між плечима, мс.

| Сценарій | Медіана baseline → candidate | Парний Δ / поріг | p95 Δ / поріг | Перше відкриття baseline → candidate |
| --- | ---: | ---: | ---: | ---: |
| Малий | 4,11 → 4,54 | +0,45 / +8,0 | +0,35 / +16,7 | 4,51 → 7,02 |
| Великі | 4,38 → 8,45 | +4,13 / +33,3 | +4,07 / +50,0 | 5,00 → 87,23 |

**PASS для повторного відкриття** в обох сценаріях. Медіана парного Δ до першого `frame_post_draw` −0,45 / +4,29 мс відповідно. Діапазони парних Δ для основної метрики +0,31…+0,59 та +3,74…+4,28 мс. Фоновий CPU (медіана) 20,30% → 20,03%, main-thread runnable wait 5,43 → 2,29 мс/с, peak RSS 2053 → 2062 MiB. Усі плечі, frame p95/p99/max, FPS, 1% low, process і PSI telemetry збережено. Ці кадри виміряно на замороженому меню. Tick metrics N/A. Перше відкриття великих слотів додало парні **+82,07 мс** і потребує фізичної оцінки. Поріг стосувався повторного відкриття. Першу часткову серію з idle cap та невідповідним розміром вікна збережено окремо. Повна performance matrix — NOT RUN. [Profile B](../performance.md#real-world-gaming-profile-b)

## Сумісність і gates

PR #27 перевірено на `d91d049e2fbea6057ed39438d3c4ea8a76623918`. Draft, Python/CI policy та Godot/Windows build SUCCESS, release SKIPPED. Суміщення через `git merge-tree --write-tree` і `git archive` у фізичній тимчасовій копії. Дерево `af2ec7f4b9071b5a02389821ce062c725f96210f`, `game/` `e19d3724eb29b15c0ba720e0247c6f8f722f17a9`. [PR #27 і канонічні матеріали STABILITY-01](https://github.com/ZaGOR-1/port-drone/pull/27)

| Gate | Результат |
| --- | --- |
| SP recovery | Історичні 115/115 на `ffff868` для початкового scope, 141/141 на `bd2c3da`. Зміна runtime вимагала повтору цільового fixture. Окремий PCK 168/168 після виправлення, зокрема повторний restore з точними clock, RNG і NetHash відносно прямого restore тієї самої копії. |
| Суміщений PCK | PASS. SP recovery 168/168, MP checkpoint 67/67 у семи процесах, snapshot matrix 112/112, staged restore 49/49, disk fault 6/6, saved-match gate 47/47. Host resume звірив turn, RNG і NetHash. |
| Disk restore fault, звичайний SP Save/Load, autosave isolation, build identity | PASS 6/6, 22/22, 11/11 і 3/3 на runtime кандидата. Перевикористано попередні докази для незмінених сценаріїв і меж. |
| Windows x64 portable, шаблон і DLL, packaged identity | PASS для збірки та перевірки на Ubuntu. [Точний комплект](WINDOWS_QA_HANDOFF.md) |
| Фізичний Windows, file sharing, power-loss | NOT RUN. Windows CI цього SP кандидата — NOT RUN до публікації Draft PR. |

## Відтворення та збереження доказів

`~/projects/droneflames-archive/FIX-STABILITY-02B/` містить `SHA256SUMS`, Git bundle, контрприклади, PCK, checkpoint та SP fixtures, усі серії меню, телеметрію і Windows ZIP. `review-followup/` містить фінальні gates. `FIX-STABILITY-02/` містить baseline PCK і первинні докази. Baseline PCK SHA256 `6a6ba98baa85c72d5bb1b5d22c2b54f7e39faf41a87330f9b10aad884f4bcb92`, фінальний PCK для меню та disk gates `ac72859fe2be7b21d240a867aad70f6d1e99203ede1424859092d123fed5f236`. [Політика доказів](../DEVELOPMENT_WORKFLOW.md#постійне-збереження-доказів)

```bash
archive="$HOME/projects/droneflames-archive/FIX-STABILITY-02B"
prev="$HOME/projects/droneflames-archive/FIX-STABILITY-02"
export DF_GODOT="$HOME/projects/droneflames-toolchain/official-4.7.2/godot"
export PYTHONDONTWRITEBYTECODE=1
sp=6ebedf4092f09959a97b75baf232827e10ea9274
mp=d91d049e2fbea6057ed39438d3c4ea8a76623918
replay=$(mktemp -d "$HOME/projects/fix-stability-02b-replay.XXXXXXXX")
git clone -b fix/sp-continue-recovery "$archive/FIX-STABILITY-02B.bundle" "$replay/source"
git -C "$replay/source" fetch "$archive/FIX-STABILITY-02B.bundle" refs/heads/fix/mp-host-checkpoint
mkdir "$replay/combined" "$replay/disk" "$replay/windows"
(cd "$archive" && sha256sum -c SHA256SUMS)
python3 "$archive/latency/run.py" "$DF_GODOT" "$prev/baseline.pck" \
  "$archive/review-followup/after/sp-continue.pck" "$replay/latency"
python3 "$archive/latency/telemetry-summary.py" "$replay/latency"
"$archive/combined/run.sh" "$replay/source" "$sp" "$mp" "$replay/combined"
"$prev/replay-disk-gates.sh" "$replay/source" "$archive/review-followup/after/sp-continue.pck" "$replay/disk"
"$archive/review-followup/build-windows.sh" "$replay/source" "$sp" "$replay/windows" "$(dirname "$DF_GODOT")"
```

Для контрприкладу з `review-followup/counterexample.gd` запусти штатний wrapper у фізичній копії `bd2c3da`, підставивши цей fixture як `tests/test_sp_continue.gd`. Для позитивного прогону використай fixture на `6ebedf4`. Прогони використовують синтетичні профілі й свіжий MP checkpoint для TTL.
