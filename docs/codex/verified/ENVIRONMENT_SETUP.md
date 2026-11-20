# Середовище розробки — Phase 2, 2026-11-19

HEAD `af1b4c975564bac916db079d8470c2394d4920e5`. Один checkout у `/home/zagor/projects/port-drone`; Windows-каталог нижче містить лише build artifacts, не другий Git-репозиторій. Game source, protocol7, FORMAT1, native DLL і tracked `.godot/` незмінні.

## Перевірені компоненти

| Компонент | Фактичний стан |
|---|---|
| Ubuntu | 26.04.1 LTS, WSL2 x86_64, kernel6.18.54.1, glibc2.43 |
| Python / Git | 3.14.4 /2.53.0; лише стандартна бібліотека Python |
| CPU, видимий WSL | Ryzen5 7640HS,6 logical CPUs; це ліміт VM, не повний опис фізичних ядер |
| Linux editor | `godot_dl/godot`,146414384 bytes, `4.7.2.stable.official.ed1daf0bf` |
| Windows release template | `godot_dl/windows_release_x86_64.exe`,109268480 bytes; зібраний EXE повідомляє ту саму версію/hash |
| Linux shared libs | ldd: librt/pthread/dl/m/libc/loader знаходяться, missing немає; engine реально виконав suite |
| Windows | Windows11 Pro x64, version10.0.26300, build26300; PowerShell та WSL interop працюють |
| GPU / D3D12 | RTX4060 Laptop driver32.0.16.2101; Radeon760M driver31.0.14005.22001; d3d12.dll наявна. GUI/GPU rendering NOT RUN |
| Steam | steam.exe наявний; account/config не читали, реальний Steam API у tests не ініціалізували |
| Native | Ті самі3 tracked AMD64 DLL; Windows process реально завантажив усі3. Linux відповідників немає |

Жодних apt/pip packages не встановлювали. На початку Phase2 `godot_dl/` уже містив обидва binary; попередня відсутність у Phase1 більше не актуальна. Виконаний fetch успішно використав кеш. Окремо завантажені офіційні archives для повної integrity-перевірки; editor/template не замінювалися іншою версією.

## Команди Ubuntu

```sh
cd ~/projects/port-drone
python3 tools/fetch_godot.py godot_dl
godot_dl/godot --version
ldd godot_dl/godot
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tools/check_performance.py --out dist/phase2_baseline/regression
python3 tools/build.py --godot godot_dl/godot \
  --template godot_dl/windows_release_x86_64.exe \
  --version 0.33.2.3 --repo "" --out dist/phase2_baseline/windows-x64
```

Для цього запуску build/test commands додатково обгорнуті `dist/phase2_baseline/run_check.py`: command/cwd/start/elapsed/exit JSON, stdout+stderr log, окремі XDG_DATA_HOME/CONFIG_HOME/CACHE_HOME, `DF_NO_UPDATE=1`. Built-in performance runner теж створює тимчасові ізольовані XDG paths. Не запускати `--path game` в editor/import mode: це могло б змінити tracked import cache. Використовували main-pack або packer project.

## Integrity та походження

Джерело: [офіційний Godot4.7.2 release](https://github.com/godotengine/godot/releases/tag/4.7.2-stable), metadata GitHub API за exact tag, без latest і без токенів. Прочитані повні archives, SHA256 порівняні з asset.digest із HTTPS API; ZIP-member CRC та extracted bytes зіставлені з кешем. Це не незалежна перевірка signing identity: API/archives належать одному upstream.

| Об'єкт | SHA256 |
|---|---|
| Linux ZIP,77860424 bytes | `cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4` |
| Export TPZ,1281349702 bytes | `f298490b8d44d934be425a5a65a51bf15f422428b229a06a6e11d9ffea248011` |
| Cached Linux editor | `8d106cbe6144c2dc7e881d61d2429c1a8a76e6b22ef48bd5e48dcf934953f71e` |
| Cached Windows template | `d34d36f3be1a6c49c56525ae86469b92e4f417ddf0b43cf00dd80c385c4b0562` |

`tools/fetch_godot.py` сам digest не перевіряє; verification виконана окремим audit helper. Evidence: `dist/phase2_baseline/{official_release,engine_integrity,godot_cache_initial,dependencies}.json`, `logs/{fetch,engine_info,engine_integrity}.log`. Archives залишені в ignored `downloads/`, близько1.36GB. Digest metadata й commands продубльовані тут для відновлення після очищення dist.

## Windows user data та локальний запуск

Launcher задає APPDATA/LOCALAPPDATA лише для свого процесу й дітей; `override.cfg` біля EXE додає окремий namespace `DroneFlames-Phase2-af1b4c9`. Реально створена тестова user data directory під `test-user/Roaming/DroneFlames-Phase2-af1b4c9`; реальні saves не копіювали/читали/змінювали.

[Godot4.7 data paths](https://github.com/godotengine/godot-docs/blob/4.7/tutorials/io/data_paths.rst) пояснює custom user directory. Для точного pin додатково звірені [OS_Windows::get_config_path/get_user_data_dir](https://github.com/godotengine/godot/blob/4.7.2-stable/platform/windows/os_windows.cpp) та [завантаження зовнішнього override.cfg](https://github.com/godotengine/godot/blob/4.7.2-stable/core/config/project_settings.cpp). `_sc_` для export template не використовували; `--user-data-dir` у CLI цього engine немає.

Release template не підтримує standalone `--script`; це підтверджено його `--help` і невдалою першою спробою. Для GDScript fixtures використовується Linux editor; Windows release smoke — звичайний startup із `--headless --quit-after240`. Інструкції й обмеження — [WINDOWS_TESTING](WINDOWS_TESTING.md).
