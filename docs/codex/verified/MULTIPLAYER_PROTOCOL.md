> **CURRENT identity / HISTORICAL report below.** v0.36.0/PROTO7/SIM_REV `v036-integration-1`. Exact hello/resume gate, power wire/schema/owner guard і canonical hash нових fields перевірені targeted fixtures у PR #4; full physical LAN/Steam NOT RUN. [Current flows](ARCHITECTURE_AND_FLOWS.md), [fixes](V036_FIX_RESULTS.md). Старі revisions/SHA/permissions/results нижче датовані, не поточні.

# Phase 5B.2 — command validation і compatibility boundary

PROTO7/RPC signatures/packet types/command ordering/native DLL/Steam code незмінні. Targeted _exec schema guards до ownership/callv: mil.build(valid enum/cell/Country/optional parent, free=true заборонено для network caller); mil.air.rebase/entity3args; order_airdrop/entity/finiteVector2/optionalCountry. Valid UI commands не змінюють кодування. Internal free spawn/build через прямі calls збережено. Загальне ALLOWED hardening R07 окремо.

Cooldown state тепер серіалізується optional FORMAT1 і входить у hash canonical-order. SIM_REVpr10-critical-1 НЕ підвищено за обмеженням користувача. Реальний ENet hello current/current accepts, oldPR10 rejects, R02/current з однаковим identity accepts. Останнє не означає simulation compatibility: **owner-approved revision/build gate потрібен перед network розповсюдженням**. Tests лише exact same build. Full two-peer command/restore/reconnect/host rotation NOTRUN. R02111+41 та Phase5 save/continue PASS у component scope.

Докази: PHASE5B2_REGRESSION_RESULTS.md, PHASE5B2_FIXES.md. Старі compatibility твердження нижче зберігають історичний scope.

---

## Історичний checkpoint (збережено)

# Phase 5B.1 уточнення restore lifecycle

PROTO=7 і packet types незмінні. [R02 lifecycle/commit point](R02_SNAPSHOT_RESTORE_FIX.md): snapshot не успішний до decoder→core→systems→finish→fog/cache/Main cleanup. Session epoch інвалідовує stale coroutines; partial failure завершує local session, скидає queues/flags і зберігає seat/checkpoint. Повний старий світ rollback не виконується.

SIM_REVpr10-critical-1 production version admission перевірено справжнім ENet hello у двох loopback processes: originalPR10 відхилено; current/current і Phase5/current прийнято. Отже identity guard існує, але не є source hash; exact same binary потрібний для acceptance. Повний command stream/reconnect/resync/host migration між двома peers лишається NOT RUN. [Докази](R02_FAILURE_INJECTION_TESTS.md).

---

## Історичний checkpoint (збережено)

# Phase 5 delta — codex/fix-pr10-critical, uncommitted

PROTO7/transport packet layout/RPC signatures незмінні. NetConfig.version тепер Menus.VERSION/7/pr10-critical-1 через opaque SIM_REV; чинні LAN/Steam/rejoin guards порівнюють identity. Це явна зміна build admission semantics; mixed-build фактичний2-peer test NOT RUN. Product version у source не підвищено.

Net-driven rendering більше не advances seasons, hash охоплює season state і pending land terms. Human land_deal лише пропонує, існуючий answer_as авторизує recipient/one-shot consent; typed args перевірені до _owns. Ship ownership читає c. Два independent fixed-tick runs із різним rendering PASS; це не повна MP certification. **Inherited R02 HIGH лишається:** false restore все одно advances clocks/go/rejoin, runtime FAIL. Повний delta/тести/межі — PR10_CRITICAL_FIXES/PR10_REGRESSION_RESULTS; Phase5B_PLAN має окремий fix. Нижче історичний baseline af1b4c9, не current candidate.


---

## Історичний документ / попередній scope (збережено)

# Мультиплеєр: transport, lockstep, snapshots

