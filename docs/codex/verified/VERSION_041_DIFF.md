# DEFERRED / ON HOLD — рішення Phase 5 від 2026-11-20

Ця міграція не входить до поточного циклу. Розвиваємо власний Godot PC-порт через beta; matching0.41 dev package/parity не є активною метою або blocker для нашої розробки. Пошук вихідних матеріалів припинений до окремої нової задачі/появи matching sources і прав. Release ZIP не підміняє development project. Історичний аналіз і rollback нижче збережені; старі BLOCKED gates описують лише можливість майбутньої оригінальної міграції. Актуальний напрям — CURRENT_STATE/AGENTS/INTEGRATION_STRATEGY.

---

## Історичний документ / попередній scope (збережено)

# Порівняння 0.33.2.3 і release 0.41.4.1

На2026-11-19. Old source — af1b4c9,881 tracked files, Phase2 runtime baseline. New input — ZIP SHA256 `c23c413b99bcfc5d4df6dce449978b7ed207bbee174885ff62a433adb4d162b0`. New PCK catalog encrypted; executable/native code не запускали.

Уточнення 2026-11-20: цей binary/source comparison збережений без повторного запуску. Продовження пошуку не дало matching dev sources: локальний `port-drone-0.41.4.1.zip` має ті самі 881 baseline files, власні beta-гілки лишають version 0.33.2.3, credited community port — base 0.33.4. Назви гілок/механік не встановлюють functional equivalence із native release 0.41. Нові discovery evidence і capability gates — [MIGRATION_041](MIGRATION_041.md).

Позначки: **CONFIRMED** — bytes/header/файл/read-only tool result; **SYMBOLIC** — native string/source-unit/class references, поведінка не перевірена; **UNKNOWN** — немає source або runtime evidence. Binary string не є specification чи control-flow proof. Native offsets/повні списки — `dist/phase3_041/binary_string_evidence.csv`, `static_comparison.json`.

## Системи гри

