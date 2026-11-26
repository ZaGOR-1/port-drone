# R07 · Handoff

> Історичний матеріал з `toolchain/int04.l9g7ydNd/r07/README.md`. [Реєстр досліджень](../../INDEX.md)

У каталозі handoff виконай `sha256sum -c SHA256SUMS.txt`. `summary.json`, `frames.csv` і `raw/` містять оброблені та сирі дані. Маніфести QA і версії ELF, PCK, EXE та DLL збережено в `provenance/`. Runtime і QA-бінарники використовуються з DEV-02 та окремих каталогів збірки.

## Повторення Late E

Задай `DF_R07_TOOLCHAIN` із шляхом до DEV-02, `DF_R07_REPO` із шляхом до чистого фізичного worktree на SHA з `BASE`, і `DF_R07_RUNTIME` із шляхом до official Linux package з ELF та addons. Після `python3 prepare.py A` створи B через `python3 prepare.py B /path/to/candidate/operations.gd`. Вихідні каталоги pack і run мають бути новими. Для пари виконай `./run.sh A e-1-A g` та `./run.sh B e-1-B g`. Друга пара B/A і третя A/B. `python3 analyze.py` збирає три пари. Прапор `R07_VERIFY=1` під час підготовки додає аудит слідів і слотів, а `DF_R06_TRACE=1 DF_R02_SPOT_AUDIT=1 ./run.sh A verify-A h` запускає перевірку. Окремий профіль `R07_SPANS=1` розділяє просторові витрати всередині та зовні search.

Коміти в `BASE` і `CANDIDATE` достатні для відновлення джерел зі стандартного Git або з `portable/source`. Для package build використовуй `df build --platform linux --profile official --revision <candidate>` і відповідний Windows виклик. R06 probe застосовується лише до тимчасової фізичної копії.

Додаткова A/B-пара із сенсорами не входить у головну таблицю. За час запуску A/B температура CPU 59,88–78,25 / 67,88–77,88 °C, зайнятість CPU хоста 11,7–61,3 / 16,8–62,9%, GPU 46–48 / 47–49 °C та завантаження GPU 0–50 / 0–45%. Виміри охоплюють завантаження й replay. NetHash збігся. Дані в `evidence/telemetry-*.csv` та `raw/telemetry-*/`.

У додатковому C1200 B/A, поза основною Late E вибіркою, tick p95 31,63 → 28,79 мс і p99 76,21 → 74,95 мс. NetHash знову збігся. FPS у цій парі 31,30 → 34,15 проти 30,09 → 28,71 у першій C-парі. Зміна FPS у C1200 також INCONCLUSIVE.
