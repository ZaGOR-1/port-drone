# Локальний draft — НЕ опублікований PR

Назва: **Preserve OKREDU cumulative PC features and stabilize seasons, land consent and carrier lifecycle**

Head codex/fix-pr10-critical → base beta. Це текст майбутнього консолідованого PR після gates, не дозвіл merge.

PR10 містить усі commits PR1–9. Гілка зберігає їхню історію й авторство OKREDU та додає regression fixes: gameplay seasons незалежні від render cadence; людські земельні угоди потребують authorized acceptance; Ship ownership використовує c; Chronicle записує флот; carrier loss не створює null-base RTB.

Точна валідація: [PR10_REGRESSION_RESULTS](PR10_REGRESSION_RESULTS.md); root causes/правила: [PR10_CRITICAL_FIXES](PR10_CRITICAL_FIXES.md). PROTO7/FORMAT1/DLL незмінні; новий opaque simulation identity відокремлює builds. Старі saves перевірені у synthetic scope, downgrade не сертифікований.

Перед публікацією/merge: owner обирає один primary PR замість конкуруючого PR10; review із OKREDU; R02 fix; actual 2-peer compatibility/determinism/reconnect; Windows GUI checklist; review performance/shutdown diagnostics. Старі cumulative PR повторно не squash/cherry-pick. Fixes ще uncommitted, final commit SHA відсутній.

Ні PR, ні comments, ні закриття старих PR не виконані. Публікувати лише після дозволу й актуалізації результатів.