HEAD `af1b4c9`, 2026-11-19. Повністю прочитані `net_session.gd` (3045 рядків), `net_config.gd`, `net_codec.gd`, `net_hash.gd`, PC Steam scripts. RtcLink/backend helpers прочитані частково; повний текст пройшов лексичний аналіз. Жодний multiplayer runtime тест не виконаний.

## Шари й ідентичності

Main створює Node `Net` з NetSession: однаковий шлях на кожному peer — вимога Godot RPC. NetSession.Mode: OFF/LAN/ONLINE. Steam використовує Mode.LAN плюс `steam=true`, не окреме enum значення. Transport підставляється у `multiplayer.multiplayer_peer`:

| Режим | Discovery / lobby | Transport |
|---|---|---|
| LAN | LanDiscovery UDP beacon/browse; порти24601/24602 | ENet host24600; MAX_PLAYERS4, максимум3 guests |
| Steam | GodotSteam lobby, df_game=DroneFlames, v, host; friends invite/`+connect_lobby` | SteamPeer: MultiplayerPeerExtension, Steam Networking Messages channel3 |
| Online | Backend WSS, account Bearer, room code/public browser/ranked | WsTunnelPeer lobby → WebRTCMultiplayerPeer з ICE/TURN для гри |

`NetConfig.PROTO=7`; `version()`=`Menus.VERSION/7`. `steam_net.gd::_on_lobby_joined:209` перевіряє exact v; `NetSession::_hello:1422` повторно перевіряє exact version. Build-процес змінює Menus.VERSION разом з updater version. Hash source/PCK чи native ABI у handshake не передається.

Peer1 — поточний host; index slots — seat гри; country ID=slot+1. У roster є peer/name/ready/left/arch/cos/flag, із початку матчу стабільний `seat` для chat. При online host rotation peer IDs змінюються, country slot зберігається; host після promotion може мати local_slot!=0. Не прирівнювати всі host/country/seat IDs до1.

`LanDiscovery` прочитано повністю: host відповідає на `DF?` і, крім iOS/test_no_broadcast, шле announcement щосекунди; browse кожні3 s будує loopback + усі адреси1…254 приватних /24, опитує до64 адрес/frame, прибирає rooms після7 s. Це мережеві дії runtime discovery, які аудит не запускав; відсутність room не обов'язково означає проблему ENet transport. JSON discovery лише перевіряє df marker; version/admission перевіряються наступними шарами.

## Steam wire

`steam_peer.gd`: header7 bytes: kind:u8(offset0), nonce:u32(offset1), transfer channel:u8(offset5), mode:u8(offset6), потім payload. Kind enum DATA0/HELLO1/WELCOME2/BYE3/PING4/REFUSE5. Constants reliable9/unreliable1, Steam channel3, `MAX_SIZE=512*1024−64=524224`. Non-DATA control messages reliable. Guest передає тільки host, host шле кожному target/всім/всім крім target; relay підтримку оголошено Godot.

Handshake: guest nonce random31bit nonzero, HELLO кожні1 s, give-up25 s. Host приймає HELLO, зберігає sid/nonce/seen, WELCOME і peer_connected; ping1 s, timeout45 s. Дані/bye/ping приймаються за nonce на link; guest додатково перевіряє sid==host_sid. Host `_on_msg` адресує links за derived pid; sid повторно не звіряє. Nonce відсікає старі сесії, не є криптографічною автентифікацією.

`peer_id_of=(sid & 0xffffffff)%2147483000+2`: колізія математично можлива, напр. account1 і2147483001 дають peer3. При HELLO existing pid з іншим nonce `_drop` заміняє link без перевірки existing sid. Реальну частоту такого випадку не вимірювали. `SteamNet::_on_session_request` делегує `wants_session`; host_mode приймає будь-який sid, перевірки lobby membership тут немає. NetSession обмежує roster/version, але transport admission залишається широким.

`SteamMock`: loopback UDP, port41000+(sid%1000), `/tmp/df_steam_mock/lobby_*.json`, deferred callbacks. Однаковий modulo1000 дає port collision. Mock не моделює Steam reliable queue і великий packet support; max UDP payload суттєво менший за524224. Це тестовий adapter, не доказ production transport correctness.

