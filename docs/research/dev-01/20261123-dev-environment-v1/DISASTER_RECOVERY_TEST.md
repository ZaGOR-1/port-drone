# Disaster Recovery Test

> Історичний матеріал з `toolchain/backups/20261123-dev-environment-v1.J78ugB/essential.tar.zst::droneflames-toolchain/dev-environment/docs/DISASTER_RECOVERY_TEST.md`. [Реєстр досліджень](../../INDEX.md)

Відновлення виконується у свіжому порожньому каталозі з пробілами в імені. Окремі прогони перевіряють Essential і Essential + Extended.

1. Звірити SHA256 архівів, виконати bootstrap restore, звірити bundle, `beta`/`main`, diagnostic HEAD, diff, untracked і режими файлів. Звірити відновлений вміст із backup-inventory.
2. Перевірити Godot Release/QA/patch за локальним build manifest, офіційні редактор/template за CI pin, SFX за packager і обидва профілі через `df-windows run --check`.
3. Перевірити R01/R02 PCK/packages, raw JSON/CSV і `e-long/state.snapshot` за хешами. Виконати легкі перевірки Python runner і build identity.
4. Для Extended перевірити точний upstream commit, застосовність C++ patch, Git fsck, ZIP та MinGW preflight без компіляції.
5. Звірити production Git/диф worktree й попередню копію. Окремо записати перевірку PowerShell parser і межі Windows QA.

Версійний backup має фінальний звіт `DISASTER_RECOVERY_TEST.md` поряд з архівами. Він створюється після відновлення саме цих архівів.
