> Історичний матеріал з `toolchain/int12.7iX78x0s/github/pr-body.md`. [Реєстр досліджень](../INDEX.md)

## R21 · Watchdog exit search

База `3298af5878501d458920b41dc5738f60571ac551`, версія 0.36.10. Production `b638a68`, результати `8b564ca`. `Operations.wd_exit` пропускає чотири клітини разом, якщо всі належать території виходу. Для решти збережено порядок обходу, tie-breaking, land component і живі перевірки.

Profile B GO. У трьох D2100 парах медіана парної зміни `wd_exit` CPU −41,49%, tick p99 −16,40%, FPS −4,86%, 1% low +3,12%. Економія на 4816 становила 21–27 мс, на 4864 24–31 мс. У Late E на 4746 `wd_exit` зменшився на 26,8 мс. Командний batch у найгіршому кадрі й siege spike D5000 лишаються відкритими. Simulation CPU +4,48% у D2100, причина варіації відкрита.

576/576 прямих порівнянь, 37/37 Operations і transport на кожному плечі, 390/390 покрокових зіставлень, byte-identical snapshots і wire commands. Simulation regression 2476/2476, Save/Load 22/22, ENet turns/reconnect/resync, official Windows/Linux builds, PCK identity і Linux native/Wine smoke — PASS. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с.

Фізичні Windows FPS, LAN і Steam — NOT RUN. Відомі попередження при виході Godot залишаються. [Результати та обмеження](../../r21/R21_RESULTS.md)


## INT-12 · 0.36.11

Результати умовного performance gate та залишкові ризики зафіксовано в [звіті R21](../../r21/R21_RESULTS.md#int-12--performance-review). PATCH синхронізує version.cfg, Menus.VERSION, fixtures та примітку ru/uk/en. Production-код R21 збігається з перевіреним кандидатом.

Фінальний CI PASS. ENet допускає 0.36.11/0.36.11 та відхиляє 0.36.10/0.36.11 в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1 і 30 тіків/с збережено. Фізичні Windows FPS, LAN і Steam — NOT RUN. Попередження Godot під час виходу залишаються відкритими.
