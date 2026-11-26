# Локальна Windows x64 збірка DroneFlames на Ubuntu

> Історичний матеріал з `toolchain/windows-dev/README.md`. [Реєстр досліджень](../../INDEX.md)

## Щоденні команди

Зібрати `HEAD` основного checkout зі штатним Windows template. `official` є профілем за замовчуванням.

```bash
~/projects/droneflames-toolchain/windows-dev/df-windows build
```

Зібрати іншу локальну гілку, tag чи SHA без перемикання гілок. Для окремого worktree передай його корінь через `--source`.

```bash
~/projects/droneflames-toolchain/windows-dev/df-windows build c91e0e6
~/projects/droneflames-toolchain/windows-dev/df-windows build --source /path/to/feature-worktree
```

У робочому дереві джерела мають бути відсутні staged, unstaged та untracked зміни. Ігноровані Git файли залишаються поза snapshot. Скрипт завантажує вибраний коміт у власний staging Git і копіює його файли, включно з `project.binary` і tracked `game/.godot`. Використовуються `tools/build.py` і `tools/ci/verify_build.py` саме з вибраної ревізії. Для ревізій зі зміненим Godot pin можна вказати інший каталог через `--engine-dir`. Потрібні Git, Python 3.12+ і `sha256sum`.

Для локальної збірки з виправленням GDScript VM вибери `patched`. Профіль використовує Release template з локального engine manifest. Штатний Linux editor пакує PCK і перевіряє його ідентичність.

```bash
~/projects/droneflames-toolchain/windows-dev/df-windows build --template patched
```

Запустити останній перевірений official або patched комплект через Wine. Додай `--check` для перевірки без запуску.

```bash
~/projects/droneflames-toolchain/windows-dev/df-windows run
~/projects/droneflames-toolchain/windows-dev/df-windows run --template patched
```

Перед запуском перевіряються EXE, три DLL і обидва SHA256-маніфести. Wine використовує окремий локальний `wine-prefix/` зі спільними для цих QA-збірок збереженнями. Updater вимкнено, ініціалізацію Steam пропущено через `DF_STEAM_MOCK=0`. Перший ручний запуск створить цей Wine-профіль.

## Артефакти й контрольна перевірка

Кожна спроба збірки зберігає короткий `build.log` у власному каталозі `builds/`. Для успішної збірки `package/` містить EXE, три DLL, ZIP і SHA256-маніфести. `BUILD_PROVENANCE.json` фіксує commit, dirty tree, дерево `game/`, хеші рушія й артефактів та packaged identity. Вказівник профілю атомарно оновлюється після проходження перевірок. `latest` зберігає official комплект, `latest-patched` — patched. Попередні успішні комплекти зберігаються.

Середовище перевірки — Ubuntu 26.04.1 LTS, Godot 4.7.2 і Wine 10.0. Для `c91e0e6a7eef831687e6e63550560bba739a6b87` пройшли збірка, CI-перевірки engine pin, Windows AMD64 PE, вбудованого PCK, DLL і packaged identity `v0.36.0/7/v036-integration-1`, обидва SHA256-маніфести та `run --check`. Помилка через відсутній рушій зберегла попередній `latest`. Production checkout чистий. Wine GUI для цього EXE — **NOT RUN**. Раніше повідомлений власником GUI smoke 7/7 стосується попереднього артефакту.

Офіційний Windows template без виправлення GDScript VM. Це локальний QA-комплект, статус release-ready не встановлено. Повна матриця CI, Steam/LAN і ручна перевірка цієї збірки — **NOT RUN**.

## Patched контрольна збірка

`builds/20261123T151811Z-c91e0e6a-etc88hks/` містить перевірений DroneFlames v0.36.0 від `c91e0e6a7eef831687e6e63550560bba739a6b87`. SHA256 EXE — `f2bffeb0e9ef6bb4cbc7ef003387f73dde7873a75382144a04e9175853853515`.

Patched профіль використовує з вибраної ревізії штатні CI перевірки PE32+, шаблону, PCK, DLL і packaged identity. Штатний CI-пін редактора та official template перевіряється звичайним CLI. Окремий локальний профіль перевіряє SHA256 patched Release template і C++ diff, відхиляє QA EXE як шаблон та додає `GODOT_BUILD_MANIFEST.json` до комплекту. Обидва профілі пройшли `run --check`. Wine GUI і нативний Windows QA для цього пакета — **NOT RUN**. [Відновлення рушія](../mingw-patched/README.md)

## Один переносний Windows EXE

Після успішного `build --template patched` виконай

```bash
~/projects/droneflames-toolchain/windows-dev/df-windows pack-sfx
```

Команда повторно перевіряє останній patched package і друкує шлях та SHA256 SFX. За потреби передай `--out` із новим вихідним каталогом. Інструкція й межі QA наведені в [portable-sfx/README.md](../portable-sfx/README.md).
