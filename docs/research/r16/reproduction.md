# Відтворення R16

> Історичний матеріал з `toolchain/performance/r16.Z7ODtxEb/reproduction.md`. [Реєстр досліджень](../INDEX.md)

Потрібні точний source commit d6a38e8db58361430df69ffe0a98e628acac6d8b, DEV-02/unified df і official Godot 4.7.2. Після розпакування перевірте sha256sum -c SHA256SUMS.txt. Скопіюйте harness, fixtures та provenance/runtime-path.txt до нового каталогу у droneflames-toolchain/performance. Створіть порожні raw, build та source.

    git -C /home/zagor/projects/port-drone archive d6a38e8db58361430df69ffe0a98e628acac6d8b | tar -x -C source
    export DF_R09_TOOLCHAIN=/home/zagor/projects/droneflames-toolchain
    export DF_R09_RUNTIME="$(cat provenance/runtime-path.txt)"
    python3 prepare.py minimal source
    python3 run.py fresh-D2100 D2100 --ticks 120 --snapshot
    python3 run.py fresh-LateE late --mode headless --trace --fixed-clock --ticks 150

raw/*/config.json містить argv, effective workload, камеру, режим і бюджет кожного запуску. Використовуйте --pack detail для детальних scopes, --pack render16 для ізоляції рендерингу, --pack spotcounts для лічильників. run.py може підготувати фізичну копію пакета перед запуском, якщо її немає. screen.sh і follow.sh описують послідовність прогонів. orders[].wire_base64 у result.json містить серіалізовані команди fixture, які також відтворюються з коду та seed.

profile_summary та profile містять wall-clock scopes на головному потоці, з відніманням заміряних вкладених викликів. host.csv, threads.csv, pressure.csv містять періодичні відліки Linux. Pause робить redraw з фіксованим авторитетним станом. Headless виконує по тику за кадр без GUI. Синтетичний setup використовує прямий spawn і безплатне розміщення споруд.

Повторна обробка без запуску гри виконується через python3 analyze16.py. Для plot16.py потрібен локальний matplotlib, версії наведено у provenance/plotdeps.log. python3 verify16.py звіряє A/B trace.