## Початок матчу

`host_start:1490` вимагає host і >=2 slots; створює seed/WorldSettings та CFG_KEYS, 16-byte Crypto seat tokens для гостей; закриває discovery/joinable. Steam/LAN → `_send_start`, online спершу seal/turn→direct peer readiness (host28 s, guest32 s).

Reliable authority+call_local `_start` передає ws/cfg/n/ranked/names/archs/flags/seats. На кожному пристрої: GameConfig sync, reset lockstep, net_driven=true, net_tick0, await `Main.net_begin`, готовність `_ready_rq`; host після всіх `_mark_ready` шле `_begin`. Через60 s host помічає неготових left і додає AI command. Новий незнайомий guest після старту отримує running; late join підтримується як повернення власника seat, не довільний spectator.

## Маршрут команд і валідація

UI/Main `_sim` або статичний `NetSession.sim` → `call_sim`. Offline виклик одразу; MP — encode, локальний double-tap dedup400 ms, issue({k:call,o:path,m:method,a:encoded args}), seq q. Host ставить s=local_slot й append pending; guest шле reliable any_peer `_cmd_rq` host-у.

Host `_cmd_rq:1975` знаходить sender у roster, приймає k тільки call/cap/town, перезаписує s, видаляє c (guest не обирає довільну country), нормалізує cell/arch для placement. Порядок pending — порядок прийнятих host-ом команд; це canonical order для peers.

На початку turn `_exec:2002`:

- issuer із slot+1; k=call вимагає issuer.is_player, ALLOWED[path.method], існуючий target+method.
- NetCodec decode; `_owns` вимагає, щоб перший Country був issuer, прямі Facility/Unit/Drone/Aircraft/Ship/Missile arguments мали owner issuer, id_arg (якщо>=0) дорівнював issuer.id. City дозволений чужий як attack target; другий Country — trading partner.
- Окремі guards забороняють примусову торгівлю з іншим human без його згоди.
- k cap/town створює міста; human/ai — host-generated передавання контролю на disconnect/rejoin.
- cb результат виконується лише на issuing device; збережено instance id і script callback owner, щоб закритий sheet не спричинив invalid lambda.

ALLOWED — поточний контракт у `net_session.gd:33`: World cmd_field/build_sub/static/strike/refill/recall; Military build/repair/launch; Air loadout/buy/orders; Army/Operations groups/fronts; Defense/Protect; Diplomacy і PeaceConf; Economy/Trade331; Naval/Navy; Rail. Додавати нові gameplay actions потрібно і в UI route, і в цей контракт, і у validation tests.

`NetCodec`: tagged references C/Y/F/U/D/M/A/S з ID, `$a` typed-array descriptor, `$d` wrapped dictionary. Game scripts у typed arrays обмежені res://game/*.gd без `..`. Entities resolve за runtime registry/arrays. Це інший codec, ніж Save reference table.

Обмеження: `_owns` не рекурсивний для вкладених контейнерів; перевірки argument count/type/range здебільшого покладені на методи. Ship.owner називається `c`, тоді як `_owns` читає country_id; поточні основні Navy commands передають Facility/IDs, тому доступний UI regression ще не доведений. Немає явного per-peer command rate/bytes/arity budget у `_cmd_rq`; malformed allowed call може дійти до callv на всіх peers. Це область hardening, не пройдений adversarial test.

## Lockstep і швидкість

SIM_DT1/30, TICKS_PER_TURN3 → turn0.1 simulation s. Host `_host_turns:2193` випускає turns з commands/speed, накопичує максимум3 turns; зупиняється, якщо host inactive/restoring. MP_SPEEDS1/2/3; speed змінює pace, не dt. Host speed modes: consensus minimum human wish, auto1→2 після20 quiet real seconds →3 після60, або off1. Старт capital placement завжди1x; автоматичний capital timeout90 game seconds.