| Напрям |0.33 перевірена основа |0.41 evidence | Що можна стверджувати |
|---|---|---|---|
| Симуляція / час / RNG |GameWorld GDScript; SP adaptive dt, MP1/30×3, Cad344, власні RNG |Native GameWorld @0x258166; src/world_core/*.cpp, entities/cad344.cpp |SYMBOLIC перенесення/інша реалізація core; tick order/RNG/speed equivalence UNKNOWN |
| Країни / сутності |Country/City/Facility/Unit fields, enums і references доступні |Native systems зберігають country/city references за identifiers; schema в PCK/native прихована |Нові entity fields/IDs/enum ordinals UNKNOWN; старі моделі не копіювати автоматично |
| Економіка / логістика |Economy production10s/trade16s, warehouses, Rail/Supply |Economy @0x216c76; economy_core/nav.cpp, arms356.cpp, transit356.cpp, rail_man/trains.cpp; Arms356/Transit356 без старих точних names |SYMBOLIC додаткові компоненти; formula/cost/storage/production balance changes UNKNOWN |
| Дипломатія |PEACE/WAR/TRUCE/ALLIANCE, treaties/subjects/coalitions |Diplomacy @0x234a4b; sim_dip/diplomacy.cpp, dip_requests/react, peace_conf; ui_hud/dip_page_nuke.cpp |Native implementation references CONFIRMED, treaty/AI decisions і правила нових політик UNKNOWN |
| Армія |10 Unit types, Army/Fire/Tac/Groups |sim_mil/army*.cpp, army_water/posts/war; Airborne @0x2c9d67, old scripts exact-name absent |SYMBOLIC новий Airborne компонент; unit roster/stats/capture rules UNKNOWN |
| Авіація |Air/GDScript,4 aircraft classes |air.cpp, air_kab.cpp, air_strike.cpp; atlas_air388/388p references |SYMBOLIC нові source/asset references; aircraft abilities/навантаження/баланс UNKNOWN |
| Флот / десант |Naval/Navy/Ship, окремий sea navigation |Naval @0x28d502; sim_mil/naval/navy/navy_strike.cpp |Є native counterparts; ship models/combat/nav behavior delta UNKNOWN |
| БПЛА / ракети / ППО |Military/Drone/Missile/Defense/Nuclear source |military/mil_*/drone_brain/defense/nuclear/nuke380.cpp |SYMBOLIC ширша native decomposition; damage/ranges/interception probabilities і нова ядерна механіка UNKNOWN |
| AI |AiBots/personas,8 think phases, Cad budget |AiBots @0x24b32e, src/sim_dip/ai.cpp; diagnostic AiBots.cmp |Native AI implementation references; strategy/difficulty/income/scheduling equivalence UNKNOWN |
| Генерація карти |WorldGen/WorldGen2, packed terrain/ownership, gen_version2 |worldgen/map_gen/world_gen/world_gen2/world_data.cpp; редактори карт/scenario source-unit names |SYMBOLIC нові editing-related components; seed compatibility/river algorithm/map serialization UNKNOWN |
| Рендеринг / пори року |TerrainView/chunks/strategic layers,8 shader sources |Seasons @0x23b16a; render/seasons.cpp/night_far.cpp; seasons385 palette/atlas references |SYMBOLIC seasons-related code/data references absent old source names; візуальний ефект/якість/GPU runtime UNKNOWN |
| UI / редактори / моддинг |HUD/Menus/UI24 GDScript |ContentDB @0x1f76f2, CityBuilder @0x2588fe, ModEditor @0x239c66, ScenarioEditor @0x2aa2ec; editor/*.cpp, mods/map_pack/mod_package.cpp, ui_menu/workshop*.cpp |Нові identifiers/native source references CONFIRMED; доступний редактор, Lua API/SDK і функціональний workshop UNKNOWN |
| Графічні ресурси |86 JSON,89 ctex, відкриті atlas metadata/import mappings |27 new asset-reference candidates, зокрема atlas_farm385/395, air388, r380, ui370/ws; actual data у locked PCK |Asset references відрізняються; наявність/байти/пікселі цих assets UNKNOWN |
| Audio |114 oggvorbisstr/2 mp3str, Sfx/music code |Music/sfx path templates у native core, payload inventory недоступний |Нові композиції/ефекти/codecs/audio behavior НЕ підтверджені |
| Локалізація |ru/uk/en/es PO, SHOW_ES=false у picker |Loc/native source; NotoKufiArabic400/700 references, яких немає у старих res tokens |Нові font references CONFIRMED; Arabic/інші переклади, повнота catalogs і GUI coverage UNKNOWN |
| Save/load |DFS1/FORMAT1, entity graph+ZSTD/MD5;7 synthetic Phase2 checks |src/app/save/save_slots.cpp, FORMAT @0x205e61, user://match.save @0x27ca59; manifest data_compatibility=pc34-v1 |Назви/namespace markers є; numeric FORMAT/header/codec/migrations UNKNOWN. FORMAT1 не переносити |
| Multiplayer |NetSession GDScript, protocol7, host lockstep/rejoin/resync |Окремий native net ELF,15 src/*.cpp paths incl net_session_loop/sync/resume; PROTO @0x2695f |Інша implementation boundary; numeric protocol/tick/packet/authority/reconnect compatibility UNKNOWN. Protocol7 не переносити |
| Windows / dependencies |Official4.7.2.ed1daf0bf template+embedded PCK; PcPort/SteamNet/updater |Custom4.7.2 engine, separate encrypted PCK, bridge DLL+ARM64 images+CRT; WebRTC byte-identical |CONFIRMED delivery/runtime differences; native ABI/calls та збереження старих PC UX features не перевірені |

Source-unit paths у таблиці — embedded strings, **не надані файли**. New identifiers означають більше, ніж manifest version, але не доводять доступність усіх можливостей гравцю. Зокрема presence nuke380/Seasons/Workshop не використовується для вигаданого опису gameplay.

## Прямі порівняння bytes і delivery

| Об'єкт |0.33 Phase2 |0.41 ZIP | Висновок |
|---|---:|---:|---|
| EXE bytes |214642580 з PCK усередині |61139968, PCK окремо |Інший спосіб доставки; size сам не є порівнянням gameplay code |
| PCK bytes |105374088 |128402668 |Hashes різні, catalog/content equivalence не доведена |
| PCK format / producer |4 /4.7.2 |4 /4.7.2 |Version-family збігається; це не гарантія custom engine/game ABI |
| PCK flags |2, directory відкритий |3, directory encrypted |Old863 hashes доступні; new693 лише declared count |
| Public source tag tree |881 blobs af1b4c9 |Ті самі881 blob SHA |Tag source не оновлений до supplied native build |
| Windows game/net bridge |Немає |234292736 /20992 bytes |Нові binary components |
| ARM64 game/net/libc++ images |Немає в старій PC runtime |3 файли, bridge містить matching SHA |Новий dependency contract; потрібні ці exact components |
| WebRTC DLL |4058112 bytes |Ті самі bytes/SHA |Один підтверджений reuse candidate; peer interoperability не перевірена |
| GodotSteam/steam_api64 |2 зовнішні DLL |У outer ZIP відсутні |Стару Steam integration не можна просто скопіювати; Steam absence загалом не доведено |
| Update delivery |Single EXE swap+libs ZIP |Folder ZIP; browser-setup manifest |Old updater release contract несумісний з new packaging; це зазначає і publisher |

## Сумісність

- **Saves:** UNKNOWN. Старі приватні saves не відкривали новим release; shared filename не доводить schema compatibility. Потрібні schema/version docs і synthetic fixtures для обох версій.
- **Мережа:** UNKNOWN. Номер PROTO не отримано; cross-version peers не запускали. Саме число version_info не є handshake specification.
- **PC UI/input:** UNKNOWN для0.41. PcPort/SteamNet/main paths старої бази доступні для аналізу, але новий SceneTree/native bindings/config приховані; transplant без dependency analysis не виконано.
- **Build:** поточні build.py/pack.gd можуть відтворити0.33. Native game/net/bridge/custom-engine sources і encrypted resource project для0.41 не отримані. Зміна --version на0.41 лише перейменувала б стару гру.
- **Функціональна еквівалентність:** NOT RUN. Немає власної source-built0.41 для чесного порівняння з publisher binary.

Вихід: **інший native runtime підтверджений; повний semantic diff і редагована0.41 основа BLOCKED**. План подальших дій — [MIGRATION_041](MIGRATION_041.md).
