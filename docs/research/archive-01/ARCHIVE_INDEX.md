# Локальний архів DroneFlames

> Історичний матеріал з `archive/INDEX.md`. [Реєстр досліджень](../INDEX.md)

- [MAINT-02 · консолідація, канонічний список і план MAINT-03](../maint-02/INDEX.md)
- [MAINT-01 · Git backup, інвентар і відновлення](../maint-01/INDEX.md)
- Каталог канонічних місць (`MAINT-02/canonical-catalog.tsv`). Відносні посилання в `catalog/` ведуть до оригіналів.

- [R24–R27C · docs-only handoff, Git bundle і докази](../r24-r27c/HANDOFF.md)
  Резерв на іншому носії — `/run/media/zagor/KINGSTON/DroneFlames-R24-R27C.PKqHW3FQ/`.
  SHA256 tar `23f4d8c3bb0ce104383910bc6626d60b884b9467f1d8125c9ed6bfda386a89a4`.
  Незалежне відновлення й контрприклади (`R24-R27C-usb-verification/restore.log`)

## ARCHIVE-01 · Історичні дослідження та QA

Звірено з Git-джерелом R24–R27C `572bb39` і серверною `beta` `06b0ff2`. Це аудит збереження. Історичні verdict і статус поточної QA залишаються окремими.

| Категорія | COMPLETE | PARTIAL | MISSING | NOT APPLICABLE |
| --- | ---: | ---: | ---: | ---: |
| Phase | 0 | 10 | 0 | 2 |
| PERF | 1 | 3 | 0 | 0 |
| R01–R27C, варіанти та release recovery | 30 | 4 | 0 | 0 |
| INT | 11 | 1 | 0 | 0 |
| FIX | 1 | 8 | 0 | 0 |
| L10N | 0 | 3 | 0 | 0 |
| QA | 0 | 4 | 0 | 1 |
| NATIVE | 4 | 1 | 0 | 0 |
| MAINT | 3 | 3 | 0 | 0 |
| DOCS, DEV, L01/L02, migration | 3 | 4 | 0 | 0 |
| **Усього** | **53** | **41** | **0** | **3** |

Реєстр досліджень (`ARCHIVE-01/research-index.tsv`) містить ID, verdict, baseline, статус повноти, звіт, діагностичні логи й raw, тести, fixtures, патчі, SHA256, команди відтворення й канонічні шляхи. Поля evidence посилаються на репрезентативні файли або члени архівів. Синтаксис `архів::член` указує на точний запис усередині пакета. `bundle:R24-R27C@572bb39:шлях` відновлюється з bundle. COMPLETE означає наявність доказів у межах задокументованого scope. PARTIAL позначає відсутні первинні матеріали або неповне підтвердження точної бази, сценарію чи способу відтворення. MISSING означає відсутність і звіту, і доступних матеріалів. NOT APPLICABLE позначає плани без прогонів.

- 19 відновлених посилань (`ARCHIVE-01/symlinks.tsv`) знову ведуть до точних канонічних файлів. Копії з KINGSTON збіглися з SHA256 MAINT-02. INT, R15 і L10N (`ARCHIVE-01/manifest-recoveries.tsv`) мають шість додаткових відновлених файлів, включно з L10N-03 ZIP із cold storage (`ARCHIVE-01/l10n03-cold-restore.log`). Повторні перевірки маніфестів INT-06, INT-08, L10N-01, L10N-02 і L10N-03 пройшли.
- 20 прогалин DOCS-02B (`ARCHIVE-01/docs02b-gaps.tsv`) лишаються відкритими для оригінальних raw/overlay. Markdown-звіти наявні. Історичний локальний каталог `~/projects/droneflames-backups/` відсутній, а точні Phase 2/4/5/7 dist і ранні commit objects не знайдено в перевірених резервних копіях. Зіставлення Git-індексу ZIP (`ARCHIVE-01/historical-git.tsv`) · Пізніші regression і fixture логи (`ARCHIVE-01/projects-zip-later-evidence.tsv`)
- Додатковий архів (`ARCHIVE-01/unsealed-evidence.tar.gz`) зберігає 3 951 файл із незапакованих серій і доступних пізніших логів з `projects.zip`. Дані з однаковим SHA256 займають одну копію всередині пакета. Члени і SHA256 (`ARCHIVE-01/supplement-members.tsv`) · Незалежне розпакування (`ARCHIVE-01/supplement-restore.log`)
- 47 пакетів і SHA256 (`ARCHIVE-01/archive-assets.sha256`), з яких 41 збігся з уже записаними SHA256. Cold storage (`ARCHIVE-01/cold-check.log`) пройшло перевірку Restic. Основний та інкрементальні bundles відновлено в порожньому репозиторії, `git fsck --full` пройшов. Відновлені refs (`ARCHIVE-01/recovered-refs.tsv`) · Перевірка bundles (`ARCHIVE-01/bundle-verify.log`). R27B/R27C мають окремий перевірений A/B handoff вище.
- Для перегенерації реєстру після очищення використай `DF_ARCHIVE_SOURCE=/шлях/до/відновленого-checkout python3 ARCHIVE-01/inventory.py`. Віднови checkout гілки `perf/r27-impact-spatial-index` з R24–R27C bundle поза production repository. Скрипти історичних harness із абсолютними шляхами запускай у фізичній копії зі шляхами, підставленими за їхнім `REPRODUCE.md`.

