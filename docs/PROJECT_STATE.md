# DroneFlames — пам’ять проєкту

Звірено 2026-11-26 для `beta` `7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33`. Перед роботою звір фактичний Git HEAD, refs і worktree. [Маршрут за темами](INDEX.md)

## Baseline

| Що | Перевірено |
| --- | --- |
| Продукт | RTS із генерацією карти, економікою, військом, ШІ, дипломатією, хронікою та Save/Load. LAN/ENet і Steam lockstep реалізовані. [Архітектура](codex/verified/ARCHITECTURE_AND_FLOWS.md) |
| `beta` | `0.36.11`, INT-12/R21 і документація MAINT-02/R23. Локальна гілка й remote ref збіглися на момент звірки. [PR #20](https://github.com/ZaGOR-1/port-drone/pull/20), [PR #21](https://github.com/ZaGOR-1/port-drone/pull/21) |
| `main` | `172df65e3bd004efed9a5444e90a284d9d69db10`. Історична UI-мітка `v0.34.0` і конфіг updater `0.33.2.3` належать цьому checkout. |
| Контракти `beta` | [Version](../game/pc/version.cfg) `0.36.11`, [NetConfig](../game/net/net_config.gd) PROTO 7, SIM_REV `v036-integration-1`, 30 ticks/s, 3 ticks/turn. [Save](../game/game/save.gd) FORMAT 1. Мережевий identity містить повну версію. QA peers звіряють SHA256 EXE/DLL. |
| Платформа й toolchain | Ціль Windows x64, фізичний QA на Windows 11. DOCS-02 виконано на нативному Ubuntu 26.04.1. Попередні WSL2 і Wine виміри мають власні scopes. Склад офіційного Godot звірено з [CI-піном](../tools/ci/godot-4.7.2.json). Нативний Linux-порт і cross-play відкладені. |
| CI на baseline | Python/CI policy і Godot regressions/Windows x64 build SUCCESS. Release SKIPPED. [Run 45714307932](https://github.com/ZaGOR-1/port-drone/actions/runs/45714307932) |

## Межі QA та відкриті ризики

- GUI, хоткеї, Save/Continue і запуск Steam підтверджені власником на історичному суміщеному SFX. Фізичні Windows LAN, Steam-матч, reconnect/resync і кількісний late-game Profile B для поточної `beta` — NOT RUN. [Точні збірки й докази](WINDOWS_QA.md)
- R23 зафіксував локальний ефект 0.36.4 → 0.36.11 на Ubuntu з контрольними сценами. Відтворення 2–3 FPS у кампанії власника лишається відкритим. R11/R12/R13/R22 зберігають історичні NO-GO. NATIVE-01–02D дослідили GDExtension й межі інтеграції, production Rust відкладено. [R23](r23/R23_RESULTS.md)
- Відомі teardown/RID попередження. Updater integrity, відновлення після збоїв та покриття всіх мережевих схем потребують окремого підтвердження. [Backlog](codex/verified/BACKLOG.md)
- Локальні історичні докази шукай за індексом `droneflames-archive` і handoff відповідної задачі. Частина старих тестових файлів у `droneflames-toolchain/.cold-storage` потребує відновлення за її README. Попередній стан з ідентифікаторами PERF, INT, FIX, L10N та історичними шляхами збережено в [Git snapshot](https://github.com/ZaGOR-1/port-drone/blob/7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33/docs/PROJECT_STATE.md).

## Next steps

1. Відтворити late-game скаргу на фізичній Windows із save власника та точним SHA256 комплекту. Профілювати за [Profile B](performance.md).
2. Провести [двопірний Windows QA](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md) з LAN, Steam та reconnect/resync.
3. DOCS-02 підготовлено для локального review у `~/projects/droneflames-worktrees/docs02`, гілка `docs/docs02-comprehensive-audit`. [Інвентар і перевірки](DOCUMENTATION_AUDIT.md)
