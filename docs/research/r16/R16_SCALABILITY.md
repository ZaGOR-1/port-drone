# R16 · Scalability baseline 0.36.7

> Історичний матеріал з `archive/ARCHIVE-01/recovered-refs.tsv@c7c031febf06:docs/r16/R16_SCALABILITY.md`. [Реєстр досліджень](../INDEX.md)

Baseline d6a38e8db58361430df69ffe0a98e628acac6d8b. На Ubuntu, official Godot 4.7.2, RTX 4060 Laptop, Vulkan Forward Mobile. Медіани 3 прогонів D2100 20,27 FPS, dense D2100 14,82, D5000 9,80. Максимум 5000 активних у synthetic dense D5000 на початку вимірювання, 6,85 FPS, найгірше 8-секундне вікно 6,29 FPS. Фізичне Windows падіння до 2–3 FPS NOT_REPRODUCED, сейв проблемної партії власника відсутній. Фізичні Windows GUI/FPS, LAN і Steam — NOT RUN.

D2100 до 4800 відтворив історичний hash 1b05f1b5ed18fc7f. Між вікнами з 1040 активних юнітів frame p99 зріс 92,22 → 244,87 мс, pending очищено, RSS не зростав наприкінці. Розподілений D5000 до 945 дав 9,45 FPS та 1% low 2,20. Стала деградація 2–3 FPS відсутня. Пауза, headless, камера та роздільність показали брак часу головного потоку, з окремою значущою вартістю підготовки шарів при щільній камері.

На новому snapshot у тику 4816 1 554 664 full-registry visits в Operations._army та Operations._tick.membership_scan коштували 150,78 мс exclusive. На відновленому D5000 2 295 206 visits коштували 240,29 мс. R17 — впорядкований підбір за home у вузькій фазі Operations із перевіркою поточних rules, membership freshness, порядку, repeated restore та NetHash. Базовий grid maintenance 0,20–0,47 мс/тик, глобальна перебудова не має виміряного обґрунтування. Late E, D2100 і D5000 instrumented/minimal replay збіглися. Production gameplay не змінювався.

Повний звіт, sample frames, workload, scope details, long windows, графіки й snapshot SHA256 — у /home/zagor/projects/droneflames-toolchain/performance/r16.Z7ODtxEb/. Рекомендації R17 і ранні gates містяться в reports/ARCHITECTURE.md handoff.
