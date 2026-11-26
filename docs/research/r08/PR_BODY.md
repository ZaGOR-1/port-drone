> Історичний матеріал з `toolchain/performance/r08.ifM6bVgQ/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## R08 · Пошук суходолу при формуванні маршрутів

На Late E кадр 4693 містить чотири `army.order_attack` по 188 байтів. Команди виконуються в порядку slot 0–3, тик 4692, turn 1564, exec_tick 0. Головний внесок дає `Army.order_attack → safe_point → land_point`. Четверта команда будує маршрут для 359 fallback-юнітів із 120 точок і робить 4 754 пошуки суходолу.

`land_point` обходить тільки периметр кільця, читаючи клітинки в тих самих межах і порядку. Перша придатна точка, поведінка мостів і fallback збережені. Порядок, час і результати lockstep-команд, validation, wire, RNG, NetHash, path budgets і snapshot семантика збережені. Версія 0.36.3, PROTO=7, SIM_REV=v036-integration-1, Save.FORMAT=1.

## Апаратні A/B

Official Linux Godot 4.7.2, RTX 4060 Laptop, Vulkan Mobile. Однакові ELF, camera, seed, snapshot і 150 ticks. Порядок A/B, B/A, A/B.

- Затримка пакета 174,449 → 118,694, 174,818 → 123,223 та 170,684 → 121,996 мс. Медіана 174,449 → 121,996 мс.
- `_exec` 174,294 → 121,818 мс. Найдорожча команда 130,050 → 89,455 мс. `land_point` 87,926 → 32,446 мс.
- Frame p99 168,002 → 153,187 мс. Найдовший кадр 202,140 → 165,546 мс, пік перемістився з 4693 на 4746. FPS INCONCLUSIVE.
- Контроль C1200 без масового пакета. Стан збігся. FPS 33,87 → 33,72 в одній парі.

## Перевірки

Python 48/48 без SKIP, simulation 2476/2476, watchdog 101/101, кільця 8/8. Replay 150/150 із точним збігом із R07. На 4746 NetHash `c9301a1dcbcd76e8`, фінальний `3c338abc3ec9d5c7`, RNG `1940658711`. Збіглося продовження після Save/Load на 66 тиках, одна команда, повторні та відхилені команди й restore перед пакетом. ENet host/guest, reconnect і resync пройшли.

Початковий HUD fixture проходив 36/36 assertions, але мав залежний від випадкового seed витік DummyTexture при виході. Той самий shutdown log відтворено на A і B з однаковим seed. Окремий тестовий коміт фіксує seed фонової карти меню для HUD fixture зі збереженням assertions і перевірки помилок.

Official Linux і Windows x64 QA build, native Linux headless та Wine headless PASS. Пакети походять із коміту `d59bba6`. Фізичний Windows, LAN і Steam NOT RUN. Потрібен review перед інтеграцією.

[Методика, по-командні CPU scopes, метрики й докази](../../r08/R08_RESULTS.md)
