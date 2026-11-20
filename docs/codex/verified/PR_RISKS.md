# Phase 5C — актуальні ризики

R01 startup suffix cleanup виправлений у локальному targeted scope: actual Linux 35 / native Windows 36 checks PASS. Усі .old retained; невідомі staging files, links, directories та paths захищені. Windows symlink creation SKIP. Це не закриває R03/R04 download integrity/atomic activation — **OPEN HIGH**. [Review](PHASE5C_GEMINI_REVIEW.md).

Погоджений SIM_REV pr10-phase5b2-1 відділяє known old revisions: 5 actual admission scenarios і 30 saved identity checks PASS. Same SIM_REV не є code fingerprint; exact same EXE/DLL SHA потрібні для QA. Optional FORMAT1 cooldown/downgrade ризики лишаються. PROTO 7 / FORMAT1 number / native DLL незмінні.

R07 general network schema, R05 durability/deep malformed saves, R18 shutdown FAIL та whole-game p99 OPEN. GUI/full two-peer/Steam/LAN NOT RUN. Із updater off можна перейти до ізольованого final QA, не до beta merge/public distribution. Remote workflow може ще auto-publish: local CI edits лишаються uncommitted/unpushed.

---

## Історичний checkpoint до Phase5C (збережено)

# Phase 5B.2 — актуальний overlay

PA05 airport dispatcher, PA07 cooldown persistence, PA09 REBASE/AIRDROP cancel та PA08 eager fallback закриті в локальному targeted scope; [root causes/patches](PHASE5B2_FIXES.md), [RED/GREEN](PHASE5B2_REGRESSION_RESULTS.md). Додатковий HIGH forged `mil.build(...,free=true)` відтворено та відхилено новим targeted schema guard; invalid build/air arg types/arity більше не доходять до callv у цих трьох methods.

**Блокер compatibility:** optional FORMAT1 `land_cooldowns` і новий hash змінюють simulation persistence. Old reader реально ігнорує поле; downgrade unsupported. Same SIM_REV R02/current реально admit; потрібний owner-approved revision/build gate. PROTO7/FORMAT1 number/DLL не змінені. Не випускати mixed-build match.

General ALLOWED schemas R07, updater R01/R03/R04, save durability/deep malformed fields R05, shutdown R18, p99 та WindowsGUI/full realMP лишаються OPEN/NOT RUN. R02 target suites111+41 PASS,16ключових functions незмінні; це не exhaustive malformed world schema validation. Історичні findings нижче описують свої попередні snapshots.

---

## Історичний checkpoint (збережено)

# Phase 5B.1 status overlay — R02

R02 HIGH root cause виправлено локально в targeted/fault-injection scope: [опис](R02_SNAPSHOT_RESTORE_FIX.md), [RED/GREEN](R02_FAILURE_INJECTION_TESTS.md). `_restore_from` і saved `_resume_restore` більше не активують failure; scoped errors, epoch та cleanup-before-commit покривають вкладені помилки і lifecycle races. Частково відновлений світ завершує локальну сесію, saved seat/checkpoint збережені для manual retry.

Залишковий R02 acceptance: full two-peer production reconnect/resync/host handover НЕ перевірено. PA11 уточнено: production handshake реально відхиляє originalPR10 з іншою identity; Phase5/R02 з тією самою identity обидва admit. Це не гарантія mixed-build determinism. SAME EXACT BUILD required. PROTO7/FORMAT1 незмінні.

Не вважати закритими інші updater HIGH, R05 загальне disk corruption, R18 shutdown або p99. Перед merge потрібні Windows GUI/full multiplayer acceptance і review. Історичні findings нижче не переписуються як результати нового коду.

---

## Історичний checkpoint (збережено)

# Phase 5 status overlay — 2026-11-20

