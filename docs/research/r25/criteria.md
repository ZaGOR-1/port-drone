# R25 · критерії до запуску A/B

> Історичний матеріал з `toolchain/performance/r25/criteria.md`. [Реєстр досліджень](../INDEX.md)

- Primary Late E, 150 ticks from 4650. Four sequential matched pairs AB, BA, BA, AB. D2100 restore 150 ticks from 4800 as two paired workload controls AB, BA. C1200 150 measured ticks after standard 45 warm ticks as two paired lighter controls BA, AB.
- Gate Late E 4692 command batch thread CPU. All four pairs must improve, median saving ≥5% and ≥3 ms, with the smallest saving exceeding half the cross-arm repeat MAD in ms (maximum of the two arms). Expected reduction in summed order_attack thread CPU and direct count evidence required.
- No systematic adverse (>5% median in Late E, >10% on both reverse-order control pairs) movement in frame p99, frame max, tick p99, FPS, or 1% low. Inspect the event frame and adjacent frames individually; unrelated spikes and materially different background must be evidenced. When noise or coherent background effects prevent interpretation, INCONCLUSIVE.
- Exact route bytes and ordered commands, per-tick NetHash/RNG, restore and host/peer tests required. Record all arms and regression fixtures. GUI measurement on rendered Profile B only. Counting and full traces run separately. Physical Windows QA separate.
