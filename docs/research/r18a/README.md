# DroneFlames R18A

> Історичний матеріал з `toolchain/performance/r18a.mg4Q3ih0/README.md`. [Реєстр досліджень](../INDEX.md)

[Підсумок, lifecycle, детермінізм і лічильники](R18A_RESULTS.md). Машинний PASS (`reports/validation.txt`). Лічильники A/B (`reports/operation-counts.csv`).

A походить із beta d6a38e8db58361430df69ffe0a98e628acac6d8b. B — локальний коміт 6d83ef995a154e842906d2ebdb15a41c5a883ce3, версія 0.36.7. Candidate patch містить і production diff, і regression fixture. Оригінальний документаційний diff R18 і поточний незакомічений стан збережено окремо в provenance. Бінарні PCK у компактний handoff не включено. Хеші runtime, фактичних diagnostic PCK та вхідних fixtures є в provenance.

Перевірте архів і SHA256SUMS. Команда bash reproduce.sh створює новий каталог у toolchain performance, відновлює дві фізичні копії та запускає лише headless differential, replay, repeated restore і дисковий Save/Load. Використовується встановлений official Godot 4.7.2 і runtime з provenance/runtime-path.txt. Шлях до runtime можна задати через DF_R09_RUNTIME. Reproducer використовує proof pack із fixed-tick завершенням для всіх сценаріїв. Початкові докази C1200, D2100 і Late E також завершили повні задані вікна. Перші D5000 і dense D5000, які зупинив старий elapsed guard, збережено окремо. Часові поля R16 runner у raw є технічними журналами headless replay.

Raw містить покрокові порівняння й синтетичні дискові сейви. Ізольовані user profiles і runtime binaries до архіву не включено. Файли R18 зі станами D2100/4800, D5000/945 та щільним D5000/165 збережено як додаткові входи. Поточні C/D replay будуються зі спільного seed і command fixture, а Late E використовує незмінний snapshot та історичну контрольну трасу.
