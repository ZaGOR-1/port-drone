# Development Standards v1 · Backup

> Історичний матеріал з `toolchain/standards-l10n-qa.5fWAvJ/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

Збережи цей каталог разом із Development Environment v1. Bundle містить тільки три feature-коміти й потребує Git-бази c91e0e6 з Essential v1. Профілі, saves і секрети до bundle не входять.

```bash
(cd "/path/to/handoff" && sha256sum --check --strict SHA256SUMS.txt)
git -C "/path/to/restored/port-drone" bundle verify "/path/to/handoff/development-standards-l10n.bundle"
git -C "/path/to/restored/port-drone" fetch "/path/to/handoff/development-standards-l10n.bundle" \
    feature/development-standards-l10n:refs/heads/feature/development-standards-l10n
```

Fetch створює відсутню локальну feature-гілку. Base beta лишається на своєму commit. Перевірені QA-докази в окремому архіві.
