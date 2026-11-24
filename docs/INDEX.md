# Документація DroneFlames

Почни з [PROJECT_STATE.md](PROJECT_STATE.md). Посилання нижче ведуть до основного документа для кожної теми. Для технічних контрактів остаточним джерелом є відповідний код на перевіреному Git HEAD. Історичні звіти фіксують стан на момент написання.

| Тема | Основне джерело | Що знайдеш |
| --- | --- | --- |
| Початок роботи | [README](../README.md) · [AGENTS](../AGENTS.md) | Опис гри, запуск, правила для сесій |
| Стан проєкту | [PROJECT_STATE](PROJECT_STATE.md) | Git, кандидати, відкриті питання, handoff |
| Архітектура | [Architecture and flows](codex/verified/ARCHITECTURE_AND_FLOWS.md) | Boot, Main, HUD, World, симуляція й межі модулів |
| Ігрові підсистеми | [Gameplay systems](codex/verified/GAMEPLAY_SYSTEMS.md) · [Resources and UI](codex/verified/RESOURCES_AND_UI.md) · [Hotkeys](codex/verified/WINDOWS_CONTEXT_HOTKEYS_QA.md) | Генерація, економіка, військо, ШІ, ресурси й desktop UI |
| Мультиплеєр | [Multiplayer protocol](codex/verified/MULTIPLAYER_PROTOCOL.md) · [Two-peer QA](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md) | PROTO, Steam/LAN, host turns, hashes, план двох ПК |
| Save/Load | [Save format](codex/verified/SAVE_FORMAT.md) · [R02 recovery](codex/verified/R02_RELEASE_RECOVERY.md) | FORMAT1, optional fields, межі restore і downgrade |
| Windows build/export | [Build and release](codex/verified/BUILD_RELEASE.md) | PCK, DLL, CI, офіційний template та межі SFX |
| Godot runtime | [Windows QA · MinGW](WINDOWS_QA.md#godot-mingw) | Native race, provenance, headless CPU benchmark |
| Тестування і QA | [Windows QA](WINDOWS_QA.md#перевірки) · [Windows checklist](codex/verified/WINDOWS_BETA_QA_CHECKLIST.md) | Поточні результати за артефактами та ручні сценарії |
| INT-01 | [Інтеграція PR #7–#9](INT01_INTEGRATION.md) · [Windows checklist](INT01_WINDOWS_QA.md) | QA-кандидат 0.36.1, Windows A/B і порядок приймання |
| Продуктивність | [Performance validation](performance.md) · [PERF-01 ОТРК](perf01/PERF01_ANALYSIS.md) · [PERF-02 підтвердження](perf02/PERF02_ANALYSIS.md) · [PERF-03 дефіцит ОТРК](perf03/PERF03_RESULTS.md) · [R07 watchdog](r07/R07_RESULTS.md) · [R08 lockstep](r08/R08_RESULTS.md) · [R10 ArmyFire._impact](r10/R10_RESULTS.md) · [INT-06](r10/INT06_INTEGRATION.md) | Вимірювання, результати CPU та QA масового вибору |
| Roadmap і рішення | [Next steps](PROJECT_STATE.md#next-steps) · [Backlog](codex/verified/BACKLOG.md) · [Decisions](codex/verified/DECISIONS.md) | Windows QA та FPS, Linux-порт, UI після Linux |
| Історичні технічні звіти | [Інвентар Markdown](DOCUMENTATION_AUDIT.md) | Git/PR історія, Phase-звіти, старі контрольні збірки, source coverage |

Шлях `docs/codex/verified/` збережено для наявних посилань. Дата, commit і тестовий сценарій у кожному звіті визначають його обсяг. Історичний PASS і старі дозволи не переносяться на поточний HEAD.

## Правила розробки й локалізації

- [Git workflow](DEVELOPMENT_WORKFLOW.md) · [Versioning](VERSIONING_POLICY.md)
- [Аудит локалізації](LOCALIZATION_AUDIT.md) · [Зміни](LOCALIZATION_FIXES.md) · [Глосарій](LOCALIZATION_GLOSSARY.md) · [Тести й ручний QA](LOCALIZATION_TESTS.md)
