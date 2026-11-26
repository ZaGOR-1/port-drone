# Локальний стан DroneFlames R06

> Історичний матеріал з `toolchain/performance/r06/PROJECT_STATE.md`. [Реєстр досліджень](../INDEX.md)

**PARTIAL · perf/r06 · c91e0e6a7eef831687e6e63550560bba739a6b87.** R06 міститься у самостійному локальному репозиторії performance/r06/source. Оптимізовано повторний збір складу для rail hint під час _check. Дві пари E підтвердили економію в черзі, а вплив на FPS залишився непевним. Детермінізм за 150 E і 600 C ticks перевірено, наявні simulation та Save/Load тести пройдено для обох варіантів. Native Windows та Multiplayer NOT RUN. Патч залишено локально.

Production beta чиста. R01/R02 і R03–R05 збіглися з початковими відбитками. Локального main у production checkout немає, origin/main відображено в production.after. Наступний пріоритет — withdrawal wd_exit. [Аналіз](R06_ANALYSIS.md) · [Зміни](R06_CHANGES.md) · [A/B](R06_AB_RESULTS.md) · [Детермінізм](R06_DETERMINISM.md) · [Наступний крок](R06_NEXT_STEPS.md)
