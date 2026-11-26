# R18B acceptance · GO

> Історичний матеріал з `toolchain/performance/r18b-profile-b.gFaqgQ6i/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

[Повні метрики, контрольні пари та CPU breakdown](RESULTS.md). JSON (`reports/profile-b.json`). [Взаємодія з R17](rebase-review.md). [Draft PR #18](https://github.com/ZaGOR-1/port-drone/pull/18).

База `117781083ff108c8353b9e53a3eda3d49bedd0fe`, версія 0.36.8. Production commit `b33d49cf0a70ed01cd36d0aae79b93497475ab31`, документаційний `800a251`. Повний rebase diff у `provenance/r18b.patch`. Початкові commit `6d83ef9`, локальний diff документації і handoff R18A збережено. Опубліковано лише `perf/impact-candidate-enumeration`; локальний оновлений worktree використовує гілку `perf/impact-candidate-enumeration-r18b`, історичний worktree далі тримає початкову локальну гілку. Beta/main, stash і історичні worktrees звірено.

- Детермінізм PASS. 330/330 покрокових збігів, усі A/B пари підтвердили NetHash, RNG, команди та workload. R18 core 42/42, city rail callback 7/7, ArmyFire 59/59, R17 differential 33/33 на A/B. Повторний restore Late E двічі на варіант. QА fixture R17 у першій standalone спробі відхилив untyped empty Array. В ізольованій копії fixture використано `Array[Unit]` з тією самою заміною. Початковий журнал і diff тесту збережено.
- Simulation regression 2476/2476. ENet reconnect/resync PASS. Старий і власний disk save збіглися за 66-тиковим продовженням і NetHash `fa5ad6f5e571e226`. Lifecycle B від тика 4800 до 5160, NetHash `efe7eeae801431dc`. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1, 30 тіків/с.
- Official Linux і Windows x64 PASS. PCK SHA256 `38f043b345dcd864bd64f08ac95751977b346022cc69ca1df952b8e21ec7420d`. Linux native і Wine smoke PASS. Відомі teardown повідомлення лишилися. Порівняння видимих попереджень із INT-09 в `evidence/exit-warnings.diff`.
- Windows A/B kit і SHA256 у `windows-ab/`. Linux build у каталозі, на який вказує `official/linux-path.txt`. Фізичний Windows A/B, LAN і Steam — NOT RUN.
- При вимірюванні 981 457 рангів отримано 72,72 мс CPU за медіаною. Локальна clock GDExtension використовує заголовок саме pinned 4.7.2, компілюється окремо від рушія і лишається в QA. Усі patch/clock/runner входи, сирі метрики й SHA пакунків збережено. [Документація C API Godot](https://docs.godotengine.org/en/stable/engine_details/engine_api/gdextension/index.html)
