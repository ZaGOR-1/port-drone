# Godot 4.7.2 MinGW для DroneFlames

> Історичний матеріал з `toolchain/mingw-patched/README.md`. [Реєстр досліджень](../../INDEX.md)

BUILD_MANIFEST.json фіксує ролі артефактів, SHA256, upstream, toolchain, залежності та журнали. `artifacts/release/godot.windows.template_release.x86_64.exe` використовується для пакування гри. `artifacts/qa/godot-windows-qa.exe` має `disable_path_overrides=no` для запуску GDScript fixture.

## Відновлення та повторна збірка

Збережи окрему фізичну копію цього workspace для повторної збірки. Для відновлення вихідного дерева використовуй upstream Godot `4.7.2-stable` на точному коміті `ed1daf0bf001b61586d9930840f2f1394092c079` у підкаталозі `godot/`. `build.sh` звіряє коміт і застосовує збережений patch до чистого дерева або звіряє наявний diff.

Використовуй GCC 13 POSIX і SCons 4.10.1 з версіями Ubuntu-пакетів у маніфесті. Якщо відновлюєш `deps/`, URL і SHA256 двох ZIP є в `dependency-pins.json`. Після звірки хешів розпакуй ANGLE у `deps/angle/`, а AccessKit у `deps/accesskit/`, зберігши внутрішній каталог `accesskit-c-0.22.3/`.

У корені ізольованої копії запусти preflight. Після підтвердження перевірок fixture і gate `PREFLIGHT_PASS` виконай команду збірки. Скрипт очікує в gate SHA256 поточного патча, використовує `-j2` і зберігає повний журнал. Вихідний EXE з’явиться в `godot/bin/`.

```bash
./build.sh preflight
./build.sh build
```

Для окремої QA збірки використай параметри з `scons-options.sh` і додай `disable_path_overrides=no`. Запускай її в окремій копії, оскільки вихідне ім’я SCons у Release і QA однакове. Збережи нові SHA256 і результати перевірок до оновлення engine manifest. Побайтова відтворюваність між збірками не встановлена.

## Межі перевірки

Локальні журнали Wine для QA EXE містять PASS для семантики та 20/20 маркерів PASS у race з 12 потоками й 4096 ділянками. У серії 20 були повідомлення про global script cache. Окремі фінальні прогони після виправлення fixture пройшли без цих помилок. Benchmark перевірив завершення й контрольну суму за 4 млн ітерацій, останній час 103802 мкс. Порівняння продуктивності **INCONCLUSIVE** без парного Windows baseline.

Для Release EXE перевірено PE32+, SHA256 та побайтовий префікс зібраного DroneFlames.exe. Нативний Windows QA, окремий fixture suite на Release EXE і Wine GUI для нового пакета — **NOT RUN**. [Локальний workflow](../windows-dev/README.md)
