# Відтворення R27

> Історичний матеріал з `toolchain/performance/r27/REPRODUCE.md`. [Реєстр досліджень](../INDEX.md)

A — `1e912390394e6eafab004eb4d3ff82794dd2baeb`. B — той самий runtime з `candidate.patch`. Пінований Godot і пакети ідентифікує `builds.sha256`. `criteria.md` і його SHA256 зафіксовано до feasibility. Повторний аналіз із розпакованого архіву:

```bash
sha256sum -c SHA256SUMS
python3 summarize.py
python3 verify-proof.py
```

`summary.json` містить сирі scopes, абсолютні метрики та попарні зміни. `proof-summary.json` звіряє хеші, RNG, сторони, snapshot bytes і trace подій. Дві ENet перестановки працюють через 127.0.0.1 та production turn RPC. У `raw/*/config.json` записано точні аргументи, окрім ролей `enet-replay.py`.

Для нового запуску підготуйте фізичні копії A та B, копіюйте скрипти й fixtures до свіжого каталогу, підставте шляхи в `env.sh` і runner scripts. Для packing використовуйте pinned editor, спільний Linux release runtime та локальний QA clock R23. Діагностика feasibility використовує `prepare.py audit27 ...`. Інші пакети створюються через `prepare.py proof27-A|proof27-B|bench27-A|bench27-B ...`. Див. `run-feasibility.sh`, `run-proof.sh`, `run-proof-restore.sh`, `run-mutation.sh`, `run-counts.sh`, `run-gates.sh` та `run-pairs.sh`. Діагностику й benchmark запускайте послідовно. Аргументи, строки й DATA/CONFIG/CACHE профілі окремі для кожного плеча.

`r27_feed.gd` створює тестові артилерійські гармати й подає детерміновані цілі в штатний `_launch`. Між фазами зберігається симуляційний порядок. Цей fixture перевіряє навантаження від поєднання збігів і промахів. Він є контрольованим штучним workload. `audit27` завжди застосовує damage зі штатного скану. Тіньовий lookup і окремий headless count служать тільки feasibility. Приймальні CPU/tick/frame дані належать rendered Profile B.

XDG-профілі, caches і бінарні ігрові збірки залишено поза архівом. Include контрольних snapshots походить виключно із синтетичного тесту.
