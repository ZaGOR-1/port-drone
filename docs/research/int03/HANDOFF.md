# INT-03 · beta 0.36.2

> Історичний матеріал з `toolchain/int03.IGMm9Fth/handoff/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

[PR #11](https://github.com/ZaGOR-1/port-drone/pull/11) інтегровано звичайним merge commit. Стара beta , нова beta , перевірений HEAD PR . Повне Git-дерево merge відповідає кандидатові. Main . [CI до merge](https://github.com/ZaGOR-1/port-drone/actions/runs/45455652643) · [CI після merge](https://github.com/ZaGOR-1/port-drone/actions/runs/45456781081)

Локальний  на чистій beta, синхронізованій fast-forward. Гілку  видалено локально й віддалено.  лишено на detached  для історичних сценаріїв toolchain.

Обидва official QA-архіви з точного merge SHA. Метадані, розміри, SHA256 та докази в  й . Runtime останньої перевіреної версії DEV-02 потрібен для нових збірок.

-
-

## Відновлення

Почни з чистої beta , відновленої DEV-02. У каталозі handoff виконай . Далі з кореня відновленого checkout перевір , виконай  і . Звір b2af27a67d503aa6587a82dc5255458fedf32e79 з  та 0.36.2 з . Процедуру перевірено на незалежному клоні відновленої beta DEV-02 через Git bundle, fast-forward, дерево й dangling blob 92645e8ae814d22df21e86d2804b532b410cc870
dangling commit c1ddd45139da8259aed5c6e9a911d797cecd9bd0.

## Відкладені перевірки та відкат

Фізичний Windows GUI QA — NOT RUN, відкладено власником. Фізичний LAN і Steam — NOT RUN. За повного боєзапасу GUI performance INCONCLUSIVE. Для мережевої сесії потрібна однакова повна версія. Звичайні збереження використовують Save.FORMAT 1.

Для відкату створи окрему гілку від поточної beta, застосуй  і подай окремий PR до beta. Review має перевірити вплив на версію, мережевий допуск і зміни після INT-03. Запусти CI перед інтеграцією revert.

Після fast-forward повторна звірка виявила в індексі та файлах точне дорелізне дерево 0.36.1. Цей стан збережено в локальному stash `40a9f64be2729b80cff7d6139f9addd64a687993` і в `pre-ff-checkout-snapshot.patch` поруч із handoff. Фінальний checkout повторно звірено з origin/beta та build guard 0.36.2.
