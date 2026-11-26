# R08 · Контекст для кадру 4693

> Історичний матеріал з `toolchain/int04.l9g7ydNd/r08/README.md`. [Реєстр досліджень](../../INDEX.md)

Історична пара R07 Late E містить headless audit `raw/breakdown-A/result.json` та `raw/breakdown-B/result.json`. На кадрі з `tick=4693` чотири виклики `NetSession._exec` разом зайняли 153 694 та 164 133 мкс. Траса кожної команди фіксує ігровий тик 4692, turn 1564, exec_tick 0 і SHA256 wire payload. Час є inclusive. Внесок самого `_exec` і вкладених command handlers потребує окремого профілювання.

У сусідньому `r07/` лежать точний `late-e.snapshot` (тик 4650, seed 20261016, 1024²), `input.json`, fixtures, wrappers, офіційні runtime pins і raw logs. З каталогу r07 виконай `sha256sum -c SHA256SUMS.txt`. Використовуй чистий Git checkout на SHA з `BASE` для baseline A або SHA з `CANDIDATE` для B. Для порівняння з INT-04 можна використати merge SHA, записаний у handoff.

Вкажи `DF_R07_TOOLCHAIN` на актуальний toolchain, `DF_R07_REPO` на обраний checkout, `DF_R07_RUNTIME` на official Linux package з ELF та addons. У фізичній копії r07, де вихідні каталоги ще відсутні, запусти:

```bash
R07_VERIFY=1 R07_SPANS=1 python3 prepare.py R08
DF_R06_TRACE=1 DF_R02_SPOT_AUDIT=1 ./run.sh R08 r08-baseline h
jq '.frames[] | select(.tick == 4693) | {tick, apply_us:.us.apply, apply_count:.calls.apply, queue_trace, net_hash, rng}' r08-baseline/result.json
```

Очікувана послідовність команд і стан збережені в `control-frame.json`. Історичні часові значення залежать від навантаження хоста. Фінальний NetHash Late E `3c338abc3ec9d5c7`, NetHash на 4746 `c9301a1dcbcd76e8`, RNG `1940658711`. У INT-04 код R08 не змінювався.
