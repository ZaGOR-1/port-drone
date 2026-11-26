# Формат збережень DroneFlames

## Поточний контракт

[Save](../../../game/game/save.gd) веде `FORMAT=1`, snapshot graph і restore, [SaveSlots](../../../game/game/save_slots.gd) — дискові слоти. Optional `sys.diplo.land_cooldowns` та `sys.hold.far_fail` за відсутності дають порожні значення. Legacy save перевіряй на копії. Сумісність downgrade не гарантовано.

- Autosave кодує graph на main і відокремлює header/body/thumbnail через `duplicate(true)` до запуску worker. Navy відновлює потрібний стан без незбережених TTL caches. Repeated restore має очистити stale state.
- SP Continue і штатний loader використовують спільний preflight та порядок за актуальними заголовками. У незавершеному слоті перевіряються звичайні копії за seq/date, потім `.bak` і `.tmp`. У браузері слот з одним придатним `.tmp` зайнятий і доступний для ручного завантаження. Перевірка доступності лише читає файли, після кліку вибір виконується заново. [FIX-STABILITY-02B](../../fix-stability-02/INTEGRATION_READINESS.md)
- `Save._net_body` перевіряє variant wrapper, довжини, межі, формат і форми обов’язкових полів та посилань до staged load. `Save.net_restore` готує заморожений world. `NetSession` комітить час, turn і запуск після перевіреної підготовки. [Мережевий контракт](MULTIPLAYER_PROTOCOL.md#поточний-контракт)
- Використовуй [save/restore fixtures](../../DEVELOPMENT_WORKFLOW.md#перевірки-за-scope). Відмова у fixture підтверджує лише відповідний шлях. Дискова стійкість за crash/power-loss потребує окремих доказів. Фізичне приймання прив’язуй до [точного Windows комплекту](../../WINDOWS_QA.md#перевірки).

## Історичні checkpoints

Опис і результати далі належать указаним Phase та PR. Для поточного коду користуйся контрактом вище.

> **Підтвердження PR #4 і попередні звіти.** FORMAT1, optional land_cooldowns + UrbanHold far_fail, legacy missing defaults і repeated restore перевірені PR #4. Autosave freeze повного encoded graph перед worker; Navy current-threat routes/scratch reset. New→old downgrade unsupported; OS durability не закрита. [Current flows](ARCHITECTURE_AND_FLOWS.md), [tests](V036_FIX_RESULTS.md).

# Phase 5B.2 — явне optional розширення FORMAT1

Число FORMAT=1 і контейнер/entity/reference layout незмінні. Додано `sys.diplo.land_cooldowns: Dictionary[String, float|int]` (directional from:to → simulation game_time успішної угоди), копіювання save/load; відсутнє поле дає empty history і очищає попередній світ. Shared Save._sound перевіряє тип/ключі/finite/nonnegative timestamp<=savedclock до mutation disk/network.

[FIX06 та compatibility policy](PHASE5B2_FIXES.md), [actual tests](PHASE5B2_REGRESSION_RESULTS.md). Old→new legacy/disk/snapshot PASS; історію старого save реконструювати неможливо. New→old реальний R02 reader читає snapshot і губить cooldown, тому **semantic downgrade UNSUPPORTED**. Не заявляти двосторонню сумісність або повністю незмінну schema. Новий authoritative state входить у NetHash; mixed-build revision gate потрібен до розповсюдження, identifiers зараз не змінені.

R02 safety збережено, scoped suites PASS; arbitrary malformed nested data/disk transaction/R05 не закриті. New optional-field validation не є універсальною схемою всього world.

---

## Історичний checkpoint (збережено)

# Phase 5B.1 мережевий restore

FORMAT1 та encoder незмінні; додано лише перевірку вхідного network snapshot/guard по staged load. [R02](R02_SNAPSHOT_RESTORE_FIX.md) не змінює serialized fields/RNG/hash і не сертифікує довільно пошкоджені disk saves. Старий checkpoint та synthetic roundtrips перевірено; malformed nested save hardening R05 лишається окремою задачею. Partial load не rollback-иться: мережеву сесію безпечно завершуємо і будуємо fresh menu world.

---

## Історичний checkpoint (збережено)

# Phase 5 delta — FORMAT1 envelope незмінний

Candidate від PR10, isolated/uncommitted. Ship.FIELDS/c owner, entity contracts і native DLL незмінні. Human land consent terms — новий kind=land у вже serialized Diplomacy.t_offers; не новий FORMAT/schema envelope. Actual Main Save.save_game/Save.load_slot перевіряє pending terms/recipient, carrier/plane links, seasonal state та loss→load→continue. Legacy Phase2 snapshot→newMain та fresh world PASS у synthetic scope.

**New→old downgrade не сертифікований/не підтриманий**: старий code не знає land offer kind/carrier enums. Завжди copies/окремий namespace, не старий stable save directory. Довільні malformed internal dictionaries, приватні saves та OS fault matrix NOT RUN. LandTrade._last_deal cooldown не збережений після load (PA07 FAIL), а NetSession ігнорує restore=false (R02 HIGH FAIL). Це не виправлено цим phase. Точні results/limits — PR10_REGRESSION_RESULTS; наступні fixes — PHASE5B_PLAN. Нижче історичні результати0.33.


---

## Історичний документ / попередній scope (збережено)

# Збереження і serialization

HEAD `af1b4c9`. Повністю прочитані `game/game/save.gd`, `save_slots.gd`, моделі Country/City/Facility/Unit/Drone/Missile/Aircraft/Ship/Bridge та NetConfig. Phase2 synthetic disk/core round-trip **PASS**,7 checks; GUI load_slot, OS failure injection та legacy/private saves **NOT RUN**. FORMAT1 не змінений.

## Шляхи й окремі namespaces

| Шлях | Призначення |
|---|---|
| `user://saves/slot_N.save` | Manual main, N1…5 |
| `slot_N.a0.save`, `.a1.save`, `.a2.save` | Autosaves |
| `slot_N.save.bak`, `.save.tmp` | Manual backup / temporary commit candidate |
| `slot_N.meta`, `.meta.tmp`, `.png` | Godot Variant metadata / thumbnail56×56 |
| `user://match.save[.tmp/.bak]` | Legacy save candidates, migration to slot1 |
| `user://net_match.save[.tmp]` | Host network match (окремий формат) |
| `user://settings.cfg` | GameConfig prefs + audio settings, shared ConfigFile sections |
| `user://pc_port.cfg` | Desktop scale/fullscreen/window position |
| `user://net.cfg` | Backend overrides, nick, rejoin metadata/token |
| `user://account.bin`, `attest.bin`, `ranked_pending.bin` | Account/device/ranked state; не логувати й не копіювати в документацію |
| `user://tutorial337.cfg`, `user://perf/...` | Tutorial progress / diagnostic output |
| `user://libs_try.txt` | Updater retry guard; DLL/EXE і libs.rev живуть біля EXE |

`SaveSlots.path:33` будує імена; не використовувати repository-relative paths для game user data. Runtime root залежить від Godot application config/OS. Phase2 fixtures використовували ізольовані XDG paths у dist; Windows launcher — test-user APPDATA + custom namespace. Реальні user data directory не читали/не змінювали; observed test paths у ENVIRONMENT_SETUP/RUNTIME_BASELINE.

## Single-player disk envelope

`Save.MAGIC=827541060` (`DFS1`, little-endian u32); FORMAT1. `Save::_write_raw:805` записує послідовно:

1. store_32(MAGIC).
2. store_var(header Dictionary) — Godot Variant serialization з власним length prefix.
3. store_64(raw uncompressed byte count).
4. 16 raw bytes MD5(compressed payload).
5. store_64(compressed byte count).
6. ZSTD-compressed `var_to_bytes(body)`.

Header: format, application/config/version, country/color, game_time/elapsed/score, unix date/date_text, size/bots/cities; нові metadata slot/t_ms/seq/mid/flag/tier/place/n_countries/map_type/size_i/difficulty/cb_on/creative/end. `seq` сортує копії всередині slot; t_ms для найсвіжішої партії. Application version у header не гарантує CI EXE version: build patch змінює pc/version і Menus, а не project.binary.

Body: `{format, core, sys, ents}`. Core містить entity refs країн/міст/мостів/player/RNG, settings/config, clocks, map/UI state, roads/jobs/checkpoints, biome/flags/owners, object packed arrays і sprite names, fires/ruins/decals, allowed delayed callbacks, camera/zoom/speed. Height генерується заново з settings, а не лежить окремою копією у core.

`_open:860` перевіряє magic, Dictionary header, format<=1, compressed lengths, MD5; raw_n має бути>0 і<=1 GiB. `_read` перевіряє decompressed size і Dictionary/core. MD5 — corruption check, не автентичність чи підпис. `_sound` — мінімальна перевірка core/ents та non-null countries/cities/bridges; не повна схема всіх полів/діапазонів.

## Entity graph codec

ENTITY whitelist: Country, City, Facility, Unit, Drone, Missile, Aircraft, Bridge, Rng. Reference marker `"\u0001r"` → index у ents. Елемент ents=`[class_name, serialized script fields]`. `_ref` реєструє об'єкт до обходу полів; `_load_core` спочатку створює всі об'єкти, потім fill — підтримка shared references і entity cycles. Dictionary/Array containers enc/dec рекурсивні; довільні cyclic containers не слід вважати підтриманими лише через підтримку entity cycles.

`_names` використовує PROPERTY_USAGE_SCRIPT_VARIABLE; dump пропускає Callable/Signal/RID та non-entity Objects. `_entity_dump` починає з inst_to_dict, прибирає @path/@subpath і трансформує лише complex fields. Facility.fx не зберігається; City.visited пакується як SET marker з PackedInt32Array keys, flag position як `$flag`. Typed arrays/dictionaries відновлюються через current property type у `_assign`. Enum ordinal, property names і `class_name` — save contract.

Ship **не** входить у ENTITY: `Navy.save_state:3003` перетворює ships через `Ship.to_dict`, потім `from_dict` зі FIELDS. Owner key=`c`; не міняти його на country_id без migration. Air стан лежить усередині Military save; Trade331/Upkeep335/Ports — Economy; NavyArt/NavyFleets — Navy. Це важливі вложені boundaries.

ORDER=[mil,econ,rail,army,defense,diplo,ai,session,vision]; GENERIC=[defense,diplo,ai,session]. `_system_names:755` доповнює список властивостями World: non-Node Objects із save_state+load_state. Не кожне поле World автоматично зберігається. Cad344 не має цього API; деякі caches і jobs навмисно пропущені. Entity-specific/system-specific migration не замінює загальна FORMAT1.

## Write, background і транзакційність

Manual `save_game`: can_save → wait worker → snapshot на main → `_sound` → thumbnail → synchronous serialize/compress/write. `can_save/why_not` відхиляє меню, no player/capital/cities, tutorial, eliminated, net_driven, no_save. Поразка/перемога має slot end flag; старі copies залишаються.

Autosave tick кожні60 real seconds, може чекати active touches до20 s додатково; skip коли game_time не змінився, save неможливий або task ще працює. Snapshot формується на main; `_queue_write:782` виконує `body.duplicate(true)`, підставляє arrays цього frozen core у thumbnail input; worker серіалізує, стискає і пише. Phase2 regression `_test_save` пройшов перевірку frozen body/thumbnail під live mutation. Це конкретний fixture, не доказ відсутності всіх thread races; benchmarks також завершили3 autosaves/run.

Temporary save flush/get_error перевіряється перед rotation. Для main старий destination переноситься в bak, для a0 існуючий destination може видалятися, далі tmp→destination. Autosave history shift a0→a1→a2 коли різниця game_time>=300 s. `fresh=true` у before_write спочатку видаляє старі copies slot-а, вже після запису нового tmp, але **перед** final rename. Не гарантувати all-or-nothing: частина rename/remove return codes і metadata commit не перевіряються; можливі failure windows. Tmp додається останнім у fallback load order, тому recovery залежить від metadata/slot discovery. Acceptance failure injection — BACKLOG.

`_task/_write_ok/SaveSlots._meta_c/_gen/last` — статичний стан; UI може читати slots під час background write. set_flag/delete/main-save чекають worker, але rows/meta не роблять загальний mutex. Це потенційна гонка, не доведене пошкодження; перевіряти окремо. Engine забороняє довільні active SceneTree writes із threads; код thumbnail використовує Image, не Texture2D scene updates. Довідка [Godot4.7 thread-safe APIs](https://github.com/godotengine/godot-docs/blob/4.7/tutorials/performance/thread_safe_apis.rst) звірена через Context7.

## Load і сумісність

Load order: preferred key, решта copies за seq/date, bak вкінці, tmp останнім. Пошкоджений candidate пропускається; якщо нічого валідного — slot bad, файли не видаляються. `_load_pack` встановлює cfg, legacy gen_version1 default, ховає UI, створює світ, зупиняє World processing, load core/system state, rebuild terrain/objects/checkpoints/flags, restore camera/speed, refresh HUD.

Compatibility hooks: missing cfg defaults expand/AI dig/alliances/limits/reserves; creative heuristic лише для старих saves без ключа; missile_stock доповнюється до поточного MT_CAP size; sprite IDs remap за spr_name; uranium/deep reserve/upkeep мають load defaults; typed properties проходять current field whitelist. Нові поля мають безпечні початкові значення, але це не доказ довільної backward/forward compatibility. Header відкидає лише format>1; version не є повним schema gate.

`SaveSlots.migrate:413`: якщо legacy є і slot files немає, обирає найновіший валідний `_open`, копіює через tmp, перевіряє копію, переносить у slot1; legacy перейменовує в `.pre332`. Якщо slots уже існують або legacy unreadable — зберігає legacy. Не тестувати на єдиній копії: migration має side effects і частину rename return codes не перевіряє.

## Network snapshot і saved match

Snapshot — `var_to_bytes([raw.size(), raw.compress(ZSTD)])`, без single-player MAGIC/header/MD5. Net restore перевіряє wrapper Array size2 і body Dictionary/core; raw-size upper bound/decompressed-size equality/entity schema перевірені слабше за disk `_open`.

`NetSession.save_match` через NetConfig.store_var записує exact version/proto, turn, mode, room/host/roster/tokens/config, played time, snapshot. MATCH_SAVE_TURNS600 (~60 simulation seconds), focus/exit також trigger. `NetConfig.save_match:140` видаляє старий destination перед rename tmp; немає bak/MD5 і перевірки final rename. `resume_host` exact version check; stale match TTL3 days. Це окремий durability risk від single-player slot rotation.

## Правила наступної зміни

Phase2 save probe: manual write→_read→_load_core/_load_systems/_finish у новому synthetic World; NetHash/owners/biome/flags/time/counts збережені, player entity identity відновлена. Corrupt compressed payload і invalid net wrapper відхилені; sampled state після rejected wrapper незмінний. Це не виклик Main UI load_slot і не NetSession failure-path regression. Деталі/7 assertions: [RUNTIME_BASELINE](RUNTIME_BASELINE.md).

Перед зміною codec: прочитати Save/SaveSlots, усі змінені entity/system save/load methods, NetCodec/NetHash/NetSession restore; fixtures лише synthetic або копії. Acceptance: старий save load; round-trip entity identity/cycles/enums; гроші/counts/owners/RNG; mutate-during-autosave; corrupt/truncated/future-format fallback; migration/final-rename/ENOSPC failures; MP all-peer snapshot convergence. У цьому запуску формат і поведінка не змінені.
