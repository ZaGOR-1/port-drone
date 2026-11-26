# INT-02 · DroneFlames 0.36.1 у beta

> Історичний матеріал з `toolchain/int02.50NeyJ/RESULTS.md`. [Реєстр досліджень](../INDEX.md)

**PASS для інтеграції й очищення.** Фізичний Windows QA відкладено власником, статус NOT RUN.

[PR #10](https://github.com/ZaGOR-1/port-drone/pull/10) об’єднано звичайним merge commit. Його перший батько — попередня beta, другий — погоджений кандидат. GitHub автоматично позначив #7, #8 і #9 як Merged, їхні SHA перевірено як предків нового beta.

| Об’єкт | SHA |
| --- | --- |
| Стара beta | `c91e0e6a7eef831687e6e63550560bba739a6b87` |
| Кандидат | `f3db608d77a8d7f78af22c6122108962e5f3c75f` |
| Нова beta | `11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b` |
| Повне дерево кандидата і beta | `0f97159041c77942b9ce4a6ab86fbff69a495c59` |
| Дерево game/ | `26dd6975cf20e987d4db703f1cabde4e85483cb0` |
| origin/main | `172df65e3bd004efed9a5444e90a284d9d69db10` |

Обидва прогони CI пройшли Python і policy, discovery з Godot 47/47, L10N 125/125, HUD і ввід 36/36, simulation 2476/2476, build identity та Windows x64. Release job SKIPPED штатно. Git refs, GitHub releases і deployments звірено до та після. Нових тегів, релізів або deployments немає. [CI PR](https://github.com/ZaGOR-1/port-drone/actions/runs/45403507530) · [CI beta](https://github.com/ZaGOR-1/port-drone/actions/runs/45404484832)

## Очищення

Локально через `git branch -d` і в origin видалено `feature/development-standards-l10n`, `fix/hud-camera-input`, `perf/otrk-target-selection` та `integration/qa-v0.36.1`. Відновлюваність refs перевірено з bundle. Worktree `port-drone-fix-hud-input` був чистий і видалений звичайним `git worktree remove`. Worktree `port-drone-standards-l10n` збережено з ігнорованим `tools/__pycache__/`. `port-drone-perf01` та `port-drone-integration-qa` збережено для наявних QA tooling links. Ці три checkout мають detached HEAD на попередніх SHA. Основний `/home/zagor/projects/port-drone` оновлено fast-forward до origin/beta. Робоче дерево чисте за звичайним Git status, локальна ігнорована `.serena/` збережена. AGENTS.md містить нові Development Standards.

## Пакет і відкриті перевірки

Версія `0.36.1`, `PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1`. ZIP має provenance кандидата з тим самим деревом, що й нова beta. SHA256 перевірено повторно.

- ZIP `/home/zagor/projects/droneflames-toolchain/integration-qa-v0.36.1/DroneFlames-0.36.1-Integration-QA-Windows-x64.zip`
- SHA256 `55f5c7a4e2d7780d608fb0fcfffe0db5ffecc4b6461182f19394dd0ab312d986`
- Windows native, DPI, фізичний LAN/Steam — NOT RUN. Відкриті затримка ОТРК при дефіциті боєзапасу, Linux OpenGL `mesh is null` і завершення Linux процесу після X11 close. [INT-01](../int01/RESULTS.md)

## Rollback

В окремій гілці від актуальної `origin/beta` звірити батьків `11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b`. Виконати `git revert -m 1 11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b`. Відкрити PR до beta, дочекатися CI та review. Перевірити версію, Windows x64 package identity, Save/Load та multiplayer fixtures перед прийманням.
