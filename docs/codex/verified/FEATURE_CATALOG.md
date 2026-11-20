# Phase 5 overlay — каталог старого PR10 збережено нижче

0.41 parity не мета власної DroneFlames; історичні порівняння нижче не активна стратегія. Поточний candidate — uncommitted codex/fix-pr10-critical. П’ять BROKEN контрактів старого каталогу мають targeted IMPLEMENTED & TESTED у новому local scope: winter farm render independence; human land consent; own-carrier command purchase; safe carrier loss; mixed-fleet Chronicle recording/disk.81assertions та Main/HUD/save/load/continue підтверджують наведене; actual2-peer/GUI ще NOT RUN.

Ця delta не змінює статус AI carrier provisioning, airport dispatch, cooldown persistence, REBASE/AIRDROP cancel, повного Chronicle viewer/MP replay або GPU appearance. Старі50rows/підрахунки нижче — snapshot untouched96053d66; не видавати22 tested старого snapshot або цей delta за повну готовність гри. Результати — PR10_CRITICAL_FIXES/PR10_REGRESSION_RESULTS. Human accept workflow тепер реалізовано; його historical «відсутній» нижче стосується лише до-fix head.


---

## Історичний документ / попередній scope (збережено)

# Каталог можливостей PR #1–#10

Head `96053d66eb984cc24e3acce647a55a195136abd2`, 2026-11-20. **50 окремих можливостей/контрактів** за наведеним нижче способом поділу; це не 50 завершених ігрових механік. Пакети оптимізацій і UI також входять до каталогу. Один рядок не дорівнює одному assertion.

**IMPLEMENTED & TESTED: 22**; **IMPLEMENTED, NOT RUNTIME TESTED: 12**; **PARTIAL: 7**; **BROKEN: 8**; **UNVERIFIED: 1**.

IMPLEMENTED & TESTED означає наявний код плюс відтворений позитивний component/runtime тест у вказаній межі. Windows GUI/real MP не додаються до цього статусу автоматично. BROKEN — відтворений дефект конкретного контракту; інші частини тієї самої системи можуть працювати. PARTIAL — код або тестове покриття неповні для заявленої можливості. UNVERIFIED — інтеграційну властивість не доведено.

