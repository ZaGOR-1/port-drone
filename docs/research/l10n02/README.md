# DroneFlames · L10N-02

> Історичний матеріал з `toolchain/l10n02-qa.sfnBnw/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

Локальний handoff зі статусом PARTIAL. Feature HEAD `a8aff50a41ea23a80fad3f497b92fa695dffde78`, дерево гри `26e85284d4c7ae2d11bdc95a0f09eef623d15683`. Версія 0.36.0. Production beta `c91e0e6a7eef831687e6e63550560bba739a6b87`.

Bundle містить feature-гілку з повною історією, включно з базою. Архів QA містить журнал аудиту перекладів, результати тестів, скриншоти та маніфести збірки. Профілі й файли збережень до архіву QA не входять. Перевірений локальний Windows QA-пакет лежить у `../validated/`.

```bash
sha256sum --check --strict SHA256SUMS.txt
git clone --branch feature/development-standards-l10n ./droneflames-l10n02.bundle restored
git -C restored fsck --full
git -C restored status --short --branch
```

Для приймання дивись `docs/LOCALIZATION_TESTS.md` у відновленій гілці.
