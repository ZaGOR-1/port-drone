# DroneFlames R18

> Історичний матеріал з `toolchain/performance/r18.4rC4kUzE/README.md`. [Реєстр досліджень](../INDEX.md)

[Preflight, статичний аудит і рішення](R18_RESULTS.md). Архівні метрики R16 (`reports/r16-impact.csv`). Сирий preflight (`raw/initial-preflight/summary.json`).

Handoff включає точкові копії R16 і R14 профілів, snapshots, diff документації, методику R17C та скрипт офлайн-агрегації. Команда python3 historical.py будує таблиці з наявних JSON/CSV без запуску рушія. Щільний D5000 snapshot на 165 є станом на кінці історичного вимірювання. Початкове вікно dense відтворюється за seed, warmup і налаштуваннями з raw/r16/extra-dense5000/config.json. Snapshots D2100/4800 і D5000/945 призначено для відповідних restore сценаріїв. SHA256SUMS перевіряє вміст після розпакування.
