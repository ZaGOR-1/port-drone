> Історичний матеріал з `toolchain/performance/r10.sgT1Rl0N/provenance/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## Зміна

Ранній фільтр у наземному циклі `ArmyFire._impact` використовує ту саму `distance_to` і включну межу `max(r + 3, r * 2.5)`. Порядок кандидатів, шкода, suppression, pin і RNG збережені. Склад кандидата: `85d76a1`, `8509ddb`, `e2b5f46`. Версія 0.36.4.

## A/B

- D2100 на Ubuntu, Godot 4.7.2 official, RTX 4060 Laptop, Vulkan Forward Mobile. Inclusive _impact 8.81 → 4.94 мс/кадр (−44.0%), наземна фаза 707.17 → 203.33 мс/інтервал, _hostile 999 184 → 4 937. FPS 19.18 → 20.84 у трьох парах, 1% low 6.70 → 6.91.
- C1200. Inclusive _impact 3.25 → 2.16 мс/кадр (−33.5%), _hostile 359 219 → 3 154. FPS INCONCLUSIVE у C1200 і Medium.
- Щільний контроль з усіма 2100 юнітами всередині радіуса показав +4.6–14.4% на влучання. У D2100 frame p99 +4.0%, у Medium tick p99 +14.3%.

## Перевірки

- Differential 49/49 для A і B, Python 49/49 без SKIP, simulation 2476/2476, watchdog 101/101, ring 8/8.
- Late E, D2100 і C1200 збіглися покроково на 150/150 тіках кожен. Late E відтворив `f19767f333c29101`, `c9301a1dcbcd76e8`, `3c338abc3ec9d5c7` і RNG `1940658711`.
- Активний бій Save/Load, cross-load A → B, snapshot restore, ENet admission, reconnect/resync, Linux native smoke, official Windows x64 build і Wine headless smoke пройшли. Результати пакетів прив’язані до дерева `6e367205359cdc75d4e83520ac11901d421afae8`.
- Фізичні Windows GUI/FPS, LAN і Steam мають статус NOT RUN. Для приймання потрібен Windows A/B на D2100 і щільному сценарії.

[Повний звіт, методика й межі](https://github.com/ZaGOR-1/port-drone/blob/perf/armyfire-impact/docs/r10/R10_RESULTS.md)
