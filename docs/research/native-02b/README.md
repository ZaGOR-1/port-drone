# NATIVE-02B handoff

> Історичний матеріал з `toolchain/native-02b/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

`native-02b.patch` застосовується до beta `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035`. Результати описано в `source/research/native-02b/README.md`. `SHA256SUMS` охоплює весь payload. `evidence/test-binary-sha256.txt` ідентифікує зовнішні runtime та експериментальні PCK.

Для нового прогону зробити фізичну копію `harness/`. Вказати `DF_N02B_BASE` на чисту beta, `DF_N02B_SOURCE` на worktree кандидата, `DF_R09_TOOLCHAIN` на каталог з `official-4.7.2/godot` і `DF_R09_RUNTIME` на готовий Linux runtime INT-10 0.36.9. Для editor fixtures `DF_N02B_DEBUG_LIBS` вказує на наявні debug .so Steam/WebRTC. Використати `CARGO_HOME`, `RUSTUP_HOME` й `PATH` з NATIVE-01. GUI harness налаштовано на X11 і Vulkan з RTX 4060 Laptop (GPU index 1). На іншій машині звірити GPU index та параметри telemetry. Production runtime та Godot editor повторно не збиралися.

```bash
set -euo pipefail
export PYTHONDONTWRITEBYTECODE=1
mkdir -p raw reports
cargo build --manifest-path "$DF_N02B_SOURCE/research/native-02b/native/Cargo.toml" \
  --offline --locked --release --target-dir "$PWD/target"
bash run-screen.sh
bash run-diagnostics.sh
python3 report-acquire.py
bash run-proof.sh
python3 verify-proof.py
```

Для повторного аналізу записаних даних з'єднати `harness/raw/` з `evidence/raw/` у відновленій копії й створити `harness/reports/`. PCK відтворюються скриптами. Вимірювальні оверлеї `army.gd` та `target_acquisition.gd` додаються під час пакування фізичних копій. Діагностика Rust працює на окремій копії crate, її таймери відсутні у звичайному B. Фіксовані історичні контрольні хеші походять із R18B.
