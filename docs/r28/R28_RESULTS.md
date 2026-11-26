# R28 · Прямий обхід ordered acquisition buckets

**NO-GO на feasibility gate.** База `047c474e9058b819a45b0fc8f705d00cfd45c95c`, DroneFlames 0.36.11. Кандидат мав прибрати копіювання посилань у `_tmp_near` зі збереженням R19. Оціночна економія всього scratch copy path — **0,213 мс/тік** у dense D5000. [Поріг переходу до PoC](FEASIBILITY_GATE.md), зафіксований до вимірювань у `archive/R28/feasibility.md`, становив **0,25 мс/тік і 3% acquire CPU**. Runtime PoC не створювався.

## Семантика baseline

- `Army.update` будує grid і scan masks раз на 0,25 с. R19 використовує кеш лише на scan зі штатними Army/GameWorld та великим змішаним bucket. `_acquire` достроково завершується для чинної цілі або країни без доступного acquire. Guard, grey zone і нестандартні war keys проходять чинний fallback.
- `_near_acquire_foes_into` очищає повторно вживаний `_tmp_near`. Обходить клітинки за рядком і колонкою, відбирає їх за scan-time `_umask` і ліниво фільтрує записи за поточними ворогами, зберігаючи insertion order і дублікати. Усі вибрані посилання скопійовано до початку фільтра цілей. `_acquire` читає alive, тип, позицію, ворожість і дим наживо. Рівні відстані лишають першу ціль, бо `d2 >= bd` пропускає нічию. Facility fallback і запис `u.target` ідуть після unit loop.
- Побудова grid і restore змінюють його ревізію, а setter `Unit.country_id` змінює ревізію власності. Новий запит бачить ці зміни; рух, смерть і поява юніта зберігають штатний момент оновлення spatial membership. Ревізії не серіалізуються. Callback між запитами не обґрунтовує зміну порядку всередині запиту.
- **PASS, синтетична мутація всередині запиту.** `membership_callback.gd` підміняє `Operations.smoke_at` через тестовий підклас. Поки baseline перевіряє першу ціль, callback міняє власника ближчого юніта в пізнішому bucket. Розмір реєстру лишається 4. Перший запит вибрав ID 9 із уже скопійованого списку, наступний після інвалідації — ID 3. Це обмеження для наївного лінивого обходу, який матеріалізував би пізніший bucket після callback. Штатний `Operations.smoke_at` лише читає зони. У реальному scan побічні ефекти fight/advance відбуваються між acquire; лінивий обхід мав би окремо зберегти межу snapshot membership і поведінку fallback. [Army](../../game/game/army.gd) · [Unit](../../game/game/unit.gd) · [R19](../r19/R19_RESULTS.md) · [R27C](../r27/R27_RESULTS.md#r27c--відновлення-коректності)

## Feasibility

Одне headless плече на сценарій, 45 warm-up + 60 виміряних fixed ticks, seed 20261016, карта 1024, Godot 4.7.2 та Linux QA runtime INT-12. Зміна R28 в наявному harness додає лічильник форми cached queries. Фізичний Windows і rendered Profile B — NOT RUN.

| Сценарій | Cached queries з `foes > 0` і `fm > 0` | `append_array` | Скопійовані посилання | Baseline NetHash на кінці |
| --- | ---: | ---: | ---: | --- |
| Dense D5000 | 23 924 | 13 538 | 833 299 | `0498c09fa7575023` |
| C1200 | 0 | 0 | 0 | `752c94fe4a3ccd21` |

У dense 15 680 cached queries не мали жодного bucket для копії. Microprobe окремо від гри використовував RefCounted і той самий повторно вживаний Array. Відтворено гістограму копій та кількості bucket-ів з headless run, із рівним поділом посилань між bucket-ами однієї форми. Дев’ять пар у збалансованому порядку A/B та B/A дали **0,213 мс/тік** медіани, діапазон **0,202–0,220**. Це wall-time оцінка повної потенційно усуваної роботи `clear + append_array` без ціни нового обходу, а не ігровий CPU A/B. Для масштабу це близько **2,5%** від історичних 8,46 мс/тік acquire CPU у R19. Абсолютний поріг 0,25 мс/тік, зафіксований до замірів, не пройдено навіть у найвищій парі. Одинарний bucket або інший вузький fallback усунув би лише частину копій. Поточні acquire/update CPU, native heap allocations, tick/frame p99, FPS і RAM delta для кандидата — **NOT RUN**. Rendered A/B та його acceptance, включно з tick p99 guard **+5%**, не застосовувалися.

## Перевірки та відтворення

- **PASS на baseline.** R19 fixture 24/24, включно з порядком, нічиїми, дублікатами, alive, власністю, зміною war set, grid revision, guard/grey zone і серіалізацією ревізій. Окремий callback fixture PASS. Два baseline NetHash вище ідентифікують workload. Differential RNG, NetHash, restore, host/peer і post-GO regression suites — **NOT RUN**, бо runtime-кандидата немає. Логи editor fixture містять відсутні Linux debug-модулі та відому teardown діагностику. Fixture не використовує Steam або WebRTC.
- **PASS build identity і scope.** Версія 0.36.11. Ігрове дерево і контракти PROTO, SIM_REV та Save.FORMAT збігаються з `047c474`.
- Постійний handoff — `~/projects/droneflames-archive/R28/`. У ньому є критерій до замірів, сирі JSON/логи, harness, fixture, SHA256 і скрипти відтворення. Маніфест `SHA256SUMS` має SHA256 `467bb4830f268dd0f30884e70fdb3d841e672fe5a9ee56baeb9a93d1eb687787`. Існуючий Linux QA пакет INT-12 і Godot 4.7.2 прив’язано до SHA256. **PASS незалежного відновлення.** З базового checkout і запакованого runtime у свіжому каталозі відтворено точні SHA256 PCK і executable, R19 24/24 та callback ID 9 → ID 3. Для точного PCK є [спільний handoff R28–R29](../r29/R29_RESULTS.md#точні-діагностичні-pck).

```bash
archive="$HOME/projects/droneflames-archive/R28"
(cd "$archive" && sha256sum -c SHA256SUMS)
python3 "$archive/summarize.py"
bash "$archive/reproduce.sh" /path/to/047c474-checkout
```

**Рішення.** Відкласти прямий обхід. Повертатися до цієї ідеї за свіжих даних, які покажуть більшу частку копіювання, і починати з перевірки межі snapshot membership.
