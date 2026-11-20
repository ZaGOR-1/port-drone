# Phase 5C — актуальна local build/CI policy

[Exact artifacts/commands/tests](PHASE5C_INTEGRATION_RESULTS.md). Pinned Godot4.7.2; Windows build/native headless exit0, три original DLL loaded/hash-match. Existing Menus v0.34.0 label не є owner-approved stable; source product number не підвищували.

Локальна `.github/workflows/build.yml`: push main/beta + PR — tests/build only. Release лише workflow_dispatch із refs/heads/main, publish_release=true, nonempty approved release_version та successful build. Automatic tag publication прибрана; write permission лише release job; build-only UPDATE_REPO empty. Offline policy/YAML checks PASS; Actions NOT RUN; actionlint відсутній. Старий remote auto-release може діяти до integration; у цій сесії нічого не публікували.

G01 cleanup звужено до actual names; усі .old retained. Download/ZIP/atomic replacement R03/R04 OPEN; updater для QA off. .gitignore не ховає tracked .godot/AGENTS/docs. [Windows QA](WINDOWS_BETA_QA_CHECKLIST.md) та artifact launchers призначені для manual testing, не production release.

---

## Історичний checkpoint до Phase5C (збережено)

# Збірка, CI, updater

Стан на `af1b4c9`, 2026-11-19. Джерела повністю прочитані: `tools/build.py`, `fetch_godot.py`, `remote_unzip.py`, `release.py`, `packproj/pack.gd`, `.github/workflows/build.yml`, `game/pc/updater.gd`.

## Локальна збірка

```sh
python3 tools/fetch_godot.py godot_dl
python3 tools/build.py --godot godot_dl/godot \
  --template godot_dl/windows_release_x86_64.exe \
  --version 0.33.2.3 --repo "" --out dist/phase2_baseline/windows-x64
```

Phase2 ці fetch/build-команди **PASS**. Editor/template4.7.2.ed1daf0bf звірені з офіційними archives/digests, Windows EXE214642580 bytes зібраний і виконав headless smoke. Repo порожній навмисно: updater disabled у локальній тестовій збірці. `GODOT_VERSION` не змінювали. Provenance/комплект/обмеження — [ENVIRONMENT_SETUP](ENVIRONMENT_SETUP.md), [RUNTIME_BASELINE](RUNTIME_BASELINE.md), [WINDOWS_TESTING](WINDOWS_TESTING.md).

`fetch_godot.py` завантажує Linux editor ZIP і дістає Windows template з `.tpz` HTTP Range-запитами через `remote_unzip.py`. Перевірка editor/template digest у цих scripts відсутня; для template є лише size assert >50 MB. Наявний кеш перевіряється переважно за існуванням файла; не доводить версію, checksum чи походження.

`build.py:34` створює тимчасову копію `game/`; лише в ній переписує `pc/version.cfg` version/repo і `ui/menus.gd::VERSION`. PCK містить **усі** файли, включно з прихованими (`pack.gd:4`), без whitelist і без обов'язкового parse/runtime smoke. Перевірка `data[:4] == GDPC` засвідчує magic, не цілісність графа ресурсів чи компіляцію GDScript. Return codes `pck_start/add_file/flush` не перевіряються самим packer.

EXE = Windows template + padding до 64 bytes + PCK + trailer `<QI` (PCK length, `0x43504447`). Native ZIP створюється з `libs/` у відсортованому порядку, timestamp ZIP entries 2026-01-01; артефакти — `DroneFlames.exe`, `DroneFlames-libs-r1.zip`, `SHA256SUMS.txt`. Порядок обходу PCK не сортується: byte-for-byte reproducibility не встановлена. PCK містить імпортовані ресурси й project.binary, а не звичайний editor export із відновлених PNG/OGG.

Phase2 додатково перевірив authenticated template prefix, padding/trailer, embedded PCK format4,863/863 source hashes через engine і JSON cfg.repo="". Усі264 game GDScript завантажені/скомпільовані;3 tracked tool scripts реально виконані. Це зовнішня baseline-перевірка, не новий gate у build.py/CI. Точний склад і SHA256 — RUNTIME_BASELINE; native binaries не оновлювали.

