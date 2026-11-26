# DroneFlames MAINT-01 · Інвентаризація й відновлення

> Історичний матеріал з `archive/MAINT-01/INDEX.md`. [Реєстр досліджень](../INDEX.md)

**PASS у межах інвентаризації, резервування та перевірок нижче.** Beta `f629882296a3419b2e1dc298619f83072c1320f9`, версія 0.36.11, R23 `43c84b2195a02043eeacfe39c6e11659126fb245`. Origin main `172df65e3bd004efed9a5444e90a284d9d69db10`. Стан зафіксовано 26 листопада 2026 року. Рішення в пооб’єктних планах очікують погодження власника.

## Карта матеріалів

| Матеріал | Розташування в цьому каталозі |
| --- | --- |
| 22 локальні та 6 віддалених гілок | [Таблиця](BRANCHES.md) · SHA і перевірка ancestry/patch (`inventory/branches.tsv`) |
| 38 зареєстрованих worktrees | Стан і ключі payload (`inventory/worktrees.tsv`) · Рішення й розміри (`inventory/worktree-plan.tsv`) |
| Основні папки й деталізація toolchain | Рішення для 532 шляхів (`inventory/folder-plan.tsv`) · Розміри (`inventory/projects-size.tsv`) · Toolchain depth 2 (`inventory/toolchain-du-depth2.tsv`) |
| 66 Git-метаданих у вкладених каталогах | Інвентар (`inventory/nested-repos.tsv`) · Дельти для 30 незареєстрованих копій (`inventory/nested-deltas.tsv`) |
| Build artifacts, bundles, handoffs і manifests | Інвентар файлів (`inventory/artifacts.tsv`) · Результати SHA256 (`verification/existing-checks.log`) |
| Абсолютні шляхи і symlinks | Файли зі збігами (`inventory/absolute-path-files.txt`) · Symlink → ціль (`inventory/symlinks.tsv`) |
| Відновлення з нового Git backup | Bundle, dirty trees, stash (`verification/independent-recovery-verified.log`) · QA-коміти (`verification/qa-sources-recovery.log`) · Вкладені дельти (`verification/nested-restore-verified.log`) |
| Перевірка історичних матеріалів | R13, R22, R23 та всі Rust PoC (`verification/existing-restore.log`) · Toolchain, DEV02, R18A (`verification/toolchain-dev02-r18a.log`) · QA-01 (`verification/qa01.log`) · Патч Godot (`verification/godot-patch-recovery.log`) |
| Нові резервні дані та контрольні суми | Основний bundle (`backup/port-drone-complete.bundle`) · QA increment (`backup/qa-sources.increment.bundle`) · SHA256SUMS |

Розміри — виділені байти за `du -x`. У вкладених таблицях батьківські суми включають дочірні. Toolchain містить частину worktrees і підкаталогів із hardlinks. Ці суми вже частково перекриваються.

| Об’єкт | Виділено, ГіБ | Роль |
| --- | ---: | --- |
| `port-drone/` | 0,22 | Основний Git і checkout beta |
| `droneflames-toolchain/` | 224,65 | Чинні інструменти й історичний workspace |
| ↳ `performance/` | 103,95 | QA-збірки, runners, заміри R01–R23 і джерела |
| ↳ `performance/r23/` | 1,87 | R23, контрольні checkout, пакети й відновлений handoff |
| ↳ `backups/` | 3,80 | Канонічні SFX/MinGW/DEV01/R03–R06/Linux L01 backups |
| `.dev02-recovery.n2qB4R/` | 6,87 | Recovery, CRLF і повний комплект USB v2 |
| `.dev02-restore.M8nSap/` | 4,87 | Перевірка відновлення DEV02 |
| `fix01-qa.6S6Ygb/` | 2,38 | Збірки, патчі та GUI-докази FIX-01 |
| 37 допоміжних зареєстрованих worktrees | 4,10 | Checkout-копії, приблизно 113–114 МіБ кожна |

**Звільнено на MAINT-01 0 байт.** 4,10 ГіБ — валова верхня оцінка для 37 допоміжних worktrees після перевірки шляхів і погодження. Окремий кандидат `R03-R06 restore test.IyJxR9` займає 3,48 ГіБ. Його вивільнення залежить від звірки конкретної копії з канонічним архівом. Перенесення історичних матеріалів на тому самому розділі дає порядок у каталогах. Економію місця дає вилучення підтверджених реплік у MAINT-02. Великі QA-каталоги потребують окремої звірки їхнього payload. Нове резервне наповнення MAINT-01 займає близько 208 МіБ плюс ізольовані копії перевірки.

## Git і незакомічена робота

Усі 70 refs основного bundle пройшли fetch і fsck у чистому репозиторії без alternates. Bundle містить локальні гілки, remote-tracking refs, stash ref, точні HEAD усіх worktrees та додатковий reflog-коміт `3101e30dc1f3066a2a921d19daee750948050d87`. Тегів не виявлено. QA-джерела R19 `e313f53ddde3486e34f4529f0ac4262fbbd181d1` і R21 `640b768a02fca913939dcb429b4b9ff118ba58a7` мають окремий невеликий increment. Їхні `addons` — symlinks, для працездатності потрібні записані цілі.

