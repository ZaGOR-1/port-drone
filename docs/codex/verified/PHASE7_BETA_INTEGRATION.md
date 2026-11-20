# Phase 7 — консолідована інтеграція в beta

2026-11-20. Власник ZaGOR-1 прямо дозволив commit, push гілки Codex, один integration PR та merge **лише в beta**, без force push, release/tags/dispatch або зміни branch protection. Рішення supersedes попередню вимогу чекати manual GUI/MP перед development integration. Це не stable release і не приймання неперевірених функцій як PASS.

## Перевірена база

Після safe fetch origin/main та origin/beta: `af1b4c975564bac916db079d8470c2394d4920e5`. Merge-base candidate/beta той самий; beta-only commits **0**. Актуальний PR10 head `96053d66eb984cc24e3acce647a55a195136abd2` відповідає перевіреній базі fixes. Усі наведені PR heads — ancestors PR10 та кандидата, missing commits **0**. PR1–4 мають sibling history, включену merge-комітом у cumulative result; кількість commits не використовувалася як доказ сама по собі.

| PR | Актуальний head SHA | Head ancestor PR10/candidate | Відсутні коміти |
|---|---|---|---|
| [#1](https://github.com/ZaGOR-1/port-drone/pull/1) | `d6383064276c13863b3d540ccf4e461408db3d69` | YES | 0 |
| [#2](https://github.com/ZaGOR-1/port-drone/pull/2) | `50efdbac3c860f0a5e8ed63e5c465f2e3f2ddfef` | YES | 0 |
| [#3](https://github.com/ZaGOR-1/port-drone/pull/3) | `0a6225c9f6c6c4d7770ce127846b3f65e30cae2c` | YES | 0 |
| [#4](https://github.com/ZaGOR-1/port-drone/pull/4) | `bb77603d9734ed1b729c3932a9a0ed0267a4a7ad` | YES | 0 |
| [#5](https://github.com/ZaGOR-1/port-drone/pull/5) | `1806831cd2bcf934e45af7fd89cbf1c64bc262ef` | YES | 0 |
| [#6](https://github.com/ZaGOR-1/port-drone/pull/6) | `f8e42970fe336fcd308fd92ee9e2671293265a7e` | YES | 0 |
| [#7](https://github.com/ZaGOR-1/port-drone/pull/7) | `877355144ad6322ac7b00ae4a1de185fe4440b63` | YES | 0 |
| [#8](https://github.com/ZaGOR-1/port-drone/pull/8) | `299800d9fd2294fa022e84d373969fb6b17160a9` | YES | 0 |
| [#9](https://github.com/ZaGOR-1/port-drone/pull/9) | `84f95c9c76db802f2774a8201850f3817bfae9e2` | YES | 0 |
| [#10](https://github.com/ZaGOR-1/port-drone/pull/10) | `96053d66eb984cc24e3acce647a55a195136abd2` | YES | 0 |

Докази: `git merge-base`, `git merge-base --is-ancestor`, `git rev-list <head> --not <candidate>`, graph і GitHub REST PR metadata у `dist/phase7_20261120-224516/ancestry.json`, `history_graph.txt`, `pr_01.json`…`pr_10.json`. Старі PR не merge/cherry-pick/squash окремо. Історія й commit authors OKREDU збережені без rewriting.

## Backup та коміти

Phase5C archive86files перевірено через SHA256 та actual extraction; усі поточні файли відповідали manifest. Створено додатковий immutable Phase7 backup86files у `dist/phase7_20261120-224516/backup/`, extraction/hash proof також PASS. Кеші, .serena, ignored dist payload і native resources не stage; source/tests/docs/AGENTS включаються явними списками.

Shared gameplay/net/save hunks і їхні tests закомічені разом, щоб не створювати штучні частково узгоджені snapshots. Окремо updater та CI:

- `8b4a92600eca04488a10ddbca190357193a8c391` — fix: stabilize PR10 gameplay, save/load and snapshot recovery
- `f945358ac9c73fd3fb9ee085b56351f781190e6f` — fix(updater): retain rollback and restrict startup cleanup
- `526fd2d463a57cc9e1e14bbd9dd84c98e9becbff` — ci: build beta without automatic release publication

Документація/policy/PR template/repository hygiene/QA launchers — наступний окремий commit. Нові commits використовують наявну локальну Git identity власника; Codex assistance зазначена в commit body, не приписана історичним людським commits. Жодного Co-authored-by з вигаданою особою.

## Автоматичні докази й безпека

Використовується [Phase5C checkpoint](PHASE5C_INTEGRATION_RESULTS.md):26Python,2476Godot,309mechanics,81critical,R02 111+41,FIX05–08 suites/save-load-continue/269scripts/883PCK/Windowsx64/native headless — PASS у stated scope. Source game/test payload після commit byte-identical до hash-verified Phase5C candidate. Перед push виконується мінімальний post-commit smoke; argv/results/logs — `dist/phase7_20261120-224516/`. Не називати Phase5C результати новим GUI/MP прогоном.

PROTO7/FORMAT1 number/native DLL/Steam implementation не змінено інтеграцією. SIM_REV=`pr10-phase5b2-1`. Optional cooldown persistence та unsupported new→old downgrade залишаються. SIM_REV не криптографічний fingerprint: exact same EXE+DLL SHA для обох QA peers.

`.github/workflows/build.yml` у кандидатові: beta/main push та PR — tests/build без publication; release лише explicit manual main+publish_release=true+approved version+successful build. Build-only updater repo empty. Source `pc/version.cfg` repo empty. Production updater download/replacement **заборонено використовувати в тестовій beta** до окремого integrity/transaction fix; QA launchers встановлюють DF_NO_UPDATE=1. Релізи/теги/manual Actions не створюються. До merge remote main може мати старий workflow; main не чіпати.

## Відкриті дефекти й QA після інтеграції

OPEN: R03/R04 updater integrity/atomicity; R05 save durability/deep malformed/downgrade; R07 general untrusted command schemas; R18 shutdown leaks; global p99. Windows GUI18cases та full independent two-peer gameplay/reconnect/resync/host-change/Steam/LAN — **NOT RUN** і переносяться у Phase8 за явним рішенням власника.

[Phase8 QA plan](PHASE8_BETA_QA_PLAN.md). Exact merged origin/beta SHA, integration PR URL і фактичний статус старих PR записуються після операції в local `dist/phase7_20261120-224516/PHASE7_FINAL_REPORT.md` та `PHASE8_BETA_QA_PLAN.md` і фінальній відповіді. Поточний документ не оголошує майбутній merge виконаним. Якщо GitHub вимагає reviews/checks, PR лишається відкритим без bypass. Старі PR вручну не закривати; якщо GitHub залишить OPEN з усіма commits у beta, вказати superseded.
