# INT-08 · R15 у beta 0.36.7

> Історичний матеріал з `toolchain/int08.1UTXXUmq/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

[PR #16](https://github.com/ZaGOR-1/port-drone/pull/16) об’єднано звичайним merge commit. [Pre-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45610133602) · [Post-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45611268786)

| Роль | SHA |
| --- | --- |
| Стара beta 0.36.6 | `50f3f04306ec49ea600296135225282907c9955c` |
| Оптимізація R15 | `0dc44603c07cd81c96f023295f6a21d928a77cd5` |
| Fixture і докази R15 | `75f6a1327092ad23bcf58cf734010deec6ff870d` |
| Version bump | `6a41f0d49cb1c20e5e49536a53c7df32a6b477d2` |
| Перевірений кандидат | `0be04d6e77dcf10f5f6af890ade948579770710d` |
| Нова beta 0.36.7 | `d6a38e8db58361430df69ffe0a98e628acac6d8b` |
| Спільне повне дерево | `dd16f44de141f445cbfd91eed3fe6c8c663a4f23` |
| Main | `172df65e3bd004efed9a5444e90a284d9d69db10` |
| Ідентичний PCK на Windows і Linux, SHA256 | `c984f1dafdee622da6d206b9427003571244f78e4d8c99a74fc365ac3a6dafb6` |

- [Цільовий review](../../r15/INT08_INTEGRATION.md) · [Вихідні докази R15](../r15/handoff/README.md) · Повний diff (`INT08.diff`) · [Локальний QA](QA.md)
- Windows x64 QA ZIP (`../packages/DroneFlames-0.36.7-Windows-x64-QA.zip`) · Linux x86_64 QA TAR (`../packages/DroneFlames-0.36.7-Linux-x86_64-QA.tar.gz`) · SHA256 (`../packages/SHA256SUMS.txt`) · Розміри в байтах (`../post/archive-sizes.txt`) · Перевірка після розпакування (`../evidence/post-archives.log`)
- Git bundle increment (`beta-0.36.6-to-0.36.7.increment.bundle`) · Незалежне відновлення (`../evidence/restore.log`) · Checkout, worktrees і cleanup (`../evidence/finish-git.log`)
- [Контекст R16](R16_CONTEXT.md) · SHA256 доказів (`SHA256SUMS.txt`)

Після розпакування Linux smoke пройшов. Перший Wine smoke мав нативний page fault. Повтори й контроль бази описано в [QA](QA.md).

Фізичний Windows GUI/FPS відкладено власником, фізичні LAN і Steam — NOT RUN. Залишкові ризики щільного D2100, R10, R14 і teardown відкриті. R11–R13 лишилися поза beta. Main без змін. Release, tags і deployment відсутні.

Для відновлення bundle потрібна історія до 0.36.6 включно. Незалежний тест отримав лише попередній beta до імпорту bundle і перевірив SHA, дерево, версію та git fsck. Якщо потрібен відкат R15, створити окремий reviewable PR від актуальної beta з `git revert -m 1 d6a38e8db58361430df69ffe0a98e628acac6d8b` і пройти відповідний QA. Версію й допуск кандидата відкату погодити в цьому PR.
