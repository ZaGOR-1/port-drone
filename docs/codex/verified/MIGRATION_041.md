# DEFERRED / ON HOLD — рішення Phase 5 від 2026-11-20

Ця міграція не входить до поточного циклу. Розвиваємо власний Godot PC-порт через beta; matching0.41 dev package/parity не є активною метою або blocker для нашої розробки. Пошук вихідних матеріалів припинений до окремої нової задачі/появи matching sources і прав. Release ZIP не підміняє development project. Історичний аналіз і rollback нижче збережені; старі BLOCKED gates описують лише можливість майбутньої оригінальної міграції. Актуальний напрям — CURRENT_STATE/AGENTS/INTEGRATION_STRATEGY.

---

## Історичний документ / попередній scope (збережено)

# Міграція до 0.41.4.1 — checkpoint і gates

Оновлено 2026-11-20 після продовження перерваної сесії. Branch `codex/migrate-0.41.4.1`, HEAD/main `af1b4c975564bac916db079d8470c2394d4920e5`. **Release analysis і розширений пошук виконані; повного доступного dev-пакета не знайдено, заміна development основи на 0.41 BLOCKED.** Поточний game/ залишається перевіреною 0.33.2.3; номер 0.41 не підставляли у старі scripts/build.

## Що виконано 19 листопада

1. Прочитано AGENTS/verified context, перевірено Git status; попередній untracked overlay збережений. Створено окрему migration branch, main ref незмінний.
2. Повний tracked rollback: `dist/phase3_041/rollback/repository-main.bundle` (complete main history, bundle verify PASS), `tracked-033.tar.gz` (881 files), `tracked_hashes.json`. Verified Phase2 docs скопійовані в `verified-phase2.tar.gz`.
3. Усі123 наявні Phase2 artifacts залишені на місці, їх SHA256 записані в `phase2_artifact_hashes.json`. Старі runtime logs/checkpoint/build не перезаписані. Нові analysis/helpers/downloads тільки в окремому ignored `dist/phase3_041/` і verified docs.
4. Отримано publisher ZIP/manifest, перевірено API/publisher/local hashes,25 ZIP CRC та paths; extracted окремо. Binaries/launcher не виконувалися.
5. Штатним verified Godot4.7.2 виконано read-only PCK mount; encrypted directory недоступний, exit2/error log збережені. Release code не load/instantiate.
6. Виконано static PE/ELF/version/export/import/string comparison, old/new WebRTC identity, tag tree881/881 і всі10 public branch tree checks.
7. Сформовано VERSION_041_ANALYSIS/DIFF і цей plan. Game code/resources/protocol/save formats/DLL/CI не змінювали; commit/push/tag/release/workflow не виконували.

## Продовження 20 листопада: стан і джерела

Прочитані всі шість документів із запиту; відсутніх серед них немає. Звірка з rollback manifest підтвердила 881/881 tracked bytes і 123/123 Phase2 artifact hashes. Bundle verify exit0; tar-каталоги містять 881 tracked files і 18 Phase2 documents. ZIP SHA256 `c23c413b…d162b0` та 25 extracted file hashes незмінні. Це перевірки збереження матеріалів після перерви; regression/benchmark/engine fetch/PCK mount не повторювали.