| Worktree | HEAD | Збережений стан |
| --- | --- | --- |
| `performance/source` | `c91e0e6a` | 11 змінених tracked GDScript і чотири untracked probe/runner scripts |
| `port-drone-r13` | `8c83d91d` | PoC `army.gd`, два docs tracked і новий звіт |
| `port-drone-r18` | `6d83ef99` | Початковий R18A у Git і незакомічений запис `PROJECT_STATE.md` |
| `port-drone-r22` | `f6298822` | Три production-файли PoC і незакомічений запис стану |

Для зареєстрованих дерев збережено binary staged/unstaged patches, raw index, flags, статус, HEAD і worktree metadata. Staged змін у цих джерелах на момент інвентаризації не було. Заново відтворено tracked/extra payload усіх чотирьох dirty дерев, два репрезентативні комітні checkout R23 і NATIVE-02D та локальні налаштування Serena. `tools/__pycache__` записано як регенерований кеш. У вкладених копіях збережено 36 різних gzip payload для 30 станів, зокрема R03–R06, CRLF і старі staged deletions у restore L10N. Конфігурації облікових записів, профілі Wine та credentials з інструментів окремо не експортувалися. Оригінальні каталоги лишаються дійсними джерелами для перевірки їхніх профілів і кешів перед MAINT-02.

Локальні branch heads R17, R18B, R19 і R21 є предками beta. Перевірка за правою стороною `beta...ref`, patch-equivalence і списками фактичних змін показала унікальну роботу в гілках R11, R12, R18A, docs і Rust. Для R13/R22 ancestry не відображає робочу дельту. Докази інтеграції та SHA кожної гілки вказані в [таблиці](BRANCHES.md).

## Відновлення

Виконуй у нових порожніх каталогах. `archive` нижче вказує на цей каталог. Новий Git backup і payload локальні та на тому самому диску. Для захисту від відмови диска потрібна додаткова приватна копія.

```bash
archive="$HOME/projects/droneflames-archive/MAINT-01"
(cd "$archive" && sha256sum -c SHA256SUMS)
restore=$(mktemp -d)
git -C "$restore" init
git -C "$restore" bundle verify "$archive/backup/port-drone-complete.bundle"
git -C "$restore" fetch "$archive/backup/port-drone-complete.bundle" '+refs/*:refs/*'
git -C "$restore" fsck --full
while IFS=$'\t' read -r sym target; do
    git -C "$restore" symbolic-ref "$sym" "$target"
done < "$archive/inventory/symbolic-refs.tsv"
git -C "$restore" bundle verify "$archive/backup/qa-sources.increment.bundle"
git -C "$restore" fetch "$archive/backup/qa-sources.increment.bundle" '+refs/maint01/qa/*:refs/maint01/qa/*'
```

Для конкретного дерева візьми `id` і `head` із `inventory/worktrees.tsv`. Створи detached worktree у свіжій директорії через `git -C "$restore" worktree add --detach "$dest" "$sha"`. Якщо patches непорожні, застосуй спочатку `git -C "$dest" apply --index "$payload/staged.patch"` і потім `git -C "$dest" apply "$payload/unstaged.patch"`. Розпакуй наявний `extras.tar.gz` через `tar -xpzf "$payload/extras.tar.gz" -C "$dest"`, щоб зберегти режими. Метадані `gitdir` і `commondir` є довідковими. Git створює актуальні посилання під час `worktree add`.

Для stash створи detached checkout з `40a9f64be2729b80cff7d6139f9addd64a687993^1`, далі виконай `git stash apply --index 40a9f64be2729b80cff7d6139f9addd64a687993`. Перевірена рівність індексу другому parent stash і tracked diff фінальному tree stash. Оригінальний reflog сташу збережено як `backup/stash-reflog`.

Канонічні історичні копії повторно використано за шляхами з логів. Архів MinGW/toolchain відновив власний SHA256-маніфест. Його патч накладено на чисті файли офіційного Godot `ed1daf0bf001b61586d9930840f2f1394092c079`, шість змінених файлів збіглися з чинним patched checkout. [Команди toolchain в RESTORE.md](../portable-sfx/RESTORE.md). Повний DEV02 перевіряється з `.dev02-recovery.n2qB4R/Комплект для USB v2`. Початкова перевірка з каталогу пакування мала відсутні сусідні компоненти. У зібраному комплекті всі SHA256 пройшли.

## Документація, яку варто консолідувати

