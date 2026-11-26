# Архів локальних артефактів DroneFlames

> Історичний матеріал з `toolchain/.cold-storage/README.md`. [Реєстр досліджень](../INDEX.md)

У цьому каталозі лежать старі тестові Wine-префікси та великі локальні артефакти QA і збірки. Дані зберігаються в репозиторії Restic `repo/` з дедуплікацією та стисненням. Для читання потрібен файл `key`. Зберігайте його приватно разом з архівом і встановленим тут виконуваним файлом `restic`.

- `wine.paths`, `heavy.paths` і `medium.paths` містять оригінальні абсолютні шляхи.
- `wine.snapshot`, `heavy.snapshot` і `medium.snapshot` містять ідентифікатори знімків.
- `*.removed.log` показує, що фактично видалено з розпакованого дерева.
- `*.compare.log` і `*.check.log` містять результати звірки з контрольним відновленням.
- `mingw-obj.removed.log` фіксує обсяг видалених проміжних `.o` і `.a` у `mingw-patched/godot/bin/obj`. SCons згенерує їх під час наступної повної компіляції.

## Результат · 2026-11-26

`du -x -B1` зафіксував 217.18 → 51.69 GiB. Звільнено 165.49 GiB (76.2%). Архів займає 9.72 GiB і входить до підсумкового розміру.

Перевірено повне відновлення трьох знімків, контрольні суми вмісту та звірку з оригіналами. Після цього видалено 62 розпаковані Wine-префікси й 17 877 окремих файлів. Повне читання сховища через `restic check --read-data` завершилося без помилок. Списки Git worktrees і стан гілки `beta` з HEAD `7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33` збіглися до й після. SHA256 архівів DR v1 і збережених SFX пройшли.

Для повтору архівованого QA або запуску архівованого Linux runtime спершу відновіть потрібні файли за списками шляхів. Ігрові тести й повторна компіляція Godot — NOT RUN.

## Відновлення одного шляху

Виберіть `wine` для Wine-префікса, `heavy` для файлів від 16 MiB або `medium` для файлів від 1 до 16 MiB. Підставте повний оригінальний шлях з відповідного `.paths`. Restic відновить його в окремий каталог для перевірки.

```bash
cd /home/zagor/projects/droneflames-toolchain
state="$PWD/.cold-storage"
kind=heavy
original='/home/zagor/projects/droneflames-toolchain/шлях-зі-списку'
restore_dir=$(mktemp -d "$HOME/droneflames-restore.XXXXXXXX")
"$state/restic" -r "$state/repo" --password-file "$state/key" \
  restore "$(cat "$state/$kind.snapshot")" --include "$original" \
  --target "$restore_dir" --verify
```

Відновлений об’єкт лежить за шляхом `$restore_dir$original`. Щоб повернути його, коли оригінальний шлях вільний, скористайтесь `mv -nT -- "$restore_dir$original" "$original"`. Повторний запуск із тим самим ідентифікатором знімка без `--include` відновлює весь набір. Повне відновлення потребує приблизно 74 GiB для `wine`, 73 GiB для `heavy` або 27 GiB для `medium`.