## Графіка та продуктивність

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| Coalescing закритих sprite/rect spans | IMPLEMENTED, NOT RUNTIME TESTED | [PR #2](https://github.com/ZaGOR-1/port-drone/pull/2), [game/world/cover_draw.gd:29](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/world/cover_draw.gd#L29) | Реальний batching у коді; shader/draw GPU та pixel equivalence NOT RUN. |
| Пропуск idle redraw і sway без дерев | IMPLEMENTED, NOT RUNTIME TESTED | [PR #2](https://github.com/ZaGOR-1/port-drone/pull/2), [game/world/objects_layer.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/world/objects_layer.gd) | Додані has_trees/signatures; Life idle component є у suite, повний render цикл не тестований. |
| Shader early discard, neighbour pruning, 16 країнових slots | IMPLEMENTED, NOT RUNTIME TESTED | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5), [game/world/conf_map.gdshader](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/world/conf_map.gdshader) | Shaders завантажені headless; реальна GPU compilation/image comparison NOT RUN. |
| O(1) free/active FX pool та reset scale | IMPLEMENTED & TESTED | [PR #1](https://github.com/ZaGOR-1/port-drone/pull/1), [game/world/fx_layer.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/world/fx_layer.gd) | _test_fx_pool PASS; візуальні ефекти потребують Windows GUI. |
| Frustum culling, rail budget, military scan throttling | IMPLEMENTED, NOT RUNTIME TESTED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/world/units_layer.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/world/units_layer.gd) | Код підключений; benchmark вимірює sim, не GPU/FPS, видимість країв не перевірена. |
| Однопрохідний upkeep без повторного сканування | PARTIAL | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/game/upkeep335.gd:334](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/upkeep335.gd#L334) | _tally_all є, але eager fallback зберігає старий scan: PA08. |

## Економіка

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| Масове будівництво вільних залежей та upgrade-by-kind | IMPLEMENTED & TESTED | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5), [game/game/economy/eco_trade.gd:1627](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/economy/eco_trade.gd#L1627) | Suite Step1 перевіряє backend і ресурсні обмеження; UI не пройдений. |
| Плутоній з АЕС і обмеження запасу | IMPLEMENTED & TESTED | [PR #6](https://github.com/ZaGOR-1/port-drone/pull/6), [game/game/nuclear.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/nuclear.gd) | Step2 PASS: 45s/unit, cap12 у звичайній грі; creative має інші правила. |
| Зимовий farm output −50% у lockstep | BROKEN | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8), [game/game/seasons.gd:95](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/seasons.gd#L95) | Числовий multiplier є; render delta впливає на authoritative результат: PA01. |
| Економічні modifiers ідеологій | IMPLEMENTED & TESTED | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8), [game/game/ideology.gd:59](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/ideology.gd#L59) | Формули та production hooks є; Step4 PASS для вибраних modifiers, не весь balance. |

## Дипломатія

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| Подарунок і AI buy/sell/swap територій | IMPLEMENTED & TESTED | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9), [game/game/land_trade.gd:105](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/land_trade.gd#L105) | Step5 перевіряє передачі з AI; не підтверджує всі перенесення складів/авіації. |
| Buy/sell/swap із підтвердженням другого human | BROKEN | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9), [game/game/land_trade.gd:105](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/land_trade.gd#L105) | Пропозиції/accept немає; PA02: одностороння зміна майна/грошей. |
| Відведення військ після передачі землі | PARTIAL | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9), [game/game/land_trade.gd:253](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/land_trade.gd#L253) | Код змінює ground path і air base/refund; nav obstacles, full parking, deck jet compatibility не перевірені. |
| Ядерне стримування, halt-nukes та санкції | IMPLEMENTED, NOT RUNTIME TESTED | [PR #6](https://github.com/ZaGOR-1/port-drone/pull/6), [game/game/diplomacy/dip_allies.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/diplomacy/dip_allies.gd) | Підключені scoring/fulfil/reaction; повний AI/дипломатичний сценарій NOT RUN. |

## Військова система

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| Пріоритет guns перед missile AD; allied target caps | IMPLEMENTED & TESTED | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5), [game/game/defense.gd:406](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/defense.gd#L406) | Step1 AD cases PASS: 1 shooter, 2 для ballistic; не живий multiplayer. |
| Десантування transport → paratroop infantry | IMPLEMENTED & TESTED | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/air.gd:721](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/air.gd#L721) | Step3 реально виконує flight/drop/RTB і появу підрозділів; airport UI PA05. |
| Будівництво AIRPORT через звичайний HUD | BROKEN | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/main.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/main.gd) | Direct build працює; _on_action("airport") не перемикає mode: PA05. |
| Націоналізм: бонус оборони +8% | PARTIAL | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8), [game/game/ideology.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/ideology.gd) | Є лише опис і march speed, damage hook не знайдено: PA10. |

## Флот та авіація

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| Авіаносець, hangar compatibility і 2–4 місця | IMPLEMENTED & TESTED | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/navy.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/navy.gd) | Step3 spawn/fit/deck capacity та Ship codec PASS. |
| Палубний jet: запуск і посадка на рухомий carrier | IMPLEMENTED & TESTED | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/air.gd:262](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/air.gd#L262) | Step3 виконує прямий backend flight/recovery; мережевий шлях окремо BROKEN. |
| Купівля палубного літака через MP command | BROKEN | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/ui/ui24/navy_dock.gd:1059](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/ui24/navy_dock.gd#L1059) | PA03: Ship ownership accessor неправильний. |
| Обробка загибелі carrier без запасної бази | BROKEN | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/navy.gd:3178](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/navy.gd#L3178) | PA06: airborne wing переходить до RTB з null base. |
| Carrier escort center та nearest-base return | IMPLEMENTED & TESTED | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/navy_fleets.gd:533](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/navy_fleets.gd#L533) | Step3 steering і вибір ближчої бази PASS; повна морська кампанія NOT RUN. |
| Aircraft sell 50% і rebase | IMPLEMENTED & TESTED | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5), [game/game/air.gd:311](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/air.gd#L311) | Step1 backend PASS; PC cancel mode має PA09. |
| Deck ASM атака кораблів і rearm біля naval base | PARTIAL | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/air.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/air.gd) | Пуск/вартість у коді, rearm-away rejection PASS; повний ASM combat/rearm cycle NOT RUN. |

