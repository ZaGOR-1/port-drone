# R18 · HOST_NOT_READY

> Історичний матеріал з `toolchain/performance/r18.4rC4kUzE/reports/R18_RESULTS.md`. [Реєстр досліджень](../INDEX.md)

Статичний аналіз чистої beta d6a38e8db58361430df69ffe0a98e628acac6d8b, версія 0.36.7. Worktree /home/zagor/projects/port-drone-r18, гілка perf/impact-candidate-enumeration.

## Хост

Preflight за методикою R17C охопив 60 інтервалів за 60,04 с. Сторонній CPU мав медіану 14,75%, діапазон 11,00–35,83%, 8 інтервалів понад 19% і 4 понад 23%. Розкид 24,83 п.п. за допустимих 8 п.п. Основні процеси за вікно — code 45,08 CPU-с, Discord 28,07, chrome 14,80 та localsearch-3 14,03. Пік зайнятості окремого логічного ядра 73,27%, runnable tasks медіана 3 і пік 11. CPU 58,0–69,5 °C, GPU 45–46 °C. Середня частота CPU за відліками 2,50–4,68 ГГц, GPU core 210–525 МГц. Пік memory PSI some 0,625%, swap-in 1923 сторінки, swap-out 11 805. Ознак паралельних compilation, packaging або benchmark jobs немає. Сирий preflight (`../raw/initial-preflight/summary.json`)

## Повторна робота

ArmyFire._update_shells обробляє завершені снаряди у зворотному порядку масиву. Кожен _impact проходить увесь Army.units та обчислює distance_to на кожній позиції. Відсікання R10 перед eligibility зменшує кількість перевірок state і hostility, а виклик distance_to лишається на кожному записі. Фаза споруд повторно проходить Military.facilities до першої живої цілі. R14 читає live at_war один раз. Міста обходяться до першого збігу. Fort cells уже використовують локальний пошук.

| Архів R16 | Влучань / повних ground обходів | _impact exclusive, мс/кадр | мс/влучання | FPS / 1% low | Tick / frame p99, мс |
| --- | ---: | ---: | ---: | ---: | ---: |
| D2100 detail | 547 | 3,649 | 0,801 | 20,49 / 9,22 | 59,42 / 98,18 |
| D2100 dense detail | 672 | 5,418 | 0,968 | 13,59 / 4,90 | 113,18 / 183,20 |
| D5000 detail | 1038 | 11,015 | 1,273 | 9,40 / 4,06 | 142,15 / 207,91 |
| D5000 dense minimal | Невідомо | Невідомо | Невідомо | 6,85 / 2,98 | 202,54 / 323,54 |

У detail-рядках один кадр припадає на один тик і число входів у фазу споруд дорівнює числу влучань. Кількість справді повних facility проходів залежить від раннього break. Inclusive та exclusive _impact у R16 probe збігаються через відсутність виміряних дочірніх scopes. Профілі R16 не містять per-impact visits, часток поза геометрією та окремих фазових timings. У detail D2100 ground workload на межах вікна 2001 → 1727, у D5000 4600 → 4304, а реєстр споруд на цих відліках має 1080 записів. Добуток endpoint workload на число влучань не є фактичним visits. Щільний D5000 використовував мінімальний probe без лічильника _impact. R16 CPU, frame/tick p50–max і RSS (`r16-impact.csv`)

Історичний audit D2100 R14 B зафіксував 1 015 000 ground visits, **99,257%** поза радіусами. Damage 608, suppression 3768, разом **0,431%** записів. Pin входить у suppression, 1760 викликів. Facility visits **589 317**, **99,953%** поза геометрією, 5 damage calls. В окремому CPU-прогоні R14 B ground scan займав 202,496 мс inclusive та 178,000 мс exclusive за 120 кадрів. Facility scan 222,966 та 222,940 мс. Sampled ground state 29 мкс за 107 відліків, facility state 3175 мкс за 9278, facility geometry 421 мкс за 1514. Ці відліки включають вартість таймера. Ground distance окремим таймером не виміряно. Рядки R14 мають власні базу й профілювання. Архівні лічильники і scopes (`historical-metrics.json`)

## Актуальність, порядок та мутації