Backlog: від3 turns host уповільнює turns удвічі, від5 утримує; guest із >=30 turns backlog вважається catching-up і не гальмує інших. У `_run` до24 ticks/frame і14 ms simulation budget з EMA прогнозом; перший tick дозволений навіть за перевищення. Черга зберігає900 turns (~90 simulation s). `_turn` reliable authority+call_local, commands тільки exec_tick0. World.net_sim=true лише під час commands/ticks, Navy.cur reset кожного tick.

Main focus-out викликає host inactive **лише на mobile feature**; desktop focus-out не паузить усіх (`main.gd:288`). Текстовий коментар про загальне background pause потрібно читати разом із цією PC умовою. Локальне pause/menu не зупиняє MP `_apply_speed`; manual pause action показує пояснення.

## Desync, resync, повернення

Кожні50 turns (>0) guests шлють NetHash.of + bounded parts JSON (<32768 chars); host порівнює у близькому turn window. Hash — перші16 hex MD5 від вибірки числових state, owners,obj_state,diplomacy aggregates. Це64-bit diagnostic summary, не криптографічний доказ тотожності всього serialized state; частину даних включено агрегатами/quantized. NetHash.parts містить детальні діагностичні записи, але не всі вони входять у NetHash.of. Guard між turns може знайти UI/frame writes (`NetConfig.guard`).

Mismatch → `_queue_resync` → snapshot наприкінці turn. `Save.net_snapshot` wrapper=[raw_size,ZSTD(var_to_bytes(body))]. Частини по16000 bytes, authority `_snap_begin(n,size,parts)` та `_snap_part(i,data)`. На приймачі parts з'єднуються за індексом; declared size не перевіряється, ліміти загального size/count/part indices не задані. Host trusted authority, але robustness malformed snapshot не доведена.

**Усі** peers і host відновлюють одні байти: codec пропускає деякі caches/pending Callables, тому «тільки виправлений guest» мав би інший стан. Після restore player переприв'язується за local_slot, net_tick=(n+1)×3, exec_turn=n+1, exec_tick0; зберігається per-device fog, Main очищає FrontPlan/strike caches. Newest snapshot чекає завершення поточного restore.

Підтверджений failure-path defect: `_restore_from:2999` лише логує ok=false; все одно змінює clocks, викликає net_after_restore, знімає restoring/rejoining і може показати успіх. Деталі R02 у RISKS. Snapshot schema validation і rollback на пошкодженому input — NOT RUN.

Disconnect guest → host-generated AI command, країна продовжує грати. Seat token (128bit) дозволяє rejoin; try every4 s до60 s, live connection waiting window150 s; snapshot watchdog20 s без progress і hard cap180 s. Saved place зазвичай20 min, host-away3 days. `resume_host` вимагає exact build/proto version, чекає до180 s на гостей, missing → AI; гості можуть повернутися пізніше.

Online host rotation використовує server epoch/names/most-advanced state, `_on_promoted`, country slot retention; LAN/Steam такої online server promotion не мають. Не переносити поведінку online rotation на Steam без implementation/tests.

## Backend і privacy boundary

RtcLink/Api використовують Bearer Account.access; Api має15 s timeout, refresh-once при401, журналює method/path/code без body. NetTls завантажує власний CA bundle для snaipix.com suffix; це довіра до CA, не доведений SPKI pin. DeviceCheck має iOS/Android adapters; native DFDevice не включено в активний extension_list. Windows backend admission/features потребують окремого smoke на погодженому test server.

Production API/WSS, реальний Steam, ranked та reports під час аудиту не використовувалися. Не писати seat tokens, account state, cookies/authorization чи приватні snapshots у verified docs або logs.


Пропозиція мінімального admission gate для окремого погодження: `SIM_REV=pr10-phase5b2-1` замість поточного `pr10-critical-1`, без зміни PROTO7/product version. Після дозволу — actual old/new rejection та saved-match resume mismatch tests. У цій сесії ця зміна **не виконана**. Це не робить old executable безпечним reader нового save: unsupported downgrade/backup policy лишається окремою умовою.
