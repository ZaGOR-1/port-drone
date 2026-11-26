# R06 · Детермінізм і регресії

> Історичний матеріал з `toolchain/performance/r06/R06_DETERMINISM.md`. [Реєстр досліджень](../INDEX.md)

## Покрокове порівняння Windows EXE під Wine

| Сценарій | Порівняно тиків | Кінцевий NetHash A/B | Результат |
| --- | ---: | --- | --- |
| E з відновленого snapshot 4650 | 150, тики 4651–4800 | 3c338abc3ec9d5c7 | PASS |
| C1200, headless lockstep | 600 | 86913469d718ce57 | PASS |
| D2100, GUI | 120 після 45 warm-up, спільні підсумкові дані | 6bee855c1a62f9d0 | PASS на контрольних станах |

E headless порівнює проміжний NetHash і SHA256 повного Operations.save_state на кожному тику. Збіглися 531 пара try/outcome, 199 подій ще незавершеного soft job і 41 завершення soft jobs у порядку виконання. Записи завершення містять digest результату, записи pending — ключ, навігаційну версію, стан і залишок спільного бюджету. Для E точні тики та ID казарм при застосуванні були 4712/253, 4713/372, 4714/366, 4743/244, 4744/255, 4745/260. Із snapshot відновлено 32 відкладені накази. Наприкінці залишилося 30 відкладених та 89 активних або wait-операцій. SHA256 стану Operations на тику 4800 — 4d60cd865f66a8a27ebd5c9af75613b46e3bd64aced4aab76ac1586b3e28c845.

Для C1200 збіглися всі 600 покрокових NetHash, digest стану Operations і трасовані події. NetHash на тику 300 — 742e462adeb98058. В обох сценаріях збіглися seed, turn/count/byte size батчів, checksum серіалізованих команд, NetHash.parts і SHA256 кінцевого стану руху. Replay генерує батчі тим самим кодом та з тих самих вхідних даних. Raw JSON містить послідовність turn, кількість, розмір і контрольну суму, окремого дампу serialized wire bytes немає. У E є чотири команди в turn 1564, CRC 1999988886. У C є по чотири команди в turns 4, 44, 84, 124, 164, CRC 1826857750. E траса (`R06_TICK_TRACE.json`) · Raw E A (`runs/trace-A/frames.json`) · Raw E B (`runs/trace-B/frames.json`) · Raw C A (`runs/c600-A/frames.json`) · Raw C B (`runs/c600-B/frames.json`)

## Регресійні тести

- **Queue fixture — 22/22 A і B, JSON побайтово збіглися.** Реальні queue_order, _run_oq, cancel, save_state/load_state. Керовані відповіді start перевіряють негайне застосування, один і кілька тиків PENDING, спільну межу спроб, скасування, втрату казарми, заміну цілі, передавання поточного власника при повторі, supersession та відновлення під час PENDING. Окремими assertions перевірено порядок складу війська й fallback швидкості для лише posted units. Цей fixture керує готовністю під час перевірки черги. Окремими підсценаріями він запускає реальні _wd_tick на межі timeout та Economy.nav_path після появи бар’єра і відкриття нового проходу. Справжні route/start і зміни стану soft jobs виконані у Windows E replay.
- **Simulation regression — 2476/2476 A і B.** Використано точний PCK, витягнутий з кожного Windows EXE, через наявний офіційний Linux editor 4.7.2 у headless.
- **Save/Load — 111 + 49 + 6 перевірок у кожному варіанті.** Пройшли snapshot state, інтеграційний завантажувач із матрицею відмов і відновлення дискового save. Це наявний unittest на staged tree. E додає фактичне A/B відновлення з накопиченою чергою під Wine.
- **Watchdog — тригер і реальні виклики у E.** Окремий fixture пройшов до і після реального WD_MAX. Сценарій, де перешкода або ворожий власник змінюються саме під час живого PENDING job, залишився NOT RUN. Логіка оркестрації зміни власника покрита окремо від реального захоплення; R06 не претендує на повне покриття цих крайових випадків.
- **Native Windows і реальний Multiplayer — NOT RUN.** Lockstep probe виконує локальний відтворюваний сценарій без двох мережевих клієнтів. Linux editor використовувався лише для локальних тестів. У Linux-логах є повідомлення про відсутні Steam/WebRTC .so і попередження teardown fixture. Exit code та assertions пройшли.

Queue A (`tests-A/queue.json`) · Queue B (`tests-B/queue.json`) · Simulation A (`tests-A/simulation/regression.json`) · Simulation B (`tests-B/simulation/regression.json`) · Save/Load A (`tests-A/snapshot-runner.log`) · Save/Load B (`tests-B/snapshot-runner.log`)
