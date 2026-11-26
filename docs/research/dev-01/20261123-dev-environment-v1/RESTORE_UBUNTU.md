# Ubuntu 26.04 · відновлення

> Історичний матеріал з `toolchain/backups/20261123-dev-environment-v1.J78ugB/essential.tar.zst::droneflames-toolchain/dev-environment/docs/RESTORE_UBUNTU.md`. [Реєстр досліджень](../../INDEX.md)

1. Візьми **цілий** каталог backup з іншого фізичного SSD. Запусти `sha256sum -c SHA256SUMS.txt` у ньому перед запуском bootstrap. Потрібні Bash, Git 2.48+ з relative worktrees, Python 3.12+, zstd і GNU coreutils. Поточний перевірений комплект — Git 2.53.0, Python 3.14.4, zstd 1.5.7.
2. Вкажи відсутній або порожній каталог на Linux FS з підтримкою executable bits. Батьківський каталог має існувати. Залиши приблизно 5 ГБ для Essential + Extended і додаткове місце для наступних збірок.
3. Для Essential виконай команду без `--extended`. З `--extended` додатково відновляться dependency ZIP, ліцензії, чистий pinned Godot source і попередній контрольний пакет.

```bash
cd "/media/$USER/External SSD/DroneFlames/20261123-dev-environment-v1.J78ugB"
sha256sum -c SHA256SUMS.txt
bash ./restore-ubuntu.sh "$PWD" "$HOME/projects/DroneFlames recovered" --extended
```

Restore перевіряє SHA256 перед розпакуванням, приймає звичайні файли й каталоги та перевіряє bundle і worktree у приватному тимчасовому каталозі. `port-drone/` матиме чисту `beta` і локальну `main`. `droneflames-toolchain/performance/source` відновиться detached із staged/unstaged diff, untracked і executable modes. Сирі матеріали snapshot залишаться в `git-snapshot/`. Скрипт зупиниться перед наявними даними. Для повторного прогону обери інший destination.

```bash
workspace="$HOME/projects/DroneFlames recovered"
toolchain="$workspace/droneflames-toolchain"
"$toolchain/dev-environment/ubuntu/setup-ubuntu.sh" --workspace-root "$workspace"
"$toolchain/windows-dev/df-windows" run --check --template official
"$toolchain/windows-dev/df-windows" run --check --template patched
python3 "$toolchain/portable-sfx/package_sfx.py" verify "$toolchain/portable-sfx/artifacts/ubuntu-20261123"
git -C "$toolchain/performance/source" status --short
```

Setup друкує команди встановлення. Для повсякденної розробки потрібні Git, Python, Node/npm, Codex і системні бібліотеки Godot. Для повторного QA встанови Wine та графічні/Vulkan драйвери. На перевіреній Ubuntu `wine64` поклав `wineserver` у `/usr/lib/x86_64-linux-gnu/wine`. Якщо runner потребує його в PATH, перевір розташування через `dpkg -L wine64` і додай потрібний каталог у PATH поточного shell. Нові Wine prefixes створюються на першому запуску.

Для звичайного пакування достатньо включених editor, шаблонів і DLL. Після перевірки залежностей запусти `df-windows build --template official` або `df-windows build --template patched`. Для нового SFX потрібен MinGW POSIX. Для повторної компіляції Godot із Extended звір піновані ZIP, розпакуй їх за `mingw-patched/README.md`, встанови SCons та точні MinGW пакети з `BUILD_MANIFEST.json`, створи лінки через `ubuntu/prepare-mingw-posix.sh <mingw-patched>`, повтори preflight і fixture gate. Історичний `PREFLIGHT_PASS` служить доказом попереднього прогону. Godot source з Extended відновлюється чистим. `build.sh` звіряє Git commit і застосовує patch.

Для відтворення R01/R02 використовуй пакет і сценарій відповідного прогону. Документи `performance/R02_SCENARIOS.md` і `performance/PERFORMANCE_BASELINE.md` визначають вхідні дані й команди. При новому прогоні створи окремий output. Godot Editor/import запускай лише в фізичному shadow.
