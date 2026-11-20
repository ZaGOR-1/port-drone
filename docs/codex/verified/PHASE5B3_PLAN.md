# Phase 5C — актуалізація наступного етапу

Попередні P0 SIM revision та R01 cleanup нижче виконані локально у 5C: [review](PHASE5C_GEMINI_REVIEW.md), [тести](PHASE5C_INTEGRATION_RESULTS.md). Власник прямо погодив pr10-phase5b2-1 у Phase5C; revision реалізована без зміни PROTO7/FORMAT1/product number.

Наступне — exact same build Windows GUI 18 cases та full two-peer commands/hash/RNG/reconnect/resync/host-change acceptance. Нових великих механік не починати. Далі — окремо погоджені R03/R04 update integrity, R07 schemas, R05 save durability, R18 shutdown і p99. Workflow/template лише локальні, main/beta незмінні. Звичайні fix/* від beta — після консолідованої інтеграції. Увесь candidate не оголошений READY FOR BETA.

---

## Історичний checkpoint до Phase5C (збережено)

# Phase 5B.3 — наступні незалежні задачі

2026-11-20. Цей документ — план, а не дозвіл автоматично виконувати зміни чи публікувати результат. FIX05–08 та R02 залишаються uncommitted у codex/fix-pr10-critical. Не створювати нову гілку від голого HEAD96053: він не містить цих fixes. Перед наступним edit — новий унікальний backup dirty tree. Після дозволеного checkpoint/integration нормальні fix/* від beta.

| Пріоритет | Логічний набір | Acceptance / залежності |
|---|---|---|
| P0 | Build identity / compatibility gate | Власник окремо погоджує новий SIM_REV або content/build fingerprint. Production identifiers у Phase5B.2 не змінені. Exact same cohort; real old/new admission rejection; network saved-match resume відхиляє несумісну revision; план new-save downgrade warning. Same SIM_REV зараз пропускає різний код і новий cooldown/hash |
| P0 | fix/updater-cleanup — R01 | Лише updater-owned names; sandbox fixtures; чужі .old/.new/.tmp/dirs зберігаються. Відсутня destructive перевірка біля живої інсталяції |
| P0 | fix/update-integrity — R03/R04 | Окремо від cleanup: HTTPS/origin/digest, safe ZIP names, complete DLL/EXE validation, atomic staging, failure rollback/permissions/timeouts. Native DLL заміна лише після окремого дозволу; тестувати dummy copies |
| P1 | Same-build two-peer acceptance | Повні UI→commands→canonical turns→hash/RNG→snapshot→continue; різні FPS/stalls; reconnect/resync, partial failure/manual retry/late packet/host rotation. Loopback hello не закриває цей gate |
| P1 | Windows GUI/Steam/LAN | Airport button/build/buy; Esc/RMB REBASE/AIRDROP до target і після queued command; cooldown після restart/save/load; DPI/input/audio/GPU; два незалежні same-build peers. Launcher із Steam bypass — тільки SP/headless |
| P1 | General network call schema — R07 | Phase5B.2 захищає тільки mil.build/rebase/order_airdrop та попередні land paths. Не вважати всі ALLOWED callv hardened: arity/types/ranges/ownership у вкладених containers/rate limits — окремий аудит/test-first task |
| P1 | Save fault/durability — R05 | Optional cooldown уже prevalidated, але arbitrary nested corrupt dictionaries/rename/ENOSPC/crash/autosave races не сертифіковані. Old→new policy зафіксована; old reader loses new cooldown, downgrade unsupported |
| P2 | Shutdown lifetime/resource leaks — R18 | Розділити test-owned refs і production cycles; ObjectDB/CanvasItem/resource/DummyTexture diagnostics, без розширення allowlist заради PASS |
| P2 | p99 / worker timing | Звичайний asynchronous production mode та контрольоване job completion вимірювати окремо. Lab forcing waits змінює tail і не порівнюється напряму зі старими42–50ms. Profile AI/Chronicle/economy/worker waits; same checkpoint/seed/engine/ticks/AI; raw samples/пари/повтори |
| P2 | Aircraft edge lifecycle | Captured/destroyed/missing source base під час queued flight, active RTB/airdrop retarget/fuel failure/loaded troops. Не вводити нові refund/abort mechanics без gameplay review |

До beta: code review ЗаGOR-1/OKREDU, compatibility gate, відкриті HIGH updater/network risks, Windows GUI і full multiplayer acceptance. Один cumulative PR10+fixes, attribution/ancestry зберегти;10cumulativePR не застосовувати окремими squash/cherry-pick. Не створювати конкуруючі PR без узгодження. main — stable,0.41 migration DEFERRED.

Для погодження gameplay: gift consent, pending TTL90s/одна на пару, existing directional human cooldown; cancel до submission/queued command boundary; вже завантажені troops не дають нового автоматичного refund. Ці правила в Phase5B.2 не переписані.


Пропозиція мінімального admission gate для окремого погодження: `SIM_REV=pr10-phase5b2-1` замість поточного `pr10-critical-1`, без зміни PROTO7/product version. Після дозволу — actual old/new rejection та saved-match resume mismatch tests. У цій сесії ця зміна **не виконана**. Це не робить old executable безпечним reader нового save: unsupported downgrade/backup policy лишається окремою умовою.
