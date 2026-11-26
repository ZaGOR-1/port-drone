# Інкрементальний backup R03–R06

> Історичний матеріал з `toolchain/dev-environment/docs/R03_R06_BACKUP.md`. [Реєстр досліджень](../INDEX.md)

**Restore PASS.** Архів performance-r03-r06.tar.zst (`../../backups/20261123-r03-r06.0PbwwJ/performance-r03-r06.tar.zst`) має 1 614 112 242 байти (1,50 GiB) і SHA256 936df994cd83c74efcbad11413433d9b873252ca74d81bbe2ef4931f83d37ffe. Контрольні суми (`../../backups/20261123-r03-r06.0PbwwJ/SHA256SUMS.txt`) · Лог відновлення (`../../backups/20261123-r03-r06.0PbwwJ/restore-test.log`)

Архів містить raw CSV/JSON і журнали, синтетичні benchmark snapshots, сценарії, regression fixtures, docs, Git index/unstaged binary patches, untracked файли, SHA256 і права доступу, а також 12 точних QA-пакетів та staged-source patches. П’ять локальних source дерев, зокрема r03/fixed, зафіксовано на c91e0e6a7eef831687e6e63550560bba739a6b87. Git-історія для розгортання береться з основного Development Environment v1.

Виключені Wine prefixes, test cache/data/config, тимчасові build profiles, фізичні checkout-копії staging, .git, locks і embedded.pck, який відновлюється з точного EXE. У source дерев не було ignored файлів, необхідних для досліджень. Відібрані текстові файли й Git patches пройшли локальний пошук типових токенів і приватних ключів. Архів містить локальні benchmark матеріали та історичні шляхи, тому зберігати його як приватний робочий backup.

### Додати після перевстановлення Ubuntu

1. Віднови Development Environment v1 за чинною інструкцією. Потрібні git, Python 3.12+, zstd і відновлений port-drone, що містить базовий commit. Для інкремента інтернет не потрібен.
2. Перевір SHA256 в інкрементальному каталозі і розгорни в новий каталог. Команда використовує копію Git як локальне джерело без remote fetch. Замінити власні шляхи у змінних.

```bash
ws="/path/to/restored-workspace"
inc="/media/you/SSD/20261123-r03-r06.0PbwwJ"
(cd "$inc" && sha256sum --check --strict SHA256SUMS.txt)
PYTHONDONTWRITEBYTECODE=1 python3 "$inc/restore_performance.py" \
    --repository "$ws/port-drone" --destination "$ws/r03-r06-restored"
```

Підкаталоги r03, r04, r05, r06 знаходяться у r03-r06-restored/performance. За потреби перенеси кожен каталог у відновлений droneflames-toolchain/performance лише якщо відповідний каталог відсутній. У дереві R03 fixed лежить усередині r03. Справжні історичні logs збережені, їхні абсолютні шляхи відображають минуле оточення. Wine prefix для нових запусків створюється окремо.

Тест виконано в порожньому каталозі на базі Git із відновленого Essential v1. Відтворено status, exact patches, SHA256 змінених/untracked файлів і режими доступу 5 source дерев. Із patches відтворено й звірено 12 STAGED_TREE. QA-SHA256SUMS пройшов для всіх 12 пакетів, а 4 зведені списки контрольних сум — для R03–R06. Ігрові benchmark прогони під час restore не повторювалися.

### Скопіювати на зовнішній SSD

Скопіюй два каталоги цілком. Development Environment v1 лишається первинною копією для ОС і Git. Інкремент містить R03–R06 та окремий архів нової версії dev-environment із CLI, manifest, тестами й документацією. За наявності попередньої USB копії v1 звір її контрольні суми після додавання інкремента.

```bash
backups=/home/zagor/projects/droneflames-toolchain/backups
usb="/media/you/SSD"
cp -r --no-clobber -- "$backups/20261123-dev-environment-v1.J78ugB" \
    "$backups/20261123-r03-r06.0PbwwJ" "$usb/"
(cd "$usb/20261123-dev-environment-v1.J78ugB" && sha256sum --check --strict SHA256SUMS.txt)
(cd "$usb/20261123-r03-r06.0PbwwJ" && sha256sum --check --strict SHA256SUMS.txt)
```

Локальні кодові зміни CLI можна відкрити без зміни v1. Після SHA256 перевірки розпакуй dev-environment-cross-platform-v1.tar.zst в окремий порожній каталог. Викликай dev-environment/scripts/df із --workspace-root на відновлений workspace. Архів зберігає права виконання навіть під час перенесення через exFAT. Облікові дані, якщо потрібні, слід відновлювати окремо зі своїх захищених джерел.
