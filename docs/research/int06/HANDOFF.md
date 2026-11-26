# DroneFlames INT-06 · beta 0.36.5

> Історичний матеріал з `toolchain/int06.ruEDaqvC/handoff/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

[PR #14](https://github.com/ZaGOR-1/port-drone/pull/14) інтегровано звичайним merge-комітом `8c83d91d06989cc3857c7560c4690188bf88a964` від `d8114afac56c2475ca9ded5bd8627d4d42000041`. Другий батько `4dc315c9a3a53f554bab031fed39bf3bfe481474` має те саме повне дерево. Version bump `a2bcdb0dfc55ed7bfe300f241c582f496c8d60a2`. Main звірено на `172df65e3bd004efed9a5444e90a284d9d69db10`. [PR CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45502518012) · [beta CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45503403181)

## Склад

- `beta-0.36.4-to-0.36.5.increment.bundle` відновлює merge й вершину R10 з наявного базового 0.36.4. Незалежний restore зафіксовано в `post/restore.log`.
- `DroneFlames-R10-handoff.tar.gz` містить сирі A/B, fixtures, differential tests, результати й provenance R10. `candidate` додає review p99, diff, перевірки нової версії, Windows kit provenance й межі приймання власником.
- `replay` містить повторні INT-06 покрокові JSON і журнали. `pre-final` та `post` зберігають build provenance і smoke. `github` містить CI, PR, branch rules і знімки releases, tags та deployments.
- `SHA256SUMS.txt` перевіряється командою `sha256sum -c SHA256SUMS.txt` у цьому каталозі. Маніфест пакетів розміщено в `post/PACKAGE-SHA256SUMS.txt` та в каталозі пакетів.

## QA-пакети

- `/home/zagor/projects/droneflames-toolchain/int06.ruEDaqvC/packages/DroneFlames-0.36.5-Windows-x64-QA.zip` · 139372562 байти · SHA256 `92db3259926645382b0afadc08001fbaf45b04a794f911147dbca41af9fb0295`.
- `/home/zagor/projects/droneflames-toolchain/int06.ruEDaqvC/packages/DroneFlames-0.36.5-Linux-x86_64-QA.tar.gz` · 126957310 байтів · SHA256 `d11ee4de16a0abdacad36d043f5d9e8ccc3164fd3760c8764924a83ba6e471c2`.

Official Godot 4.7.2, Linux x86-64 ELF і SO, Windows PE32+ x86-64 EXE й DLL. Provenance обох має джерело `8c83d91d06989cc3857c7560c4690188bf88a964`, clean і спільний PCK SHA256 `90586bf043ecd7c1b2f7f1a5e2e08a89aa4a0ac05f3184af158e44fc6f6ba8f7`. Linux native і Wine headless smoke після розпакування PASS.

## Межі перевірок

R10 Physical Windows user acceptance: PASS — owner-reported. Quantitative Windows A/B metrics: NOT PROVIDED. Фізичні Windows GUI/FPS фінального 0.36.5, LAN і Steam — NOT RUN. ENet loopback, admission, reconnect і resync перевірено у двопроцесному fixture на pinned editor із PCK кандидата. Додаткова спроба запустити зовнішній fixture в official export template не завершилася, оскільки його CLI не підтримує `--main-pack`, а з автоматичним PCK зовнішній script не видав тестовий маркер. Нативний launcher перевірено smoke після розпакування. DummyTexture і попередження про ресурси при виході лишаються відкритими.

R11 NO-GO збережено локально. Відкат INT-06 через окремий reviewable PR до `beta` з `git revert -m 1 8c83d91d06989cc3857c7560c4690188bf88a964` і повторною перевіркою версії, CI та сумісності.