- **Ground grid.** Army._build_grid викликається зі scan cadence 0,25 с до руху в Army.update. Вогнева фаза йде після руху, tac.update і reinf.tick. Свіже поле pos у посиланні може вже належати іншому bucket. DEAD відсікається під час побудови, FPV зберігаються окремо. Усередині тика з’являються нові записи, а DEAD фізично прибирається в кінці Army.update після понад 0,5 с. Маски bucket також є знімком стану на rebuild.
- **Facility grid.** _fgrid_t задає окремий період 1 с. Attached і TRENCH_H пропускаються, інші лінії можуть займати кілька bucket-ів. _near_fac_into має окремий dedup. Реальна межа споруди залежить від max(size.x, size.y) * 2 + r. Порядок row → column з insertion order усередині bucket може змінити перший збіг у Military.facilities. Наземний порядок також впливає на порядок damage, pin та RNG, зокрема у _kill.
- **Порядок ефектів.** До ground проходу виконуються FX/VFX, BattleWatch і кратер. У land-проході Army._damage(Unit), _kill і pin змінюють HP, suppression, DEAD, події та RNG. У прямих переглянутих шляхах ці функції не переносять юнітів у нову позицію та не дописують реєстр. Динамічне підтвердження вкладених callbacks ще потрібне.
- **Синхронна мутація між влучаннями.** Naval.on_shell і remove_line_cell відпрацьовують до фази споруд. remove_line_cell змінює bounds і викликає forts_changed.emit. Знищення споруди через Army._damage(Facility) → gw.strike планує відкладений strike. City branch викликає _apply_strike синхронно. Ланцюг _apply_strike → Rail.on_strike → RailTroops.on_hit → _unload дописує юнітів до Army.units на нових позиціях. Вони можуть потрапити в геометрію наступного снаряда.

## Обраний напрям статичного дизайну

Короткоживучий coarse grid **тільки для ground фази ArmyFire**, зі свіжими позиціями після вступних callbacks. Зберігати ordinal кожного запису в Army.units, відновлювати порядок лише для локальних кандидатів і читати eligibility наживо. Ordinal відповідає позиції в масиві, незалежно від ID і можливої повторної появи того самого посилання. Широка геометрична фаза має бути консервативною з урахуванням точності Vector2. Після неї чинний distance_to і всі межі, включно з inclusive damage/suppression/pin та strict half damage, виконуються в початковому порядку.

Підбір придатний лише в доведеній фазі без позиційних і структурних мутацій. Синхронний city strike завершує таку фазу. Інші callback-шляхи потребують гарантії або консервативної інвалідації. Fallback має бути обрано перед застосуванням першого ground ефекту. Частково застосований запит не можна повторювати. Для NaN/нечислових меж, прямих викликів поза фазою та непідтвердженої геометрії зберігається базовий шлях. Facilities поки лишаються поза прототипом через footprint і first-match порядок.

Ідеальна верхня межа зменшення **повних ground проходів** за одного build на активний кадр і нульових інвалідаціях — 547 → 94 (82,82%) D2100, 672 → 74 (88,99%) dense D2100 і 1038 → 106 (89,79%) D5000. D5000 мав 102 кадри з кількома влучаннями зі 106 активних. Це модель проходів. Total visits і CPU залежать від розмірів реєстру, локальної щільності, rebuild, ordinal merge/sort, fallback та очищення. RAM також входить у бюджет. У dense виграш може зникнути.

20% від 11,015 мс становлять 2,203 мс/кадр. При simulation 60,228 мс/тик це економить 3,66% за сталих інших витрат. Для окремої гілки simulation gate потрібно близько 3,011 мс/тик, або 27,34% історичної вартості _impact. Навіть повне усунення scope дало б лише 18,29% чистого часу симуляції за цієї моделі. Ground enumeration є лише частиною scope. Вартість B і visits після змін **NOT RUN**.

Цільові differential наступного запуску мають покрити stale crossed-bucket, різний порядок ID та ordinal, floating-point межі, живі state/owner, висадку між двома impacts, вкладені callbacks і repeated restore. Порівнювати damage, suppression, pin, RNG, NetHash і порядок side effects. Старі R10/R14 assertions залишаються опорою, виконання їх у R18 — NOT RUN.

## Gate, Git і наступний крок

**NOT RUN** для всіх нових A/B, повного CPU R18, simulation/FPS +5%, FPS/1% low контролів, tail, пам’яті, детермінізму й повного QA. Статичний аудит установлює ризик взаємозаміни grid, а оцінка виграшу ще потребує перевірки. Official пакети, smoke, Windows A/B, commit, push і PR — NOT RUN.

У worktree R18 оновлено лише docs/PROJECT_STATE.md. R17 позначено **DEFERRED / HOST_NOT_READY**, його diff побайтно збігається з резервною копією. Перевірено beta, main, stash 40a9f64 та стан R13. Наступний уже виміряний hotspot поруч із _impact — Army._advance, **11,278 мс/кадр exclusive** в detail D5000. Приймання R18 потребує придатного хоста, підрахунку реальних фазових visits і differential вузького ground PoC.
