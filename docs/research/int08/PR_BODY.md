> Історичний матеріал з `toolchain/int08.1UTXXUmq/handoff/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## R15 та INT-08 · 0.36.7

Підвищення PATCH окремим комітом `6a41f0d`. База `50f3f04306ec49ea600296135225282907c9955c`, кандидат `0be04d6e77dcf10f5f6af890ade948579770710d`.

### Цільовий review · PASS

Під час синхронного наземного скану `alive`, `air`, дипломатія й дим лише читають стан. У вкладених викликах відсутні сигнали, мутації та передача керування. Bucket-дані актуальні до завершення скану країни. Кожна країна й кожен виклик створюють власний набір. Порядок eyes → рядок → стовпець → запис, чинні маски й старе членство в grid збережено. Ущільнення вилучає виявлені цілі, залишає геометричні промахи в початковому порядку та зберігає перше виявлення за дублювання посилань. Збережено smoke, recon, окопи, включні межі, alive/state, tie-breaking, naval/facility phases, поріг 60 і spotting cadence. [Review](../../r15/INT08_INTEGRATION.md)

### Performance evidence R15

- D2100 `_spot` за чотири виклики 356,525 → 99,413 мс (−72,1%). Медіани frame p99 137,948 → 93,125 мс (−32,5%), tick p99 107,404 → 49,925 мс (−53,5%). FPS зріс у всіх трьох D2100 парах, кадри понад 100 мс 15 → 1.
- Candidate visits 758 511 → 390 151, state checks 383 315 → 7 403, materialized references 758 511 → 6 836. Збіглися 382 748 геометричних перевірок і 2 135 наземних виявлень. Парні таблиці, raw frame CSV, CPU scopes і counts відтворено побайтово з JSON та журналів R15. [R15 measurements](../../r15/R15_RESULTS.md)
- Щільний D2100 дав 13,970 → 13,176 і 13,289 → 14,264 FPS. У першій парі впали FPS і 1% low, максимальний B-кадр 254,368 мс на тику 113 поза spotting cadence. У цьому кадрі simulation tick зайняв 185,474 мс. У двох парах покращилися frame і tick p99. Причина розбіжності відкрита. Максимуми C1200 №2 і Medium №1 також зросли. Хвостові ризики R10, ціна guard у щільному контролі R10, а також R14 C1200 p95, dense tick p99, 1% low і RSS залишаються відкритими. [R10](../../r10/INT06_INTEGRATION.md#продуктивність-і-p99) · [R14](../../r14/INT07_INTEGRATION.md)

### Pre-merge QA · PASS

- Python 50/50 без SKIP, simulation 2476/2476, watchdog 101/101, ring 8/8, R10 differential 49/49, R14 differential 59/59, R15 differential 1310/1310 на A та B з однаковою трасою, HUD/input 36/36, L10N, version guard і runtime identity.
- Детермінізм C1200 і D2100 120/120 тіків, Late E 150/150 і Save/Load 66/66 зі спільного й власного сейву. Fixtures виконано з фіксованим кадровим кроком, що стабілізує неавторитетні часові мітки HUD. Assertions та очікувані хеші збережено. Late E 4693 `f19767f333c29101`, 4746 `c9301a1dcbcd76e8`, 4800 `3c338abc3ec9d5c7`, RNG `1940658711`.
- ENet loopback admission/reconnect/resync пройшов. 0.36.7/0.36.7 допускається, 0.36.6/0.36.7 відхиляється у двох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1, 30 тіків/с, RNG, NetHash і wire збережено.
- DEV-02 / unified df з official Godot 4.7.2. Windows x64 build, Linux native і Wine headless smoke пройшли. PCK Linux та вбудований Windows PCK побайтово збігаються. DummyTexture, mesh is null і teardown warnings лишаються відкритими.
- Фізичний Windows GUI/FPS — NOT RUN, відкладено власником. Фізичні LAN та Steam — NOT RUN.

Звичайний merge commit у `beta`. R11–R13 лишаються NO-GO. CI на merge запускає перевірки й QA build з read-only permissions, release і deployment не виконуються. Відкат за потреби через окремий reviewable revert PR від актуальної `beta`.

### Після merge

`beta` 0.36.7 — `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Повне дерево `dd16f44de141f445cbfd91eed3fe6c8c663a4f23` збігається з перевіреним кандидатом. Обидва CI пройшли. Release job пропущено політикою. Main без змін, нових releases, tags і deployments немає. [Pre-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45610133602) · [Post-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45611268786)

Windows і Linux QA-архіви зібрано з точного beta SHA. Перевірено EXE/ELF, три DLL, три SO, provenance, контрольні суми й ідентичність PCK. Linux smoke з розпакованого архіву PASS. Wine з розпакованого архіву PARTIAL. Перша спроба завершилася native page fault після WorldGen, усі чотири повтори на тому самому EXE пройшли. Контроль 0.36.6 пройшов 2/2. Причина збою невстановлена. Фізичні Windows GUI/FPS, LAN і Steam — NOT RUN.