| Джерело | Що перевірено | Результат для 0.41.4.1 |
|---|---|---|
| [Publisher repository](https://github.com/frd21313123123/port-drone) | Поточні 10 branch heads, 12 tags, 12 releases, 28 commits main, 7 issue/PR records; public gists — 0 | Heads збігаються з учорашніми; дерева повторно не скачували. Тег 0.41.4.1 і main — af1b4c9. У доступній локальній історії немає native C++/Lua/build-source package |
| [Release 0.41.4.1](https://github.com/frd21313123123/port-drone/releases/tag/v0.41.4.1) | Metadata/body/assets зіставлено з учорашніми | Два publisher assets: Windows runtime ZIP і SHA256SUMS; окремого dev/source asset немає. GitHub Source code archive прив'язаний до старого commit |
| Інші public repos publisher | Metadata 38 repositories | Додаткового репозиторію, позначеного як DroneFlames game/net dev source, не виявлено. Вміст усіх 38 сторонніх проєктів не аудіювали |
| [Власний fork](https://github.com/ZaGOR-1/port-drone/branches) | 12 branches, 0 tags/releases; 10 нових для цього аудиту recursive trees без truncation, 12 version.cfg | main/beta — af1b4c9; beta-phase*/beta-step* мають 880–903 blobs, version 0.33.2.3, без native sources релізу 0.41. Ці гілки не є перевіреною міграцією; їхню поведінку/compatibility не тестували |
| [Credited community port](https://github.com/makkaX2/DroneFlames-PC-Port) | master/test trees 2122/2165 blobs без truncation; README/build.py/workflow/version manifests; 74 tags/releases | Manifests: 0.33.5.38 / 0.33.5.52-test, base_upstream_version 0.33.4. Немає C++ game/net sources, release 0.41 або окремо названого source/SDK asset. Це не matching dev package |
| [Mods repository](https://github.com/makkaX2/DroneFlames-Mods) | Tree 126 blobs, без truncation | Mod packages не замінюють engine/game/net sources; файлів до checkout не переносили |
| Публічний web/GitHub repository search | DroneFlames, точна версія, publisher, native/source | Matching dev package не знайдений. Інші неатрибутовані community/mod repos не використовували як source; відсутність у пошуку не доводить глобальну відсутність private code |

Додаткові гілки власного fork: `beta-phase0-tooling-quickwins`, `beta-phase1-render-opt`, `beta-phase2-sim-perf`, `beta-phase3-steam-lan-and-ui`, `beta-step1-qol-and-systems`, `beta-step2-nukes-and-zaslon`, `beta-step3-carriers-and-airborne`, `beta-step4-seasons-ideology-flags`, `beta-step5-chronicle-and-territory`, `beta-step6-nukes-pc-perf`. Пошук metadata не є review їхньої реалізації. Локальні refs/main не змінені; fetch/checkout/merge цих гілок не виконували.

### Локальні матеріали

Додатково перевірено project checkout і DroneFlames/port-drone назви у Windows Downloads/Desktop/Documents та Ubuntu Downloads (останній каталог відсутній). Це обмежений пошук, не сканування всіх дисків або приватних даних. У знайдених ZIP читали каталог/вміст без запуску й без extraction поверх checkout.

| Матеріал | Наявний вміст і призначення |
|---|---|
| `game/`, `tools/`, `tests/`, `libs/` | Редагований порт 0.33.2.3 і його збірка/тести; не source 0.41 |
| `dist/phase2_baseline/` | Збережені working Windows build, engine integrity, logs/checkpoints і synthetic test evidence 0.33 |
| `dist/phase3_041/rollback/` | Git bundle, tracked tar, Phase2 docs tar і hash manifests; нічого не відновлювали поверх checkout |
| `dist/phase3_041/downloads/` і `release-verified/` | Publisher ZIP/manifest та 25 release files: EXE, encrypted PCK, DLL, ARM64 images, launcher/metadata. Source project тут не наданий |
| Windows Downloads `DroneFlames-PC-0.41.4.1.zip` і `… (1).zip` | По 227958581 bytes, обидва SHA256 c23c413b…d162b0 — копії того самого runtime release |
| Windows Downloads `port-drone-0.41.4.1.zip`, `port-drone-main.zip` | По 881 файлу, 881/881 contents SHA256 збігаються з rollback 0.33; назва архіву не встановлює версію source |
| Windows Downloads `DroneFlames_Codex_Development_Pack.zip` і `… (1).zip` | Однакові 50934-byte ZIP, по 29 files; documentation/prompts/audit tools/tests. Власний DEVELOPMENT_PACK_MANIFEST прямо виключає game code/assets. Це не game dev package |
| Windows Desktop `DroneFlames-PC-0.41.4.1/` | Видимий outer release layout bin/images/PLAY/version_info; внутрішній source project не отриманий, binaries не запускали. Повну hash-звірку саме Desktop-копії не робили |
| Windows Downloads `DroneFlames_PC_Beta_Setup_v0.41.4.3_droneflamesmod.exe` | Лише знайдена назва installer іншої версії. Походження/вміст не підтверджували, не виконували й не використовували як 0.41.4.1 input |

Raw evidence: `dist/phase3_041/continuation_20261120/{preflight,integrity,local_materials,local_history,backup_catalogs,fork_versions,source_search_summary}.json` та `github/`. API queries мають timestamps і saved JSON; первинний запит до GitHub tags/profile через web мав обмеження fetch, для цих даних використано успішний public REST API. Після server restart використано збережені responses; незаписаний aggregate transport log не видається за виконаний.

Вчорашні `dist/phase3_041/validation.json` і `logs/validation.log`, на які посилалася TEST_MATRIX, **відсутні**. Окремі первинні evidence файли існують; сьогоднішній integrity report і фінальний continuation validator зберігаються під новими шляхами. Старі PASS не перейменовуються в нові результати.

## Чи достатньо матеріалів для розробки 0.41

| Потреба | Статус | Чого бракує |
|---|---|---|
| Редагувати ігрову логіку | BLOCKED | Реальні game/net implementation sources; PE/ELF strings не є редагованим кодом |
| Міняти сцени й ресурси | BLOCKED | Project/settings/scenes і відкриті resource inputs; encrypted PCK catalog недоступний |
| Додавати нові механіки | BLOCKED | Game APIs/data definitions/simulation sources і build/test path; mod SDK для exact release не знайдено |
| Самостійно збирати Windows x64 | BLOCKED | Matching custom engine/native/bridge sources, bindings, dependencies/toolchain і export settings |
| Підтримувати multiplayer і saves | UNKNOWN compatibility / BLOCKED implementation | Фактичні schemas, codecs, protocol/authority/tick contracts, migration rules і fixtures |
| Автоматизовано тестувати власні зміни | BLOCKED для game behavior | Source-built runtime/editor bindings і test entrypoints/golden scenarios. Перевірки hashes/ZIP можливі вже зараз, але не перевіряють нові mechanics |

Готовий release потенційно можна використовувати як reference для запуску; у цьому аудиті його runtime NOT RUN. Повноцінний редагований проєкт 0.41.4.1 не отриманий. Не встановлено, що будь-який довільний source із номером 0.41 відповідає саме цьому release.

## Gates міграції

| Gate | Стан | Що потрібно |
|---|---|---|
| Publisher artifact identity | PASS |ZIP SHA c23c413b…d162b0, manifest/API match |
| Rollback0.33 / Phase2 preservation | PASS |Bundle/tar/hashes, main і tracked bytes незмінні |
| Право локальної адаптації code/art0.41 | UNKNOWN / не підтверджено |Підтвердження власника/користувача щодо конкретних матеріалів; public URL не є license grant. Запит поставлено, мовчання не є відповіддю |
| Повні редаговані game/net sources | BLOCKED |Немає source для ARM64 game/net implementations;187/15 cpp paths у strings не є файлами |
| Project/resource catalog і editable configuration | BLOCKED |Encrypted PCK index; key/nonencrypted dev export/project не надані |
| Custom engine/bridge build provenance | BLOCKED |Немає matching patchset/build scripts/toolchain для custom engine/bridge/net proxy |
| Save/protocol compatibility | UNKNOWN |Фактичні FORMAT/PROTO/codec/schema/migration/replay specs та fixtures |
| Власна source-built0.41 Windows build | BLOCKED |Попередні source/build gates не виконані |
| Функціональна equivalence із publisher build | NOT RUN |Потрібна відтворена build, isolated Windows/runtime test matrix |

Немає твердження «права заборонені»: їх не підтверджено. Навіть якщо дозвіл буде підтверджений, source/resource/build gates залишаються незалежними. Попередній план міграції передбачав виконання цих умов; поточний запит від 20 листопада дозволяє пошук і документацію та прямо забороняє production code changes. Реалізація після отримання package потребуватиме окремого дозволеного scope.

## Чого бракує для повної development основи

Запитаний dev package має відповідати саме game image SHA `b343d16e…24163d`, net image `de2b93e6…98b9d` та release0.41.4.1/build beta-0.41.4.1-8, а не довільній0.41 папці:

- Game/net C++ source, headers/generated bindings, content definitions; відповідні native/df_game і native/df_net trees.
- Project settings, startup scenes, GDExtension descriptors, усі GDScript/Lua files за наявності, import mappings і редаговані asset/catalog/locale inputs із provenance.
- Дозволений nonencrypted dev PCK або project/resources і офіційно наданий доступ до catalog. Доступ до PCK не замінює native implementation sources.
- Godot custom_build patchset/commit/config, matching export template build; ключ або незашифрований development export за потреби, без запису секретів у docs/logs.
- Windows bridge/net proxy source або підтримуваний SDK/ABI з правами на використання; toolchain/build scripts, NDK/godot-cpp revisions, image hash generation/activation contract. Для повної відтворюваності потрібні sources цих компонентів.
- Фактичні protocol/command/tick/hash schemas, Save FORMAT/fields/defaults/migration policy; значення pc34-v1 і його межі сумісності.
- Synthetic golden saves, command streams/checkpoints і control cases0.41; локальний Windows acceptance checklist.
- Права на локальне редагування/adaptation code/art. Дозвіл на публікацію — окремий scope, не наслідок цього етапу.

### Що запросити в автора і навіщо

| Компонент | Призначення / критерій приймання |
|---|---|
| Repository/commit або source archive з manifest | Прив'язати package до 0.41.4.1 / beta-0.41.4.1-8 і supplied game/net hashes. Потрібен документований зв'язок sources/build inputs з release, не вимога, що будь-яка локальна компіляція одразу дасть bit-identical binary |
| Game implementation, headers, generated bindings і генератори | Редагувати world/entities/economy/combat/AI/UI та додавати механіки; потрібні реалізації, а не тільки назви класів або SDK stubs |
| Net implementation і packet/command schemas | Підтримувати lobby/session/ticks/RNG/hash/resync/rejoin/validation; потрібні version rules і local/mock/relay test interfaces без production credentials |
| `project.godot`, startup scenes, `.gdextension`, editable scenes/resources, original assets/locales/import inputs | Відкривати проєкт у редакторі, міняти сцени/контент і відновити ресурсні залежності. Надати дозволений незашифрований dev project/export; шифрування не обходити |
| Custom Godot 4.7.2 source revision/patchset/build options і matching templates | Відтворити API/ABI модифікованого engine. Для WSL2 потрібен підтримуваний Linux editor/native build path, для Windows — x64 template/runtime |
| Windows bridge/net proxy source і build integration або повний підтримуваний native x64 replacement path | Відтворити зв'язок game/net з Windows. SDK із закритим core дозволяє лише часткову основу; для поставленої мети потрібен редагований core |
| Toolchain/dependency lock, godot-cpp/NDK/compiler revisions, generation/build/export scripts | Відтворювана development build в Ubuntu WSL2 та Windows; Linux `.so`/debug targets за потреби або інструкція їх складання. Production signing keys і токени не потрібні |
| Save serializer/schema/defaults/migrations і пояснення `pc34-v1` | Безпечно підтримувати save/load і встановити cross-version policy, не успадковувати FORMAT1 за припущенням |
| Synthetic saves, golden command streams/checkpoints і test commands | Автоматизований round-trip, replay, 2-peer/reconnect та контроль mechanics без приватних saves/акаунтів |
| Підтвердження scope дозволу на конкретний code/art package | Встановити можливість локального редагування й приватного тестування. Публікація залишається окремим scope |

### Кому адресувати запит

Перший адресат — [publisher frd21313123123](https://github.com/frd21313123123): він може надати build provenance/maintainer contact для exact ZIP. Credits ведуть до [community port makkaX2](https://github.com/makkaX2/DroneFlames-PC-Port) / [@droneflamesmod](https://t.me/droneflamesmod). Community-канал прямо називає себе неофіційним і посилається на [@droneflames](https://t.me/droneflames) як канал розробників гри. Це маршрут для уточнення, не перевірка юридичної особи чи обіцянка доступу до private sources. Автоматичних повідомлень/issues не створювали.

Текст запиту, який користувач може передати:

> Потрібен редагований development package саме DroneFlames PC 0.41.4.1, build beta-0.41.4.1-8, ZIP SHA256 c23c413b99bcfc5d4df6dce449978b7ed207bbee174885ff62a433adb4d162b0, для локальної розробки в Ubuntu WSL2 і тестів у Windows 11. Чи можете надати відповідний repository/commit або source archive: game/net implementations і bindings, відкритий Godot project/scenes/assets, custom 4.7.2 engine/Windows bridge build inputs, toolchain/export scripts, save/protocol schemas і synthetic test fixtures? Просимо підтвердити scope дозволу на локальне редагування code/art. Якщо повні sources недоступні, уточніть, чи є офіційний SDK/dev project та які компоненти залишаються закритими. Релізний ZIP, installer або GitHub Source code archive зі старим af1b4c9 не містять потрібної нової основи. Секрети, signing keys і production credentials не потрібні.

## План після отримання dev package

1. Зафіксувати package hashes/commit/permissions, інвентаризувати всі input files у staging; зіставити їх із native versions та resource IDs релізу.
2. Відтворити project/scene/native binding graph, source serializers і simulation scheduling. Розрізняти code generation та фактичні implementations.
3. Зібрати нову основу в migration branch з документованими build inputs, не замінювати native/engine довільними версіями. Спочатку baseline без gameplay changes.
4. Переносити PC-компоненти лише після перевірки interfaces у таблиці нижче. Один компонент за diff, tests перед наступним.
5. Перенести тести за behavior: старі2458 checks не стають0.41 PASS автоматично; GDScript tests можуть вимагати native bindings/test API. Залишити deterministic/reference comparisons.
6. Synthetic saves і2 peers: round-trip/recovery, version mismatch, command ownership, failed restore, disconnect/rejoin/host changes. За format change — явна migration, а не old FORMAT1 за замовчуванням.
7. Isolated Windows source build → pinned publisher binary comparison на однакових world/config/input; menu/input/audio/rendering/FPS/save-load/multiplayer. Жодних реальних saves чи production accounts.

## PC-компоненти: що переносити обережно

| Старий компонент | Можливість reuse | Умова |
|---|---|---|
| WebRTC DLL |Єдина підтверджена byte identity |Зберегти exact файл; peer/API compatibility все одно тестувати |
| PcPort scale/fullscreen/window |Source доступний у0.33; нова підтримка UNKNOWN |Знайти0.41 SceneTree/autoload/settings ownership і масштабування; native UI може мати власні hooks |
| ArmySelect/input/Main callbacks |Автоматичний перенос не підтверджений |Node paths, native methods/arguments, country ownership/commands, camera transforms |
| SteamNet/SteamPeer/GodotSteam |Старі callbacks/protocol не доведені для new net core |Новий transport API/version/admission; не переносити AppID480 чи protocol7 за припущенням |
| Save/SaveSlots/NetCodec/NetHash |Old implementation не є new schema |Повний new codec/identity/enum/RNG contract і migration fixtures |
| Updater/build/release |Packaging contract відрізняється |Old single-EXE swap не встановлює new ZIP+images; потрібна нова documented transaction, без CI publication цього етапу |
| Python release tooling |Можливі окремі reusable перевірки |Нова asset set/version/layout semantics і відповідні unit tests |

## Варіанти, якщо sources не нададуть

1. **Рекомендований:** отримати matching dev source/SDK і права у власників/maintainer-а. Повідомлень їм автоматично не надсилали.
2. Nonencrypted dev project/PCK + documented native SDK може дозволити UI/config/mod development, але core залишиться binary dependency; це слід прямо називати частковою основою.
3. Зберігати verified0.41 ZIP як isolated reference для майбутніх runtime comparisons. Repackage/copy binaries не є source build або завершеною міграцією.
4. Продовжувати доступну0.33 codebase, окремо реалізовуючи погоджені зміни; це не тотожність0.41 і не досягнення поточної мети повної заміни.

Rollback зараз не вимагає відновлення game/: він не змінювався. Bundle/tar можна перевірити або розгорнути в нове місце для recovery; destructive reset/clean/extract поверх checkout не виконувати. Не прибирати tracked `.godot/` чи старі Phase2 artifacts.

## Наступний практичний крок

Участь користувача потрібна для доступу до відсутніх матеріалів: передати наведений запит publisher/правовласнику або вказати точні шляхи до іншого власного backup/private repository, а також підтверджений scope прав, якщо він уже є. Запитання поставлено під час поточної роботи; відповіді на момент checkpoint немає. Непідтверджений доступ не вважається відсутністю файлів у всіх можливих джерелах.

Після отримання — staging inventory/provenance/build mapping, потім gates вище. Якщо sources не нададуть, реалістичні окремі напрями: продовжити доступний 0.33 порт (спершу review вже наявних beta-гілок) або реалізовувати погоджені можливості самостійно за наявності необхідних прав. Це окремі задачі, не завершення міграції до авторської 0.41.4.1. Game changes зараз не дозволені.
