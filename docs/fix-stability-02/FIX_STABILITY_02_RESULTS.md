# FIX-STABILITY-02 — SP Continue recovery

2026-11-26. **Локальний PASS.** Baseline `beta f15224268ae6f4be06b5372ff5b7c99d5635793b`, версія `0.36.11`. Код і постійний fixture у `ffff868beb044b766189523a835f53340d048bca`, дерево `game/` `9f152d73985419d84799e993d0ca6d71d12610c3`. Джерело ST01-02 — `research/stability-01` `1f438977dcf04e28cea5dbbdb6a48134395010cd`. Канонічний звіт STABILITY-01 переносить PR #27. [PR #27](https://github.com/ZaGOR-1/port-drone/pull/27) · [Постійне збереження доказів](../DEVELOPMENT_WORKFLOW.md#постійне-збереження-доказів)

## Першопричина і виправлення

Індекс слота не враховував `.tmp` і міг приховати `.bak` за наявності запису про пошкоджений primary. Той самий індекс дозволяв показати Continue для заголовка несумісного або обрізаного файла. Збережені fixtures STABILITY-01 відтворили обидва первинні дефекти. Continue повернув false, а прямий `Save.load_slot` прочитав той самий snapshot з `game_time=42`.

Наявні `load_order`, `Save._read` і `Save._sound` тепер спільні для видимості, заголовка Continue і завантаження. У слоті пріоритет збережено. Явно вибрана копія йде першою, далі звичайні копії за seq/date, `.bak`, потім `.tmp`. Між слотами порівнюється timestamp першої придатної копії кожного незавершеного слота. Позначка `bad` дозволяє перевірити копії знову. Після натискання вибір перевиконується на актуальних файлах. Restore використовує вже прочитаний snapshot.

`Save.has_save()` і `Save.save_info()` читають дані й кешують лише metadata в пам’яті. Legacy migration лишається окремою штатною дією перед побудовою меню або завантаженням. Код міграції, snapshot format і staged restore збережено. Головне меню використовує одне читання для кнопки й заголовка. [Save](../../game/game/save.gd) · [SaveSlots](../../game/game/save_slots.gd)

## Перевірки

| Gate | Результат |
| --- | --- |
| Вихідні fixtures STABILITY-01 `continue` і `backup` | Baseline FAIL для продукту. В обох випадках Continue приховав придатну копію, прямий loader відновив її |
| Постійна матриця Continue | Baseline 20 FAIL із 115, кандидат 115/115 PASS |
| Primary, відсутній або пошкоджений primary із `.tmp` або `.bak`, обидві fallback-копії, autosave та explicit preferred | PASS |
| Усі копії пошкоджені чи відсутні, несумісний заголовок, обрізане тіло, закритий слот і відновлення після `bad` | PASS |
| Видалення чи заміна файла між перевіркою й Continue, повтор через Main | PASS. Перевірки доступності зберегли наявність і SHA256 усіх файлів fixture |
| Restore NetHash/RNG | PASS. Кожне відновлення порівняно зі штатним прямим restore тих самих байтів |
| Disk restore fault, PR10 Save/Load, v0.36 autosave isolation, source build identity | PASS 6/6, 22/22, 11/11 і 3/3 відповідно |
| Фізичний Windows і power-loss | NOT RUN |

Межі. Continue використовує штатний preflight. Успіх пізніх стадій залежить від перевірок самого restore. Браузер історії збережень і далі показує рядки зі свого metadata index. Перевірка придатності тепер читає тіло копії. Час відкриття меню на великих слотах у цьому етапі не вимірювався. `PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1` і версію `0.36.11` звірено.

## Відтворення та архів

Ubuntu, офіційний Godot `4.7.2.stable.official.ed1daf0bf`, seed `159331`, синтетичні ізольовані профілі. У `~/projects/droneflames-archive/FIX-STABILITY-02/` збережено baseline PCK, PCK кандидата, контрольні saves, первинні STABILITY-01 cases, сирі логи, маніфест і самодостатній Git bundle. PCK baseline SHA256 `6a6ba98baa85c72d5bb1b5d22c2b54f7e39faf41a87330f9b10aad884f4bcb92`, кандидат `3c29dad229f84ee2d2a8ac4fd9a20d0514e06ae742821992cacfe66a50fe0b4b`. [Постійний fixture](../../tests/test_sp_continue.gd) · [Python runner](../../tests/test_sp_continue.py)

```bash
archive="$HOME/projects/droneflames-archive/FIX-STABILITY-02"
export DF_GODOT="$HOME/projects/droneflames-toolchain/official-4.7.2/godot"
export PYTHONDONTWRITEBYTECODE=1
replay=$(mktemp -d "$HOME/projects/fix-stability-02-replay.XXXXXXXX")
mkdir "$replay/baseline"
"$archive/replay-baseline.sh" "$PWD" "$replay/baseline"
export DF_TEST_LOG_DIR="$replay/candidate"
python3 -m unittest discover -s tests -k test_sp_continue -k test_autosave_isolation -k test_build_identity -v
"$archive/replay-disk-gates.sh" "$PWD" "$DF_TEST_LOG_DIR/sp-continue.pck" "$replay"
```
