## Зміни

- SP Continue використовує той самий порядок і preflight, що й loader. Явно вибрана копія йде першою. Звичайні копії впорядковані за seq/date, далі йдуть `.bak` і `.tmp`.
- Continue повторно вибирає копію на момент кліку за актуальним вмістом. Застарілий `.meta` не змінює порядок. Слот із одним придатним `.tmp` видно в Saves і під час вибору слота нової гри. Відкриття меню й Continue зберігають придатний `.tmp` за наявності legacy save.
- Меню перевикористовує preflight за ідентичністю стисненого тіла та пропускає тіла слотів, які вже не можуть перемогти за timestamp.

## Перевірки

- SP recovery 168/168 PASS. Disk restore fault 6/6, SP Save/Load 22/22, autosave isolation 11/11, source identity 3/3 PASS.
- У суміщеному дереві з PR #27 SP recovery, MP checkpoint, snapshot restore і saved-match identity PASS.
- Rendered Profile B, повторне відкриття меню PASS. Парний Δ медіани +0,45 мс для малого та +4,13 мс для п’яти великих слотів. Перше відкриття п’яти великих додало +82,07 мс.
- Windows x64 portable і packaged identity перевірено під час збірки. Фізичний Windows і power-loss — NOT RUN. Merge очікує фізичний QA та рішення власника.

Baseline `beta f152242`, runtime `6ebedf4`. Версія `0.36.11`, PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1. Канонічний звіт STABILITY-01 міститься в PR #27. [Review і сирі докази](INTEGRATION_READINESS.md) · [Windows QA та команди власнику](WINDOWS_QA_HANDOFF.md)
