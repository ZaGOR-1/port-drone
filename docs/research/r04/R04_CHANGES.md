# R04 · Одна локальна зміна

> Історичний матеріал з `toolchain/performance/r04/R04_CHANGES.md`. [Реєстр досліджень](../INDEX.md)

`Army._advance` обчислює `reached` і `next_pos` один раз. Внутрішній `_dry_step` приймає готову позицію та виконує чинну перевірку. Після успіху `_turn` оновлює heading/frame без запису `pos`. Записується та сама проєкція. При відхиленні кроку збережено побічний ефект повернення на берег, відновлення cover і виклик `_blocked`. В обох гілках використано попередню послідовність округлення й арифметичних операцій. Критерій прибуття, шлях, repath, порядок оновлення юнітів і RNG збережені.

Патч відносно production змінює один файл `game/game/army.gd`. `_dry_step` має одного викликача. В ізольованих staging A і B файли `game/` відрізняються тільки цим файлом. Вилучено повторне обчислення позиції та повторний тест arrival, без додаткового кешу чи зміни схеми стану. Діагностичний P має окремі зміни підетапів. Diff (`R04_OPTIMIZED.patch`) · Збіг staging (`stage-game-diff.txt`)

## Відновлення запуску

Точний staged source кожної збірки збережений у `build-{P,A,B}/complete-pck-source.patch` і `STAGED_TREE` разом із перевіреним EXE, DLL і build provenance. QA збірки створені штатними `tools/build.py` і patched verifier із `df-windows`. Усі використовують готовий Release template. Непов'язані native/SFX компоненти та пін рушія збережені.

```bash
export PATH="/usr/lib/x86_64-linux-gnu/wine:$PATH"
# Profiling P, один сценарій у новий output.
DF_R02_MOVE_DETAIL=1 python3 run_r04.py --r02 D runs/profile-new --variant P \
  --units 2100 --ticks 270 --warm-ticks 45 --timeout 110
./test-r04.sh A B
./suite-r04.sh pilot
./suite-r04.sh benchmark
./suite-r04.sh regression
python3 summarize.py
```

Повтори створюють свіжі каталоги результатів. Історичний E snapshot та метадані включено до `inputs/e-long`. Wine prefix створюється локально в R04, до копії результатів профіль переносити не потрібно.
