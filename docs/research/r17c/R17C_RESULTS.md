# R17C · HOST_NOT_READY

> Історичний матеріал з `toolchain/performance/r17c.bisE12lZ/reports/R17C_RESULTS.md`. [Реєстр досліджень](../INDEX.md)

Серію Late E зупинено до першої A/B-пари за обов'язковим 60-секундним preflight. Пройдено 60 односекундних інтервалів за 60,04 секунди. Нових FPS, 1% low, frame/tick percentiles та даних A/B немає. Історичні дві придатні пари R17B використано лише як контекст.

| Перевірка | Результат |
| --- | --- |
| Сторонній CPU | **FAIL.** Медіана 19,32%, діапазон 13,17–29,42%, 32 із 60 інтервалів понад 19%. Розкид 16,25 п.п. за межі 8 п.п. |
| Пікові інтервали | 10 понад 23%. На 29,42% основні процеси дали chrome 187%, code 73%, Discord 47% і localsearch-3 32% одного ядра. |
| Активні сторонні процеси | За 60 секунд серед зафіксованих top процесів chrome спожив близько 48,10 CPU-с, code 46,05, Discord 27,89, localsearch-3 13,78. Ці величини пояснюють перевищення ліміту preflight. |
| Ядра і runnable | Піки окремих логічних CPU до 68,00%. Медіана runnable tasks 4, пік 21. |
| Температури і частоти | CPU 59,75–68,63 °C, GPU 45–46 °C. Середня частота CPU за відліками 2,53–4,60 ГГц. GPU core 210–2010 МГц, GPU memory 405–7001 МГц. |
| Тиск на пам'ять | Максимум інтервального memory PSI some 0,112%. Swap-in 254 сторінки, swap-out 0. |
| Паралельні тяжкі роботи | Компіляторів, пакувальників чи benchmark jobs вибірка не виявила. |

Телеметрія per-core, runnable, температури, частоти, PSI та swap є в `raw/initial-preflight/host.jsonl`. Незмінний sampler R17B зберіг CPU сторонніх процесів і scheduler pressure в `raw/initial-preflight/system.csv`. Жоден користувацький процес не завершувався. Системні параметри залишилися під контролем власника.

## Gate

| Критерій | Результат |
| --- | --- |
| Visits ≥80% | **PASS R17**, повторно застосовано до того самого кандидата. D2100 −94,95%, D5000 −82,30% з верхньою оцінкою очищення. |
| Піковий membership CPU ≥30% | **PASS R17.** D2100 −94,56%, D5000 −96,01%. |
| Tick p99 ≥15% | **PASS R17.** D2100 restore −21,38%, D5000 restore −50,54%. |
| Детермінізм, workload і repeated restore | **PASS R17/R17B** для перевірених сценаріїв. 390/390 R17, цільові 37/37 на A/B та repeated restore R17B. Новий workload check **NOT RUN**. |
| Суттєва memory regression | **PASS R17/R17B** у перевірених коротких вікнах. Тривалий контроль **NOT RUN**. |
| Late E FPS, 1% low та frame percentiles | **NOT RUN, HOST_NOT_READY.** 0 нових пар. R17B лишається історичним контекстом. |

## Git і QA

Кандидат 0.36.7 у `/home/zagor/projects/port-drone-r17` на `perf/operations-membership-lookup`. HEAD `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Початковий і фінальний diff та статус збіглися з backup R17B. За SHA256 звірено R17B handoff, діагностичні PCK, runtime, snapshots, fixtures і runner. Підтверджено refs `beta` і `origin/main`, наявність stash `40a9f64` та незавершені зміни R13.

Нові прогони QA, official пакети, Wine, Windows A/B, коміти, push і PR **NOT RUN**. Ризик причинності Late E та приймання на фізичному Windows лишається відкритим. Рекомендація — зберегти PoC локально до перевірки на іншому стабільному хості або відкласти R17.
