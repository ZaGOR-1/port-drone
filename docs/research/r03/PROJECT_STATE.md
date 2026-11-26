# DroneFlames · Стан Performance R03

> Історичний матеріал з `toolchain/performance/r03/PROJECT_STATE.md`. [Реєстр досліджень](../INDEX.md)

2026-11-23. Production `/home/zagor/projects/port-drone` чиста на `beta` `c91e0e6a7eef831687e6e63550560bba739a6b87`. Диференційний відбиток і статус detached R01/R02 `/home/zagor/projects/droneflames-toolchain/performance/source` збіглися до і після. R03 — окремий клон `/home/zagor/projects/droneflames-toolchain/performance/r03/source`, гілка `perf/r03`, той самий HEAD, 10 modified і 3 untracked діагностичні скрипти. Віддалених refs немає.

**PARTIAL.** Spotting став швидшим у всіх трьох fixed-view сценаріях, із точним збігом визначених станів A/B. D1920 має регрес середнього FPS. R03 лишається локальним PoC. Завдання для наступного циклу — профіль руху в `Army._advance` та повтор на Windows x64 із контрольованим навантаженням. Нативний Windows бойовий MP і GUI **NOT RUN**. Чистий production `docs/PROJECT_STATE.md` лишається на committed baseline.

[Аналіз](R03_ANALYSIS.md) · [Зміна й provenance](R03_CHANGES.md) · [A/B](R03_AB_RESULTS.md) · [Детермінізм](R03_DETERMINISM.md) · [Наступний крок](R03_NEXT_STEPS.md)