### Повна резервна копія на іншому носії

Покажчик джерел для резервування (`ARCHIVE-01/backup-include.txt`) охоплює локальний каталог, канонічні матеріали поза ним, cold storage і точкові пакети з KINGSTON. Обсяг джерел перед дедуплікацією — близько 29 GiB. Використай інший носій із достатнім вільним місцем. Повна копія ARCHIVE-01 на новий носій — **BLOCKED**. Див. [результат фінальної перевірки](#фінальна-перевірка-архіву-й-очищення). Пароль нового Restic і ключ наявного cold storage зберігай окремо в приватному сховищі.

```bash
set -euo pipefail
archive="$HOME/projects/droneflames-archive"
cold="$HOME/projects/droneflames-toolchain/.cold-storage"
read -r -p 'Точка монтування окремого носія: ' medium
mountpoint -q "$medium"
test "$(findmnt -n -T "$medium" -o SOURCE)" != "$(findmnt -n -T "$archive" -o SOURCE)"
test "$(findmnt -n -T "$medium" -o SOURCE)" != "$(findmnt -n -T "/run/media/$USER/KINGSTON" -o SOURCE)"
df -h "$medium"
export RESTIC_REPOSITORY="$medium/DroneFlames-archive-restic"
"$cold/restic" init
"$cold/restic" backup --files-from-verbatim "$archive/ARCHIVE-01/backup-include.txt" \
  --exclude 'account.bin' --exclude '.env' --exclude '*/.cold-storage/key'
"$cold/restic" check --read-data
recovered=$(mktemp -d "$HOME/droneflames-archive-restore.XXXXXXXX")
"$cold/restic" restore latest --target "$recovered" --verify
(cd "$recovered/$HOME/projects" && \
  sha256sum -c droneflames-archive/ARCHIVE-01/archive-assets.sha256)
```

`restic init` потрібен лише для нового сховища. Після відновлення звір SHA256, віднови Git bundle в порожній каталог і відкрий вибрані raw/fixtures із різних серій. Зберігай окрему копію за перевіреною версією manifest. Очищення дозволене лише у scope, для якого звірено інтеграцію, усі унікальні докази і відновлення. Відкриті історичні прогалини не дають підстави для загального очищення.

### Фінальна перевірка архіву й очищення

Звірено 2026-11-26. **Повна резервна копія — BLOCKED.** Усі 97 джерел доступні, їхній логічний розмір — 30 067 614 592 байти до дедуплікації. Єдиний змонтований зовнішній носій — KINGSTON (/dev/sda1, exFAT), вільно 13 498 056 704 байти. KINGSTON одночасно є джерелом для чотирьох шляхів зі списку резервування. Для повної копії потрібен окремий носій із достатнім місцем. Новий Restic snapshot та його відновлення — NOT RUN.

**Наявна копія R24–R27C — PASS.** Поточний маніфест ARCHIVE-01 пройшов SHA256. Перевірка очищення звірила повний SHA256 USB tar і внутрішній маніфест. Для тих самих байтів підтверджено незалежне відновлення п’яти Git refs, трьох PoC і A/B контрприкладів R27B/R27C. Звіти відсутніх історичних першоджерел лишаються у реєстрі DOCS-02B. Протокол відновлення (`R24-R27C-usb-verification/restore.log`)

**PR #23, cleanup --check — PASS, exit 0.** Merge 06b0ff2cb54709487d39b391c5c2ffaaa3a70d50 досягнутий із origin/beta. Після fetch змінився лише remote-tracking ref origin/beta. Локальні beta, main, runtime, чотири гілки й worktrees збережені. Лог перевірки (`ARCHIVE-01/pr23-cleanup-check.aULfO1yc`)

| Локальна гілка | Worktree під ~/projects/droneflames-worktrees | Перевірена вершина |
| --- | --- | --- |
| research/r24-scalability | r24 | 750dcf9 |
| perf/r25-fallback-routes | r25 | 075bc22 |
| perf/r26-outline-rendering | r26 | f3269e4 |
| perf/r27-impact-spatial-index | r27 | 572bb39 |

Ці чотири локальні пари готові до очищення за рішенням власника. Скрипт повторно перевіряє PR, хеші резерву, refs та чистоту й зайнятість worktrees. Загальне очищення й очищення віддалених refs мають окремий scope. [Команда власника й handoff](../r24-r27c/HANDOFF.md)
