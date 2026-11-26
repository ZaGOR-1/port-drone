# DroneFlames Development Environment v1

> Історичний матеріал з `toolchain/dev-environment/README.md`. [Реєстр досліджень](../../INDEX.md)

Один checkout гри на `beta`, окремий Windows x64 toolchain і діагностичний R01/R02 worktree. Ubuntu 26.04.1 amd64 збирає Windows-пакети. Windows 11 має окремі команди підготовки й перевірки. Статус нативного QA наведено у звіті.

```text
<workspace>/
├── port-drone/                            # спільний Git checkout
└── droneflames-toolchain/
    ├── dev-environment/                    # цей каталог
    ├── windows-dev/                        # df-windows, builds, official/patched
    ├── official-4.7.2/                     # Linux editor, Windows template
    ├── mingw-patched/                      # Release/QA, patch, pins
    ├── portable-sfx/                       # launcher, packager, кандидати
    ├── performance/source/                 # detached R01/R02 worktree
    └── godot-mcp-support/                   # launcher, bridge, shadow tooling
```

Задай `DF_WORKSPACE_ROOT` або передай `--workspace-root` / `-WorkspaceRoot`. `df-windows build --source` має пріоритет для checkout, `--engine-dir` задає каталог pinned editor/template.

- [Що скопіювати на SSD](../BACKUP_GUIDE.md)
- [Інвентар](../INVENTORY.md)
- [Ubuntu restore](../docs/RESTORE_UBUNTU.md) · [Windows 11 setup](../docs/SETUP_WINDOWS.md)
- [Codex, MCP і VS Code](../CODEX_MCP.md)
- [Архітектура](../docs/CROSS_PLATFORM_ARCHITECTURE.md) · [Межі](../KNOWN_LIMITATIONS.md) · [Disaster recovery test](../docs/DISASTER_RECOVERY_TEST.md)
- Manifest (`manifests/environment.json`) · Склад резервної копії (`manifests/backup-layout.json`)

```bash
./ubuntu/setup-ubuntu.sh --dry-run
./ubuntu/check-ubuntu.sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -v
```

Каталог підготовлений для майбутнього приватного toolchain repo. Артефакти, QA-дані та історичні архіви зберігай у сусідніх каталогах. Шаблони конфігурації в `manifests/`.

## Cross-Platform Build v1

Запускай `scripts/df --help`. [Windows build/run/SFX](../docs/CROSS_PLATFORM_BUILD.md) · [Linux readiness](../docs/LINUX_READINESS.md) · [R03–R06 backup](../../r03-r06/R03_R06_BACKUP.md)
