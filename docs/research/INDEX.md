# Реєстр інженерних досліджень DroneFlames

97 записів ARCHIVE-01. Стан доказів і verdict перенесено з `archive/ARCHIVE-01/research-index.tsv`. **53 COMPLETE · 41 PARTIAL · 0 MISSING · 3 NOT APPLICABLE.**

COMPLETE означає достатні докази в історичному scope. PARTIAL позначає прогалини в первинних даних, ідентифікації бази або відтворенні. NOT APPLICABLE позначає плани без прогонів. Історичні PASS і GO обмежені умовами відповідного звіту.

На `origin/beta` `06b0ff2` 54 записи вже мали хоча б один звіт або консолідований документ, указаний у реєстрі ARCHIVE-01. Для 42 записів доступні першоджерела перенесено з архівів. MAINT-06 представлено архівним записом. Згадки про інші дослідження в оглядах не враховано як окремі звіти.

## Звіти та докази

Звіти й інструкції читаються з Git. Колонка «Докази» дає основний шлях до артефактів або тестів. За ID у зовнішньому `research-index.tsv` можна знайти baseline, конкретні файли й члени пакетів, SHA256, відтворення та відомі обмеження.

- `archive/` відповідає `~/projects/droneflames-archive/`. [Індекс архіву, відновлення й резервування](archive-01/ARCHIVE_INDEX.md)
- `toolchain/` відповідає `~/projects/droneflames-toolchain/`. `KINGSTON/` позначає історичну назву зовнішнього носія. `пакет::член` вказує на файл усередині архіву.
- [Маніфести та provenance](archive-01/ARCHIVE_INDEX.md#archive-01--історичні-дослідження-та-qa) включають `archive/ARCHIVE-01/archive-assets.sha256` і `archive/R24-R27C/SHA256SUMS`. Доступ до зовнішніх пакетів потрібен для запуску частини історичних перевірок.

| ID | Verdict у тодішньому scope | Повнота | Звіти й інструкції | Докази |
| --- | --- | --- | --- | --- |
| Phase 1 | Етап інвентаризації; окремий runtime verdict не встановлено | PARTIAL | [Звіт](../codex/verified/TEST_MATRIX.md) | [Історична матриця](../codex/verified/TEST_MATRIX.md) |
| Phase 2 | Windows/Linux startup mix; shutdown FAIL | PARTIAL | [RUNTIME_BASELINE](../codex/verified/RUNTIME_BASELINE.md) · [WINDOWS_TESTING](../codex/verified/WINDOWS_TESTING.md) | [Історична матриця](../codex/verified/TEST_MATRIX.md) |
| Phase 3 | Валідація без доступного первинного JSON/log | PARTIAL | [Звіт](../codex/verified/TEST_MATRIX.md) | [Історична матриця](../codex/verified/TEST_MATRIX.md) |
| Phase 4 | NOT READY для старого PR10 | PARTIAL | [PR_AUDIT_OVERVIEW](../codex/verified/PR_AUDIT_OVERVIEW.md) · [PR_TEST_RESULTS](../codex/verified/PR_TEST_RESULTS.md) · [PR_01_TO_10_REVIEW](../codex/verified/PR_01_TO_10_REVIEW.md) | [Історична матриця](../codex/verified/TEST_MATRIX.md) |
| Phase 5 | NOT READY; HIGH snapshot restore | PARTIAL | [PR10_CRITICAL_FIXES](../codex/verified/PR10_CRITICAL_FIXES.md) · [PR10_REGRESSION_RESULTS](../codex/verified/PR10_REGRESSION_RESULTS.md) | [test_pr10_critical.gd](../../tests/test_pr10_critical.gd) |
| Phase 5B | Історичний план і checkpoints | PARTIAL | [PHASE5B_PLAN](../codex/verified/PHASE5B_PLAN.md) · [PHASE5B_PROGRESS](../codex/verified/PHASE5B_PROGRESS.md) | [Історична матриця](../codex/verified/TEST_MATRIX.md) |
| Phase 5B.1 | R02 functional PASS у звіті | PARTIAL | [R02_SNAPSHOT_RESTORE_FIX](../codex/verified/R02_SNAPSHOT_RESTORE_FIX.md) · [R02_FAILURE_INJECTION_TESTS](../codex/verified/R02_FAILURE_INJECTION_TESTS.md) | [test_snapshot_restore.gd](../../tests/test_snapshot_restore.gd) |
| Phase 5B.2 | READY FOR NEXT STAGE у локальному scope | PARTIAL | [PHASE5B2_FIXES](../codex/verified/PHASE5B2_FIXES.md) · [PHASE5B2_REGRESSION_RESULTS](../codex/verified/PHASE5B2_REGRESSION_RESULTS.md) · [PHASE5B2_PERFORMANCE](../codex/verified/PHASE5B2_PERFORMANCE.md) | [test_phase5b2.py](../../tests/test_phase5b2.py) |
| Phase 5B.3 | PLAN | NOT APPLICABLE | [Звіт](../codex/verified/PHASE5B3_PLAN.md) | План |
| Phase 5C | READY FOR FINAL QA у тодішньому scope | PARTIAL | [PHASE5C_INTEGRATION_RESULTS](../codex/verified/PHASE5C_INTEGRATION_RESULTS.md) · [PHASE5C_GEMINI_REVIEW](../codex/verified/PHASE5C_GEMINI_REVIEW.md) | [test_updater_cleanup.gd](../../tests/test_updater_cleanup.gd) |
| Phase 7 | Історичний checkpoint інтеграції | PARTIAL | [Звіт](../codex/verified/PHASE7_BETA_INTEGRATION.md) | [Історична матриця](../codex/verified/TEST_MATRIX.md) |
| Phase 8 | PLAN | NOT APPLICABLE | [Звіт](../codex/verified/PHASE8_BETA_QA_PLAN.md) | План |
| PERF-HOST-01 | Дослідження режиму навантаження | PARTIAL | [Звіт](perf-host-01/HANDOFF.md) · [Матеріали perf-host-01](perf-host-01/) | `toolchain/performance/perf-host-01.ZAytfEP7/DroneFlames-PERF-HOST-01-handoff.tar.gz` |
| PERF-01 | Linux GUI A/B; native Windows FPS INCONCLUSIVE | PARTIAL | [PERF01_AB_RESULTS](../perf01/PERF01_AB_RESULTS.md) · [PERF01_REPRODUCTION](../perf01/PERF01_REPRODUCTION.md) | `toolchain/performance/perf01/PERF01-evidence.tar.zst` |
| PERF-02 | Linux CPU refresh знижено; FPS залежить від сценарію | PARTIAL | [PERF02_ANALYSIS](../perf02/PERF02_ANALYSIS.md) · [PERF02_AB_RESULTS](../perf02/PERF02_AB_RESULTS.md) | `toolchain/performance/perf02/PERF02-evidence.tar.zst` |
| PERF-03 | Інтегровано через INT-03 | COMPLETE | [Звіт](../perf03/PERF03_RESULTS.md) | `toolchain/int03.IGMm9Fth/DroneFlames-INT03-handoff.tar.gz` |
| R01 | Baseline і bottleneck analysis | COMPLETE | [PERFORMANCE_BASELINE](r01/PERFORMANCE_BASELINE.md) · [PERFORMANCE_BOTTLENECKS](r01/PERFORMANCE_BOTTLENECKS.md) · [Матеріали r01](r01/) | `archive/ARCHIVE-01/unsealed-evidence.tar.gz` |
| R02 | PARTIAL; падіння 2–3 FPS не відтворено | PARTIAL | [R02_PERFORMANCE_BASELINE](r02/R02_PERFORMANCE_BASELINE.md) · [R02_DETERMINISM_CHECK](r02/R02_DETERMINISM_CHECK.md) · [Матеріали r02](r02/) | `archive/ARCHIVE-01/unsealed-evidence.tar.gz` |
| R02-RELEASE | Recovery PASS у headless scope | PARTIAL | [Звіт](../codex/verified/R02_RELEASE_RECOVERY.md) · [Матеріали portable-sfx](portable-sfx/) | `toolchain/backups/20261123-EoyiC0` |
| R03 | PARTIAL; локальний ефект, обмежений A/B scope | COMPLETE | [Звіт](r03/R03_AB_RESULTS.md) · [Матеріали r03](r03/) | `toolchain/backups/20261123-r03-r06.0PbwwJ/performance-r03-r06.tar.zst` |
| R04 | INCONCLUSIVE для глобального FPS | COMPLETE | [Звіт](r04/R04_AB_RESULTS.md) · [Матеріали r04](r04/) | `toolchain/backups/20261123-r03-r06.0PbwwJ/performance-r03-r06.tar.zst` |
| R05 | Діагностика командної черги | COMPLETE | [R05_BENCHMARK_CONDITIONS](r05/R05_BENCHMARK_CONDITIONS.md) · [R05_NEXT_OPTIMIZATION](r05/R05_NEXT_OPTIMIZATION.md) · [Матеріали r05](r05/) | `toolchain/backups/20261123-r03-r06.0PbwwJ/performance-r03-r06.tar.zst` |
| R06 | INCONCLUSIVE для FPS; локальна CPU-економія | COMPLETE | [Звіт](r06/R06_AB_RESULTS.md) · [Матеріали r06](r06/) | `toolchain/backups/20261123-r03-r06.0PbwwJ/performance-r03-r06.tar.zst` |
| R07 | Інтегровано через INT-04 | COMPLETE | [Звіт](../r07/R07_RESULTS.md) · [Матеріали r07](r07/) | `toolchain/performance/r07/R07-handoff.tar.gz` |
| R08 | Інтегровано через INT-05 | COMPLETE | [Звіт](../r08/R08_RESULTS.md) · [Матеріали r08](r08/) | `toolchain/performance/r08.ifM6bVgQ/DroneFlames-R08-handoff.tar.gz` |
| R09 | Baseline профілювання | COMPLETE | [Звіт](r09/HANDOFF.md) · [Матеріали r09](r09/) | `toolchain/performance/r09.vlpdda5t/DroneFlames-R09-handoff.tar.gz` |
| R10 | Інтегровано через INT-06 | COMPLETE | [Звіт](../r10/R10_RESULTS.md) · [Матеріали r10](r10/) | `toolchain/performance/r10.sgT1Rl0N/DroneFlames-R10-handoff.tar.gz` |
| R11 | NO-GO | PARTIAL | [Звіт](r11/HANDOFF.md) · [Матеріали r11](r11/) | `archive/ARCHIVE-01/unsealed-evidence.tar.gz` |
| R12 | NO-GO | COMPLETE | [HANDOFF](r12/HANDOFF.md) · [QA](r12/QA.md) · [Матеріали r12](r12/) | `toolchain/performance/r12.VIKojgL3/DroneFlames-R12-NO_GO-handoff.tar.gz` |
| R13 | NO-GO | COMPLETE | [HANDOFF](r13/HANDOFF.md) · [METHOD](r13/METHOD.md) · [Матеріали r13](r13/) | `toolchain/performance/r13.C0NIjw0t/DroneFlames-R13-NO_GO-handoff.tar.gz` |
| R14 | Інтегровано через INT-07 | COMPLETE | [Звіт](../r14/R14_RESULTS.md) · [Матеріали r14](r14/) | `toolchain/performance/r14.GEz1Tr3B` |
| R15 | GO; інтегровано через INT-08 | COMPLETE | [Звіт](../r15/R15_RESULTS.md) · [Матеріали r15](r15/) | `toolchain/performance/r15.pCbzhv2E` |
| R16 | Результат детермінізму й restore у handoff | COMPLETE | [Звіт](r16/reproduction.md) · [Матеріали r16](r16/) | `toolchain/performance/r16.Z7ODtxEb/DroneFlames-R16-handoff.tar.gz` |
| R17 | GO після Final Acceptance | COMPLETE | [Звіт](r17/FINAL_ACCEPTANCE.md) · [Матеріали r17](r17/) | `toolchain/performance/r17.xD07pkTL/DroneFlames-R17-handoff.tar.gz` |
| R17B | INCONCLUSIVE | COMPLETE | [Звіт](r17b/README.md) · [Матеріали r17b](r17b/) | `toolchain/performance/r17b.tcCPTLHp/DroneFlames-R17B-handoff.tar.gz` |
| R17C | HOST_NOT_READY; 0 нових A/B-пар | PARTIAL | [Звіт](r17c/README.md) · [Матеріали r17c](r17c/) | `toolchain/performance/r17c.bisE12lZ/DroneFlames-R17C-handoff.tar.gz` |
| R18 | HOST_NOT_READY; статичний аналіз | COMPLETE | [Звіт](r18/README.md) · [Матеріали r18](r18/) | `toolchain/performance/r18.4rC4kUzE/DroneFlames-R18-handoff.tar.gz` |
| R18A | Функціональний PASS; нові performance виміри NOT RUN | COMPLETE | [Звіт](r18a/README.md) · [Матеріали r18a](r18a/) | `toolchain/performance/r18a.mg4Q3ih0/DroneFlames-R18A-handoff.tar.gz` |
| R18B | GO; інтегровано через INT-10 | COMPLETE | [Звіт](r18b/HANDOFF.md) · [Матеріали r18b](r18b/) | `toolchain/performance/r18b.LG5dtpLy/DroneFlames-R18B-handoff.tar.gz` |
| R19 | GO; інтегровано через INT-11 | COMPLETE | [Звіт](../r19/R19_RESULTS.md) · [Матеріали r19](r19/) | `toolchain/performance/r19/R19-handoff.tar.gz` |
| R20 | NO-GO | COMPLETE | [R20_RESULTS](r20/R20_RESULTS.md) · [README](r20/README.md) · [Матеріали r20](r20/) | `toolchain/performance/r20/R20-handoff.tar.gz` |
| R21 | GO; інтегровано через INT-12 | COMPLETE | [Звіт](../r21/R21_RESULTS.md) · [Матеріали r21](r21/) | `toolchain/performance/r21/R21-handoff.tar.gz` |
| R22 | NO-GO | COMPLETE | [R22_RESULTS](r22/R22_RESULTS.md) · [README](r22/README.md) · [Матеріали r22](r22/) | `toolchain/performance/r22/R22-handoff.tar.gz` |
| R23 | Аналіз масштабування, 65 GUI прогонів | COMPLETE | [Звіт](../r23/R23_RESULTS.md) · [Матеріали r23](r23/) | `toolchain/performance/r23/DroneFlames-R23-handoff.tar.gz` |
| R24 | Дослідження завершено | COMPLETE | [Звіт](../r24/R24_RESULTS.md) · [Матеріали r24-r27c](r24-r27c/) | `archive/R24-R27C` |
| R25 | INCONCLUSIVE | COMPLETE | [Звіт](../r25/R25_RESULTS.md) · [Матеріали r25](r25/) · [Матеріали r24-r27c](r24-r27c/) | `archive/R24-R27C` |
| R26 | NO-GO | COMPLETE | [Звіт](../r26/R26_RESULTS.md) · [Матеріали r26](r26/) · [Матеріали r24-r27c](r24-r27c/) | `archive/R24-R27C` |
| R27 | GO лише початковий локальний scope | COMPLETE | [Звіт](../r27/R27_RESULTS.md) · [Матеріали r27](r27/) · [Матеріали r24-r27c](r24-r27c/) | `archive/R24-R27C` |
| R27B | NO-GO; callback створення вузла | COMPLETE | [Звіт](../r27/R27_RESULTS.md#r27b--готовність-до-інтеграції) · [Матеріали r24-r27c](r24-r27c/) | `archive/R24-R27C` |
| R27C | NO-GO; callback повторно використаного спрайта | COMPLETE | [Звіт](../r27/R27_RESULTS.md#r27c--відновлення-коректності) · [Матеріали r24-r27c](r24-r27c/) | `archive/R24-R27C` |
| INT-01 | Conditional; див. Windows gate | COMPLETE | [INT01_INTEGRATION](../INT01_INTEGRATION.md) · [INT01_WINDOWS_QA](../INT01_WINDOWS_QA.md) · [Матеріали int01](int01/) | `toolchain/integration-qa-v0.36.1` |
| INT-02 | PASS інтеграції; Windows physical NOT RUN | PARTIAL | [Звіт](int02/RESULTS.md) · [Матеріали int02](int02/) | `toolchain/int02.50NeyJ` |
| INT-03 | Інтегровано PR #11 | COMPLETE | [REVIEW](int03/REVIEW.md) · [HANDOFF](int03/HANDOFF.md) · [Матеріали int03](int03/) | `toolchain/int03.IGMm9Fth/DroneFlames-INT03-handoff.tar.gz` |
| INT-04 | Інтегровано PR #12 | COMPLETE | [Звіт](int04/HANDOFF.md) · [Матеріали int04](int04/) | `toolchain/performance/r07/R07-handoff.tar.gz` |
| INT-05 | Інтегровано PR #13 | COMPLETE | [Звіт](int05/HANDOFF.md) · [Матеріали int05](int05/) | `toolchain/performance/r08.ifM6bVgQ/DroneFlames-R08-handoff.tar.gz` |
| INT-06 | Інтегровано PR #14 | COMPLETE | [INT06_INTEGRATION](../r10/INT06_INTEGRATION.md) · [HANDOFF](int06/HANDOFF.md) · [Матеріали int06](int06/) | `toolchain/performance/r10.sgT1Rl0N/DroneFlames-R10-handoff.tar.gz` |
| INT-07 | Інтегровано PR #15 | COMPLETE | [Звіт](../r14/INT07_INTEGRATION.md) · [Матеріали int07](int07/) | `toolchain/int07.4IWmLXCl/handoff` |
| INT-08 | Інтегровано PR #16 | COMPLETE | [Звіт](../r15/INT08_INTEGRATION.md) · [Матеріали int08](int08/) | `toolchain/int08.1UTXXUmq/handoff` |
| INT-09 | Інтегровано PR #17 | COMPLETE | [Звіт](int09/INT09.md) · [Матеріали int09](int09/) | `toolchain/performance/r17-final-profile-b.9tC9OIb6/DroneFlames-R17-Final-Acceptance-evidence.tar.gz` |
| INT-10 | Інтегровано PR #18 | COMPLETE | [Звіт](int10/INT10.md) · [Матеріали int10](int10/) | `toolchain/performance/r18b-profile-b.gFaqgQ6i/DroneFlames-R18B-evidence.tar.gz` |
| INT-11 | Інтегровано PR #19 | COMPLETE | [Звіт](int11/INT11.md) · [Матеріали int11](int11/) | `toolchain/performance/r19/R19-handoff.tar.gz` |
| INT-12 | Інтегровано PR #20 | COMPLETE | [Звіт](int12/INT12.md) · [Матеріали int12](int12/) | `toolchain/performance/r21/R21-handoff.tar.gz` |
| FIX-01-HUD | Conditional; фізичний Windows після fix NOT RUN | COMPLETE | [FIX01_WINDOWS_QA](../FIX01_WINDOWS_QA.md) · [FIX01_REGRESSION_TESTS](../FIX01_REGRESSION_TESTS.md) · [Матеріали fix01-hud](fix01-hud/) | Див. звіт |
| FIX-01-Phase5 | Seasons у Phase5; історичний PASS у fixture | PARTIAL | [Звіт](../codex/verified/PR10_CRITICAL_FIXES.md) | [test_pr10_critical.gd](../../tests/test_pr10_critical.gd) |
| FIX-02 | Land consent; historical scoped PASS | PARTIAL | [Звіт](../codex/verified/PR10_CRITICAL_FIXES.md) | [test_pr10_critical.gd](../../tests/test_pr10_critical.gd) |
| FIX-03 | Ship.c і Chronicle; historical scoped PASS | PARTIAL | [Звіт](../codex/verified/PR10_CRITICAL_FIXES.md) | [test_pr10_critical.gd](../../tests/test_pr10_critical.gd) |
| FIX-04 | Carrier lifecycle; historical scoped PASS | PARTIAL | [Звіт](../codex/verified/PR10_CRITICAL_FIXES.md) | [test_pr10_critical.gd](../../tests/test_pr10_critical.gd) |
| FIX-05 | Phase5B.2; historical scoped PASS | PARTIAL | [PHASE5B2_FIXES](../codex/verified/PHASE5B2_FIXES.md) · [PHASE5B2_REGRESSION_RESULTS](../codex/verified/PHASE5B2_REGRESSION_RESULTS.md) | [test_phase5b2.py](../../tests/test_phase5b2.py) |
| FIX-06 | Phase5B.2; historical scoped PASS | PARTIAL | [PHASE5B2_FIXES](../codex/verified/PHASE5B2_FIXES.md) · [PHASE5B2_REGRESSION_RESULTS](../codex/verified/PHASE5B2_REGRESSION_RESULTS.md) | [test_phase5b2.py](../../tests/test_phase5b2.py) |
| FIX-07 | Phase5B.2; historical scoped PASS | PARTIAL | [PHASE5B2_FIXES](../codex/verified/PHASE5B2_FIXES.md) · [PHASE5B2_REGRESSION_RESULTS](../codex/verified/PHASE5B2_REGRESSION_RESULTS.md) | [test_phase5b2.py](../../tests/test_phase5b2.py) |
| FIX-08 | Microbench та regression у тодішньому scope | PARTIAL | [Звіт](../codex/verified/PHASE5B2_PERFORMANCE.md) | [test_upkeep_fallback.gd](../../tests/test_upkeep_fallback.gd) |
| L10N-01 | Історичні scope результати | PARTIAL | [LOCALIZATION_FIXES](../LOCALIZATION_FIXES.md) · [LOCALIZATION_TESTS](../LOCALIZATION_TESTS.md) · [Матеріали l10n01](l10n01/) | `toolchain/standards-l10n-qa.5fWAvJ/handoff` |
| L10N-02 | Цільовий Linux GUI/HEADLESS PASS | PARTIAL | [LOCALIZATION_TESTS](../LOCALIZATION_TESTS.md) · [README](l10n02/README.md) · [Матеріали l10n02](l10n02/) | `toolchain/l10n02-qa.sfnBnw/handoff` |
| L10N-03 | QA у перевірених режимах | PARTIAL | [L10N03_QA_SUMMARY](../L10N03_QA_SUMMARY.md) · [L10N03_MULTIPLAYER_QA](../L10N03_MULTIPLAYER_QA.md) · [Матеріали l10n03](l10n03/) | `toolchain/l10n03-qa.vfFa4l/bundle` |
| QA-01 | Wine startup розмежовано з Linux native | PARTIAL | [Звіт](qa01/README.md) · [Матеріали qa01](qa01/) | `toolchain/qa01.BF2QJ4IH/QA01-evidence.tar.gz` |
| QA-PORTABLE-SFX | Scoped headless/GUI owner evidence | PARTIAL | [WINDOWS_QA](../WINDOWS_QA.md) · [WINDOWS_CONTEXT_HOTKEYS_QA](../codex/verified/WINDOWS_CONTEXT_HOTKEYS_QA.md) · [Матеріали portable-sfx](portable-sfx/) | `toolchain/backups/20261123-EoyiC0` |
| QA-UI-01–03 | Scope GUI/scale у звіті | PARTIAL | [Звіт](../WINDOWS_QA.md) | `toolchain/backups/20261123-EoyiC0` |
| QA-INPUT-01/GAME-01 | Scope GUI/keyboard у звіті | PARTIAL | [Звіт](../WINDOWS_QA.md) | `toolchain/backups/20261123-EoyiC0` |
| QA-WINDOWS-TWO-PEER | PLAN; physical acceptance NOT RUN | NOT APPLICABLE | [Звіт](../codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md) | [Run-MultiplayerQA.ps1](../../tools/qa/Run-MultiplayerQA.ps1) |
| NATIVE-01 | Технічна можливість GDExtension підтверджена | PARTIAL | [POC_README](native-01/POC_README.md) · [R23_RESULTS](../r23/R23_RESULTS.md) · [Матеріали native-01](native-01/) | `toolchain/native-01/NATIVE-01-handoff.tar.gz` |
| NATIVE-02 | Вузький research GO; production відкладено | COMPLETE | [Звіт](native-02/handoff/README.md) · [Матеріали native-02](native-02/) | `toolchain/native-02/NATIVE-02-handoff.tar.gz` |
| NATIVE-02B | Виграш acquire поглинув marshal | COMPLETE | [Звіт](native-02b/README.md) · [Матеріали native-02b](native-02b/) | `toolchain/native-02b/NATIVE-02B-handoff.tar.gz` |
| NATIVE-02C | Оцінено стелю Vision; production не підтверджено | COMPLETE | [Звіт](native-02c/README.md) · [Матеріали native-02c](native-02c/) | `toolchain/native-02c/NATIVE-02C-handoff.tar.gz` |
| NATIVE-02D | Оцінено стелю Army/Unit; production не підтверджено | COMPLETE | [Звіт](native-02d/README.md) · [Матеріали native-02d](native-02d/) | `toolchain/native-02d/NATIVE-02D-handoff.tar.gz` |
| MAINT-01 | Незалежний Git restore PASS | COMPLETE | [Звіт](maint-01/INDEX.md) · [Матеріали maint-01](maint-01/) | `archive/MAINT-01` |
| MAINT-02 | Консолідація та R23 reanalysis | COMPLETE | [Звіт](maint-02/INDEX.md) · [Матеріали maint-02](maint-02/) | `archive/MAINT-02` |
| MAINT-03 | Перевірка USB/refs та інтеграція | COMPLETE | [Звіт](maint-03/INDEX.md) · [Матеріали maint-03](maint-03/) | `archive/MAINT-03` |
| MAINT-04 | Інвентар гілок | PARTIAL | [Звіт](maint-04/INDEX.md) · [Матеріали maint-04](maint-04/) | `archive/MAINT-04` |
| MAINT-05 | Інвентар допоміжних папок | PARTIAL | [Звіт](maint-05/INDEX.md) · [Матеріали maint-05](maint-05/) | `archive/MAINT-05` |
| MAINT-06 | Supplement/точні пакети | PARTIAL | [Архівний запис](#maint-06) | `archive/MAINT-06` |
| DOCS-02 | Аудит; початковий INCONCLUSIVE | COMPLETE | [Звіт](../DOCUMENTATION_AUDIT.md#docs-02--2026-11-26) | `archive/R24-R27C/SHA256SUMS` |
| DOCS-02B | Review завершено; 20 історичних прогалин | COMPLETE | [Звіт](../DOCUMENTATION_AUDIT.md#docs-02b--незалежне-review) | `archive/ARCHIVE-01/docs02b-gaps.tsv` |
| DEV-01 | Disaster recovery scoped PASS | COMPLETE | [Звіт](dev-01/docs/DISASTER_RECOVERY_TEST.md) · [Матеріали dev-01](dev-01/) | `toolchain/backups/20261123-dev-environment-v1.J78ugB` |
| DEV-02 | Development environment restore | PARTIAL | [Звіт](dev-02/REPORT.md) · [Матеріали dev-02](dev-02/) | `toolchain/dev02.tMRUbu/Development-Environment-v2` |
| L01 | Linux native prototype | PARTIAL | [Звіт](l01/RESTORE_L01.md) · [Матеріали l01](l01/) | `toolchain/backups/20261123-linux-native-l01.u9ML5E` |
| L02 | Portability дослідження | PARTIAL | [PROJECT_STATE](l01/linux-native/PROJECT_STATE.md) · [CLI_REFERENCE](l02/CLI_REFERENCE.md) · [Матеріали l02](l02/) | `toolchain/l02-portability.H0BQrG/DroneFlames-L02-portability-overlay.tar.gz` |
| MIGRATION-041 | DEFERRED; assessment | PARTIAL | [MIGRATION_041](../codex/verified/MIGRATION_041.md) · [VERSION_041_ANALYSIS](../codex/verified/VERSION_041_ANALYSIS.md) · [VERSION_041_DIFF](../codex/verified/VERSION_041_DIFF.md) | Див. звіт |

## MAINT-06

MAINT-06 перевірив 4 676 унікальних SHA256 у 68 коренях USB-архіву. ARCHIVE-01 зберіг логи й таблиці MAINT-06. Окремого Markdown-звіту в інвентарі немає. Верифікацію USB-копії зафіксовано в `archive/MAINT-06/verify-from-usb.log`. Покажчик доповнення INT-08 — `archive/MAINT-06/int08-supplement.tsv`. Точні пакети перелічено в `archive/MAINT-06/exact-packages.tsv`. Baseline інвентаря — `7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33`.

## Відомі прогалини

`R11_REPORT.md` та окремі Windows QA звіти `WINDOWS_GUI_UI_QA_RESULTS.md`, `WINDOWS_KEYBOARD_QA.md` і `WINDOWS_INPUT_FOLLOWUP_QA.md` зафіксовані в історичних покажчиках. Доступні [handoff R11](r11/HANDOFF.md) і [консолідований Windows QA](../WINDOWS_QA.md). Оригінали ранніх звітів SFX/MinGW, перелічених у [DOCS-02](../DOCUMENTATION_AUDIT.md#локальні-джерела-поза-git-baseline), не знайдено в перевірених доступних джерелах. Доступні інструкції пакування й відновлення перенесено до [portable-sfx](portable-sfx/).

## Додаткові матеріали

- [Історичні документи ранньої beta](early-beta/) та [інструкції відновлення резервної копії R03–R06](r03-r06/).
- [Пакування та відновлення portable SFX](portable-sfx/), [підготовка портативного середовища](dev-01/) та [L01](l01/) й [L02](l02/).
- [Резервна копія та контрприклади R24–R27C](r24-r27c/HANDOFF.md). Виконувані контрприклади R27B/R27C лишаються у зовнішньому handoff з маніфестом.
- [Попередній стан проєкту](https://github.com/ZaGOR-1/port-drone/blob/7181e88b03a6ad5c2a5c64a6fbf02bfc8854ff33/docs/PROJECT_STATE.md) фіксує історичні ідентифікатори PERF, INT, FIX і L10N.
- [Прогалини DOCS-02B](../DOCUMENTATION_AUDIT.md#docs-02b--незалежне-review) і первинний перелік `archive/ARCHIVE-01/docs02b-gaps.tsv`.

## Після ARCHIVE-01

| ID | Verdict | Повнота | Baseline | Звіт і відтворення | Докази |
| --- | --- | --- | --- | --- | --- |
| R28 | NO-GO на feasibility | COMPLETE у scope feasibility | `047c474` | [Звіт](../r28/R28_RESULTS.md) | `archive/R28/SHA256SUMS` |
| R29 | NO-GO на feasibility | COMPLETE у scope feasibility | `047c474` | [Звіт](../r29/R29_RESULTS.md) | `archive/R29/SHA256SUMS` |
| R30 | Дослідження завершено, R31 feasibility рекомендовано | COMPLETE у scope аналізу | `acd9760` | [Звіт](../r30/R30_RESULTS.md) | `archive/R30/SHA256SUMS` |
| R31 | NO-GO на feasibility | COMPLETE у scope feasibility | `acd9760` | [Звіт](../r31/R31_RESULTS.md) | `archive/R31/SHA256SUMS` |
| R32 | NO-GO на feasibility | COMPLETE у scope feasibility | `acd9760` | [Звіт](../r32/R32_RESULTS.md) | `archive/R32/SHA256SUMS` |
| R33 | NO-GO на feasibility | COMPLETE у scope feasibility | `acd9760` | [Звіт](../r33/R33_RESULTS.md) | `archive/R33/SHA256SUMS` |

[Точні діагностичні PCK обох досліджень](../r29/R29_RESULTS.md#точні-діагностичні-pck) збережено в `archive/R28-R29-PCK/`.
