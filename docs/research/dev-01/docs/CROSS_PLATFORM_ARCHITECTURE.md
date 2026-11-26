# Спільний код та платформні інструменти

> Історичний матеріал з `toolchain/dev-environment/docs/CROSS_PLATFORM_ARCHITECTURE.md`. [Реєстр досліджень](../../INDEX.md)

`port-drone` і `beta` лишаються джерелом гри. Формат save, мережевий протокол, симуляція й тести спільні. Toolchain тримає платформні editors, шаблони, DLL, SFX та докази QA поза checkout. Шляхи задає `DF_WORKSPACE_ROOT`, частина інструментів приймає явні overrides. `environment.json` посилається на чинні Godot pins і provenance за ролями. Хеші рушія читаються з джерел істини.

1. Зафіксувати мінімальну версію API manifest після перевірки відновлення на новій системі. Підхопити в `df-windows` наявні профілі та зберегти старі команди.
2. Тонкий диспетчер `df` підключено до Windows build, run і SFX. Обидва профілі пройшли перевірку identity, DLL та SHA256 у workspace з пробілами на Ubuntu. WSL2 ще потребує окремої перевірки.
3. Узгодити Windows backend після нативного QA. Спільні верифікатори, platform-specific tool discovery, packaging і launcher. Перевірити однакову поведінку на тому самому commit.
4. Після окремого рішення про Linux-порт підібрати нативні GDExtension, залежності та Linux packaging. Додати окремий QA gate для runtime і валідувати shared Save/Load та MP compatibility.

[Cross-Platform Build v1](CROSS_PLATFORM_BUILD.md) фіксує доступні команди та QA. Linux build/run/package і загальний `df test` залишаються наступними етапами.
