# R18A · CORRECTNESS_PASS

> Історичний матеріал з `toolchain/performance/r18a.mg4Q3ih0/reports/R18A_RESULTS.md`. [Реєстр досліджень](../INDEX.md)

Вузький наземний PoC від beta d6a38e8db58361430df69ffe0a98e628acac6d8b. Версія 0.36.7. Новий performance verdict **NOT RUN**.

## Алгоритм і межа актуальності

Підбір належить синхронному виклику ArmyFire._update_shells. Перший impact використовує прямий обхід, а за наступного придатного impact підбір читає свіжий Army.units і розкладає ранги записів за coarse bucket 64 px. Застосування снарядів лишається у вихідному зворотному порядку. Запит читає лише доступні локальні bucket-и, сортує їхні ordinal-и та застосовує чинний distance_to і ті самі умови damage, suppression, pin та hostility. Ordinal визначає місце в масиві, тому рівні або різноспрямовані ID та повторні посилання обробляються у вихідному порядку.

Для запиту широка фаза розширюється на повний bucket. Обмеження координат ±2²⁰ та effect radius ≤256 дає запас на округлення Vector2. Вузька фаза залишає обчислення й порівняння baseline, включно з damage/suppression/pin на межі та strict half-radius. Непридатні координати, нечислові позиції, завеликий радіус, одиночний снаряд, прямий виклик і неперевірені підкласи переходять на прямий обхід. VFX, naval, fort, facility і city ефекти виконуються у вихідній послідовності. Фаза споруд збережена.

| Мутація | Межа актуальності |
| --- | --- |
| Рух, звичайний spawn/destruction, посадка й висадка між Army.update | ArmyFire запускається після руху, tac і reinf. Підбір виникає після вступних callbacks і зникає на виході зі shell batch. Чинний _ugrid не використовується. |
| Damage, suppression, pin, DEAD, зміна ворожості | Позиція в bucket і ordinal не залежать від стану. Живі властивості читаються перед ефектом. У stock ground chain звірено Army._damage, _kill, pin, BattleWatch та VFX. Вони не пересувають і не додають наземні записи. |
| Naval із landings або expeditions | Перед on_shell виконується консервативна інвалідація через синхронні повідомлення та callback-шляхи. |
| Fort cell removal | Інвалідація перед remove_line_cell та forts_changed.emit. Fixture змінює pos, знищує й прибирає один запис та викликає spawn зі збереженням розміру реєстру. |
| City branch | Інвалідація перед синхронним _apply_strike. Реальне Rail.on_strike → RailTroops.on_hit → _unload додає юніта у registry до наступного снаряда. |
| Facility damage | Шкода споруді лишається в чинній фазі. Звичайний gw.strike планує _apply_strike через _delay, після поточної пачки. |
| Заміна Array або зміна розміру | Lookup звіряє ідентичність та розмір реєстру перед читанням. Це додаткова перевірка. Переміщення і same-size mutation обробляються межами callback-фаз. |
| Reentry | Вкладений _impact або _update_shells вимикає підбір зовнішньої пачки. Якщо ефект уже застосовано, зовнішній запит продовжує від наступного ordinal у тому самому масиві. Повторне застосування пройдених ефектів виключене. |
| Save/Load | Транзієнтний handle пропускається у Save.dump і Save.fill, а в кінці кожного batch посилання звільняється. Repeated restore створює новий ArmyFire. |

Захист розрахований на звірений stock call graph. Фаза наступної оптимізації, яка додає нову синхронну мутацію позицій або реєстру, має оновити цю межу і differential. Доступ до звичайних косметичних callbacks реальної мережевої сесії ще потребує повного QA.

## Коректність

Цільовий fixture 42/42 на A і B, окремий city regression 7/7 та чинний impact differential 59/59 на кожному варіанті. Порівняно точний порядок impact, eligibility, damage, suppression, pin, facility/city і strike. Цільові cases порівнюють state digest, battle events, RNG та наступний результат глобального RNG. Покрито stale grid, нульовий registry, одно- й багатокандидатні запити, різні стани, signed coordinates, однакове посилання на двох позиціях масиву, reentry і fallback для неперевіреного callback.