Нижче незмінені історичні findings для untouched PR10. У local uncommitted codex/fix-pr10-critical **PA01/02/03/04/06 виправлено у targeted scope**,81critical checks та actualMain synthetic save/continue PASS. Це не означає повну готовність мережі/усіх50catalog features. PA05/07/09 та inherited R02 runtime-відтворені після fixes; PA08/updater unchanged, shutdown FAIL; actual2-peer/GUI NOT RUN. Рішення NOT READY для integration. Поточні root causes/rules/results — PR10_CRITICAL_FIXES/PR10_REGRESSION_RESULTS, наступні задачі — PHASE5B_PLAN. Historical source links нижче вказують старий96053d66, не uncommitted fix.


---

## Історичний документ / попередній scope (збережено)

# Технічні ризики PR #1–#10

Аудит 2026-11-20, pinned head `96053d66eb984cc24e3acce647a55a195136abd2`. Severity описує наслідок; component FAIL не означає перевірений GUI crash. Production виправлень немає.

| ID | Severity | Проблема | Поява | Доказ |
|---|---|---|---|---|
| PA01 | HIGH | [Сезони змінюють економіку з render delta](#pa01) | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8) | [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json) |
| PA02 | HIGH | [Території та гроші іншого human змінюються без його згоди](#pa02) | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9) | [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json) |
| PA03 | HIGH | [MP відхиляє власний Ship у купівлі палубного літака](#pa03) | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7) | [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json) |
| PA04 | HIGH | [Хроніка не записує кадр за наявності живого корабля](#pa04) | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9) | [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json) |
| PA05 | MEDIUM | [Кнопка будівництва AIRPORT не диспетчеризується](#pa05) | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7) | [airport_probe.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/airport_probe.json) |
| PA06 | HIGH | [Після загибелі авіаносця airborne wing лишається без бази](#pa06) | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7) | [carrier_sink_probe.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/carrier_sink_probe.json) |
| PA07 | MEDIUM | [Cooldown land deals не переживає save/load](#pa07) | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9) | [logs/save_roundtrip.log](/home/zagor/projects/port-drone/dist/phase4_pr_audit/logs/save_roundtrip.log) |
| PA08 | MEDIUM | [Новий upkeep tally зберіг дорогий старий fallback](#pa08) | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10) | [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json) |
| PA09 | MEDIUM | [RMB/Esc не скасовують REBASE та AIRDROP](#pa09) | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5) | [cancel_probe.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/cancel_probe.json) |
| PA10 | LOW | [Опис націоналізму обіцяє не підключений бонус оборони](#pa10) | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8) | STATIC / NOT RUN runtime |
| PA11 | HIGH | [Номер protocol 7 не засвідчує сумісність різних builds](#pa11) | [PR #1](https://github.com/ZaGOR-1/port-drone/pull/1) | STATIC / NOT RUN runtime |
| PA12 | MEDIUM | [Хроніка має неповне покриття довгих і мережевих матчів](#pa12) | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9) | STATIC / NOT RUN runtime |

<a id="pa01"></a>

## PA01 — HIGH: Сезони змінюють економіку з render delta

[game/game/game_world.gd:391–395](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/game_world.gd#L391-L395), [game/game/game_world.gd:523–526](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/game_world.gd#L523-L526), [game/game/seasons.gd:32–96](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/seasons.gd#L32-L96), [game/game/economy.gd:75–90](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/economy.gd#L75-L90). Походження: [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8).

Сценарій: Два однакові світи, game_time=160, два nuke_zones, snow=0.44. Обидва виконують step(1/30); тільки один отримує додатковий step(0.1), як у net-driven _process.

Факт: snow=0.456 проти 0.444; farm_mul=0.5 проти 1.0 при однаковому NetHash. Це відтворений component-level determinism defect; живий 2-peer сеанс не запускали.

Рекомендоване виправлення: Оновлювати gameplay season/snow лише фіксованим simulation tick; відділити візуальне згладжування. Додати різні frame schedules, economic output і повний state hash у 2-peer тест.

Доказ: [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa02"></a>

## PA02 — HIGH: Території та гроші іншого human змінюються без його згоди

[game/game/land_trade.gd:133–200](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/land_trade.gd#L133-L200), [game/net/net_session.gd:2070–2090](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_session.gd#L2070-L2090). Походження: [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9).

Сценарій: Дві human країни з money=8000; issuer slot0 виконує дозволену diplo.land_deal(1,2,"buy","dep:20:20","",1000).

Факт: Власник залежі стає 1; money=7000/9000. Для sell/swap також відсутній human offer/accept шлях. Перевірка власника першого country argument не є згодою контрагента.

Рекомендоване виправлення: Для human контрагента створювати пропозицію; виконувати лише його окрему авторизовану accept-команду з повторною перевіркою власності, ціни й строку. До цього блокувати buy/sell/swap із human.

Доказ: [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa03"></a>

## PA03 — HIGH: MP відхиляє власний Ship у купівлі палубного літака

[game/ui/ui24/navy_dock.gd:1054–1066](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/ui24/navy_dock.gd#L1054-L1066), [game/net/net_session.gd:2077–2089](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_session.gd#L2077-L2089), [game/game/ship.gd:9–18](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/ship.gd#L9-L18). Походження: [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7).

Сценарій: Ship.c=issuer.id=1; викликати _owns(issuer,[ship,DECK_JET,issuer],-1), як у NetSession.sim купівлі літака.

Факт: Ship не має country_id. int(null) дає SCRIPT ERROR, _owns повертає false. Латентна помилка бази стала досяжною новим Ship argument у PR7; прямий Air.buy_carrier_plane тест її обходить.

Рекомендоване виправлення: Зробити явний ownership accessor для Ship.c та решти entity.country_id; перевірити NetCodec→_exec для власного/чужого Ship.

Доказ: [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa04"></a>

## PA04 — HIGH: Хроніка не записує кадр за наявності живого корабля

[game/game/chronicle.gd:156–163](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/chronicle.gd#L156-L163), [game/game/ship.gd:9–18](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/ship.gd#L9-L18). Походження: [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9).

Сценарій: Додати один живий Ship до gw.navy.ships і викликати Chronicle.record_frame; SP step викликає його кожні 4 simulation секунди.

Факт: Invalid access country_id on Ship; frames.size=0 замість ≥1. Наявний Chronicle тест кораблів не створює.

Рекомендоване виправлення: Читати Ship.c, перевірити змішаний флот, sunk/живі кораблі, disk record і viewer. Не оголошувати всю гру crash: помилка перериває цю функцію.

Доказ: [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa05"></a>

## PA05 — MEDIUM: Кнопка будівництва AIRPORT не диспетчеризується

[game/game/main.gd:620–632](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/main.gd#L620-L632), [game/game/main/main_base.gd:10–20](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/main/main_base.gd#L10-L20), [game/ui/hud/hud_base.gd:190–195](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/hud/hud_base.gd#L190-L195). Походження: [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7).

Сценарій: Main subclass із _has_capital=true та контрольним _set_mode виконує _on_action("airport"); контроль — _on_action("airfield").

Факт: airport залишає Mode.NONE (0) замість AIRPORT (64); airfield працює. Direct mil.build у suite не перевіряє кнопку.

Рекомендоване виправлення: Включити airport у dispatch або використовувати BUILD_KEYS як єдине джерело; додати action→mode→map build тест.

Доказ: [airport_probe.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/airport_probe.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa06"></a>

## PA06 — HIGH: Після загибелі авіаносця airborne wing лишається без бази

[game/game/navy.gd:3178–3197](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/navy.gd#L3178-L3197), [game/game/air.gd:185–186](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/air.gd#L185-L186), [game/game/air.gd:749–759](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/air.gd#L749-L759). Походження: [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7).

Сценарій: Палубний DECK_JET у повітрі, land airfields відсутні; _sink_carrier_wing скидає carrier_id=0, залишає base=null і RTB; наступний _fly.

Факт: Air._o викликає origin_px на Nil. Повторювані script errors замість коректного повернення або контрольованої втрати літака.

Рекомендоване виправлення: Ввести явний emergency/no-home стан із контрольованою втратою/пошуком сумісної бази. Тестувати carrier sink із parked/airborne wing, нульовою/повною/несумісною альтернативою.

Доказ: [carrier_sink_probe.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/carrier_sink_probe.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa07"></a>

## PA07 — MEDIUM: Cooldown land deals не переживає save/load

[game/game/land_trade.gd:9–9](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/land_trade.gd#L9-L9), [game/game/land_trade.gd:115–121](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/land_trade.gd#L115-L121), [game/game/save.gd:33–36](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/save.gd#L33-L36), [game/game/save.gd:389–433](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/save.gd#L389-L433). Походження: [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9).

Сценарій: У синтетичному світі встановити diplo.land._last_deal={"1:2":game_time}, зробити disk save та restore core/systems.

Факт: TRADE_COOLDOWN_RETAINED false; правила 90 секунд після load зникають. RefCounted LandTrade не має save_state/load_state і не є Save ENTITY.

Рекомендоване виправлення: Явно серіалізувати last_deal у diplomacy state із дефолтом для старих saves; roundtrip і snapshot/resync тест. Зміну формату планувати окремо.

Доказ: [logs/save_roundtrip.log](/home/zagor/projects/port-drone/dist/phase4_pr_audit/logs/save_roundtrip.log). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa08"></a>

## PA08 — MEDIUM: Новий upkeep tally зберіг дорогий старий fallback

[game/game/upkeep335.gd:415–434](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/upkeep335.gd#L415-L434). Походження: [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10).

Сценарій: Dictionary {1:42}.get(1,fallback()) викликає fallback навіть за наявного ключа; той самий шаблон у tallies.get(c.id,tally(c.id)).

Факт: fallback_calls=1. На кожну країну все ще виконується повний tally; додано _tally_all поверх попередньої роботи. Також треба звірити tally до/після _react_done перед виправленням.

Рекомендоване виправлення: Використати has()+умовний вираз; перевірити еквівалентність значень і момент обліку реактивації, потім повторити профіль.

Доказ: [audit_probes.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/audit_probes.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa09"></a>

## PA09 — MEDIUM: RMB/Esc не скасовують REBASE та AIRDROP

[game/game/main/main_core.gd:41–50](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/main/main_core.gd#L41-L50), [game/game/main.gd:1003–1030](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/main.gd#L1003-L1030). Походження: [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5).

Сценарій: Встановити Main.mode=REBASE, потім AIRDROP і викликати pc_cancel_mode у desktop середовищі.

Факт: Обидва повертають false; режими не входять до cancel allowlist. AIRDROP доданий PR7, REBASE PR5.

Рекомендоване виправлення: Додати обидва режими з очищенням refs/preview; GUI тестувати скасування до й після map tap, із відкритими панелями.

Доказ: [cancel_probe.json](/home/zagor/projects/port-drone/dist/phase4_pr_audit/cancel_probe.json). Команди і harness — [PR_TEST_RESULTS](PR_TEST_RESULTS.md).

<a id="pa10"></a>

## PA10 — LOW: Опис націоналізму обіцяє не підключений бонус оборони

[game/game/ideology.gd:22–29](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/ideology.gd#L22-L29), [game/game/ideology.gd:97–107](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/ideology.gd#L97-L107). Походження: [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8).

Сценарій: Обрати ideology=4 і звірити DESCS із усіма Ideology hooks у military/army/defense.

Факт: Є speed×1.05; defense multiplier +8% не знайдено. Статичний висновок, числовий damage runtime case NOT RUN.

Рекомендоване виправлення: Узгодити специфікацію: реалізувати в одному damage hook з тестом або виправити опис. Не додавати прихований бонус автоматично.

<a id="pa11"></a>

## PA11 — HIGH: Номер protocol 7 не засвідчує сумісність різних builds

[game/net/net_config.gd:8–8](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_config.gd#L8-L8), [game/net/net_config.gd:84–85](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_config.gd#L84-L85), [game/net/net_hash.gd:9–57](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_hash.gd#L9-L57), [game/pc/version.cfg:1–7](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/pc/version.cfg#L1-L7), [game/ui/menus.gd:12–12](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/menus.gd#L12-L12). Походження: [PR #1](https://github.com/ZaGOR-1/port-drone/pull/1).

Сценарій: Порівняти baseline з PR1–9: змінені NetHash/команди/симуляція, але Menus.VERSION до останнього commit PR10 і PROTO мають старі значення. У PR10 Menus=v0.34.0, version.cfg досі 0.33.2.3.

Факт: Статично cross-build compatibility не забезпечена одним PROTO=7. PR10 звичайний version guard відділяє від 0.33, але build.py переписує Menus.VERSION аргументом --version. Cross-build MP NOT RUN.

Рекомендоване виправлення: Погодити унікальний build/version identity та policy відмови mixed builds; окремо вирішити protocol/sim revision і hash нових authoritative полів. Не змінювати номер у межах аудиту.

<a id="pa12"></a>

## PA12 — MEDIUM: Хроніка має неповне покриття довгих і мережевих матчів

[game/game/chronicle.gd:3–6](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/chronicle.gd#L3-L6), [game/game/chronicle.gd:105–127](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/chronicle.gd#L105-L127), [game/game/chronicle.gd:201–225](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/chronicle.gd#L201-L225). Походження: [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9).

Сценарій: Матч >450 кадрів по 4s або net_driven=true; після цього finalize_and_save.

Факт: Після приблизно 30 хв нові кадри припиняються, фінальний кадр теж не додається; net_driven step одразу return. Це snapshot viewer, не повний command replay чи відновлюваний матч. Статично підтверджено; тривалий UI replay NOT RUN.

Рекомендоване виправлення: Явно обмежити опис SP scope або реалізувати bounded rolling/downsampled timeline з фінальним кадром і MP записом; зберігати sample phase за потреби.

## Успадковані проблеми бази та межі

- **R01, R03/R04 — HIGH:** updater не змінено жодним PR. `_cleanup_old` і далі видаляє всі сусідні `.old/.new/.tmp`; немає нового integrity/atomic transaction рішення. Code: [game/pc/updater.gd:114–124](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/pc/updater.gd#L114-L124). Провокаційний updater тест не повторювався; startup мав DF_NO_UPDATE=1.
- **R02 — HIGH:** failed `Save.net_restore` і далі завершується advance net_tick/exec_turn/resync counters та reconnect success path: [game/net/net_session.gd:3008–3042](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_session.gd#L3008-L3042). Ця функція byte-identical до бази; неправильний wrapper у save fixture перевіряє Save, не NetSession._restore_from. Тому R02 не закритий.
- **R07/R08 — HIGH:** відсутня повна schema/finite/bounds/admission validation усіх commands/snapshots. Нові allowlist записи не замінюють її; PA02/PA03 — конкретні приклади. Не стверджуємо, що кожну недовірену команду fuzz-tested.
- **R05 — MEDIUM:** Save FORMAT1 durability/rename fallback не перероблений. 17 synthetic checks не моделюють power-loss/denied-write або кожен частково пошкоджений entity graph.
- **R17 — MEDIUM:** Windows SteamMock лишився з `/tmp/df_steam_mock`; валідний 2-peer Windows mock тут не запускався. Invalid ID0 bypass у smoke не є Steam test.
- **R18 — MEDIUM:** Windows smoke: 11 CanvasItem RID, 226 ObjectDB, 44 resources at exit. Linux теж має leaks. Не приховані й не класифіковані як clean shutdown PASS.

Нові native DLL, runtime Python packages та scenes не додані. Сім PNG+JSON пар перевірено за розмірами/хешами/bounds; походження малюнків заявлене автором PR, незалежної перевірки авторства зображень немає. Повний GPU/DPI/input/audio/late-war/real Steam тест залишається NOT RUN. Рішення про реліз не можна приймати за mergeable=clean або exit0.
