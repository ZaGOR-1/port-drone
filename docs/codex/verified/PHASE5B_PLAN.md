# Phase 5B.2 checkpoint / подальший план

R02 і FIX05–08 локально реалізовані та перевірені у stated scope. Чинний план залишкових незалежних задач — [PHASE5B3_PLAN](PHASE5B3_PLAN.md); результати — PHASE5B2_REGRESSION_RESULTS.md. Старі таблиці нижче історичні, їхні airport/cooldown/cancel/fallback TODO більше не є активним списком. Загальний p99/GUI/fullMP/revision gate/updater/shutdown залишаються відкритими. Shared updater worktree існує окремо; узгодити scope, не переписувати.

---

## Історичний checkpoint (збережено)

# Phase 5B.2 — наступні незалежні набори

R02 Phase5B.1 local fixed/tested; [progress](PHASE5B_PROGRESS.md). Full real-peer acceptance лишається відкритим integration gate. Не повторювати початковий R02 аудит.

| Порядок | Незалежна задача | Ризик / конкретне acceptance |
|---|---|---|
| 1 | fix/airport-dispatch | Medium; actual UI→command→placement→economy/ownership→save/load, Windows controls |
| 2 | fix/land-cooldown | Medium; existing FORMAT1-compatible optional default; old/new disk + network snapshot; t=89.9/90; hash/MP review. Якщо потрібна schema/protocol зміна — окреме погодження |
| 3 | fix/air-mode-cancel | Medium; REBASE та AIRDROP окремі regression tests; Esc/RMB clears refs/preview; не виконує наказ і не видаляє старий strike plan |
| 4 | fix/updater-cleanup | High subsystem; лише owned temp artifacts, sandbox fixtures, сторонні .old/.new/.tmp зберегти; не біля користувацької інсталяції |
| 5 | fix/update-integrity | High; окремо від cleanup: verified DLL/download/hash/zip paths/atomic transaction/rollback; не міняти native DLL без дозволу |
| 6 | fix/upkeep-fallback | Medium; lazy fallback+spy/differential correctness/cache invalidation, paired same-checkpoint profile; не називати єдиною причиною p99 |
| 7 | fix/shutdown-lifetimes | Medium; ізольовано test-owned refs vs production cycles, verbose ObjectDB/resource/RID, без замовчування stderr |
| 8 | perf/p99-investigation | Profiling only до root cause; same checkpoint/seed/ticks/AI/engine/hardware, повтори p50/p99/avg/max; окремо від cold restore latency |

Перед будь-якою інтеграцією: двоє same exact build peers (commands/order/hash/RNG, reconnect/resync, disconnect/host transfer) та Windows GUI/Steam/LAN checklist; R17 mock Windows portability/загальна save fault matrix окремо. Паралельність можлива після незалежних review, але save/cooldown/network спільні файли узгодити з OKREDU.

Важливо: Phase5/R02 ще uncommitted у поточному worktree. За чинної заборони commit не можна почати fix/* від HEAD і вважати залежності збереженими. До дозволеного checkpoint продовжувати тут з окремими логічними patches/backups. Після integration — звичайні fix/* від актуальної beta. Нічого з переліку не виправлялося мовчки в R02.

---

## Історичний Phase5B план

# Phase 5B — окремі задачі стабілізації

2026-11-20. Розвиваємо власну DroneFlames; міграція 0.41 DEFERRED. Цей список НЕ означає, що проблеми виправлені. Phase5 покриває лише FIX-01–04: [результат](PR10_CRITICAL_FIXES.md), [тести](PR10_REGRESSION_RESULTS.md).

Після integration candidate кожна задача — від актуальної beta у власній fix/* гілці. До integration залежний fix може походити від зафіксованої candidate лише з явно записаною залежністю, в окремому worktree. Не починати від старої beta й не дублювати cumulative diff. Не додавати наведені fixes мовчки до Phase5. Commit/push/PR/merge потребують окремого дозволу.

| Пріоритет | Гілка / ризик | Scope та acceptance |
|---|---|---|
| P0 | fix/snapshot-restore-failure — R02 HIGH | NetSession._restore_from враховує false Save.net_restore. RED: invalid wrapper/corrupt snapshot; turn/tick/clock/go/rejoin-success не advances. GREEN: контрольований retry/leave, валідний restore та реальні 2-peer resync/reconnect. Без PROTO7/FORMAT1 changes. Залишковий integration blocker. |
| P1 | fix/airport-dispatch — PA05 | UI airport button → _on_action → placement → construction/command. Перевірити кошти/ownership, Windows controls, save/load. Не лише наявність кнопки. |
| P1 | fix/land-cooldown — PA07 | LandTrade._last_deal не переживає save/load. Узгоджений backward default, disk/snapshot roundtrip, негайний повтор і t=89.9/90, pending consent та старий save. Phase5 цього НЕ виправляє. |
| P1 | fix/air-mode-cancel — PA09 | Окремі REBASE/AIRDROP assertions: RMB/Esc очищують mode/refs/preview без небажаного наказу. Старі strike planners зберігають план. |
| P1 | fix/upkeep-fallback — PA08 | Eager Dictionary.get default не викликає дорогий fallback за наявного key. Spy/differential tests, правильні суми й cache invalidation build/capture/destroy/load; paired benchmark. Не називати fallback єдиною причиною p99 без профілю. |
| P1 | fix/updater-cleanup — R01 | Повністю прочитати updater й owned artifact names. Temp fixture зберігає сторонні .old/.new/.tmp/директорії; видаляє лише власні artifacts. DLL/download transaction R03/R04 — окрема задача. Не тестувати біля робочої інсталяції. |
| P2 | fix/shutdown-lifetimes — R18 | Окремо test-owned refs і production cycles. Verbose new/load/quit diagnostics, ownership кожного ObjectDB/RID/resource. Не замовчувати stderr і не робити масовий refactor. Functional PASS співіснує з shutdown FAIL. |
| P1 | fix/windows-mock-portability — R17 | Валідні mock IDs мають Windows /tmp проблему; ID0 обходить init і не є Steam test. Ізольований session dir, двоє peers, same-build admission/mixed-SIM_REV rejection, command stream/hash/frame stalls/reconnect. Native DLL не замінювати. Відсутній res://dev/net_autotest.gd не видавати за доступний harness. |
| P2 | Land loaded-offer validation / R05 | Malformed/truncated kind=land dictionaries та загальна save fault matrix. Phase5 перевіряє валідні terms і старий FORMAT1; не сертифікує довільно зіпсовані внутрішні словники, downgrade, crash/ENOSPC. |
| P2 | PA10/PA12 та PARTIAL catalog | Узгодити ideology defense hook, Chronicle duration/MP scope, AI carrier wing, parking/evacuation. Snapshot viewer не є command replay. Не вимагати parity 0.41.x. |

Наступний конкретний крок: спільний review Phase5 diff з OKREDU, потім окремий fix/snapshot-restore-failure із failing-before test. Паралельно власник може виконати Windows checklist. До закриття R02 та мережевих gates merge не виконувати.

Джерела старих findings: [PR_RISKS](PR_RISKS.md), [RISKS](RISKS.md), [PR_TEST_RESULTS](PR_TEST_RESULTS.md). Їхня Phase4 оцінка історична; FIX-01–04 уточнені новим звітом.
