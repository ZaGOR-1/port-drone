# DEFERRED / ON HOLD — рішення Phase 5 від 2026-11-20

Ця міграція не входить до поточного циклу. Розвиваємо власний Godot PC-порт через beta; matching0.41 dev package/parity не є активною метою або blocker для нашої розробки. Пошук вихідних матеріалів припинений до окремої нової задачі/появи matching sources і прав. Release ZIP не підміняє development project. Історичний аналіз і rollback нижче збережені; старі BLOCKED gates описують лише можливість майбутньої оригінальної міграції. Актуальний напрям — CURRENT_STATE/AGENTS/INTEGRATION_STRATEGY.

---

## Історичний документ / попередній scope (збережено)

# Аналіз release 0.41.4.1 — 2026-11-19, уточнено 2026-11-20

Гілка `codex/migrate-0.41.4.1`, HEAD `af1b4c975564bac916db079d8470c2394d4920e5`. Development checkout залишається0.33.2.3. Мета — перевірити можливість отримати редаговану0.41 основу; готові binaries не підміняють source migration.

20 листопада продовжено source search і перевірено збереження локальних матеріалів. Binary/engine/mount analysis нижче — результати 19 листопада, повторно їх не виконували. Нові raw responses і hash-звірки — `dist/phase3_041/continuation_20261120/`; детальний scope/локальні архіви/потрібний dev package — [MIGRATION_041](MIGRATION_041.md).

## Походження й integrity

