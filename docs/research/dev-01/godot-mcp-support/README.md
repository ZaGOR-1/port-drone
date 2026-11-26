# DroneFlames Godot MCP на Ubuntu

> Історичний матеріал з `toolchain/godot-mcp-support/README.md`. [Реєстр досліджень](../../INDEX.md)

Перевірено 2026-11-23 на Ubuntu 26.04.1 LTS, Godot `4.7.2.stable.official.ed1daf0bf` і Codex CLI 0.171.0. Production worktree `/home/zagor/projects/port-drone` на `beta` `c91e0e6a7eef831687e6e63550560bba739a6b87`. Shadow розташований у `/home/zagor/projects/droneflames-toolchain/godot-shadow`.

## Запуск

Відкрий нову сесію Codex. Глобальний запис `godot` запускає встановлений `godot-mcp` через локальний launcher із явними шляхами до shadow та Godot.

```bash
codex -C /home/zagor/projects/port-drone
```

Для команд `scene_*`, `node_*` і `project_settings_*` запусти редактор у другому терміналі. Для headless перевірки додай `--headless`.

```bash
~/projects/droneflames-toolchain/godot-mcp-support/launch-shadow editor
```

Launcher задає приватний XDG-профіль та `DF_NO_UPDATE=1`. Editor bridge слухає лише loopback. Для GDScript-діагностики закрий редактор, якщо запит зависає на повторному скануванні. Спостерігалося перезавантаження скриптів bridge посеред `filesystem_scan`.

## Оновлення

Закрий shadow-редактор і сесії Codex, які тримають Godot MCP. Скрипт використовує committed HEAD чистої **локальної** `beta`. Він не виконує fetch або pull.

```bash
~/projects/droneflames-toolchain/godot-mcp-support/sync-shadow
```

На тій самій ревізії команда повторно використовує наявну копію. Перед заміною вона порівнює файли поза `.godot/` із маніфестом, включно з новими й видаленими файлами. Godot може створювати `.uid` і `.import` та змінювати наявні sidecar-файли. Якщо перевірені локальні зміни треба зберегти окремо, запусти таку команду. Попередню копію разом із кешем скрипт перенесе в `godot-shadow-archive/`.

```bash
~/projects/droneflames-toolchain/godot-mcp-support/sync-shadow --archive-local
```

## Як зібрано shadow

Скрипт фізично копіює committed дерево `game/`, зокрема tracked кеш, імпорти й бінарну Main-сцену за `game/main.tscn.remap`. Godot віддає перевагу `project.binary`, тому активна копія містить текстовий `project.godot` зі значеннями ECFG та накладеним `override.cfg`. Конвертер повторно зчитує й звіряє значення. Конфіг зберігає запуск через `res://pc/boot.tscn`, autoloads `PcPort` і `SteamNet`, viewport 360×640 та window override 1600×900. Для редактора встановлено локальну копію аддона OREBRON з тієї ж ревізії `20ca9bd083ad`, що й сервер. Три посилання на відсутні editor plugins пропущено під час генерації. [Код Godot 4.7.2](https://github.com/godotengine/godot/blob/ed1daf0bf/core/config/project_settings.cpp) · [Вихідний код Godot MCP](https://github.com/orebron/godot-mcp/tree/20ca9bd083ad) · [Налаштування MCP в Codex](https://developers.openai.com/codex/mcp)

## Докази та межі

- Codex app-server знайшов 33 інструменти й викликав `godot/project_info` у тестовому потоці. Стандартний MCP handshake, `project_info` та `project_find` працюють. Пошук підтвердив посилання на boot-сцену, autoload і тип вузла у текстовій сцені. Бінарний вміст сцен не індексується цим пошуком.
- Headless editor bridge підтвердив читання налаштувань, `scene_open` і `scene_tree` для `PcBoot`. `class_info` з закритим редактором повернув API `Node` та `NetConfig`.
- `script_check` перевірив `net_config.gd`, `steam_net.gd` і `main.gd` з результатом `failed=0`, `ok=false`. Godot повідомляє про відсутні Linux бібліотеки GodotSteam і WebRTC, а `df_device.gdextension` не має Linux-конфігурації. Окремий тимчасовий GDScript із синтаксичною помилкою повернув шлях, рядок 2 і повідомлення парсера.
- Windows GUI, ігровий runtime, Steam/LAN, export і повна регресія в цій задачі мають статус NOT RUN.
- Production Git чистий. `project.binary`, `override.cfg` і 213 tracked-файлів `.godot` звірено побайтово з Git. Remote `main` залишилася на `172df65e3bd004efed9a5444e90a284d9d69db10`. Локальної гілки `main` у цьому checkout немає.

Результати доступні поряд із цією інструкцією в `codex-mcp-smoke.json`, `codex-project-info.json`, `mcp-smoke-editor.jsonl` і `mcp-smoke-offline.jsonl`.
