> Історичний матеріал з `toolchain/performance/r14.GEz1Tr3B/handoff/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## R14 · Обхід споруд в ArmyFire._impact

Перевикористовуємо атакувальника та live `at_war` у межах одного циклу споруд. Регістр, перша придатна споруда, inclusive squared-distance, alive, HP, події, RNG та наземні ефекти R10 збережено. Версія 0.36.5. База `8c83d91d06989cc3857c7560c4690188bf88a964`, commit коду `13dd5bffbd2878bf416c0d3bdd7663c43f7d8f73`, кандидат `8a7ddc2c3d4f3659d4d1902e0f1ce17e2dd1b256`.

## Performance

- Свіжий baseline D2100 у 120 тіках мав 547 влучань, 589 317 відвідувань споруд і 5 ефектів по спорудах. Обхід споруд займав 51,03% часу _impact. По фазі споруд усунено 589 317 викликів _hostile і зменшено пошуки країни 491 752 → 547. Visits, геометрія, відібрані цілі й ефекти збіглися.
- Окремі D2100 CPU-профілі. Facility scan 3,583 → 2,011 мс/кадр (−43,87%), _impact inclusive 7,275 → 5,188 (−28,69%), exclusive 7,007 → 4,942.
- У всіх чотирьох мінімальних парах D2100 FPS вищий, CPU tick швидший. Медіани FPS 19,996 → 20,647, 1% low 7,042 → 7,224, simulation CPU 25,831 → 24,478 мс/тик. У щільному D2100 FPS 13,036 → 13,672, simulation CPU 34,213 → 31,649 мс/тик.
- Залишкові ризики включають C1200 frame p95 +6,37% за медіанами, dense tick p99 +3,11% і одну D2100 пару з гіршим 1% low. Обмежені контрольні пари D2100 і C1200 включено в [результати](../../r14/R14_RESULTS.md). Причину окремих хвостових відхилень не встановлено.

## QA

- Python 49/49 без SKIP, simulation 2476/2476, watchdog 101/101, ring 8/8, HUD/input 36/36, L10N. Розширений differential 59/59 на варіант із byte-identical trace, R10 differential 49/49 на варіант.
- D2100 і C1200 90/90 тіків, Late E 150/150, Save/Load активного бою 66/66 зі спільного і власного save. Late E `4693 f19767f333c29101`, `4746 c9301a1dcbcd76e8`, `4800 3c338abc3ec9d5c7`, RNG `1940658711`. ENet admission, reconnect/resync пройшли. PROTO 7, SIM_REV, Save.FORMAT 1, tick rate і wire збережено.
- Official Linux native і Windows x64 build із однаковим PCK, Linux native smoke та Wine headless smoke пройшли. Windows A/B комплект містить baseline, кандидат і спільний D2100 checkpoint. Фізичні Windows GUI/FPS, LAN і Steam — NOT RUN. Draft для власницького Windows приймання.
- Обидва smoke-прогони досягли запуску сценарію. На завершенні в обох журналах зафіксовано витоки ObjectDB і ресурсів, у Wine також CanvasItem RID.
- Windows A/B відтворює спільний D2100 save через ручне завантаження. Автоматизований Linux fixture окремо застосовував визначений потік lockstep-команд.
