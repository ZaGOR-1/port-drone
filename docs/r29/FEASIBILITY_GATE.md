# R29 · Критерій до вимірювань

База 047c474, 0.36.11. Діагностика на Linux headless з fixed ticks. Основні вікна D2100 restore 4800 + 120, Late E restore 4650 + 150 та контроль C1200 45 + 60. Жоден запуск цього етапу не є rendered Profile B.

Перехід до одного runtime PoC потребує реалістичної чистої економії одночасно ≥5 мс на відтвореному важкому watchdog-тику та ≥10% від inclusive CPU батьківського watchdog-виклику на цьому тику. Ціль відповідає рідкісному піку latency: 5 мс — близько 15% бюджету тика 30 Гц, а відносний поріг вимагає помітного виграшу для всієї операції. Віднімаємо lookup, insertion, initialization, memory lifecycle та потрібні інвалідації. Повторні координати самі по собі не є повторним рішенням. Спільний кеш між запитами вимагає доведеного lifetime по всіх reachable mutation/callback boundaries. Якщо оцінка потенціалу або доказ lifetime не проходять, verdict NO-GO. Якщо виміри ненадійні, INCONCLUSIVE.

Перед A/B потрібні adversarial equivalence, mutation і callback order, replay RNG/NetHash, restore, host/peer. Для Profile B GO потрібен відтворюваний чистий виграш і відсутність значущих регресій. Tick p99 guard +5%. C1200 перевіряє накладні витрати у вікні з малою активністю watchdog.
