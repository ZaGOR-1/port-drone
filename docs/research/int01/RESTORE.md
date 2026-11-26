# INT-01 · Відновлення handoff

> Історичний матеріал з `toolchain/integration-qa-v0.36.1/RESTORE.md`. [Реєстр досліджень](../INDEX.md)

## Артефакти

- `DroneFlames-0.36.1-Integration-QA-Windows-x64.zip` — переносний QA-комплект для Windows x64. Розпакуй його повністю, виконай команди з `README-QA.md` й залиш DLL поряд із EXE.
- `DroneFlames-INT01.bundle` — повна Git-історія інтеграційної гілки з трьома вихідними PR.
- `BUILD_PROVENANCE.json` — вихідний SHA, дерево, pin Godot і контрольні суми EXE/DLL. Оригінальний маніфест `df` збережено в `evidence/df-build-provenance-official.json`.
- `Windows-QA-checklist.md`, `RESULTS.md` і `INTEGRATED_COMMITS.txt` — ручний QA, підсумок і provenance комітів.

## Відновлення в новий каталог

```sh
sha256sum --check --strict SHA256SUMS.txt
git clone --branch integration/qa-v0.36.1 ./DroneFlames-INT01.bundle ./port-drone-int01-restored
git -C ./port-drone-int01-restored fsck --full
git -C ./port-drone-int01-restored rev-parse HEAD HEAD:game
```

Очікувані SHA у відповідному порядку:

- `f3db608d77a8d7f78af22c6122108962e5f3c75f`
- `26dd6975cf20e987d4db703f1cabde4e85483cb0`

Bundle перевірено через `git bundle verify`, окремий clone і `git fsck --full`. Для нового Windows ZIP запусти чинний `df build --platform windows --profile official --source <restored>` з pinned toolchain. Базовий SHA і всі результати в `RESULTS.md`.