## Ядерна зброя й ППО

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| ICBM build→arming 30s→ready→launch→reload90s | IMPLEMENTED & TESTED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/game/nuclear.gd:43](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/nuclear.gd#L43) | Step2 оновлені assertions PASS, silo state/cd roundtrip PASS. |
| Zaslon exclusive ABM для ядерних ICBM | IMPLEMENTED & TESTED | [PR #6](https://github.com/ZaGOR-1/port-drone/pull/6), [game/game/defense.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/defense.gd) | Step2 targets/interception PASS; 900 base range масштабується мапою. |
| Blast, permanent crater, radiation DoT та заборона забудови | IMPLEMENTED & TESTED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/game/game_world/gw_infra.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/game_world/gw_infra.gd) | Step2 damage/crater/radiation checks PASS; zone core roundtrip PASS, масовий late battle NOT RUN. |
| Багатостадійний nuclear VFX, quake і flash | IMPLEMENTED, NOT RUNTIME TESTED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/world/vfx_blast.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/world/vfx_blast.gd) | Реальний procedural effect; GPU вигляд, тривалість та доступність NOT RUN. |

## ШІ

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| 11 bot slots, палітра і налаштування | IMPLEMENTED & TESTED | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5), [game/game/game_config.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/game_config.gd) | Step1 checks CB_MAX/стилів PASS; повний матч із 11 ботами NOT RUN. |
| Ядерна AI build/arm/launch/ABM стратегія | IMPLEMENTED, NOT RUNTIME TESTED | [PR #6](https://github.com/ZaGOR-1/port-drone/pull/6), [game/game/nuclear.gd:724](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/nuclear.gd#L724) | Код викликається через ai_power; довга кампанія та balance NOT RUN. |
| Оптимізація пошуку цілей, grid, кешів і фаз AI | IMPLEMENTED & TESTED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/game/army_fire.gd:121](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/army_fire.gd#L121) | Компоненти Step6 і sim benchmark PASS; порядок spotting/AI cadence змінився, baseline-equivalent поведінку не доведено. |
| AI укомплектування carrier палубною авіацією | PARTIAL | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/navy.gd:2767](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/navy.gd#L2767) | Carrier hull AI є; автоматичного buy_carrier_plane caller для AI не знайдено, лише UI. |

## Мапа та інтерфейс

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| City rename із validation і label sync | IMPLEMENTED & TESTED | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5), [game/game/game_world/gw_states.gd:499](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/game_world/gw_states.gd#L499) | Step1 clean/name collision cases PASS; GUI rename NOT RUN. |
| Сезонний shader, опади, сніг, nuclear winter visuals | IMPLEMENTED, NOT RUNTIME TESTED | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8), [game/world/weather_fx.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/world/weather_fx.gd) | Seasons component та ресурси завантажені; GPU appearance NOT RUN. Навігаційне замерзання річок не реалізоване. |
| 7 ідеологій, monuments і reskin після capture | IMPLEMENTED & TESTED | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8), [game/game/ideology.gd:125](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/ideology.gd#L125) | Step4 component PASS, new atlas bounds PASS; PA10 окремо. |
| P1 RGB flag codec та brush/fill/eyedropper editor | PARTIAL | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8), [game/ui/flag_editor.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/flag_editor.gd) | Codec/validation Step4 PASS; жодного GUI input тесту трьох інструментів, весь editor не сертифікований. |
| 40 alliance emblems | IMPLEMENTED & TESTED | [PR #8](https://github.com/ZaGOR-1/port-drone/pull/8), [game/game/alliances.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/alliances.gd) | Step4 усі logo resources PASS та JSON/PNG bounds; selector UX NOT RUN. |
| Єдина PC UI scale, adaptive sheets/tooltips/hotkeys | IMPLEMENTED, NOT RUNTIME TESTED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/pc/pc_port.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/pc/pc_port.gd) | Статично виправляє baseline R12 double scale; helper bounds PASS, реальні DPI/keyboard/mouse NOT RUN. |
| Hold confirm та no-slow preference | IMPLEMENTED, NOT RUNTIME TESTED | [PR #5](https://github.com/ZaGOR-1/port-drone/pull/5), [game/ui/hud/hud_ops.gd:246](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/hud/hud_ops.gd#L246) | 0.45s tween/guards, persisted no_slow і budget hooks є; mouse release/leave/cancel NOT RUN. |
| Скасування REBASE/AIRDROP через RMB/Esc | BROKEN | [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7), [game/game/main/main_core.gd:41](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/main/main_core.gd#L41) | PA09: component returns false для обох режимів. |
| Ultimatum disputed-land highlights і ceded protection | IMPLEMENTED & TESTED | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9), [game/game/game_world/gw_map.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/game_world/gw_map.gd) | Step5 enclave reclaim protection PASS; pulsing overlay/map-pick GUI NOT RUN. |

## Збереження та повтори

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| Legacy synthetic FORMAT1 → новий codec і нові entity fields | IMPLEMENTED & TESTED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/game/save.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/save.gd) | 17 audit checks PASS: legacy defaults, silo cooldown, carrier/plane ID, troop target, seasons, zones, Chronicle event. Не гарантія всіх старих saves. |
| Хроніка змішаного матчу з кораблями | BROKEN | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9), [game/game/chronicle.gd:120](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/chronicle.gd#L120) | PA04 SCRIPT ERROR; no-ship suite PASS не покриває флот. |
| Timeline viewer, scrubber, browser і disk archive | PARTIAL | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9), [game/ui/chronicle_viewer.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/chronicle_viewer.gd) | No-ship snapshot/disk Step5 PASS; PA12 frame cap/MP scope, GUI NOT RUN; це не command replay. |
| Land deal cooldown persistence | BROKEN | [PR #9](https://github.com/ZaGOR-1/port-drone/pull/9), [game/game/land_trade.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/game/land_trade.gd) | PA07: lost after restore; цільові 17 positive checks цього не зараховують як PASS. |

## Steam і мультиплеєр

| Можливість | Стан | Джерело | Фактична межа |
|---|---|---|---|
| cmd_field validation, delayed ordering, trace gating, hash coverage | IMPLEMENTED & TESTED | [PR #1](https://github.com/ZaGOR-1/port-drone/pull/1), [game/net/net_session.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_session.gd) | Suite command/codec/hash/delayed assertions PASS; state hash лишається неповним (PA01). |
| Steam leave peer cleanup і refusing-session guard | IMPLEMENTED, NOT RUNTIME TESTED | [PR #1](https://github.com/ZaGOR-1/port-drone/pull/1), [game/pc/steam_peer.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/pc/steam_peer.gd) | Код виправлено; реальні invite/disconnect/accounts NOT RUN. |
| Steam+LAN-only UI, FrontPlan reset | IMPLEMENTED, NOT RUNTIME TESTED | [PR #4](https://github.com/ZaGOR-1/port-drone/pull/4), [game/ui/menus.gd](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/ui/menus.gd) | Online account/ranked hooks вимкнено, server script видалено; LAN/Steam GUI NOT RUN. |
| Cross-build protocol7, reconnect/resync і живий 2-peer | UNVERIFIED | [PR #10](https://github.com/ZaGOR-1/port-drone/pull/10), [game/net/net_session.gd:3008](https://github.com/ZaGOR-1/port-drone/blob/96053d66eb984cc24e3acce647a55a195136abd2/game/net/net_session.gd#L3008) | PA11, inherited R02 та PA01; transport session не тестований, Linux native .so відсутні. |

## Відношення до 0.41.x

У PR справді є окремі implementations seasons/ideologies/flags, nuclear chain/ABM, carrier/airdrop, land deals, Chronicle та PC QoL. Вони схожі за призначенням на заявлені coauthor можливості 0.34–0.41.12. Оригінальну 0.41.4.1 поведінку, balance, save/protocol/native contracts і ресурси порівняти неможливо без matching dev package; parity не встановлена.

Відсутні: повний 0.41.4.1 source/native/build package; command-level replay/resume у Chronicle; фізичне/навігаційне замерзання річок; human land-deal accept workflow; знайдений AI caller для комплектування carrier wing. Сезонний shader зображає лід, але не змінює biome/nav. Це не міграція до оригінальної 0.41.

Практична основа подальшої розробки — редагований відкритий порт із виправленим cumulative head, а dev-пакет 0.41 запитувати паралельно. Source/build gates у [MIGRATION_041](MIGRATION_041.md) залишаються чинними. Фінальний release оригінальної 0.41 тут не запускався і його PCK не розшифровували.