Джерело, яке задав користувач: [release frd21313123123/port-drone v0.41.4.1](https://github.com/frd21313123123/port-drone/releases/tag/v0.41.4.1), published2026-11-16T20:18:26Z, release id447561626. Це підтверджений publisher asset; права оригінальних авторів гри окремо не підтверджені. ZIP не є source archive GitHub.

| Перевірка | Факт |
|---|---|
| Asset | `DroneFlames-PC-0.41.4.1.zip`, id756300754,227958581 bytes |
| SHA256 | `c23c413b99bcfc5d4df6dce449978b7ed207bbee174885ff62a433adb4d162b0` |
| GitHub asset.digest | Збігається з обчисленим SHA256 |
| Publisher SHA256SUMS.txt | Завантажений окремий95-byte asset, digest також перевірений; ZIP hash збігається |
| ZIP CRC/path checks | PASS для всіх25 files; абсолютні/parent paths, symlinks, duplicates/case collisions і encrypted ZIP entries не виявлені |
| Розпакований обсяг |477634394 bytes; окремий `dist/phase3_041/release-verified/` |

SHA256 із API і manifest підтверджує відповідність файлу publisher-у, не незалежний підпис authorship чи безпечність усіх executable. EXE/DLL/SO/uninstaller/PLAY.cmd із release **не запускалися і не завантажувалися як бібліотеки**. Виконаний лише попередньо перевірений Godot editor для read-only mount PCK.

Докази: `dist/phase3_041/{release_metadata,download_integrity,repository_metadata,tag_ref_metadata}.json`, `downloads/`, `logs/download_integrity.log`. Release URL/asset IDs/digests зафіксовані; майбутній latest не використовувати як заміну цьому input.

## Що містить ZIP

Один кореневий каталог `DroneFlames-PC-0.41.4.1/`:

- `bin/`:15 files — EXE, окремий PCK,13 Windows DLL. Серед DLL два нові bridge/entry modules, WebRTC і10 CRT runtime files.
- `images/`:3 ELF64 AArch64 Android libraries — game, net, libc++.
- Root: `PLAY.cmd`, `version_info.json`, `app_icon.ico`,2 PORT text files, `unins000.exe/dat`.

PLAY.cmd66 bytes лише змінює cwd на bin і запускає bin/DroneFlames.exe. Він не задає isolated user directory, update policy або тестовий Steam mode. Uninstaller — x86 PE; engine/Windows DLL — AMD64. Наявність x86 uninstaller не перетворює гру на32-bit.

`version_info.json`: version0.41.4.1, update_channel=alpha, update_build_id=beta-0.41.4.1-8, display_stage=Beta, windows_delivery=browser-setup, update_sequence8, data_compatibility=pc34-v1. Останнє — manifest identifier, **не встановлене значення Save.FORMAT**.

PORT credits згадують v0.32.0/v0.31.7, інший launcher filename, plaintext GDScript і99 unlocked cosmetics. У цьому ZIP таких відкритих sources/launcher немає; ці тексти застарілі або непідтверджені для даної збірки. Їх заяви про чистоту/повну відтворюваність не є результатами аудиту.

## Версії та native boundary

| Компонент | Факт / рівень доказу |
|---|---|
| Windows EXE |61139968 bytes; PE fixed file/product version0.41.4.1 |
| Godot engine | У EXE рядок `4.7.2.stable.custom_build` @0x2c40b68; PCK header producer4.7.2. Runtime --version NOT RUN; engine commit/patchset UNKNOWN |
| Game core | `images/libdf_game.android.template_release.arm64.so`,39664864 bytes; self-label `v0.41.4` @0x21310f, exported `df_game_init` |
| Net core | `images/libdf_net.android.template_release.arm64.so`,2422944 bytes; exported `df_net_init`, окремий version number UNKNOWN |
| Windows bridge | `df_game_pc_bridge.dll`,234292736 bytes, exports df_pc_game_init/df_pc_net_init; окрема version metadata відсутня |
| Net entry | `df_net_pc_entry.dll`,20992 bytes; export df_pc_net_proxy_init, reference df_pc_net_init; version UNKNOWN |
| Android runtime | `images/libc++_shared.so`,1374336 bytes; AArch64/NDK runtime, не редагований game source |
| WebRTC |4058112 bytes; **byte-identical** попередньому tracked DLL, SHA256 `3a8053d325a874493f596630b0f165f3a83e265c61d9fd87d82da6cb4c2a81fd` |

Game/net ELF stripped; dynamic symbol tables мають169/57 entries, переважно imports, а не відновлений source. Bridge містить filenames усіх3 images, check EM_AARCH64 і ASCII SHA256, що точно відповідають кожному supplied ELF. Це підтверджує зв'язок комплекту bridge/images. Конкретний механізм виконання ARM64 на Windows (AOT/translation/інший) без source не встановлений; не називати його QEMU/Unicorn за припущенням.

Окремого GodotSteam Windows DLL або steam_api64.dll у зовнішньому ZIP немає. Це не доказ відсутності будь-якої Steam підтримки: новий net module має іншу native boundary, PCK catalog прихований. Steam AppID/handshake не встановлені.

Selected SHA256:

| Файл | SHA256 |
|---|---|
| bin/DroneFlames.exe | `a49117e42828630e0e4e5930b1a99931105402f7b1fb77a887d8495977ca33d3` |
| bin/DroneFlames.pck | `88164f409ea4ee56b385ce6830874e967f00aac12266d0db65062a19199b5dc0` |
| bin/df_game_pc_bridge.dll | `d4d6987f67a2ef38c12a10f86d21a5066a38fadfa87b77c4d6c70e7bd4537320` |
| bin/df_net_pc_entry.dll | `5a2c50306ad65f355212fe1292df67b1c3db60879a3d36c1cef341ead4fb3d9a` |
| images/libdf_game…so | `b343d16e3ee8b80b9f42429af03a5f7d33074df5ebe14c5ebd91026cb724163d` |
| images/libdf_net…so | `de2b93e6eeedba6ca272e498a303bfc206988e531da1287fa0bd06de70398b9d` |

Повні hashes/PE imports/exports/ELF metadata — binary_inventory.json і read-only objdump/readelf logs. Build-machine user paths у selected string reports редаговані; це не вихідні файли проєкту.

## PCK: що встановлено, що недоступно

PCK128402668 bytes, magic GDPC, format4, producer4.7.2, flags3: PACK_DIR_ENCRYPTED + PACK_REL_FILEBASE, sparse=false. File base112, directory offset128340176; перед encrypted directory оголошено693 entries. Це **declared count**, не успішний пофайловий inventory. Flag не доводить encryption кожного payload — file flags недоступні.

Структура звірена з [Godot4.7.2 file_access_pack.cpp](https://github.com/godotengine/godot/blob/4.7.2-stable/core/io/file_access_pack.cpp) та [PackFlags](https://github.com/godotengine/godot/blob/4.7.2-stable/core/io/file_access_pack.h). Штатний [load_resource_pack](https://github.com/godotengine/godot-docs/blob/4.7/tutorials/export/exporting_pcks.rst) викликано з trusted isolated project, replace_files=false; ніякі release scenes/scripts/native extensions не load/instantiate.

**FAIL mount, exit2:** `Can't open encrypted pack directory`, decrypted MD5 mismatch. Підтверджено encrypted index і відмову stock editor без release key; повідомлення саме по собі не доводить пошкодження publisher ZIP. ZIP identity/CRC окремо PASS. PCK inspection/extraction — **BLOCKED**. Ключ не надано; додаткових дій для його отримання не проводили.

Тому для внутрішніх `.gd/.gdc/.tscn/.scn/.tres/.godot/.gdextension`, imports, assets і locale **UNKNOWN**, а не «відсутні». Зовнішній ZIP справді не містить жодного `.gd/.gdc/.cpp/.h/.hpp/.tscn/.gdextension/.godot/.lua`; але це інший scope. Поточний `gdc2gd.py` читає tokenizer101, не native ELF/PE; підстав застосовувати його до невідомого прихованого GDC немає. Сторонні decompilers/dependencies не встановлювали.

## Чи це тільки зміна номера

**Підтверджено іншу binary implementation/integration:** custom engine, нові bridge DLL, ARM64 game/net cores, encrypted separate PCK. Game core містить187 native `src/...cpp` paths, net core15. Це текстові references, не187/15 наданих C++ files. У game module є ContentDB, Seasons, Airborne, Arms356, Transit356, CityBuilder/ModEditor/ScenarioEditor — ці точні identifiers відсутні у старих GDScript texts. SaveSlots не називаємо новою механікою: старий source уже використовує цей preload alias.

Цього достатньо відхилити твердження «той самий old EXE, лише перейменований manifest». Але відповідність усіх механік заявленій0.41, formulas/balance/replay/save/net compatibility **не доведена**. Докладне порівняння з confidence — [VERSION_041_DIFF](VERSION_041_DIFF.md).

## Source availability та права

Release tag і remote main вказують на **той самий af1b4c9**, що й локальна0.33 база. Recursive tag tree має881 blobs, усі Git blob SHA точно збігаються з checkout. Автоматичний GitHub Source code archive цього tag тому не є новим0.41 source.

Перевірені всі10 публічних branch trees, без truncation: native/, lua/, C++ headers/sources/build manifests для supplied modules і license files не знайдені. Це висновок про заданий public repository/ZIP на дату аудиту, не твердження, що ніде не існує private source. GitHub repository license=null; README залишає code/art rights оригінальним авторам closed-beta APK. Підтвердження дозволу на локальну адаптацію ще не отримано; користувачу поставлено окреме фактичне запитання за його умовою Phase3§5.

**Редаговану основу0.41 із наданих матеріалів не отримано; самостійну еквівалентну source build не виконано.** Отримання ключа/nonencrypted PCK саме по собі не поверне C++ implementations, custom engine/bridge toolchain або права. Вимоги й варіанти — [MIGRATION_041](MIGRATION_041.md).

## Продовження пошуку — 2026-11-20

- Public REST API: усі 10 publisher heads збігаються з учорашніми, 12 tags/12 releases без нового dev asset; main/tag 0.41.4.1 — af1b4c9. 28 commits main є локально; path scan їхніх trees не знайшов native C++/Lua implementations/build inputs. Старі branch trees повторно не скачували. Public gists — 0; metadata 38 public repos не показали іншого явно позначеного DroneFlames dev repository. Це не пошук у приватних repos.
- Власний [ZaGOR-1 fork](https://github.com/ZaGOR-1/port-drone/branches): знайдено 12 public branches, зокрема додаткові beta-phase*/beta-step*. 10 distinct додаткових recursive trees без truncation не містять matching native sources. У всіх 12 version.cfg значення 0.33.2.3. Гілки мають власні GDScript зміни; semantic review/tests не виконували, відповідність 0.41 не встановлена. Не fetch/checkout/merge.
- [Credited port](https://github.com/makkaX2/DroneFlames-PC-Port): master/test trees 2122/2165 blobs; manifests 0.33.5.38 і 0.33.5.52-test із base_upstream_version 0.33.4. Переглянуті README/build.py/workflow/version metadata не надали matching custom engine/game/net/bridge inputs. 74 public tags/releases не містять 0.41; окремо названого source/SDK asset не знайдено. Mods repository не містить потрібного native source package. Нічого з цих матеріалів до game/ не переносили.
- Windows Downloads `port-drone-0.41.4.1.zip` і `port-drone-main.zip` — по 881/881 файлу byte-identical rollback 0.33. Два runtime ZIP — hash c23c413b…d162b0. Два 29-file Codex Development Pack ZIP — documentation/tools overlay, без game code/assets за власним manifest. Новий dev package не знайдений.
- Локальні 881 tracked/123 Phase2/25 extracted release SHA256 звірено PASS; bundle verify exit0 і tar catalogs доступні. Шифрування не обходили, нові binaries не виконували. Відсутні вчорашні aggregate validation.json/validation.log зафіксовано в MIGRATION_041/TEST_MATRIX; сьогоднішня integrity перевірка зберігається окремо.

Висновок залишається обмеженим перевіреними public джерелами й конкретними локальними шляхами. Отримати project у правовласника — можливий наступний організаційний крок; його готовність надати package невідома. Контакти і точний запит підготовлені в MIGRATION_041; повідомлень їм не надсилали.
