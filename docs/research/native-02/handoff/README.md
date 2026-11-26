# NATIVE-02 handoff

> Історичний матеріал з `toolchain/native-02/handoff/README.md`. [Реєстр досліджень](../../INDEX.md)

Застосувати `native-02.patch` до 0.36.9 `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035`. Результати й мовні контракти описано в `source/research/native-02/README.md`. `SHA256SUMS` охоплює payload цього каталогу. Окремий список `evidence/test-binary-sha256.txt` ідентифікує використані PCK, runtime й зовнішні залежності.

## Повтор замірів і QA

Скопіювати `harness/` для нового прогону. Встановити `DF_R09_TOOLCHAIN` на локальний toolchain із `official-4.7.2/godot`, `DF_R09_RUNTIME` на готовий INT-10 0.36.9 Linux runtime з `addons/`, `DF_N02_BASE` на чистий worktree beta та `DF_N02_SOURCE` на worktree PoC. Використати вже наявні `CARGO_HOME`, `RUSTUP_HOME` і `PATH` з NATIVE-01. Для роботи зовні цього ПК потрібні наявні Linux debug DLL для Steam/WebRTC у `DF_N02_DEBUG_LIBS` (реальні файли .so), а для Wine smoke шлях до INT-10 Win64 DLL у `provenance/windows-runtime-path.txt`. Python harness зафіксовано для Linux desktop / NVIDIA RTX 4060 Laptop, GPU index 1. При відтворенні на іншому хості звірити вибір GPU, кількість CPU для похідних показників та умови ізоляції профілів.

```bash
set -euo pipefail
export PYTHONDONTWRITEBYTECODE=1
mkdir -p raw reports target/release
cargo build --manifest-path "$DF_N02_SOURCE/research/native-02/Cargo.toml" \
    --offline --locked --release --target-dir "$PWD/target"
python3 prepare.py minimal-A "$DF_N02_BASE"
python3 prepare.py minimal-B "$DF_N02_SOURCE"
python3 prepare.py proof-A "$DF_N02_BASE"
python3 prepare.py proof-B "$DF_N02_SOURCE"
python3 run-profile.py screen-D5000-A D5000 --pack minimal-A --warm 45 --ticks 90 --budget 150
python3 run-profile.py screen-D5000-B D5000 --pack minimal-B --warm 45 --ticks 90 --budget 150
python3 run-profile.py screen-dense-D5000-B D5000 --pack minimal-B --warm 45 --ticks 90 --budget 150 --dense
python3 run-profile.py screen-dense-D5000-A D5000 --pack minimal-A --warm 45 --ticks 90 --budget 150 --dense
python3 report-native.py
# Після перспективного screening
bash run-series.sh
bash run-editor-fixtures.sh
bash run-replay.sh
python3 verify-native.py
# Після підтвердженого цільового виграшу
bash run-controls.sh
bash run-diagnostic.sh
python3 report-native.py
```

Для повторного аналізу записаних даних скопіювати або з'єднати посиланням `evidence/raw/` з `harness/raw/`. Покласти скрипти в фізичну копію перед новим пакуванням. Архів містить вихідний code/lockfile, відтворювані fixtures і дані замірів. Для повтору використати готові official runtime та залежності INT-10. `run.log`, `config.json`, `result.json`, явно записані snapshot та CSV-вибірки зберігаються в `evidence/raw/`.
