# INT-09 · R17 у beta 0.36.8

> Історичний матеріал з `toolchain/int09.svwoLWvo/handoff/INT09.md`. [Реєстр досліджень](../INDEX.md)

[PR #17](https://github.com/ZaGOR-1/port-drone/pull/17) інтегровано merge commit `117781083ff108c8353b9e53a3eda3d49bedd0fe`. Попередня beta `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Другий батько merge `479b91d1ef139d348962ab02b90189475cb5ba04` додає PATCH, локалізовану примітку, version assertions і PROJECT_STATE. Production PoC із `617c580` і звіт `b7a3178` звірено. Локальна beta чиста та збігається з origin/beta. Main, R18A, усі історичні worktrees і stash `40a9f64` збережено.

## Перевірки

- Початковий R17 CI, фінальний PR CI, діагностика кандидата 50/50 Godot і 2476/2476 simulation. Локальні build identity 3/3, release-policy 15/15 та lint локалізації пройшли. У точному PCK перевірено примітку для ru, uk та en. Історичні R17 Late E GO, Save/Load 22/22, repeated restore, ENet reconnect/resync та lifecycle застосовано за ідентичністю production PoC. Performance suites повторно не запускались.
- ENet admission 0.36.8/0.36.8 PASS, змішані 0.36.7/0.36.8 відхилено в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1, 30 тіків/с.
- Official Linux і Windows x64, Linux native і Wine headless smoke пройшли. Вилучений з EXE PCK та Linux PCK побайтно збігаються з PCK admission. SHA256 `b319c75dac9275b1bb8f5bc4840a214f0b50d4dcf509c252575254487adca416`. Архіви розпаковано і звірено за внутрішніми маніфестами. Зовнішні SHA256 в `../packages/SHA256SUMS`.
- В обох smoke 0.36.8 залишилися попередження тих самих типів. Порівняно зі smoke R17 0.36.7, CanvasItem RID змінилися з 14 до 15, ObjectDB instances з 232 до 234, число resources in use лишилося 44. Причину зміни лічильників окремо не перевіряли.
- Фізичний Windows A/B, фізичні LAN і Steam — NOT RUN за рішенням власника.

## Відновлення

`beta-0.36.7-to-0.36.8.increment.bundle` вимагає попередній beta SHA. У незалежному репозиторії від старої beta перевірено bundle, fetch, fast-forward, clean status, tree SHA, source version і git fsck. Лог у `../evidence/bundle-restore.log`, SHA256 у `SHA256SUMS`.

CI PASS для [PR-кандидата](https://github.com/ZaGOR-1/port-drone/actions/runs/45643841682) і [merge-коміту beta](https://github.com/ZaGOR-1/port-drone/actions/runs/45644955309).
