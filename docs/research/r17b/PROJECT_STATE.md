# R17B · Project state

> Історичний матеріал з `toolchain/performance/r17b.tcCPTLHp/reports/PROJECT_STATE.md`. [Реєстр досліджень](../INDEX.md)

Версія 0.36.7. PoC `perf/operations-membership-lookup` зберігається без коміту в `/home/zagor/projects/port-drone-r17` від `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Початковий і фінальний production diff збіглися із R17 handoff. Резервна копія `backup/` містить точні змінені файли і патч. Зафіксовано R17B окремо, щоб зберегти весь початковий незакомічений diff.

R17B INCONCLUSIVE. Дві з шести Late E пар придатні. Історичний масштаб падіння FPS не відтворився. Підтверджені пороги visits, peak CPU, tick p99, deterministic replay і repeated restore. Цільовий транспортний fixture 37/37 A і B, 150 Late E і 60 транспортних тіків збіглися. Підбір очищався в кожній фазі, повторних побудов у трьох виміряних вікнах 0. Повний QA, пакети, push і PR відкладені відповідно до раннього gate. Наступне рішення потребує контрольованого Late E на стабільному хості. [Результати й критерії](R17B_RESULTS.md)
