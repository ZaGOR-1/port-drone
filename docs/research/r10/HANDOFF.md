# DroneFlames 0.36.4 · R10 handoff

> Історичний матеріал з `toolchain/performance/r10.sgT1Rl0N/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

[R10_RESULTS.md](../../r10/R10_RESULTS.md) описує патч, докази еквівалентності, A/B та відкритий Windows QA. `R10_RESULTS.json`, `R10_RAW_FRAMES.csv` і `R10_CPU_SCOPES.csv` містять зведення й покадрові дані. У `raw/<run>/` є оригінальні JSON, аргументи, відомості про фактичне навантаження, журнали, telemetry CSV, фінальні snapshots та синтетичний дисковий save. `provenance/` містить Git diff, відбитки PCK/toolchain і версії діагностичних скриптів. `qa/` і `post/` містять тести, build provenance та результати smoke. У runtime-пакетах є окремі маніфести для кожного файлу. Перевірка цього архіву виконується командою `sha256sum -c SHA256SUMS.txt` із кореня розпакованого handoff.

## Пакети

- Linux native QA `/home/zagor/projects/droneflames-toolchain/performance/r10.sgT1Rl0N/packages/DroneFlames-0.36.4-Linux-x86_64-QA.tar.gz`.
- Windows official portable QA `/home/zagor/projects/droneflames-toolchain/performance/r10.sgT1Rl0N/packages/DroneFlames-0.36.4-Windows-x64-QA.zip`.
- Відбитки обох архівів у `packages/SHA256SUMS.txt`. Однаковий PCK перевірено всередині Windows EXE та Linux-пакета. Updater repo порожній. Архів Windows містить EXE й штатні DLL для QA.

## Відтворення

Розпакувати handoff в окремий каталог безпосередньо під `droneflames-toolchain/performance`. Перед запуском зберегти наявні `raw`, `qa` і `post` поза робочим каталогом, щоб повторний прогін мав порожні вихідні каталоги. Знадобляться той самий pinned DEV-02, RTX 4060 Laptop GPU з X11 та official runtime у `provenance/runtime-path.txt`. Якщо runtime перенесено, можна передати `DF_R09_RUNTIME`. Для portable A потрібен вихідний checkout, у якому доступний SHA бази. Передати абсолютний шлях до worktree кандидата як `r10_repo`.

```bash
export DF_PERF_SOURCE=/home/zagor/projects/port-drone
./portable/source r09 source
mkdir raw
r10_repo=/home/zagor/projects/port-drone-r10
bash matrix-r10.sh "$r10_repo"
bash suite-r10.sh "$r10_repo"
bash trace-fixed-r10.sh
bash save-r10.sh
bash dense-r10.sh cluster-fixed
bash profile-fixed-r10.sh "$r10_repo"
python3 summarize-r10.py
python3 tables-r10.py
```

Запускати GUI вимірювання послідовно. `profile-fixed-*` та `audit-fixed-*` — джерело підсумкових CPU-таблиць і лічильників. `profile-*` та `audit-*` залишені як діагностика першої спроби з неповним реєстром міток вкладених таймерів. Для покрокового C1200 джерело — `trace-fixed-C1200-*` з однаковим frame delta. Початкові `trace-C1200-*` і декодоване порівняння Operations snapshot збережені для пояснення відмінності часу HUD-підказки.
