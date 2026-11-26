# Документація DroneFlames

Почни з [AGENTS.md](../AGENTS.md) і [PROJECT_STATE.md](PROJECT_STATE.md). Знайди потрібну тему в таблиці. Технічні контракти звіряй із кодом на своєму Git HEAD.

## Чинні правила та довідники

| Тема | Канонічний маршрут |
| --- | --- |
| Огляд, авторство й права | [README](../README.md) · [English](../README.en.md) |
| Повноваження й початок сесії | [AGENTS](../AGENTS.md) |
| Поточний baseline і наступні задачі | [PROJECT_STATE](PROJECT_STATE.md) |
| Git, тести, MCP і підтримання документації | [Development Workflow](DEVELOPMENT_WORKFLOW.md) |
| Довгострокові докази, відтворення й очищення | [Політика збереження доказів](DEVELOPMENT_WORKFLOW.md#постійне-збереження-доказів) |
| Продуктова версія і bump | [Versioning Policy](VERSIONING_POLICY.md) |
| Boot, Main, HUD, World і ownership | [Architecture and Flows](codex/verified/ARCHITECTURE_AND_FLOWS.md) |
| Генерація, економіка, AI та військо | [Gameplay Systems](codex/verified/GAMEPLAY_SYSTEMS.md) |
| Ресурси, HUD і масштаб | [Resources and UI](codex/verified/RESOURCES_AND_UI.md) |
| Lockstep, identity, transports | [Multiplayer Protocol](codex/verified/MULTIPLAYER_PROTOCOL.md) |
| Формат save й restore | [Save Format](codex/verified/SAVE_FORMAT.md) |
| Офіційна Windows збірка та CI | [Build and Release](codex/verified/BUILD_RELEASE.md) |
| QA, SFX, MinGW і native diagnostics | [Windows QA](WINDOWS_QA.md) · [Фізичний two-peer сценарій](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md) |
| Локалізація | [Loc, PO і fallback](LOCALIZATION_AUDIT.md) · [Глосарій](LOCALIZATION_GLOSSARY.md) · [Тести й ручний QA](LOCALIZATION_TESTS.md) |
| Приймання продуктивності | [Real-World Gaming Profile B](performance.md#real-world-gaming-profile-b) |
| Native hotspot, Rust/GDExtension | [Межі NATIVE-01–02D](r23/R23_RESULTS.md#межі-попередніх-підходів) · [Build and Release](codex/verified/BUILD_RELEASE.md) · [Windows QA](WINDOWS_QA.md) |
| Ризики й рішення | [Backlog](codex/verified/BACKLOG.md) · [Журнал рішень](codex/verified/DECISIONS.md) |

## Історичні докази

- [Реєстр 97 досліджень ARCHIVE-01](research/INDEX.md) веде до історичних звітів, інструкцій відтворення й зовнішніх доказів.
- [R23](r23/R23_RESULTS.md) веде до масштабування 0.36.4/0.36.7/0.36.11, таблиць, довгих прогонів і меж NATIVE-01–02D. R09 `93a626e` і R16 `c7c031fe` — історичні baselines для походження fixtures. За недоступності віддаленого історичного об’єкта перевір локальний Git або індекс архіву.
- [PERF-01](perf01/PERF01_ANALYSIS.md), [PERF-02](perf02/PERF02_ANALYSIS.md), [PERF-03](perf03/PERF03_RESULTS.md), [R07](r07/R07_RESULTS.md), [R08](r08/R08_RESULTS.md), [R10](r10/R10_RESULTS.md), [R14](r14/R14_RESULTS.md), [R15](r15/R15_RESULTS.md), [R19](r19/R19_RESULTS.md) і [R21](r21/R21_RESULTS.md) зберігають окремі контрольні експерименти.
- [R24](r24/R24_RESULTS.md), [R25](r25/R25_RESULTS.md), [R26](r26/R26_RESULTS.md) і [R27–R27C](r27/R27_RESULTS.md) зберігають результати експериментів масштабування. Постійний локальний handoff із Git bundle та покажчиком доказів — `~/projects/droneflames-archive/R24-R27C/INDEX.md`.
- [R28](r28/R28_RESULTS.md) фіксує ціну копіювання ordered acquisition buckets, callback fixture та feasibility NO-GO.
- [R29](r29/R29_RESULTS.md) фіксує повторні перевірки клітин у watchdog, ціну кешу та feasibility NO-GO.
- [R30](r30/R30_RESULTS.md) ранжує CPU hotspots і пропонує три вузькі напрями масштабування та feasibility для R31.
- [Інвентар Markdown](DOCUMENTATION_AUDIT.md) веде до датованих Phase, INT, FIX, L10N і QA-звітів. [CURRENT_STATE](codex/verified/CURRENT_STATE.md) зберігає ранній handoff, [TEST_MATRIX](codex/verified/TEST_MATRIX.md) — історичні перевірки. Назва каталогу `verified` успадкована. Scope кожного PASS, NO-GO та дозволу визначає відповідний датований доказ.
