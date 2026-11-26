# MAINT-05 · Допоміжні папки

> Історичний матеріал з `archive/MAINT-05/INDEX.md`. [Реєстр досліджень](../INDEX.md)

**PASS.** Прибрано 21 погоджений detached worktree `port-drone-*` через `git worktree remove`. Для трьох dirty дерев R13, R18A і R22 застосовано `--force` після незалежного відновлення їхніх дельт з KINGSTON і звірки з фактичними файлами. Серед допоміжних копій також був ігнорований Python bytecode cache. Усі 21 SHA доступні в USB bundle під `refs/maint01/worktrees/wt-*`.

За інтервал видалення доступне місце зросло на **2 505 199 616 байтів (2,33 ГіБ)**. Додано журнал шляхів і SHA. Очищення (`cleanup.tsv`) · Заміри (`space.tsv`) · Результати USB restore (`backup-check.log`)

Десять історичних symlinks тепер ведуть до наявних Git копій із тим самим SHA або побайтно однакових файлів у handoff. Їхні поточні цілі перевірено після вилучення. Точні посилання (`links-repointed.tsv`)

У `~/projects` є одна папка з префіксом `port-drone`, основний checkout `port-drone` на чистій `beta` `7181e88`. Локально й на GitHub є лише `main` і `beta`. Залишилося 13 зареєстрованих worktrees, переважно вкладених у toolchain. Стан `performance/source` і stash `40a9f64` збігається з перевіреним backup.

## Папки droneflames

| Папка | Роль і стан |
| --- | --- |
| `droneflames-toolchain` | Приблизно 221 ГіБ. Містить чинні інструменти, Godot, runtime та історичні збірки й виміри. Основні великі кандидати залишаються в плані MAINT-03. |
| `droneflames-archive` | Приблизно 2,79 ГіБ. Містить резервні копії, каталоги та докази. Найбільша частина лежить у verification MAINT-01. |
| `droneflames-worktrees` | Приблизно 114 МіБ. Єдина дочірня папка `maint-02` — чистий detached worktree інтегрованого PR #21. Каталог призначений для нових тимчасових worktrees. |

Виділені байти (`droneflames-sizes.tsv`) · [Попередній план для великих артефактів](../maint-03/INDEX.md)

Для відновлення колишнього дерева взяти точний `wt-id` і SHA з approved-targets.tsv. У локальному чи USB bundle відповідний ref має форму `refs/maint01/worktrees/wt-XX`. Порядок відновлення tracked, staged та untracked payload наведено в [MAINT-01](../maint-01/INDEX.md#відновлення).
