> Історичний матеріал з `toolchain/int04.l9g7ydNd/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## R07 · watchdog exit search · beta 0.36.3

Цільовий review підтвердив точну рівність квадратів відстані й координат. На кожному r/k усі сторони мають спільну цілочисельну нижню межу. Відсікання решти сторін зберігає strict tie-breaking, порядок і результати фільтрів та просторових запитів. Максимальний зважений бал 814 088. Межі карти, r=48, відсутність виходу, fallback і поглиблення WD_IN збережені. Виклики pathfinding, cadence watchdog, порядок і момент застосування наказів та правила руху збережено. Gameplay diff обмежений `Operations.wd_exit`.

| Late E, історичний R07 | База | Кандидат |
| --- | ---: | ---: |
| `wd_exit`, медіана на тику 4746, мс | 118,42 | 99,96 |
| Watchdog max, мс | 156,51 | 132,57 |
| Simulation tick max, мс | 189,32 | 168,70 |
| Frame time p99, мс | 190,83 | 161,35 |
| Candidate visits на 4746 | 758 524 | 653 500 |
| Максимальний кадр, мс | 200,60 | 204,65 |

Усі три A/B-пари дали менший пік watchdog. Загальний FPS **INCONCLUSIVE**. Найдовший кадр трохи погіршився. A/B виміри взято з R07, оскільки оптимізація має той самий diff.

`ec1e824` підвищує версію до `0.36.3`, синхронізує Menus.VERSION, build guard fixtures та локалізовану примітку. Збережено PROTO=7, SIM_REV=v036-integration-1, Save.FORMAT=1, RNG і NetHash. Мережевий admission та відновлення MP match metadata вимагають однакової повної версії.

## Автоматичні перевірки INT-04

- Python discovery 47/47 без SKIP, simulation regression 2476/2476, watchdog fixture 101/101, build identity і version consistency PASS.
- L10N, «Що нового» ru/uk/en, HUD/input, Save/Load і ENet loopback PASS. Два 0.36.3 допускаються. Пари 0.36.2 ↔ 0.36.3 відхиляються в обох напрямках.
- Late E 150/150 ticks, 4650–4800. NetHash на 4746 `c9301a1dcbcd76e8`, фінальний `3c338abc3ec9d5c7`, RNG `1940658711`. Збіглися paths, Operations і watchdog state, черга і wire digest команд. Save/Load на 4800 і продовження 66/66 ticks, NetHash `8ead8c43990da97d`.
- Official 4.7.2 x64 build для Windows і Linux, Linux native headless та Wine headless PASS. PCK ідентичний на обох платформах.
- Native Windows QA **NOT RUN**, deferred by owner. Physical LAN і Steam **NOT RUN**.

[Історичні вимірювання й методика R07](../../r07/R07_RESULTS.md)
