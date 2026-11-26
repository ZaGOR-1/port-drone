# R24–R27C · Локальний handoff

> Історичний матеріал з `archive/R24-R27C/INDEX.md`. [Реєстр досліджень](../INDEX.md)

Docs-only tip `572bb390460c42bbc74682ff5dc7ae7a23343ae6`, baseline `1e91239`. Версія 0.36.11. [Текст PR](PR_BODY.md)

- `R24-R27C.bundle` містить чотири тематичні refs і baseline. Refs (`refs.txt`) · Перевірка відновлення (`restore.log`)
- R24 похідні дані й R23, R25, R26, R27 sealed archives лежать під `~/projects/droneflames-toolchain/performance/`. R27B і R27C мають власні маніфести в `r27/r27b/` та `r27/r27c/`. Покажчик файлів (`evidence-paths.txt`) · SHA256 (`evidence.sha256`)
- Історичні R08, R12, R21 і R22, на які посилається R24, доступні на KINGSTON у `DroneFlames-MAINT-03/droneflames-toolchain/performance/` за їхніми оригінальними відносними шляхами. R12/R21/R22 звірено з SHA256, R08 перевірено читанням tar. Локально ці архіви відновлюються з `medium` у [cold storage](../dev-01/README.md).
- Деякі harness-команди посилаються на оригінальні worktrees. Їхні refs можна відновити з bundle. Синтетичні fixtures і raw докази зберігаються поза цими worktrees.

Перевірка локальної копії та відновлення в новий каталог:

```bash
cd "$HOME/projects/droneflames-archive/R24-R27C"
sha256sum -c SHA256SUMS
git init --bare "$HOME/projects/r24-r27c-restored.git"
git -C "$HOME/projects/r24-r27c-restored.git" fetch "$PWD/R24-R27C.bundle" 'refs/heads/*:refs/heads/*'
git -C "$HOME/projects/r24-r27c-restored.git" fsck --full
```

`backup.sh` копіює bundle й перевірені матеріали на інший змонтований носій. `cleanup-after-pr.sh` спершу звіряє інтегрований PR, його вміст, резервну копію, refs і стан усіх чотирьох worktrees. `--check` тільки перевіряє. `--apply` прибирає локальні worktrees і гілки після тих самих перевірок. Опублікована тематична гілка має окремий життєвий цикл.

## Відтворення з резервної копії

Розпакуй `R24-R27C-backup.tar` у свіжий каталог, зберігши два корені `droneflames-archive/` і `droneflames-toolchain/`. З цього каталогу виконай:

```bash
sha256sum -c droneflames-archive/R24-R27C/evidence.sha256
(cd droneflames-archive/R24-R27C && sha256sum -c SHA256SUMS)
bash droneflames-archive/R24-R27C/verify-callbacks.sh
```

Перевірка запускає `facility-callback.gd` для нового спрайта й контролю та `pooled-visibility-callback.gd` для повторного використання спрайта. Вона читає збережені A/B PCK і Godot 4.7.2 з відновленого дерева та порівнює JSON із зафіксованим результатом. У мутаціях очікується ID 9 для baseline і ID 1 для старого PoC. У контролі обидва плеча мають обрати ID 9. Для відновлення вихідних checkout і перепакування див. `r27/r27b/reproduce-callback.sh` та refs у bundle.

Для R23/R25/R26/R27 розпакуй відповідний sealed archive та перевір внутрішній `SHA256SUMS`. Команди офлайн-аналізу й конфігурації запусків містяться у `REPRODUCE.md` або відповідному звіті. R25–R27 також мають точні PCK, Godot і потрібні бібліотеки за відносними шляхами у `evidence-paths.txt`. У старих маніфестах абсолютні шляхи ідентифікують первісне оточення. Для перевірки переносної копії використовуй `evidence.sha256`. R27C feasibility читає `raw/feasibility-dense/result.json` із sealed R27. Розпакуй цей raw файл у `r27/raw/` відновленого дерева та запусти `python3 r27/r27c/feasibility.py` з каталогу performance.

У R27 `light1-B` відсутній знімок процесів після виходу. JSON гри й телеметрія вимірюваного вікна збережені. Початкове перерване плече R25 і діагностичні логи невдалого налаштування R27B збережено з їхніми межами. Фізичний Windows QA для R27 має статус NOT RUN.
