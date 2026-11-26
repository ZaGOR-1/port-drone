# FIX-STABILITY-01B — готовність до інтеграції

2026-11-26. Baseline `beta f15224268ae6f4be06b5372ff5b7c99d5635793b`. Вхід review `2ca2152a899fb047d4cfea41b7000c1caef387df`, кандидат runtime `6c778b355b8a6c1e32a1c653c360f074cc356aa0`, дерево `game/` `b111611d64a855d04e72e2cf1b485acd674a0bc9`. **GO для Draft PR і фізичного QA. Готовність до merge і bump 0.36.12 заблокована відкритим Windows QA.** Build identity `v0.36.11/7/v036-integration-1`, Save.FORMAT 1. [FIX-STABILITY-01](FIX_STABILITY_01_RESULTS.md) · [Versioning Policy](../VERSIONING_POLICY.md)

## Review і виправлення

1. **P1 · Пошкоджений snapshot міг затерти придатну копію.** На `2ca2152` запис того самого розміру з ушкодженим внутрішнім snapshot проходив відбір primary. При наступній ротації він замінював валідний `.bak`. Fixture дав 6 FAIL із 13, включно з повторними спробами. Кандидат перевіряє snapshot і допустимий turn штатним preflight, відсіює непридатний primary під час вибору і ротації та після закриття `.tmp` звіряє length prefix і всі байти із серіалізованим буфером. Для несумісної версії залишається штатне повідомлення. [NetConfig](../../game/net/net_config.gd)
2. **P2 · Маркер міг приховати втрату checkpoint після commit.** На `2ca2152` рівність із `_saved_turn` завершувала save успіхом без перевірки файла. Кандидат дедуплікує лише за наявності придатного checkpoint із тим самим turn та identity. Після видалення файла дві ін’єктовані відмови відкриття повернули помилку, а наступна спроба того самого turn успішно відновила запис. Маркер оновлюється після публікації. [NetSession](../../game/net/net_session.gd) · [Fixture](../../tests/test_mp_checkpoint.gd)
3. `open`, результати `store_*`, `get_error()` після `flush()` та перевідкритий файл перевіряються до ротації. Godot має `void` API для `flush()` і `close()`. Windows backend може видалити давніший backup перед `MoveFileW`, у цій точці поточний primary ще існує. Після ротації читач відновлює стан прямо з `.bak`, без зворотного rename. `.tmp` може лишитись після переривання або невдалого видалення. Читач його ігнорує, наступний запис замінює. [Godot Windows rename](https://github.com/godotengine/godot/blob/ed1daf0bf/drivers/windows/dir_access_windows.cpp#L288-L325) · [Godot Windows FileAccess](https://github.com/godotengine/godot/blob/ed1daf0bf/drivers/windows/file_access_windows.cpp#L353-L376)

## Regression gates

| Перевірка | Результат |
| --- | --- |
| Same-size corruption, точний readback, open/short write, повторні відмови rename, дедуплікація і retry | PASS, 67 assertions у семи процесах разом із відновленням |
| Штатний `NetSession.resume_host()` з primary і з одного `.bak` | PASS, ізольований ENet host. Обидва відновили turn 10, наступний turn 11, той самий стан, RNG і NetHash |
| Частково записаний `.tmp` та `.tmp` без primary/backup | PASS, реконструйований дисковий стан |
| Завершення процесу після staging, після ротації і після публікації | PASS, реальний Linux SIGKILL. Новий процес прочитав turns 10 / 10 / 11. Після ротації primary був відсутній, а `.bak` байт у байт збігся з seed |
| Snapshot restore, SP Save/Continue і версійний saved-match gate | PASS після fix, разом із source build identity 3/3 |
| Godot regression на точному PCK | PASS, 2 476 assertions |
| ENet loopback admission і 11 v0.36 regressions | Успадкований PASS FIX-STABILITY-01. Протокол, код приймання й симуляція збігаються в цих сценаріях |
| Windows x64 portable, SHA256 і identity із вбудованого PCK | PASS на Linux для пакування та ідентичності |
| Фізичний Windows, Windows file sharing, живий LAN/Steam resume та power-loss | NOT RUN |

Межі. Резерв може повернути попередній збережений turn. Обидві копії лежать на одному диску. Перевірка readback охоплює байти, які повернула ОС. Full restore може відмовити з інших причин, зокрема через недоступний transport. Для спільного профілю одночасних writer-процесів гарантій немає. Явне видалення прибирає резерв першим. Якщо ОС відмовляє, гра попереджає в логах і зберігає копії до наступної спроби.

## Відтворення та докази

Архів `~/projects/droneflames-archive/FIX-STABILITY-01B/` містить первинний контрприклад `review-input/`, усі raw логи `post-fix/` і `checkpoint-final/`, процесні трасування й новий запуск читача `process-interrupt/`, Windows комплект, `SHA256SUMS` і самодостатній Git bundle. Linux Godot офіційний `4.7.2.stable.official.ed1daf0bf`. PCK кандидата SHA256 `b2ad6ea8e6ac95ccf2fa9933fd440494c9e66ed3c316da02b136ee576ce259e3`. Для нового прогону користуйся свіжим синтетичним seed, бо TTL checkpoint становить три доби.

```bash
archive="$HOME/projects/droneflames-archive/FIX-STABILITY-01B"
export DF_GODOT="$HOME/projects/droneflames-toolchain/official-4.7.2/godot"
export PYTHONDONTWRITEBYTECODE=1
replay=$(mktemp -d "$HOME/projects/fix-stability-01b-replay.XXXXXXXX")
export DF_TEST_LOG_DIR="$replay/tests"
python3 -m unittest discover -s tests -k test_mp_checkpoint -k test_snapshot_restore \
  -k test_sim_revision -k test_build_identity -v
"$archive/process-interrupt/run.sh" "$DF_TEST_LOG_DIR/mp-checkpoint.pck" \
  "$DF_TEST_LOG_DIR/mp-checkpoint-seed.save" "$replay"
DF_STEAM_MOCK=0 python3 tools/check_performance.py --godot "$DF_GODOT" \
  --pack "$DF_TEST_LOG_DIR/mp-checkpoint.pck" --mode regression --out "$replay/core"
```

[Windows QA та команди власнику](WINDOWS_QA_HANDOFF.md) · [PR summary](PR_SUMMARY.md)
