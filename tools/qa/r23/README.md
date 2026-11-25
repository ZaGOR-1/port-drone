# R23 · Офлайн-аналіз та валідація

Інструменти походять із перевіреного handoff R23 за [звітом](../../../docs/r23/R23_RESULTS.md). Потрібен Python 3.10+ і розпакований `DroneFlames-R23-handoff.tar.gz`. Спочатку звір SHA256 зовнішнього архіву й маніфест розпакованого комплекту.

```bash
handoff=/path/to/extracted-r23
reports=/path/to/new-r23-analysis
(cd "$handoff" && sha256sum -c SHA256SUMS)
python3 tools/qa/r23/analyze23.py "$handoff/harness" --out "$reports"
python3 tools/qa/r23/verify23.py "$handoff/harness" "$reports/summary.json"
```

Аналізатор читає збережені JSON/CSV і записує звіти поза handoff. Валідатор перевіряє точний набір прогонів і пар, повні вікна, збіг workload та контрольні хеші snapshots. Обидві команди працюють офлайн без Godot. Графіки й історичні GUI-команди збережено в оригінальному handoff.
