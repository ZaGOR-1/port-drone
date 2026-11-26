# FIX-STABILITY-01 — MP host checkpoint

2026-11-26. Baseline `beta` `f15224268ae6f4be06b5372ff5b7c99d5635793b`, версія `0.36.11`. STABILITY-01 перенесено окремим docs-only комітом `e042258db394cc3a781df315636af93d9657cc6f` з `1f438977dcf04e28cea5dbbdb6a48134395010cd`. Runtime і regression tests зафіксовано в `df6e5659b4a28261440eb476cc9ed463dc3ce907`, дерево `game/` `3a2513c41b161b0779ffc1f127c66f740329268f`. [Першоджерело ST01-01](../stability-01/STABILITY_01_RESULTS.md#st01-01--невдале-збереження-хоста-знищує-або-блокує-checkpoint--p1)

**Verdict: PASS для локального кандидата.** Обидва збої відтворено на baseline. Фізичне Windows-приймання лишається відкритим.

## Першопричина і виправлення

- Baseline ігнорував результат запису й перейменування, видаляв придатний primary перед публікацією і позначав turn збереженим до запису. Оригінальний fixture скоротив придатний checkpoint з 186 472 до 32 768 байтів. В окремому сценарії помилка відкриття лишила `_saved_turn = 10`, повторний запис turn 10 було пропущено, turn 11 записався. [Збережені сценарії STABILITY-01](../stability-01/STABILITY_01_RESULTS.md)
- Кандидат записує той самий length-prefixed Godot Variant у `net_match.save.tmp`. Враховує результати запису, `get_error()` після `flush()` і фактичний розмір після закриття. Після цього перевіряє перенесення primary у `.bak` і публікує в порожнє ім’я primary. Якщо фінальний rename не вдався, читач знаходить попередній checkpoint за `.bak`. Придатний primary має пріоритет. Залишковий `.tmp` ігнорується читачем, наступна спроба його перезаписує. Явне очищення прибирає резерв перед primary. SP writer не дає потрібних гарантій через неперевірений backup rename і slot-specific metadata. [NetConfig](../../game/net/net_config.gd) · [SP writer](../../game/game/save.gd)
- На Windows пінований Godot видаляє файл призначення перед `MoveFileW`. На Linux для одного filesystem застосовує POSIX `rename`. В обох випадках нові байти не записуються поверх останньої копії. Якщо Windows встигне видалити давніший backup і відмовить при його заміні, поточний primary залишається. Linux `flush()` не повертає статус `fflush`, тому окремо перевіряємо довжину після закриття. [Godot Windows rename](https://github.com/godotengine/godot/blob/ed1daf0bf/drivers/windows/dir_access_windows.cpp#L288-L325) · [Godot Linux rename](https://github.com/godotengine/godot/blob/ed1daf0bf/drivers/unix/dir_access_unix.cpp#L379-L406) · [Godot Linux FileAccess](https://github.com/godotengine/godot/blob/ed1daf0bf/drivers/unix/file_access_unix.cpp#L312-L322)
- `_saved_turn` просувається лише після публікації. Успішний turn і далі дедуплікується. Нова lockstep-сесія скидає маркер, resume відновлює його з checkpoint. На виході хост підтверджує гостям збереження за наявності опублікованого checkpoint цієї сесії, включно з попереднім підтвердженим turn після відмови. [NetSession](../../game/net/net_session.gd)

## Перевірки

| Gate | Baseline | Кандидат |
| --- | --- | --- |
| Legacy checkpoint зі справжнім snapshot Main | PASS | PASS |
| Linux `RLIMIT_FSIZE` на 32 КіБ і на один байт до повного запису | FAIL, первинний файл обрізано | PASS, файл байт у байт і snapshot читається |
| Помилка open, retry turn 10, дедуплікація, скидання маркера нової сесії, NetHash/RNG | FAIL, маркер просунувся і retry пропущено | PASS |
| Відмова ротації та публікації, перервана ротація, обрізаний primary, успішна заміна, явне очищення | NOT RUN, розширені випадки кандидата | PASS |
| SP Save/Continue, невдалий та повторний restore, legacy defaults, replay і збіг NetHash/RNG | У цій задачі NOT RUN | PASS, snapshot failure matrix, Main integration і disk recovery |
| ENet loopback admission і версійний saved-match gate | У цій задачі NOT RUN | PASS, чинна пара прийнята, несумісні identities відхилено |
| v0.36 regression, включно з autosave, Navy/UrbanHold restore і hash coverage; загальний Godot regression | У цій задачі NOT RUN | PASS, 11 тестів v0.36 і 2 476 assertions Godot regression |
| Фізичний Windows, живий двопірний LAN/Steam resume/rejoin, аварійне вимкнення живлення | NOT RUN | NOT RUN |

Постійний checkpoint fixture пройшов 34 assertions у п’яти ізольованих процесах. Ідентифікатори `PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1` і `0.36.11` звірено. Зміни стосуються локальної публікації MP checkpoint. Матеріали трьох інших дефектів залишаються у звіті STABILITY-01.

Межі доказу. Основна й резервна копії залежать від того самого диска. Відпрацювання помилок і моделювання переривання між rename підтверджено на Linux. Power-loss durability, примусове завершення процесу на кожній межі та блокування файловими handles на фізичному Windows лишаються NOT RUN. Резерв є попереднім збереженим turn і може бути старішим за поточну симуляцію. Перевірка контейнера при виборі копії відкидає обрізані файли. Повна перевірка тіла snapshot лишається в штатному restore. Діагностика недоступних debug addons і teardown збережена в сирих логах.

## Відтворення і архів

Ubuntu, офіційний Godot `4.7.2.stable.official.ed1daf0bf`, SHA256 `8d106cbe6144c2dc7e881d61d2429c1a8a76e6b22ef48bd5e48dcf934953f71e`. Seed Main `159331`; ізольовані профілі, updater і opening вимкнено, Steam mock вимкнено. Виконуй з checkout кандидата та в нових каталогах результатів. [GDScript fixture](../../tests/test_mp_checkpoint.gd) · [Python runner](../../tests/test_mp_checkpoint.py)

```bash
archive="$HOME/projects/droneflames-archive/FIX-STABILITY-01"
export DF_GODOT="$HOME/projects/droneflames-toolchain/official-4.7.2/godot"
export PYTHONDONTWRITEBYTECODE=1
mkdir -p "$HOME/projects/fix-stability-01-replay"/{baseline,checks}
export DF_TEST_LOG_DIR="$HOME/projects/fix-stability-01-replay/checks"
"$archive/replay-baseline.sh" "$PWD" "$HOME/projects/fix-stability-01-replay/baseline"
python3 -m unittest discover -s tests -k test_mp_checkpoint -k test_snapshot_restore \
  -k test_network_identity -k test_sim_revision -k test_v036_regressions -v
DF_STEAM_MOCK=0 python3 tools/check_performance.py --godot "$DF_GODOT" \
  --pack "$DF_TEST_LOG_DIR/mp-checkpoint.pck" --mode regression --out "$DF_TEST_LOG_DIR/core"
python3 tools/build.py --print-version
```

Baseline PCK SHA256 `6a6ba98baa85c72d5bb1b5d22c2b54f7e39faf41a87330f9b10aad884f4bcb92`. Кандидат PCK SHA256 `0390145a9b39117cd7ad4e5d0665fd3584dc97f968f3220cb88a158af5b76d18`. Первинне відтворення `baseline-stability.log`, контрприклади до/після `verified-baseline/`, точний PCK, checkpoint-файли, raw логи й JSON у `verified/`, Git bundle і маніфест лежать у `~/projects/droneflames-archive/FIX-STABILITY-01/`. Відновлення через `sha256sum -c SHA256SUMS` і `git clone -b fix/mp-host-checkpoint FIX-STABILITY-01.bundle <новий-каталог>`. [Політика збереження доказів](../DEVELOPMENT_WORKFLOW.md#постійне-збереження-доказів) · [Реєстр](../research/INDEX.md#після-archive-01)
