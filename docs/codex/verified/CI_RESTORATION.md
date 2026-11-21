# GitHub Actions CI — відновлення в новому репозиторії

2026-11-21. Гілка `ci/restore-build` створена від перевіреної origin/beta172df65e3bd004efed9a5444e90a284d9d69db10. PR #1/docs/codex-reonboarding з head66b975ace94c7fc194598eba6feeb0bc3468b258 не змінюється. Це вузьке відновлення CI, не новий source audit або зміна гри.

## Workflow і межі публікації

`.github/workflows/build.yml`: push main/beta, PR із base beta, optional manual build. Автоматичних tag triggers, Releases, тегів і updater activation немає. Усі робочі jobs мають contents:read, checkout не зберігає credentials; actions pinned до SHA. Після Node20 deprecation annotation першого PR run перевірено офіційні action.yml та закріплено Node24 actions: checkout7.0.1, setup-python7.1.0, upload-artifact7.0.2. Фінальні checks оцінюються лише на новому head.

- Python job: повний unittest discovery;7 Godot fixtures SKIP у чистому runner без engine, вони виконуються в build job.
- Build job: existing fetch_godot.py → перевірка SHA256/version → повний unittest із Godot → existing simulation regression → existing build.py з --repo "" → package verification → Actions artifacts на7days.
- Existing tests/test_ci_policy.py вимагає manual-main `release` expression і рівно один job-level contents:write. Для сумісності залишено **неробочий reserved guard**: build завжди повертає release=false, job не запускається; навіть його єдиний step лише відмовляє у publication з exit1. Жодних publish commands у workflow немає. Inputs publish_release/release_version самі не дозволяють публікацію. Це не реалізація release pipeline і не дозвіл на dispatch/release.
- Тести не змінено для приховування failures. Додано6 негативних/позитивних tests для artifact verifier, включно corruption після перерахунку manifest.

## Перевірений Godot

Офіційний release API: https://api.github.com/repos/godotengine/godot-builds/releases/tags/4.7.2-stable ; publication2026-08-18. Actual editor: **4.7.2.stable.official.ed1daf0bf**. І Linux ZIP, і повний export_templates.tpz завантажено й SHA256 звірено з official release asset digests; extracted members byte-identical до отриманих existing fetch script. Не підбирали іншу версію.

| Файл | SHA256 |
|---|---|
| Linux editor ZIP | cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4 |
| Export templates TPZ | f298490b8d44d934be425a5a65a51bf15f422428b229a06a6e11d9ffea248011 |
| Linux editor binary | 8d106cbe6144c2dc7e881d61d2429c1a8a76e6b22ef48bd5e48dcf934953f71e |
| Windows x64 release template | d34d36f3be1a6c49c56525ae86469b92e4f417ddf0b43cf00dd80c385c4b0562 |

Pin metadata — tools/ci/godot-4.7.2.json. CI використовує range fetch поточного script і перевіряє кінцеві binary hashes проти цього pin, тому не потребує повного1.28GB TPZ щоразу. Кеш не приймається лише за існуванням файла. Самі fetch/build scripts не змінювалися.

## Artifact verification

`tools/ci/verify_build.py` перевіряє engine hashes/version; build.py manifest; PE32+/AMD64 EXE та DLL; exact template prefix/padding; embedded PCK magic/offset/length; ZIP CRC, рівно3 unique DLL basenames і byte identity з tracked libs; sidecar DLL і launchers. Створює BUILD_PROVENANCE.json із exact source SHA/game tree/source_dirty/engine/artifact hashes та QA-SHA256SUMS.txt. Зміст усіх GDScript у PCK не перевіряється цим Python parser: compile/runtime coverage забезпечують наявні suites, не claim100% source coverage.

Пакет: EXE з embedded PCK,3 DLL, libs ZIP, обидва QA launchers, SHA256SUMS, QA-SHA256SUMS, BUILD_PROVENANCE. Artifact — один комплект із одного checkout SHA; не перезбирати незалежно на peers. Artifact retention7days; це не GitHub Release. Windows GUI, native Windows execution і live multiplayer цим Linux build не підтверджені.

## Фактично виконані локальні перевірки

- PASS: actionlint1.7.12 (binary checksum verified), YAML parse/events/permissions/no-publisher configuration.
- PASS:32 Python methods,0skips,90.165s; existing26 і нові6. Godot suites використовують isolated users. Очікувані injected/known native diagnostics обробляють existing wrappers; нових allowlists або suppressions не додано.
- PASS:2476 simulation regression checks; не performance benchmark, не two-peer proof.
- PASS: Windows EXE215004264bytes, embedded PCK105735772bytes, pinned prefix109268480bytes; DLL identity/ZIP/checksums/launchers.
- Local build до commit мав source_dirty=true, тому його не підміняємо фінальним CI artifact із clean exact SHA.
- GDScript/gameplay/DLL/resources/protocol/save/version у source не змінені. Updater download/activation, production users і Releases не запускалися.

Ignored локальні докази: dist/ci-restore/python-local.log, regression/, build-verification.json, engine-origin/verified.json. Віддалені runs/checks/artifacts і результат merge визначати за поточним CI PR/head SHA, а не з локального PASS. Не зливати PR при невдалих/відсутніх checks або невиконаних required reviews/protection. Після CI integration PR #1 лише перечитати; не переписувати його head і не зливати без необхідних умов.

## Наступний Windows QA комплект

Після прийнятого exact beta commit та з перевіреними engine/template:

```bash
python3 tools/build.py --godot godot_dl/godot \
  --template godot_dl/windows_release_x86_64.exe \
  --version 0.34.0 --repo "" --out dist/windows-qa
cp libs/*.dll tools/qa/Run-*.ps1 dist/windows-qa/
python3 tools/ci/verify_build.py --godot-dir godot_dl \
  --package dist/windows-qa --out dist/windows-qa-verification.json
```

Альтернатива — завантажити успішний verified CI artifact відповідного source SHA. Далі18manual Windows cases та два незалежні Windows peers; updater off, copied/synthetic saves, однакові EXE/DLL SHA256. Невирішені updater/save durability, shutdown/performance і real multiplayer ризики не закриті відновленням CI.