| Джерело | Запропонована дія |
| --- | --- |
| `209ae19` · Real-World Profile B | Адаптувати тільки §8 AGENTS і workflow в `docs/performance.md`. Історичні headless протоколи лишити довідковими. R17-specific gate зберегти з історичним контекстом. |
| `43c84b2` · R23 | Перенести `docs/r23/`, короткий запис у `PROJECT_STATE.md` і посилання в `docs/INDEX.md`. Дати відносні посилання на каталог доказів або archive index. |
| `ca713a4` · QA-01 | Вибрати секцію `WINDOWS_QA.md` з Wine startup, межами відтворення і підсумком для відкритих питань. Зберегти статус фізичного Windows NOT RUN. |
| `c7c031fe` · R16, `93a626e` · R09 | Історичні baselines. Додати короткі посилання з датами й SHA. R16 лишити джерелом provenance Late E/restore та історичних висновків до R17. |
| R23 `harness/` і DEV02 | Винести лише відносні шляхи, ідентифікацію SHA, перевірку workload і незалежний аналіз у підтримуваний runner, якщо це буде потрібне для нового QA. Перевірити валідатор на збережених JSON і негативних fixtures до свіжих замірів. |
| Git Workflow v2 | Зафіксувати в `docs/DEVELOPMENT_WORKFLOW.md` робочі дерева в одному каталозі, завершальний backup, recovery check і погоджене прибирання. Для `PROJECT_STATE.md` залишити короткий актуальний стан і посилання на історію. |

Перед переміщенням перевірити `DF_WORKSPACE_ROOT`, `DF_BUILD_ROOT`, `DF_WINDOWS_PATCHED_RUNTIME_DIR` у `df` і `df-windows`, а також `DF_R09_TOOLCHAIN` та `DF_R09_RUNTIME` у R23. У R23 `stage-*/addons` і QA clock/packproj використовують шляхи до інших наборів. `godot-shadow` потребує звірки з локальною конфігурацією Serena/Godot MCP. Історичні docs посилаються на відсутній `~/port-drone-worktrees-archive/`. Джерела SFX/MinGW підтверджуються наявними backups і мають отримати нові посилання після погодження. Файли зі шляхами (`inventory/absolute-path-files.txt`)

R23 потребує версійованого спільного runtime з INT-12 та QA clock із NATIVE-02C. Підкаталоги Rust також посилаються на toolchain і залежності NATIVE-01. Перед архівуванням будь-якого з них перевірити цілі symlinks та зафіксувати їхні SHA.

## Кінцева структура і межі MAINT-02

```text
~/projects/
  port-drone/                Git, beta і актуальна документація
  droneflames-toolchain/     відтворювані інструменти та чинні рантайми
  droneflames-worktrees/     активні тимчасові worktrees
  droneflames-archive/       MAINT-01, канонічні історичні комплекти та індекс
```

1. Погодити конкретний список із `worktree-plan.tsv`, `folder-plan.tsv` і `branches.tsv`. Окремо погодити будь-які remote refs і shared/OKREDU paths. Перед діями заново звірити HEAD, status, stash, hashes, відкриті споживачі й backup.
2. У свіжому тематичному worktree від актуального beta підготувати малий docs-кандидат за таблицею вище. Зберегти provenance і окремий review. Для публікації або інтеграції застосувати звичайний погоджений PR workflow.
3. Створити `droneflames-worktrees/` для нових завдань. Канонічні історичні handoff архівувати лише після перевірки кожної залежності й SHA. Для toolchain зберегти поточні точки входу та фізичні шляхи до перевірки portability. Для DEV02 закріпити повний комплект із prerequisites до розгляду його реплік.
4. Для кожного погодженого чистого checkout застосувати `git worktree remove <path>`. Якщо дерево dirty, зафіксувати свіжу дельту, відновити її незалежно і погодити конкретне вилучення з власником. `git worktree remove --force <path>` можливе лише для такого явно погодженого dirty дерева. Вилучити впевнено інтегровані локальні refs через `git branch -d <branch>` після виходу з worktree. Для відкинутих експериментів зберегти branch name і SHA в bundle та індексі. Для unattached копій і cache застосувати окрему пофайлову перевірку перед дозволом на видалення.
5. Перша черга для погодження охоплює локальні `perf/operations-membership-lookup`, `perf/impact-candidate-enumeration-r18b`, `perf/army-target-acquisition`, `perf/unit-speed-lookup` і `perf/watchdog-lockstep-latency` та їхні чисті worktrees. Наступна черга — detached копії з підтвердженим SHA й доступними залежностями. Утримати docs-кандидати до вибіркового перенесення та всі чотири dirty worktrees до окремого рішення. На етапі фізичного архівування звірити payload `R03-R06 restore test.IyJxR9` як перший великий кандидат-репліку.
6. Повторно звірити основний checkout і ref snapshot після етапу, перевірити посилання та виміряти фактично звільнені блоки. Для наступних задач при завершенні й інтеграції перевіряти backup, відновлення і залежності, тоді окремо закривати тимчасовий worktree та гілку.

MAINT-01 виконано поза production checkout. Зміни в Git-історії beta/main і фактичне очищення належать до наступного погодженого етапу. Performance benchmarks — NOT RUN.
