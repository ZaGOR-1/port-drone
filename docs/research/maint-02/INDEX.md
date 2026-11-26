# DroneFlames MAINT-02 · Консолідація

> Історичний матеріал з `archive/MAINT-02/INDEX.md`. [Реєстр досліджень](../INDEX.md)

**PASS.** Документи й офлайн-інструменти опубліковано в [Draft PR #21 до beta](https://github.com/ZaGOR-1/port-drone/pull/21). Head `90508495e3d3a224b921a2c74abeb878f3baca7b`. Попередній commit `086f97c0964e2378f8f39cdb81f6576787a6f82e`. Beta `f629882296a3419b2e1dc298619f83072c1320f9`, гра 0.36.11. Перевірки підтвердили незмінність попередніх remote refs, stash `40a9f64` і dirty checkout. Merge потребує окремого погодження.

## Фактичні дії та докази

- Штатні `git worktree remove` та `git branch -d` пройшли для п’яти погоджених об’єктів. Файлова система показала **597 000 192 додаткових байти (569,34 МіБ)** за інтервал очищення. Сума `du` вилучених дерев — **596 197 376 байтів (568,58 МіБ)**. Невелика різниця охоплює Git metadata та інші зміни файлової системи за той самий інтервал. SHA, refs і шляхи (`cleanup.tsv`) · Заміри (`space.tsv`)
- Profile B, QA-01 і R23 перенесено вибірково. Локальні нові Markdown-посилання, цілі версій і Git diff пройшли. Офлайн-аналіз R23 відтворив чотири JSON/CSV побайтно. Валідатор підтвердив 65 прогонів і 64 зіставлення та відхилив змінений workload, підміну пари й запис звітів у sealed handoff.
- Унікальні дельти R13, R18A, R22 і `performance/source`, Rust PoC, R09/R16, stash та оригінали handoff збережено. Старі сценарні скрипти INT10–INT12, R17B, R19 і R21 можуть посилатися на прибрані checkout. Для повтору відновити точний SHA з [MAINT-01](../maint-01/INDEX.md) у тимчасове дерево й передати його шлях. Виконання історичних build/QA скриптів на MAINT-02 — NOT RUN.
- Свіжі benchmarks, повна перебудова Godot, фізичні Windows GUI/FPS, LAN і Steam — NOT RUN.

## Структура та шляхи

```text
~/projects/
  port-drone/                       основний checkout beta
  droneflames-toolchain/            чинні інструменти, runtime та оригінали handoff
  droneflames-worktrees/maint-02/    робоче дерево Draft PR
  droneflames-archive/
    catalog/                        відносні посилання на канонічні матеріали
    MAINT-01/                      інвентар і незалежно перевірений backup
    MAINT-02/                      результати, зовнішній список і план MAINT-03
```

Перевірено реєстр symlinks MAINT-01 щодо п’яти вилучених дерев і процесів, які використовують їхній шлях. Чинні `df` / `df-windows` використовують `DF_WORKSPACE_ROOT` та сусідній toolchain; patched runtime можна вибрати через `DF_WINDOWS_PATCHED_RUNTIME_DIR`. R23 runners приймають `DF_R09_TOOLCHAIN` та `DF_R09_RUNTIME`. Для R23 release runtime з INT-12 і QA clock NATIVE-02C мають зберегтися або бути відновлені з перевірених матеріалів. Фізичні адреси чинного toolchain збережено. Каталог містить посилання на оригінали, тому на нього не припадають додаткові копії великих архівів. Канонічний індекс (`canonical-catalog.tsv`)

## Найбільші кандидати для наступного погодження

Виділені байти оцінено за інвентарем MAINT-01 та точковими `du -x -B1`. Вкладені рядки та hardlinks можуть перекриватися. Таблиця задає верхню межу для шляхів. Фактичний виграш залежить від перевірки payload і спільних inode.

| Шлях від toolchain | ГіБ | Клас і умова |
| --- | ---: | --- |
| `R03-R06 restore test.IyJxR9/` | 3,48 | Копія незалежного відновлення. Канонічний R03–R06 пройшов SHA256. `tar --compare` виявив лише 893 розбіжності mtime. П’ять Git source станів і patches збіглися. Додаткові файли лежать у цих відновлених checkout. Перший кандидат після зовнішнього backup. |
| `int08.1UTXXUmq/post/wine-controls/` | 7,34 | Історичні Wine-префікси. Зберегти control logs і потрібні fixtures, перевірити унікальні файли й стан профілів перед дозволом. |
| `performance/r10.sgT1Rl0N/windows-physical-qa/session.FB73YiDM/{wine-verification,smoke,wine-extra}` | 3,90 | Профілі та тимчасовий staging, умовні кандидати після відбору доказів. Окремо залишити точний ZIP A/B і зібрані результати. |
| `performance/r10.sgT1Rl0N/windows-physical-qa/session.FB73YiDM/extracted Windows QA/` | 1,02 | Розпакований дублікат build із додатковими QA-даними. Знайдено окремий ZIP результатів, `Profiles` і prepare records. Статус HOLD до перевірки й збереження унікального payload. |
| `DR v1 extended.NtuoYa/` і `DR v1 essential.vxhKXr/` | 3,94 + 2,96 | Копії незалежного відновлення DEV01. Після зовнішньої копії звірити відтворення й унікальні зміни кожної репліки. |
| `int08.1UTXXUmq/post/extracted/` | 0,39 | Дублікат збірки. EXE, PCK і Linux runtime побайтно збігаються з `post/build`. Потрібна звірка решти файлів із канонічними ZIP/TAR перед видаленням дерева. |
| `performance/perf01/smoke-wine64/` | 1,19 | Відтворюваний smoke prefix за наявності точних bytes build і доказів. Решта `perf01/` (9,30 ГіБ разом із цим prefix) потребує пофайлового відбору історичних raw, profiles і staging. |
| `native-02/target/`, `native-02/diagnostic-target/` | 0,58 + 0,35 | Build caches. Звірити готові PoC binaries, lockfile і offline Rust toolchain до рішення. |
| `mingw-patched/godot/bin/` | 3,49 | Активні build outputs поруч з історичними скомпільованими файлами. KEEP для використовуваних template/EXE. Відібрати кеші лише після перевірки маніфесту й усіх runtime references. |
| `performance/r23/harness/raw/`, `performance/r10.sgT1Rl0N/raw/` | 0,56 + 0,50 | Історичні виміри. Зберегти сирі рішення та контракти з handoff. Відокремити відтворювані XDG/cache за manifest. |
| `backups/20261123-*`, INT packages і вибрані handoff | за маніфестом | Канонічні артефакти. Зберегти на зовнішньому носії з SHA256. |

Точні результати R03–R06 (`r03-r06-replica-report.log`) · SHA дублікатів INT08 (`int08-duplicate-build-sha.txt`) · Відмінності R10 (`r10-package-compare.log`) · Точкові розміри (`candidate-details.tsv`)

## Зовнішня резервна копія та MAINT-03

Точний перелік файлів (`external-files.tsv`) містить SHA256 і шляхи від `~/projects`. Він охоплює повний Git bundle MAINT-01, дельти та stash, QA increment, maintenance increment, DEV01, DEV02, R03–R06, SFX/MinGW, L01/L02, INT handoffs і пакети, R13/R18A/R22/R23, NATIVE-01–02D та QA-01. DEV02 збирається з канонічних компонентів за оригінальним restore guide. Комплект має 1616 файлів і 7,53 ГіБ. Зовнішня копія ще не створена.

1. Погодити зовнішній носій, скопіювати список нижче в окремий порожній каталог і перевірити всі SHA256. Відновити з носія Git зі stash, репрезентативний dirty PoC та R03–R06 і перевірити доступність INT-12 runtime для офлайн/GUI відтворення R23.
2. Після окремого рішення про Draft PR узгодити інтеграцію документації. Оновити фінальні Git refs і backup після будь-якого merge.
3. Погодити першу хвилю фізичних каталогів. Почати з перевіреної репліки R03–R06, потім із конкретних перерахованих копій і Wine-префіксів після виявлення унікальних logs/QA даних та перевірки відкритих споживачів. R10 extracted лишається HOLD.
4. Повторно звірити GNU tar/manifest, робочі шляхи, Git, stash і доступність канонічних архівів. Після явно погоджених вилучень записати виміряний disk delta і відкоригувати каталог.

```bash
scope="$HOME/projects/droneflames-archive/MAINT-02"
external=/path/to/new-empty-private-backup
rsync -a --files-from="$scope/external-copy-list.txt" "$HOME/projects/" "$external/"
cp -- "$scope/external-SHA256SUMS" "$scope/external-copy-list.txt" \
    "$external/droneflames-archive/MAINT-02/"
(cd "$external" && sha256sum -c droneflames-archive/MAINT-02/external-SHA256SUMS)
```
