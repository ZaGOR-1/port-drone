# DroneFlames R17 Final Acceptance · GO

> Історичний матеріал з `toolchain/performance/r17-final-profile-b.9tC9OIb6/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

[Чотири Late E A/B-пари та аналіз](decision.md). Метрики всіх плечей (`reports/profile-b-series.json`). Порядок A/B, B/A, B/A, A/B, 150 тіків. Стан `c3ba32fe4eed13e3` → `3c338abc3ec9d5c7`, RNG `1940658711`, wire payload 760 байтів і чотири команди на контрольному turn. Усі плечі відповідають контрольним. Вісім вимірів виконано з активною Windows VM. Висновок GO спирається на порівнювані умови, узгоджений напрямок FPS і tick p99 та frame-time розподіл. Абсолютні метрики стосуються виміряної Ubuntu-сесії.

## QA

- PASS simulation regression 2476/2476, disk Save/Load 22/22 і 320 тіків після load, ENet admission із сумісним peer та відхиленням несумісних версій, двопроцесні ENet reconnect/resync.
- PASS 600-тіковий lifecycle control D2100 від тика 4800 до 5400, hash `556f1c291dab675f`. Зафіксовано 37 викликів membership build і 74 очищення, без спрацювання діагностичної перевірки на утримання посилань після Operations phase.
- PASS official Linux і Windows x64, PCK parity `c9a3cd406a2c458d38d5f7baf9d441069418db1a065fac050d945119501f3a05`, Linux native і Wine headless smoke. Відомі повідомлення Godot про ресурси на виході є в логах.
- Попередні D2100/D5000 gates, differential 37/37 і repeated restore застосовано за SHA256. Фізичний Windows A/B, LAN і Steam — NOT RUN.
- Windows A/B комплект містить наявний official baseline ZIP, новий official R17 ZIP і спільний синтетичний D2100 disk save. SHA256 і інструкція в `windows-ab/`. Linux bundle і розпакований Windows package лежать за шляхами в `official/linux-path.txt` та `official/windows-path.txt`.

## Git

Draft PR [#17](https://github.com/ZaGOR-1/port-drone/pull/17) до beta. Опубліковано лише `perf/operations-membership-lookup`, production commit `617c580` і документаційний `b7a3178`. Ідентичність game tree звірено після документаційного коміту. Version 0.36.7. Beta, main, R18A, worktrees та stash `40a9f64` збережено. R18B не запускався.

Архів доказів містить сирі метрики, логи, SHA256 provenance і маніфест Windows A/B. Великі збірки й Windows ZIP зберігаються окремо в цьому handoff.
