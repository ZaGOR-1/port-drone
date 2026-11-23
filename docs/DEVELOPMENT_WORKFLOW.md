# Development Workflow

Зафіксована база для цієї роботи — beta c91e0e6. Локальна beta відстежує origin/beta, origin/main — стабільний ref. У доступній історії тегів немає. Наявні короткі Conventional Commits та merge commits від accepted PR. Вкладених AGENTS.md на базі немає. CI будує Windows x64 і ганяє Python/Godot fixtures. Вбудований release job блокує публікацію навіть за ручного запиту.

1. Звір base, статус і всі релевантні worktrees. Створи окремий worktree. Залиш незакомічені діагностичні й чужі дерева як є.
2. Сформуй невелику зміну й релевантний тест. Godot запусти з фізичної копії або готового PCK в ізольованому профілі.
3. Звір status, staged diff і секрети. Додай лише явний список файлів. Після перевірок зроби логічний локальний коміт. Формат — type(scope): коротка дія. Приклад: fix(l10n): resolve mixed-language UI strings.
4. Зазнач у PROJECT_STATE.md перевірені SHA, незавершені QA, версію та точну гілку. Перед майбутньою інтеграцією звір актуальну beta. PR, push, merge, tag і release потребують дозволу.

[Постійні правила](../AGENTS.md) · [Версіонування](VERSIONING_POLICY.md)