| Replay | Тіків A/B | Кінцевий NetHash | World RNG |
| --- | ---: | --- | ---: |
| C1200 | 90 | 62d9da10ea104a1b | 3661858331 |
| D2100 | 90 | 71beb4885c0e768a | 569199962 |
| D5000 | 90 | e217255c133ec9fb | 3788396869 |
| Щільний D5000 | 90 | 498b24b5e913463d | 703418894 |
| Late E | 150 | 3c338abc3ec9d5c7 | 1940658711 |

510/510 покрокових зіставлень NetHash, RNG, впорядкованого unit state, Operations, watchdog, шляхів, effect trace і command apply. У Late E історичні 4693 f19767f333c29101, 4746 c9301a1dcbcd76e8 і 4800 3c338abc3ec9d5c7 та RNG 1940658711. По два repeated restore з того самого Late E snapshot на обох варіантах. Дискове продовження PASS по 66 тіків із сейву A на A/B та з власного сейву B. PROTO 7, SIM_REV v036-integration-1, FORMAT 1, 30 тіків/с і payload збережені.

## Детерміновані лічильники

Visits — ground geometry + елементи до побудови. Розширений облік додає читання rank-ів під час матеріалізації і консервативно всі rank-елементи, звільнені під час invalidation/cleanup. Bucket probes та сортування наведено окремо як роботу над підбором. Порівняння всередині native sort і алокації не виміряні.

| Replay | Повні ground scans A → B | Ground visits A → B | З rank reads і cleanup A → B | Builds / invalidations / rebuilds / fallbacks B |
| --- | ---: | ---: | ---: | ---: |
| C1200 | 267 → 96 | 302 049 → 144 202 | 302 049 → 231 468 | 46 / 3 / 2 / 50 |
| D2100 | 435 → 135 | 819 788 → 339 488 | 819 788 → 546 742 | 64 / 2 / 2 / 71 |
| D5000 | 928 → 170 | 4 157 935 → 1 046 735 | 4 157 935 → 1 723 816 | 87 / 5 / 5 / 83 |
| Щільний D5000 | 944 → 157 | 4 566 139 → 1 746 988 | 4 566 139 → 3 113 422 | 79 / 3 / 3 / 78 |
| Late E | 25 → 25 | 25 387 → 25 387 | 25 387 → 25 387 | 0 / 0 / 0 / 25 |

D5000 B зробив 12 377 bucket probes і 845 сортувань на 289 906 локальних rank, dense B 13 632 probes і 866 сортувань на 981 457 rank. На D5000 і dense були 659 560 та 1 362 011 точних geometry checks. Решта лічильників, включно з однаковою кількістю застосованих ефектів і facility visits, у CSV (`operation-counts.csv`). Числа 928 і 944 походять із 90-тикових R18A replay. Історичні 1038 R16 належать іншому вікну.

У щільному сценарії матеріалізація та сортування дорожчі, потенційний виграш за розширеним лічильником нижчий. Важливі майбутні витрати — побудова Dictionary, створення bucket arrays, виділення тимчасових масивів, native sort, stock checks і виклики helper у fallback. Стале FPS, frame tails, CPU і RSS лишаються **NOT RUN**.

## Межі виконання

Перші діагностичні D5000 і dense спроби перервав успадкований часовий stop rule R16. Їх збережено в raw, а остаточні важкі replay та дискові перевірки використали proof packs без wall-clock stop rule. Для приймання використано лише повні вікна з фіксованою кількістю тіків. Спочатку standalone template відхилив CLI override. Цільові SceneTree fixtures відпрацювали в official editor тієї самої версії, де є попередження відсутніх debug Steam/WebRTC бібліотек. Runtime replays працювали через pin DEV-02 на native ELF. Логи A/B зберігають повідомлення про завершення ObjectDB/resources. Першу помилку в тестовому очікуванні для r=0 звірено з формулою baseline: d=0 при r/2=0 потрапляє в половинний damage. Виправлено assertion, production формула лишилася чинною.

Повний regression suite, performance, packaging, Wine, мережевий QA, push, PR, merge, release і tag **NOT RUN**. Функціональні матеріали готові для окремого R18B gate на придатному хості. Висновок про CPU/FPS відкладено до цього gate.

Локальний Conventional Commit — 6d83ef995a154e842906d2ebdb15a41c5a883ce3. Документаційний diff R18/R18A лишається незакоміченим.
