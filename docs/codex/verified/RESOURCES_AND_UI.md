## Поточний маршрут HUD та ресурсів

[Hud](../../../game/ui/hud.gd) і його `extends` визначають ownership контролів. [main_input.gd](../../../game/game/main/main_input.gd) визначає world input, [PcPort](../../../game/pc/pc_port.gd) — масштаб і desktop preferences. Перед зміною перевір сигнали, ownership wheel/gesture, видимість і focus, а також локалізацію та фізичний Windows GUI у сценаріях за scope. [Потоки](ARCHITECTURE_AND_FLOWS.md) · [Fixtures](../../DEVELOPMENT_WORKFLOW.md#перевірки-за-scope) · [Windows QA](../../WINDOWS_QA.md)

Для ресурсів звір tracked remaps і imports. У checkout є binary сцени та імпортовані ресурси в `game/.godot/`. Інструменти, що оновлюють imports/UID, запускай у фізичній копії. [Правила](../../../AGENTS.md)

## Історична карта ресурсів Phase 2

# Ресурси, presentation і desktop UX

Карта на `af1b4c9`, 2026-11-19. Phase2 виконав engine file reads, scene instantiate і headless startup; GPU shader compilation, audio/video playback і GUI **NOT RUN**. Точне ручне покриття — FILE_COVERAGE; поточні runtime результати — RUNTIME_BASELINE.

## Resource graph

`res://` відповідає `game/`. 209 `.import` — UTF-8 text із кінцевим NUL; шлях `path=` веде на збережений `.godot/imported/*` resource. Є1 main-scene `.remap`; 210/210 цілей існують. Більшість оригінальних PNG/OGG/MP3/font-файлів відсутня, але `.import` і compiled resources наявні. Видалення `.godot/` може знищити єдину tracked runtime-копію.

Розв'язання901 occurrence `res://` у тексті game/ (з повторами):767 direct,95 import/remap,21 missing native platform candidates,4 prefix/dynamic,4 missing candidates. Це інша метрика, ніж863 deduplicated tokens базового auditor, який пропускає текст деяких розширень і інакше класифікує import.

Чотири missing candidates: optional `atlas_fx7.png/json` (`GameWorld._ready:28`, helper SpriteAtlas.load_atlas має placeholder) і dev scripts `res://dev/net_autotest.gd`, `res://dev/mp_shots.gd` (`Main._ready:70`). Інші asset templates й динамічні filenames не можна вичерпно перевірити regex. `uid://` references та binary uid cache — окреме runtime питання; `.uid` tracked немає.

## JSON, атласи, palette, відео

Усі86 JSON декодовані. 81 sprite descriptor містить3686 sprite entries;3651 entries мають rect+declared atlas size, жодного out-of-bounds за формулою x+w×frames,y+h не знайдено. Решта35 не мали повного набору даних для цієї перевірки. Це не валідація pixel content, правильності anchors/frame order чи фактичного texture size.

`core/sprite_atlas.gd::load_atlas` звіряє ResourceLoader.exists(png_path), JSON file existence і за наявності size порівнює Texture2D size. `.ctex` не прочитані як PNG; 89 compressed texture files залишаються METADATA. Палети — `assets/palettes/main_named.json`, `terrain19.json`, `terrain_colors.json`; runtime lookup у Palette/terrain layers. `ui/cosmetics.json` — окремі cosmetic definitions.

`assets/video/tutorial/tutorial_clips.json`:22 clips, мовиru/uk/en, fallbackru, metadata size540×960/fps30; усі66 локалізованих file refs наявні. Це відповідність manifest і файлів, а не перевірка тривалості/кодека/змісту роликів. Усього67 `.ogv` включно з opening; найбільший `opening.ogv`7584379 bytes. Не виводити сюжет/якість відео з імені.

Бінарний тип встановлено libmagic для всіх283 files; хеші/bytes кожного — FILE_COVERAGE, локально `binary_types.txt`. Навіть якщо libmagic називає .scn «National Instruments», фактичне magic RSRC/PackedScene перевірене окремо; тип libmagic не є source semantics.

## Native boundary

| DLL | Bytes | SHA256 |
|---|---:|---|
| `libs/libgodotsteam.windows.template_release.x86_64.dll` |3980800|`6535af56d325af0fff52dbb5de3703d110bb430fdef4e3026d7ece617270e530`|
| `libs/libwebrtc_native.windows.template_release.x86_64.dll` |4058112|`3a8053d325a874493f596630b0f165f3a83e265c61d9fd87d82da6cb4c2a81fd`|
| `libs/steam_api64.dll` |319128|`8de54d32508e216c9135b8bf025749243d44e404c1c22a8e5fe35acecabe7a9c`|

PE headers усіхтрьох мають signature PE і machine0x8664(AMD64). Це не доказ ABI compatibility, відсутності шкідливого коду, Authenticode signature чи точного SDK revision.

Phase2 Windows release процес реально завантажив усі3 DLL із локального test folder, без extension-load errors. Це звужує ABI uncertainty до неперевірених функцій/transport flows; реальний Steam/API/WebRTC peer ще NOT RUN. Linux binaries не надані — native checks BLOCKED, помилки лишені в logs. DLL не змінювалися.

Активний `.godot/extension_list.cfg` включає WebRTC/GodotSteam descriptors. DFDevice descriptor також існує, але до цього списку не входить і Windows targets не має. Compatibility minimum descriptors: WebRTC4.3, GodotSteam4.4, DFDevice4.5; це декларації, не перевірені SDK/build manifests. Linux/debug/native counterparts не надані; startup resolution DLL із теки EXE потребує release smoke. [Офіційні правила GDExtension4.7](https://github.com/godotengine/godot-docs/blob/4.7/engine_details/engine_api/gdextension/gdextension_file.rst) звірені через Context7; descriptors використовують feature tags і relative/res paths.

## UI і ввід

Hud має довгий extends-chain; Menus4307 lines, UI24 — sheets/docks для army/navy/economy/diplomacy/fronts/trade/notifications/tutorial. Вони будуються GDScript-ом, не великою кількістю текстових scenes. Main.mode enum визначає placement/strike/movement/select states; BUILD_KEYS/BUILD_KIND маплять UI names у facility ordinal. RouteOverlay, PendingGhost, FrontOverlay/StrikeMarks — частина planning feedback.

`PcPort`: desktop OS guard, minimum960×540, збереження fullscreen/window rectangle, default desktop UI90%, scale choices70/80/90/100/115/130%. Landscape визначається width>1.15×height; sheet width=clamp(width×0.5,440,640) за достатньої ширини, centered. F11/Alt+Enter fullscreen; Ctrl+/−/0 scale; Main додає wheel zoom, arrows, RMB/middle pan/cancel, PC ArmySelect selection. Visual correctness і shortcut conflicts NOT RUN.

Друга шкала `GameConfig.UI_SCALES=[0.8,0.85,0.9,0.95,1]` застосовується Save.apply_ui_scale після prefs load і змінює той самий root content_scale_factor. Precedence/перезапуск — test caseR12. Save.apply_ui_scale також змінює MapCamera.ui_k; PcPort._apply_scale прямо не викликає цей API. Не стверджувати наперед, що обидва controls узгоджені.

MapCamera: zoom levels0.25/0.5/1/2/3/4 із ui_k, strategic floor залежить від map size/free viewport і clamp0.01…0.17; conversion screen/world, margins, pixel snap, rubber bounds, dive/settle/shake. Render layers використовують culling/zoom thresholds, chunks/LOD і shader textures; ці presentation optimizations не є виміряною продуктивністю цього запуску.

## Локалізація й audio

Loc: ru source, uk/en/es, TranslationServer, contexts/plural handling, message recipes, named/printf args, source cache, transliteration names, pseudo expansion30%; env DF_LANG/DF_PSEUDO і CLI --lang/--pseudo. Loc.bus.changed і i18n group викликають relocalize. GameConfig.lang зберігається в settings.cfg; first-run LangPicker, потім Opening.

PO structural parser обійшов усі entries й не знайшов duplicate context/msgid. Non-header untranslated entries: EN222/6606, UK244/6615, ES4284/4367, RU0/22. RU source passthrough означає, що мала RU PO сама по собі не проблема. Число entries не дорівнює повному coverage видимих UI strings. Spanish fallback/частина strings змішуватиметься із source; потрібен language QA. Автоматичні printf-кандидати з `% of/% each` відсіяні як непідтверджені formatting bugs.

Phase2 поглиблення bootstrap: `LangPicker.SHOW_ES=false`, `langs()` за замовчуванням повертає лише ru/uk/en; ES є в Loc/PO, але прихований зі звичайного picker. `LangPicker.needed` і `Opening.should_autoplay` пропускають headless/відповідні env/CLI overrides. Тому headless startup не тестує first-language екран чи intro. Opening239 і LangPicker505 lines тепер FULL; UI selection/video playback лишаються ручними checklist cases.

Sfx — runtime-created Node із voice pools, rules/category caps, music crossfade, distance/pan/zoom/fog attenuation і shared settings.cfg. AIR_SFX/NAVY_SFX/Soundscape читають світ для presentation. Не робити висновок про audio content із114 `.oggvorbisstr` і2 `.mp3str`; звук не прослуховувався. Thread boundaries: save/write worker; road/path jobs; Menus preview WorkerThreadPool із main-thread completion handling. GUI nodes/Texture2D не переносити в worker без цільової перевірки.

`TerrainView::_run:239` ділить bake на16 bands, використовує1…8 threads і синхронно чекає завершення group task. Після збирання band bytes `build:232` створює Image/ImageTexture й присвоює texture на викликаючому потоці; паралельний bake не означає, що весь startup неблокувальний. У Main satellite action має явну заборону для MP (`main.gd:933`); parity SP/MP слід перевіряти по кожній механіці.
