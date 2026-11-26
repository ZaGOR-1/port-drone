# R16 · Вхідні матеріали після R15

> Історичний матеріал з `toolchain/int08.1UTXXUmq/handoff/R16_CONTEXT.md`. [Реєстр досліджень](../INDEX.md)

- R15 — `/home/zagor/projects/droneflames-toolchain/performance/r15.pCbzhv2E/`.
- R09 — `/home/zagor/projects/droneflames-toolchain/performance/r09.vlpdda5t/`.
- Контрольні суми доступних snapshots, manifests і saves — `R16_SHA256SUMS.txt`. Повні R15 докази та контрольні суми — `R15/handoff/SHA256SUMS.txt` і `R15/packages/SHA256SUMS.txt`, довгий R09 — `R09/handoff/SHA256SUMS.txt`. Позначки R15 і R09 у шляхах нижче відповідають абсолютним кореням вище.

| Fixture | Вхідні матеріали | Контроль |
| --- | --- | --- |
| D2100 | `R15/raw/fps-D2100-1-A/config.json`, згенерований `fixtures/r02_probe.gd`, 2100 юнітів, 1080 споруд | seed 20261016, CRC 1722618560, 45 warmup + 120 ticks, NetHash 165 `6bee855c1a62f9d0` |
| D1920 | `R15/raw/fps-D1920-1-A/config.json`, 1920 юнітів, 1080 споруд | той самий seed/CRC/інтервал, NetHash 165 `bee9dc2686d72ce0` |
| C1200 | `R15/raw/fps-C1200-1-A/config.json`, 1200 юнітів, 720 споруд | той самий seed/CRC/інтервал, NetHash 165 `31a7b74c6e28b7b9` |
| Щільний D2100 | `R15/raw/fps-dense-{1,2}-{A,B}/config.json`, `--dense`, спільний фронт, `R15/dense-control.sh` | той самий seed/CRC/інтервал, NetHash 165 `e63072c31276250a` |
| Late E | `R15/fixtures/late-e.snapshot` на тику 4650, `late-e-reference.json`, `R15/raw/qa-late-A/config.json` | 150 тіків, чотири `army.order_attack` у lockstep, відмітки `queue_trace`, CRC 1999988886, NetHash 4800 `3c338abc3ec9d5c7` |
| Тривалий D2100 | `R09/raw/long-D2100/{config.json,result.json,state.snapshot}` і `R09/R09_LATE_GAME.md` | 4800 безперервних тіків від 0, seed 20261016, CRC 52745984, NetHash 4800 `1b05f1b5ed18fc7f`; snapshot збережено в кінці |
| Додаткові QA saves | `R15/raw/qa-disk-A/active-battle.save` на тику 195, `R15/ab-stage/DroneFlames-R15-Windows-AB/Checkpoint/slot_1.save` | контрольні сценарії під Save/Load і Windows GUI A/B |

Додатковий контраст за віком партії дають історичні R01 `performance/checkpoints/aged-1800/synthetic.save` і `aged-final/synthetic.save` з `generation.json`. Перший має 1800 с, 66 юнітів і 201 споруду, другий 420 с, 24 юніти і 61 споруду. Це синтетичні контрольні стани зі значно меншим числом юнітів. Для відтворення є `performance/PERFORMANCE_BASELINE.md` і `performance/run_r01.py`.

Короткі згенеровані сценарії відновлюються через `R15/prepare.py`, `R15/run.py` і `fixtures/r02_probe.gd`. Команди генерує runner. JSON містить turn, кількість команд, wire bytes і CRC, а `raw/short-{C1200,D2100}-{A,B}/result.json` має покрокову `queue_trace`. Для Late E зіставити snapshot з `late-e-reference.json` і `R15/verify-late-and-save.py`. Для тривалого D2100 використовувати `R09/prepare.py long` і конфіг з `raw/long-D2100`. Порівнювати однорідні вікна з однаковими camera/zoom, thermal conditions, build, renderer і replay state. Готові staging PCK та raw timings належать історичним SHA.

Особливо важкі пізні стани й CPU/GPU bottlenecks після R15 потребують нового виміру. У довгому R09 зросли Operations і хвостова затримка, при меншій типовій ціні тика. Стан Late E інший. Далі варто локалізувати хвости поза cadence spotting, зокрема активні Operations, watchdog, команди, pathfinding і підготовку рендерингу, та звірити CPU/GPU на однакових кадрах. Це гіпотези для виміру. Потреба в глобальній перебудові spatial index не доведена.

У перевірених локальних профілях і QA-збереженнях не знайдено підтвердженої реальної пізньої партії власника. Історична скарга на 2–3 FPS у фізичній Windows у порівнянних умовах залишається невідтвореною. За наявності сейву потрібні точна збірка, режим, карта, камера, налаштування і характеристики Windows ПК. R16 profiling suite — NOT RUN.