`tools/gdc2gd.py` — decompiler tokenizer v101; використовує сторонній `zstandard`. Це інструмент походження, не залежність звичайного Python release-тесту чи runtime гри. Відновлення APK і повторна декомпіляція NOT RUN.

## Версії

Base `game/pc/version.cfg:4` = 0.33.2.3, `repo=""` у checkout, `libs_rev=1`; `Menus.VERSION="v0.33.2.3"`. Порожній repo відключає updater у незапатченій копії. Lobby identity: `NetConfig.version()` = `Menus.VERSION + "/7"`; CI змінює Menus і updater version разом. `project.binary` не переписується build script, тому save header `application/config/version` не слід вважати достовірною версією EXE.

Автоматична release version: `<base>.<GITHUB_RUN_NUMBER>.<GITHUB_RUN_ATTEMPT>`. Tag `v<dotted numeric>` або manual `release_version` задає точну версію. `release.version_key` порівнює числові компоненти, нормалізує кінцеві нулі, відкидає нечислове та значення >signed int64. Updater `nums/newer` виділяє числові групи; контроль генерації валідних tags лежить на release tooling.

## CI та публікація

`.github/workflows/build.yml:3`: push у `main`, `codex/performance-0.33.2.2`, tags `v*`; також pull_request і workflow_dispatch. Успішні push/manual builds публікуються автоматично; PR дає artifact. Concurrency серіалізує release workflows; окрема release job має `contents: write`, build має read.

Послідовність: 15 offline release tests → select version → fetch/cache editor/template → build → upload artifact → release job. Godot performance regression, Windows GUI, Steam mock і updater failure tests у CI не викликаються.

`release.py::release_assets` перевіряє рівно EXE + один libs ZIP і їх SHA256. `publish` читає releases, не переписує published version, дозволяє resume draft тільки для того самого commit, завантажує assets у draft, потім робить видимим. Latest отримує лише чисельно новіший stable release. Це перевірено FakeGitHub unit tests, не викликом GitHub.

## Updater

`_enabled`: Windows; headless/editor/`DF_NO_UPDATE` пропускають перевірку. Debug дозволяє `DF_UPDATE_API`, `DF_UPDATE_ASSET`, proxy/CA overrides. Release API за замовчуванням HTTPS `api.github.com/repos/<repo>/releases/latest`, без токена. JSON check має timeout 12 s; offline/failure переходить до гри. Публічну доступність релізу цього repo не перевіряли.

`_do_update` тестує запис probe-файла, завантажує EXE у `.new`, перевіряє size (коли >0) і SHA256 **лише за наявності** `asset.digest` із `sha256:`. Заміна: EXE → `.old`; `.new` → EXE; при другій rename-помилці пробує повернути `.old`. Це дві операції, не повна транзакція; код результату rollback не перевірено. `_relaunch` не перевіряє PID/помилку `OS.create_process` перед quit. Version downgrade за нормальним потоком відхиляє `newer`; незалежного підписаного anti-rollback state немає.

`_download:252` має `timeout=0`, max_redirects=10, size check після download. Обов'язкового HTTPS/allowlist для URL із asset JSON та криптографічного підпису artifact у клієнті немає. Довіра до HTTPS API не замінює digest/signature policy.

`_libs` бере максимальний `rN` серед asset names, порівнює `libs.rev` та існування трьох DLL; завантажує ZIP без digest-перевірки. Extraction бере `get_file()` і whitelist `LIB_FILES`, тому звичайний `../` у ZIP не дає довільного шляху. Проте немає перевірки повноти трьох DLL, унікальності basename, розміру кожної DLL/успішності запису й узгодженого rollback. Marker записується навіть для ZIP без дозволених entries. Guard `user://libs_try.txt` обмежує повтори до разу на хвилину.

**Перший кандидат на невелику зміну:** `_cleanup_old:114` видаляє кожен `.old/.new/.tmp` у теці EXE. План і acceptance у [BACKLOG.md](BACKLOG.md), ризик R01 у [RISKS.md](RISKS.md). У цьому аудиті cleanup/update не виконувалися.
