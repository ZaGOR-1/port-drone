# INT-12 · R21 у beta 0.36.11

> Історичний матеріал з `toolchain/int12.7iX78x0s/handoff/INT12.md`. [Реєстр досліджень](../INDEX.md)

[PR #20](https://github.com/ZaGOR-1/port-drone/pull/20) інтегровано. Стара beta `3298af5878501d458920b41dc5738f60571ac551`. Нова beta `f629882296a3419b2e1dc298619f83072c1320f9`, фінальний кандидат `2c38f711970a9206674ef92c89f9b73d2cdb1ea0`. Основний checkout синхронізовано fast-forward. Git status чистий, main, історичні worktrees, Rust PoC та stash збережено.

## Gate і QA

- Performance GO для D2100 restore після двох дозволених пар. У всіх п'яти парах CPU watchdog-тіків разом нижчий. Кількості маршрутів і команд однакові. Локальні перевірки обмежені wd_exit. FPS понад −5% просів у двох із п'яти пар, 1% low у жодній. П’ять пар дали медіани −4,86% FPS, +3,12% 1% low, +4,48% simulation CPU та −16,40% tick p99. Розкид CPU поза watchdog, вищі p95, command batch і D5000 siege лишаються відкритими. [Оцінка](handoff/PERFORMANCE.md) · Архів сирих даних (`INT12-performance.tar.gz`)
- Production QA R21 підтверджено за кодом, артефактами та SHA256. Differential 576/576, Operations/transport 37/37 на плече, 390/390 тіків, Save/Load 22/22, snapshot restore та ENet reconnect/resync. Performance suite поза двома дозволеними парами не повторювався.
- Build identity 3/3, localization lint, release note ru/uk/en, CI фінального кандидата, Linux native/Wine smoke і маніфести архівів пройшли. [Початковий CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45695337429) · [CI кандидата](https://github.com/ZaGOR-1/port-drone/actions/runs/45698199546) · [CI beta](https://github.com/ZaGOR-1/port-drone/actions/runs/45699108024)
- ENet допускає 0.36.11/0.36.11 і відхиляє 0.36.10/0.36.11 в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с.
- Пакети з merge-коміту. SHA256 PCK `6a6ba98baa85c72d5bb1b5d22c2b54f7e39faf41a87330f9b10aad884f4bcb92` збігається між Windows EXE, Linux і admission. SHA256 пакетів (`../packages/SHA256SUMS`)
- Фізичні Windows FPS, LAN і Steam — NOT RUN. Дефекти teardown Godot лишаються відкритими.

## Backup

`beta-0.36.10-to-0.36.11.increment.bundle` відновлено на незалежному репозиторії з попередньої beta. Збіглися SHA, повне дерево й версія. Clean status та git fsck PASS. Доказ відновлення (`../evidence/bundle-restore.log`) · SHA256 bundle (`SHA256SUMS`)
