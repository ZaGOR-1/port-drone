# Відтворення DroneFlames R23

> Історичний матеріал з `toolchain/performance/r23/handoff/REPRODUCE.md`. [Реєстр досліджень](../INDEX.md)

Архів містить сирі покадрові JSON, покадрові scopes, CSV хоста, stdout Godot, full-process time/RSS, fixtures, інструменти, таблиці та PNG. R23 використовує harness R22 з вимірюванням thread CPU з NATIVE-02C. Сценарії та snapshot D2100 restore походять із R16. Оригінальні артефакти зберігаються у своїх каталогах.

## Аналіз

З кореня розпакованого архіву:

```bash
sha256sum -c SHA256SUMS
cd harness
export PYTHONDONTWRITEBYTECODE=1
python3 analyze23.py
python3 verify23.py
python3 tables23.py > reports/tables.md
# matplotlib 3.11.2, numpy 2.5.5, Python 3.14.4
python3 plot23.py
```

`reports/summary.json` містить поіменні прогони, перевірки workload, inclusive та exclusive CPU і 300-тікові вікна long-run. `absolute.csv`, `paired.csv` і `long.csv` придатні для незалежної обробки. Використайте `raw/*/config.json` для точних аргументів окремого плеча. У `raw/*/result.json` є повні wire bytes синтетичних команд, NetHash, RNG і workload. `raw/*/time.txt` містить peak RSS за весь процес, `host.csv` та `system.csv` — періодичні відліки.

## Новий прогін

У свіжий каталог скопіюйте скрипти, `fixtures/`, `clock/` і `packproj/` з `harness`. У сусідніх із `harness` каталогах створіть три detached worktrees. Команди нижче запускаються з каталогу, який містить `harness`. `DF_SOURCE_REPO` вказує на локальний Git-репозиторій DroneFlames.

```bash
git -C "$DF_SOURCE_REPO" worktree add --detach "$PWD/source-4" d8114afac56c2475ca9ded5bd8627d4d42000041
git -C "$DF_SOURCE_REPO" worktree add --detach "$PWD/source-7" d6a38e8db58361430df69ffe0a98e628acac6d8b
git -C "$DF_SOURCE_REPO" worktree add --detach "$PWD/source-11" f629882296a3419b2e1dc298619f83072c1320f9
cd harness
export DF_R09_TOOLCHAIN=/path/to/droneflames-toolchain
export DF_R09_RUNTIME=/path/to/official/INT12/DroneFlames-Linux
bash prepare-all.sh > prepare.log 2>&1
bash matrix.sh > matrix.log 2>&1
bash run-detail.sh > detail.log 2>&1
bash run-targeted.sh > targeted.log 2>&1
python3 analyze23.py
python3 verify23.py
python3 tables23.py > reports/tables.md
python3 plot23.py
```

`DF_R09_TOOLCHAIN/official-4.7.2/godot` — редактор/пакувальник. `DF_R09_RUNTIME` містить спільний release template `DroneFlames.x86_64` і Linux native addons. Звірте SHA256 із `evidence/artifacts.tsv`. Готовий PCK INT-12 використано як джерело provenance для runtime. Для кожного SHA скрипт створює фізичну копію `game/`, додає діагностичні хуки й пакує її. Порядок файлів у PCK залежить від обходу файлової системи. SHA256 у handoff ідентифікує фактичні пакети вимірювання. Рушій використовується в готовому вигляді.

Потрібен доступ до desktop X11, Vulkan Forward Mobile, GPU index 1 у Godot для RTX 4060 Laptop і NVIDIA telemetry. При відтворенні на іншому обладнанні явно задайте та зафіксуйте GPU. Роздільність 1280×720, scale/graphics за чистим профілем fixture, fixed camera, zoom 100%, VSync і cap вимкнено, audio Dummy. Runner створює унікальні XDG DATA/CONFIG/CACHE для кожного плеча. Profile B записує звичайне фонове навантаження під час вимірів. Виконуйте плечі послідовно. Порядок версій задає `matrix.sh`. Для підсумкової причинної інтерпретації звірте `proof` і фактичні умови CPU/пам’яті.

В архіві зберігаються файли, потрібні для відновлення доказів. Runtime та великі PCK доступні в локальних `stage-*` з указаними SHA256. Приватні XDG-профілі та сторонні saves перебувають поза архівом.
