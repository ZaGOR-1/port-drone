> Історичний onboarding. Відомості про походження збережено нижче. Поточний стан гілок, оточення й QA наведено в [PROJECT_STATE](../../PROJECT_STATE.md).

# Факти про checkout DroneFlames

Дата аудиту: 2026-11-19 UTC. Джерело істини — файли робочого дерева на HEAD `af1b4c975564bac916db079d8470c2394d4920e5`, гілка `main`, origin `https://github.com/ZaGOR-1/port-drone.git`. Віддалений стан і CI цього коміту не перевірялися.

## Межі достовірності

Виконано повний файловий інвентар, автоматичний аналіз усього тексту tracked-файлів і поглиблене читання ключових потоків. **Повне ручне семантичне читання всіх 174121 рядків GDScript не завершене.** Пофайлові статуси й прочитані діапазони наведено у [FILE_COVERAGE.md](FILE_COVERAGE.md). Слово verified означає підтверджені наведені факти, а не сертифікацію всього продукту. Бінарні ресурси не декомпілювалися і не виконувалися.

## Репозиторій

| Категорія | Кількість / обсяг |
|---|---:|
| Tracked-файли | 881 / 113710698 bytes |
| Текст, включно з NUL-terminated `.import` | 598 / 9601961 bytes / 337676 рядків |
| Бінарні ресурси | 283 / 104108737 bytes |
| GDScript | 267 файлів / 174121 рядок |
| Top-level функції, лексичний аналіз | 7351 |
| `class_name` | 130; дублікатів немає |
| JSON | 86; усі декодуються |
| Import + scene remap | 209 + 1; усі цільові файли наявні |
| Шейдери | 8 `.gdshader`; compilation NOT RUN |
| Переклади | 4 `.po`, 91814 рядків |
| Ресурси | 89 `.ctex`, 114 `.oggvorbisstr`, 2 `.mp3str`, 4 `.fontdata`, 67 `.ogv`, 1 `.png` |
| Native | 3 Windows x86-64 DLL; 3 `.gdextension` descriptors |
| UID | tracked `.uid` немає; є binary `.godot/uid_cache.bin` |

Початковий `repository_audit.py` класифікує за розширенням: не розпізнає `.po`, `.crt`, `.remap` як текст і читає `.import` без урахування кінцевого NUL. Його 245796 рядків — інший спосіб підрахунку, не повний обсяг тексту. Уточнений аналіз класифікує UTF-8, для `.import` знімає лише кінцевий NUL **у пам'яті**. Файли на диску не нормалізувалися.

## Карта директорій

| Шлях | Вміст / tracked-файли |
|---|---|
| `game/` | 863 файли; runtime scripts, import cache, binary project/scene, assets |
| `game/game/` | Симуляція, сутності, Main, save codec |
| `game/world/` | Генерація, камера, шари рендерингу, шейдери |
| `game/ui/` | HUD, Menus, UI24 sheets, локалізований інтерфейс |
| `game/net/` | Lockstep, LAN/WebRTC, account/API, TLS, допоміжний signaling server |
| `game/pc/` | Desktop adaptation, Steam transport/mock, updater |
| `libs/` | 3 DLL / 8358040 bytes; build додає окремим ZIP |
| `tools/` | 10 tracked-файлів: packer/build/fetch/decompiler/release/performance |
| `tests/` | 1 tracked-файл `test_release.py`; додатковий untracked `test_pack_scripts.py` |
| `.github/` | 1 workflow `build.yml` |
| `docs/` | 1 tracked-файл `performance.md`; пакет `codex/` спочатку untracked |

## Середовище й стан дерева

Linux WSL2 x86_64, kernel `6.18.54.1-microsoft-standard-WSL2`, Ubuntu26.04.1/Python3.14.4/Git2.53.0. У Phase1 Godot не був доступний; на початку Phase2 обидва binaries уже були в `godot_dl/`. Fetch/cache, version та official archive/member SHA256 тепер **PASS**: editor і Windows release template4.7.2.stable.official.ed1daf0bf. Pin не змінений. Деталі — [ENVIRONMENT_SETUP](ENVIRONMENT_SETUP.md).

Phase2 current baseline:18 Python tests,2458 Godot regression checks,264 runtime script loads,863 PCK file hashes/main-scene instantiate,7 synthetic save checks, Linux і Windows headless startup **PASS** у вказаному scope. Windows EXE зібраний, усі3 DLL реально завантажені; GUI/audio/FPS/real Steam **NOT RUN**, clean-shutdown diagnostics **FAIL**. Повний звіт — [RUNTIME_BASELINE](RUNTIME_BASELINE.md). Manual coverage тепер75 FULL/25 PARTIAL/498 AUTO/283 METADATA; нові FULL — Bridge, Opening, LangPicker.

На старті `git status --short` показував лише untracked overlay: `.serena/`, `AGENTS.md`, manifest/start/checksums файли, `docs/codex/`, дублікати документації в `docs/`, `prompts/`, `templates/`, `scripts/`, `tools/codex/`, `tests/test_pack_scripts.py`. Вони існували до аудиту; їх не прибрано й не додано до index. Нова документація також поки untracked. Зміни tracked-файлів перевіряються хешами початкового інвентарю.

## Походження й права

[README](../../../README.md) прямо описує похідний порт із closed-beta Android APK і залишає права на гру та графіку оригінальним авторам. Доказу дозволу на розповсюдження під час аудиту не отримано; окремого tracked LICENSE немає. Це фіксація відомостей checkout, не юридичний висновок. Код/ресурси не завантажувалися в зовнішні сервіси. Steam AppID 480 — тестовий Spacewar (`game/pc/steam_net.gd:12`).

## Розбіжності з початковим пакетом

- Невизначеність `main.tscn` закрита статично й у Phase2 runtime: engine завантажив/інстанціював remapped672-byte PackedScene як Main із res://game/main.gd.
- `project.godot` у грі відсутній; конфігурація — 1632-byte ECFG `project.binary`, packer має власний текстовий `project.godot`.
- Файли ланцюгів лежать у `game/game/main/` та `game/game/game_world/`, не у скороченому `game/main/` із деяких стартових нотаток.
- Menus має 4307 рядків, не приблизно 3965 зі старого огляду; актуальні anchors визначені на цьому SHA.
- `docs/performance.md` описує історичну версію 0.33.2.2. Поточні `pc/version.cfg` та `Menus.VERSION` — 0.33.2.3; історичні 2422/11 PASS не є результатом цього запуску.
- Фактична мережа включає online/ranked, host rotation, reconnect, backend API; Steam — доданий транспорт, не весь multiplayer.
- Позначка «відсутні res://» із CSV не доводить runtime missing: треба враховувати імпорт, remap, feature tags, optional paths і динамічні шаблони.

## Артефакти доказів

`dist/codex_audit/`: `inventory.json`, `inventory.md`, `files.csv`, `symbols.csv`, `extends.csv`, `resource_references.csv`, `source_analysis.json`, `source_summary.json`, `all_file_metadata.csv`, `resolved_resources.json`, `data_validation.json`, `project_binary_metadata.json`, `native_metadata.json`, `binary_types.txt`, `manual_reads.jsonl`, `logs/`. `dist/` ignored; довготривалі висновки та хеші продубльовано у verified-документах, не слід покладатися лише на локальні артефакти.
