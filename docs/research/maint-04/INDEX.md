# MAINT-04 · Гілки

> Історичний матеріал з `archive/MAINT-04/INDEX.md`. [Реєстр досліджень](../INDEX.md)

**PASS.** Після прямого погодження видалено 17 локальних і п’ять GitHub-гілок. Локально та на GitHub є `main` (`172df65e3bd004efed9a5444e90a284d9d69db10`) і `beta` (`7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33`). Створено відсутній локальний tracking ref `main → origin/main`. Основний checkout чистий на `beta`. GitHub default — `main`.

Усі 34 worktrees залишилися на своїх SHA. 17 переведено в detached HEAD. Перед і після зміни перевірено tracked diffs, status та untracked/ignored дані. Dirty дельти `performance/source`, R13, R18A і R22 збігаються з перевіреним backup. Stash `40a9f64be2729b80cff7d6139f9addd64a687993` на місці.

Перед видаленням виконано незалежний fetch/fsck трьох bundles із KINGSTON. Звірилися всі локальні та GitHub heads, коміти з reflog і stash. Назви та повні SHA залишено в інвентарі. Для відновлення `perf/impact-candidate-enumeration` уточнити джерело. Локальна R18A була на `6d83ef9`, а GitHub R18B на `803ca9e`.

Локальні refs до вилучення (`local-before.tsv`) · GitHub refs до вилучення (`remote-before.tsv`) · Доказ відновлення (`recovery.log`) · GitHub після вилучення (`remote-after.tsv`) · Локальний Git після вилучення (`local-after.txt`) · Dirty payload після вилучення (`dirty-after.log`)

Для відновлення гілок використовувати [перевірені bundles та інструкції MAINT-03](../maint-03/INDEX.md). У базовому bundle локальні гілки зберігаються під `refs/heads/*`, віддалені під `refs/remotes/origin/*`. Гілку MAINT-02 і фінальний merge містять відповідні increment bundles.
