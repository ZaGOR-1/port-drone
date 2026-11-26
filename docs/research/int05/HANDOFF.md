# INT-05 · R08 у beta 0.36.4

> Історичний матеріал з `toolchain/int05.qp8pp1c0/handoff/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

[PR #13](https://github.com/ZaGOR-1/port-drone/pull/13) інтегровано звичайним merge commit. Попередня beta `690915646ec0186b5086cd254dcd6b8eab85f6c0`, нова beta `d8114afac56c2475ca9ded5bd8627d4d42000041`, кандидат `5842d633a510e939aa2d21155a7fc214088a0da8`, повне спільне дерево `7990376d039586fe548ed2eae90bbd3f6a6f2145`. Version bump `5e0507a4b871c4d05ed7991908cdf053ea0debca`. Main `172df65e3bd004efed9a5444e90a284d9d69db10`. Releases, теги та GitHub deployments відсутні. [CI до merge](https://github.com/ZaGOR-1/port-drone/actions/runs/45473355703) · [CI після merge](https://github.com/ZaGOR-1/port-drone/actions/runs/45474309953)

Після fast-forward основний checkout `/home/zagor/projects/port-drone` має узгоджені HEAD, index і вміст усіх tracked файлів. Локальну та віддалену `perf/lockstep-command-execution` видалено після перевірки Git bundle. Шлях worktree R08 потрібен історичному runner, тому worktree лишено detached на `e028f92`. Stash `40a9f64` збережено без застосування.

Локальні перевірки відтворили Python 48/48, simulation 2476/2476, watchdog 101/101, тести кільця 8/8 та HUD 36/36 у трьох ізоляціях. Результати review й відтворюваний DummyTexture defect описані в `evidence/REVIEW.md`. Late E 150/150, Save/Load 66/66, ENet reconnect/resync та повноверсійний gate успішні. Історичний FPS INCONCLUSIVE. Фізичний Windows QA відкладено власником. Фізичні LAN і Steam NOT RUN.

## QA-пакети

- `/home/zagor/projects/droneflames-toolchain/int05.qp8pp1c0/packages/DroneFlames-0.36.4-Windows-x64-QA.zip`
- `/home/zagor/projects/droneflames-toolchain/int05.qp8pp1c0/packages/DroneFlames-0.36.4-Linux-x86_64-QA.tar.gz`

Пакети зібрано з merge SHA на official Godot 4.7.2. SHA256 спільного PCK `b379ba2066219182d9614eb5699e7ceb0e7a35773658fd609299dc285538a509`. Розміри, SHA256, native files і build provenance у `provenance/`. Linux native та Wine headless пройшли після розпакування.

## Відновлення Git

Почни з чистої beta `690915646ec0186b5086cd254dcd6b8eab85f6c0`, відновленої через DEV-02 та попередні increments до INT-04. У каталозі handoff виконай `sha256sum -c SHA256SUMS.txt`.

```bash
bundle='/absolute/path/to/handoff/beta-0.36.4.increment.bundle'
git bundle verify "$bundle"
git fetch "$bundle" refs/heads/beta:refs/remotes/int05/beta
git merge --ff-only refs/remotes/int05/beta
git rev-parse HEAD
python3 tools/build.py --print-version
```

Очікуваний HEAD `d8114afac56c2475ca9ded5bd8627d4d42000041`, версія 0.36.4. Незалежний клон пройшов перевірку дерева, індексу, файлів, ancestry й fsck. Вершина історичної гілки й перевірений кандидат доступні в історії після імпорту.

## Відкат через PR

Від актуальної origin/beta створи окрему `revert/int05-r08` і виконай `git revert -m 1 d8114afac56c2475ca9ded5bd8627d4d42000041` в її worktree. Перевір diff, build guard, save й мережеві регресії, після чого подай revert PR до beta на review. Повний revert прибирає зміни PR #13, включно з PATCH bump. Якщо beta вже просунулася, звір версію з чинною політикою.

## R09

[Контекст R09](r09/README.md) містить Late E snapshot, C1200, D1920/D2100, runner, fixtures і шляхи до сирих профілів. У всіх трьох optimized прогонах R08 найдовший кадр був на тику 4746. Новий profiling suite не запускався.
