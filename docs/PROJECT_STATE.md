# DroneFlames — пам’ять проєкту

Звірено 2026-11-26 для `origin/beta` `047c474e9058b819a45b0fc8f705d00cfd45c95c`. Перед роботою звір фактичний Git HEAD, refs і worktree. [Маршрут за темами](INDEX.md)

## Baseline

| Що | Перевірено |
| --- | --- |
| Продукт | RTS із генерацією карти, економікою, військом, ШІ, дипломатією, хронікою та Save/Load. LAN/ENet і Steam lockstep реалізовані. [Архітектура](codex/verified/ARCHITECTURE_AND_FLOWS.md) |
| `origin/beta` | `0.36.11`, INT-12/R21, документація R24–R27C та реєстр ARCHIVE-01. Локальна `beta`, серверний і remote-tracking refs збіглися на `047c474`. [PR #23](https://github.com/ZaGOR-1/port-drone/pull/23), [PR #24](https://github.com/ZaGOR-1/port-drone/pull/24) |
| `main` | `172df65e3bd004efed9a5444e90a284d9d69db10`. Історична UI-мітка `v0.34.0` і конфіг updater `0.33.2.3` належать цьому checkout. |
| Контракти `beta` | [Version](../game/pc/version.cfg) `0.36.11`, [NetConfig](../game/net/net_config.gd) PROTO 7, SIM_REV `v036-integration-1`, 30 ticks/s, 3 ticks/turn. [Save](../game/game/save.gd) FORMAT 1. Мережевий identity містить повну версію. QA peers звіряють SHA256 EXE/DLL. |
| Платформа й toolchain | Ціль Windows x64, фізичний QA на Windows 11. DOCS-02 виконано на нативному Ubuntu 26.04.1. Попередні WSL2 і Wine виміри мають власні scopes. Склад офіційного Godot звірено з [CI-піном](../tools/ci/godot-4.7.2.json). Нативний Linux-порт і cross-play відкладені. |
| CI на `1e91239` | Python/CI policy і Godot regressions/Windows x64 build SUCCESS. Release SKIPPED. [Run 45729343211](https://github.com/ZaGOR-1/port-drone/actions/runs/45729343211) |

## Межі QA та відкриті ризики

- GUI, хоткеї, Save/Continue і запуск Steam підтверджені власником на історичному суміщеному SFX. Фізичні Windows LAN, Steam-матч, reconnect/resync і кількісний late-game Profile B для поточної `beta` — NOT RUN. [Точні збірки й докази](WINDOWS_QA.md)
- Історичне падіння до 2–3 FPS після попередніх оптимізацій **більше не спостерігається за повідомленням власника від 2026-11-26**. R24 зосереджено на масштабуванні. R23 лишається джерелом історичних вимірів 0.36.4 → 0.36.11 на Ubuntu. Фізичне Windows-приймання поточної `beta` має окремий scope. [R23](r23/R23_RESULTS.md) · [Історичний R19 A/B](r19/R19_RESULTS.md)
- R24 завершив аналіз на `1e91239`. Звірено історичні raw R23 і локалізовано повторну роботу в fallback-маршрутах для масових наказів за поточним кодом та лічильниками R08/R21. Нові runtime та performance прогони — NOT RUN. Shortlist, gates і локальні докази в [R24](r24/R24_RESULTS.md). Початкова гілка `research/r24-scalability` збережена в Git bundle R24–R27C. Історичні NO-GO R11/R12/R13/R22 і межі NATIVE-01–02D лишаються чинними у власних scopes.
- **R25 INCONCLUSIVE** на `1e91239`. У шести rendered парах Late E медіанна парна економія CPU пакета становила 24,5%. Еквівалентність і regression gates пройшли. Tick p99 зріс на 9,2% при допуску +5%, джерело зсуву не встановлено. PoC `2e80fe1` збережено локально, ігрову дельту вилучено в `0adae21`. [R25 та handoff](r25/R25_RESULTS.md)
- **R26 NO-GO** на `1e91239`. Triangle array для підкладок дав точний RGBA у 15/15 сценах і пройшов replay та regression gates. У dense D5000 парний outline CPU зріс на 1,45%, сумарний CPU UnitsLayer — на 1,91%, FPS знизився на 1,41%. PoC `d9cf846` є локальним, ігрову дельту вилучено в `cc8cc3d`. [R26 та handoff](r26/R26_RESULTS.md)
- **R27C NO-GO, кандидат відкладено.** Після R27B розбіжність цілі відтворено також на `visibility_changed` повторно використаного спрайта. Побудова на кожен запит не амортизується за вимірами R27. Runtime `62e20a5` вилучено в `9d3610c`. PR #23 інтегрував документацію R24–R27C, дерево гри відповідає `1e91239`, версія `0.36.11`. [R27–R27C](r27/R27_RESULTS.md#r27c--відновлення-коректності)
- **R28 NO-GO на feasibility.** У dense D5000 R19 скопіював 833 299 посилань за 60 тіків. Microprobe дав 0,213 мс/тік для всього шляху копіювання при порозі 0,25. Callback fixture підтвердив межу snapshot membership. Runtime PoC і rendered A/B — NOT RUN. [R28 та відтворення](r28/R28_RESULTS.md)
- Відомі teardown/RID попередження. Відтворення DummyTexture і зв’язок із HUD fixture зафіксовано в R08. Очищення слота через `Ctrl+1–9` без виділення залишається чинною поведінкою, UX-зміна потребує окремої задачі. [R08](r08/R08_RESULTS.md#детермінізм-та-qa) · [Керування](codex/verified/WINDOWS_CONTEXT_HOTKEYS_QA.md)
- Updater integrity, відновлення після збоїв та покриття всіх мережевих схем потребують окремого підтвердження. [Backlog](codex/verified/BACKLOG.md)
- [Реєстр 97 досліджень ARCHIVE-01](research/INDEX.md) веде до звітів, відтворення й місць збереження доказів. Постійний handoff R24–R27C — `~/projects/droneflames-archive/R24-R27C/`. Частина старих тестових файлів у `droneflames-toolchain/.cold-storage` потребує відновлення за її README. [Політика збереження доказів](DEVELOPMENT_WORKFLOW.md#постійне-збереження-доказів)

## Next steps

1. Повертатися до R27 за наявності гарантованої межі інвалідації зі збереженням амортизації. Фізичний Windows QA для R27 — NOT RUN. [R27C](r27/R27_RESULTS.md#r27c--відновлення-коректності)
2. Рішення щодо R25 відкладено. Для повторного розгляду PoC перевірити джерело зсуву tick p99 на тих самих replay ticks і підтвердити допуск у парному rendered [Profile B](performance.md#real-world-gaming-profile-b). [R25](r25/R25_RESULTS.md)
3. Провести [двопірний Windows QA](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md) з LAN, Steam та reconnect/resync.
