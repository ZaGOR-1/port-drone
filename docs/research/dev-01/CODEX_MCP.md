# Codex, MCP і VS Code

> Історичний матеріал з `toolchain/dev-environment/docs/CODEX_MCP.md`. [Реєстр досліджень](../INDEX.md)

Встанови за версіями з manifest (`../manifests/environment.json`). Відкрий локальний `~/.codex/config.toml` або `$CODEX_HOME/config.toml` і додай потрібні записи з шаблону (`../manifests/codex.mcp.example.toml`). Онови шлях Godot launcher. Виконай `codex mcp list`, а потім перевір конкретний сервер у новій сесії. OAuth і PAT додавай локально після перевстановлення ОС. [Codex MCP](https://developers.openai.com/codex/mcp)

| MCP | Відтворення |
| --- | --- |
| Serena | `uv tool install serena-agent==2.1.0`; увімкни GDScript/LSP для фізичної shadow-копії в локальній конфігурації Serena. Почни з read-only режиму. |
| Context7, Playwright, Chrome DevTools, draw.io | Node/npm, команди `npx` у шаблоні. Для offline потрібні окремі npm cache і браузери. Для строгого повтору зафіксуй npm версії після перевірки. |
| Semgrep | `uv tool install semgrep==1.186.0`, потім `semgrep mcp`; використовуй для підтримуваних мов. |
| Figma, GitHub | Remote MCP із шаблону. Повтори Figma OAuth. GitHub PAT із потрібними scopes передай через змінну середовища `GITHUB_PAT_TOKEN` із password manager. |
| Godot MCP | Ubuntu binary та addon у Essential. Джерело й ревізія в manifest. Запуск через `godot-mcp-support/launch-shadow mcp`. Для Windows використовуй платформний сервер і окремий фізичний shadow; Ubuntu Bash launcher потребує портування. |

Зберігай пул дозволених команд, серверів, назви змінних середовища та відносні шляхи в шаблонах. Перенось приватний `config.toml` лише після ручної перевірки, у зашифрованому сховищі за необхідності. Auth/session files, SSH keys, браузерні cookie, Codex history, OAuth та PAT зберігай за процедурою [BACKUP_GUIDE](BACKUP_GUIDE.md). Під час інвентаризації звірено лише назви серверів та типи launcher.

У production checkout VS Code settings відсутні. Зразки для нового `.vscode/settings.json` і `.vscode/extensions.json` є в `manifests/`. За потреби відкрий фізичний shadow редактором Godot окремо і вкажи шлях Godot в локальних VS Code settings. Глобальні налаштування, workspace history, extensions cache і `.serena/project.local.yml` лишаються локальними. Підтримувані базові опції VS Code легко відновити за шаблонами.
