# DroneFlames MAINT-03

> Історичний матеріал з `archive/MAINT-03/INDEX.md`. [Реєстр досліджень](../INDEX.md)

**PASS для інтеграції, погодженого backup, незалежного відновлення та очищення R03–R06.** INT08, DEV01 і R10 лишаються HOLD.

## Інтеграція

[PR #21](https://github.com/ZaGOR-1/port-drone/pull/21) пройшов Python/CI policy і Godot regressions/Windows x64 build. Release check мав статус SKIPPED. Після merge основний checkout синхронізовано fast-forward до `7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33`. Дерева `game/`, `libs/` і `.github/` побайтно збігаються з `f629882`, build identity 0.36.11. Main `172df65e3bd004efed9a5444e90a284d9d69db10` і stash `40a9f64be2729b80cff7d6139f9addd64a687993` звірено. CI (`pr-before.json`) · Merge receipt (`pr-after.json`)

## USB та очищення

Погоджений шлях `/run/media/zagor/KINGSTON/DroneFlames-MAINT-03`, фізичний USB `/dev/sda1`, exFAT. Записано список MAINT-02, 1 616 файлів і 8 088 817 145 байтів, плюс невеликий Git increment для merge PR #21. На носії пройшли 1 617 перевірок SHA256. У новому локальному каталозі відновлено без alternates Git із merged beta, stash, dirty R13 та R03–R06, включно з п’ятьма source checkout і дванадцятьма staged build trees. Запис і SHA256 (`copy-external.log`) · Незалежне відновлення (`restore-external.log`)

Між незалежним restore і старою копією R03–R06 збіглися всі файли за межами Git metadata. Історія п’яти checkout доступна з backup. Після перевірки залежностей видалено `droneflames-toolchain/R03-R06 restore test.IyJxR9/`. Файлова система показала **3 733 291 008 байтів (3,48 ГіБ)**. Тимчасовий новий каталог відновлення прибрано після перевірок. Звірка (`r03-r06-removal.log`) · Диск (`cleanup.tsv`)

Команда, виконана для погодженого нового каталогу:

```bash
bash "$HOME/projects/droneflames-archive/MAINT-03/copy-external.sh" /run/media/zagor/KINGSTON/DroneFlames-MAINT-03
```

Для незалежної перевірки після копіювання використати `restore-external.sh <каталог-на-USB> <наявний-локальний-каталог>`. Скрипт створює новий тимчасовий каталог для відновлення.

## Кандидати і Git

| Об’єкт | Статус і підстава |
| --- | --- |
| INT08 Wine controls, 7,34 ГіБ | **HOLD.** Відібрано 25 QA-файлів, зокрема перший crash log і шість Godot logs у профілях. Збіг SHA локального handoff перевірено. На USB бракує 44 відносних залежностей маніфесту INT08, включно з першим crash log. Сценарії `wine-controls.sh` і `seal-handoff.sh` посилаються на ці шляхи. |
| DEV01 Essential та Extended replicas, 6,90 ГіБ | **HOLD.** Канонічні TAR.ZST перевірено на USB. У Extended для архівних членів лише mtime-різниця. В Essential є також змінені editor caches, `latest-patched` та відсутній bridge JSON. Ідентифіковано 2 066 і 16 142 додаткових файлів у workspace. Перед очищенням звірити їх із процедурою відновлення і результатами тестів. |
| R10 | **HOLD.** Розпакована копія містить додаткові QA-дані. |

INT08, QA-файли (`int08-qa-files.tsv`) · 44 шляхи для доповнення USB (`int08-missing-on-usb.tsv`) · DEV01 Essential (`dev01-essential-compare.log`) · DEV01 Extended (`dev01-extended-compare.log`)

Залишається 34 зареєстровані worktrees, 18 локальних гілок і 7 віддалених heads. Активна база — `beta`; `main` лишається стабільним remote ref. Локальна `docs/maint-02-consolidation` і п’ять віддалених робочих heads уже інтегровані. Оригінальні refs Profile B, QA-01 та R23 зберігають власні SHA після вибіркового перенесення. R09, R16, L02, R11, R12 і NATIVE-01–02D лишаються історичними. R13, R18A, R22, `performance/source` лишаються dirty. Окремі R19/R21 QA-коміти `e313f53d` і `640b768a` перевірено через increment у незалежному USB restore. Точні гілки (`branches.tsv`) · Усі worktrees (`worktrees.tsv`)

## MAINT-04 для погодження

1. Доповнити зовнішню копію 44 залежностями INT08 із таблиці, перевірити весь зовнішній `handoff/SHA256SUMS.txt` і окремо розібрати шість Godot logs та інші унікальні записи Wine-префіксів. Тоді погодити конкретний список префіксів.
2. Зіставити додаткові файли та відмінності DEV01 з відновленням із канонічних Essential/Extended. Погодити вилучення лише для реплік без унікальних QA-даних і чинних залежностей. R10 тримати HOLD до окремого розбору.
3. Після погодження видалити чистий worktree і локальний ref `docs/maint-02-consolidation`. Оригінальні docs SHA лишити в архіві. Remote refs, Rust branches і dirty дерева потребують окремого рішення.

Benchmarks, нове пакування гри та повна компіляція Godot — NOT RUN.
