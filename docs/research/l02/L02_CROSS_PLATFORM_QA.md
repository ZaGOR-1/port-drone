# L02 · Cross-platform QA

> Історичний матеріал з `toolchain/l02.3ZzyV6/L02_CROSS_PLATFORM_QA.md`. [Реєстр досліджень](../INDEX.md)

Використано той самий instrumented PCK на official Linux ELF і official Windows PE під Wine 10.0. Script-опції editor не підтримуються release template, тому наявні FIX06 і L10N-03 fixtures запущено з ізольованої QA-сцени. Важкі suites R01–R06 не виконувалися.

| Перевірка | Результат |
| --- | --- |
| FIX06 replay | 38/38 assertions з кожного боку. Усі 30 fixed ticks, NetHash.parts і RNG збіглися. Фінальний NetHash `787a72dc394849ab`, RNG `3605423648`. |
| Linux → Windows PE під Wine | Синтетичний FORMAT1 save успішно завантажено. Hash `09a56928d34268f3`; SHA файлу, RNG, столиці та ігровий час збіглися. |
| Windows PE під Wine → Linux | Hash `15d831d757134ae0`; SHA файлу та відновлений стан збіглися. |
| Save/Load | 12/12 у Linux і Wine writer fixture, включно з rollback і пошкодженим save у трьох локалях. Linux New Game, Save і Continue підтверджені у GUI. Ізольовані `user://`, UTF-8 і пробіли перевірені. 884 tracked game paths, 0 case-only колізій і 0 перевірених буквальних розбіжностей. |
| Native Linux ↔ native Linux ENet | Host і guest 0. Admission, reconnect, snapshot, resync і leave. Однакові хеші на turns 20/30/40, останній `481a95623fa9a0e3`. |
| Linux host ↔ Windows PE під Wine ENet | Host і guest 0. Admission, reconnect, snapshot, resync і leave. Однакові хеші на turns 20/30/40, останній `011b8c8609800e91`. |
| Python, Godot, локалізація та UI | Python 47/47, simulation 2476/2476, L10N 125/125, HUD/миша 36/36, каталоги 0 помилок. |
| Windows x64 official | df build і --check PASS. Wine headless exit 0 після WorldGen. Linux PCK побайтово збігається з PCK, витягнутим із цього official Windows EXE. |
| Відкладено | Native Windows, фізичний LAN, реальні Steam і WebRTC сесії — NOT RUN. |

Linux network QA виконано через loopback у приватному network namespace. Native Linux і mixed runs мали різний випадковий світ між запусками. Порівняно host/guest з однаковим станом у межах кожної сесії. Replay summary (`replay-summary.json`) · LAN summary (`lan-summary.json`) · Shared PCK (`shared-pck.json`)

Пакет (`DroneFlames-0.36.1-L02-Ubuntu-x86_64-QA.tar.gz`) · SHA256 (`SHA256SUMS.txt`) · [Рендеринг](L02_GPU_RENDERING.md) · [Закриття](L02_SHUTDOWN.md) · [Runtime](L02_RUNTIME_ANALYSIS.md)
