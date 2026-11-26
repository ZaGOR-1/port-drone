# INT-07 · R14 у beta 0.36.6

> Історичний матеріал з `toolchain/int07.4IWmLXCl/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

[PR #15](https://github.com/ZaGOR-1/port-drone/pull/15) об'єднано звичайним merge commit. [Pre-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45516921206) · [Post-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45517944649)

| Роль | SHA |
| --- | --- |
| Стара beta 0.36.5 | `8c83d91d06989cc3857c7560c4690188bf88a964` |
| Оптимізація R14 | `13dd5bffbd2878bf416c0d3bdd7663c43f7d8f73` |
| Звіт R14 | `8a7ddc2c3d4f3659d4d1902e0f1ce17e2dd1b256` |
| Version bump | `8649531` |
| Перевірений кандидат | `afa984703929c2fa3b8b05953634e370831a38e7` |
| Нова beta 0.36.6 | `50f3f04306ec49ea600296135225282907c9955c` |
| Спільне дерево кандидата та merge | `53246f04009e753809231eae7514aaeaa6736996` |
| Main | `172df65e3bd004efed9a5444e90a284d9d69db10` |

- [Цільовий review](../../r14/INT07_INTEGRATION.md) · Повний diff (`INT07.diff`) · [Результати локального QA](QA.md) · [R14 raw і provenance](../r14/handoff/README.md)
- Windows x64 QA ZIP (`../packages/DroneFlames-0.36.6-Windows-x64-QA.zip`) · Linux x86_64 QA TAR (`../packages/DroneFlames-0.36.6-Linux-x86_64-QA.tar.gz`) · SHA256 архівів (`../packages/SHA256SUMS.txt`) · Розміри в байтах (`../post/archive-sizes.txt`) · Smoke після розпакування (`../evidence/post-archives.log`)
- Git bundle increment (`beta-0.36.5-to-0.36.6.increment.bundle`) · Незалежне відновлення (`../evidence/restore.log`) · Синхронізація і cleanup (`../evidence/finish-git.log`) · Pre CI JSON (`../github/pre-ci.json`) · Post CI JSON (`../github/post-ci.json`)
- [R15 context](R15_CONTEXT.md) · SHA256 доказів (`SHA256SUMS.txt`)

Цей bundle доповнює копію історії з базовим комітом 0.36.5. Відновлення перевірено в окремому клоні, у якому до імпорту був лише старий стан beta. Для відкату створити окрему робочу гілку від актуальної beta й PR із reviewable revert merge-коміту від першого батька. Окремо перевірити політику версії, допуск і пакети цього revert перед інтеграцією.

Фізичні Windows GUI/FPS, LAN і Steam лишаються NOT RUN. Власник відклав це приймання. Залишкові ризики C1200, щільного бою і teardown описано в QA та review.
