# DroneFlames · R06

> Історичний матеріал з `toolchain/performance/r06/README.md`. [Реєстр досліджень](../INDEX.md)

Локальний звіт і відтворювані докази для експерименту з підготовкою PENDING наказів.

- [Аналіз](R06_ANALYSIS.md), [PoC та diff](R06_CHANGES.md), [A/B](R06_AB_RESULTS.md), [детермінізм](R06_DETERMINISM.md), [R07](R06_NEXT_STEPS.md).
- Зведення JSON (`R06_RESULTS.json`), CSV (`R06_FRAMES.csv`), E trace (`R06_TICK_TRACE.json`) і raw каталоги runs.
- SHA256 (`R06_SHA256SUMS.txt`), provenance A (`build-A/package/BUILD_PROVENANCE.json`), provenance B (`build-B/package/BUILD_PROVENANCE.json`).

Для повтору з наявними EXE на тому самому хості:

```bash
sha256sum --strict -c R06_SHA256SUMS.txt
./reproduce.sh rerun
python3 analyze.py --runs rerun --out rerun
./test-r06.sh A B
./regression-linux.sh
```

A та B мають окремі package, BASE_COMMIT, STAGED_TREE, complete-pck-source.patch і runtime-profile.json. Щоб відновити staging без копій build-A/source та build-B/source, потрібен чистий фізичний checkout на BASE_COMMIT. Застосуй complete-pck-source.patch відповідного варіанта в цю копію та звір індекс із STAGED_TREE. Для повторного пакування потрібні наявний official editor 4.7.2, patched template SHA256 із runtime-profile.json та Windows libs репозиторію. build-r06.sh пакує поточний локальний стан R06/source через наявні tools/build.py і windows-dev/verify-patched.py. A і B можна відтворити у двох нових ізольованих копіях з відповідними source patches. До benchmark builder перевіряє копію template й готовий пакет. Його стандартний чистий git-revision workflow не переносив би незакомічений PoC.

Для наступного backup достатньо звітів, сценарію inputs/e-long, скриптів, raw runs, tests результатів і SHA256-списку разом із файлами, які він перелічує. stage-game-diff.txt і статуси *.before/*.after також варто зберегти. Дві фізичні staging-копії, витягнуті PCK і локальний wine-r02 можна відтворити. Вміст Wine prefix і його користувацьких профілів краще залишити поза резервною копією R06.
