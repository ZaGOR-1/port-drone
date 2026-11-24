# L10N-03 · Windows QA

Native Windows 11 — **NOT RUN**. Доступне Ubuntu з Wine. У libvirt system/session зареєстрованих VM немає. Перевірено чинний QA ZIP без повторної збірки.

| Артефакт | SHA256 |
| --- | --- |
| Windows x64 QA ZIP | `883668885c8f75e882b17b9330bbaac0e34c16e240c14da3e5f739eb1e3674c1` |
| DroneFlames.exe | `eb5060b3f6731c8bdbfc42637d9b4bf4b101c5d38b74ea37ca81ffdcec4543ad` |

`BUILD_PROVENANCE.json` і `QA-SHA256SUMS.txt` у ZIP підтверджують чистий source `0e8316e`, official Release template та DLL GodotSteam, WebRTC і Steam API. [CI Windows build і діагностика](https://github.com/ZaGOR-1/port-drone/actions/runs/45278752360)

| Платформа | Результат і межі |
| --- | --- |
| Ubuntu / Wine 10.0 | Повторно використано smoke саме цього EXE. Headless, `uk`, створення світу, exit 0. На виході зафіксовано повідомлення про витоки. |
| Linux GUI, L10N-02 | Переглянуто три мови, Settings і перезапуск, головне меню, New Game, Saves/Continue, HUD і план розвитку, штаб, економіку, дипломатію, порожню хроніку, tooltip, завантаження, офлайн MP і макет updater. При 960×540 переглянуто українські Settings і tooltip при UI scale 70/100/130%. Windows DPI має окремий gate. |
| Ubuntu / Godot headless, PCK з QA EXE | 11/11 перевірок. Створення й повторний запис синтетичного FORMAT1, завантаження нової точки, rollback з `bak`, відмова для пошкодженого слота, правильний підпис у `uk/ru/en` та цілісність іншого слота. |
| Ubuntu / Godot headless, локальний HTTP fixture | 42/42 перевірок updater. `uk/ru/en` для перевірки оновлень, помилок HTTP, size, checksum, write failure та кнопки продовження. За відповіді тієї самої версії, HTTP 503 і невалідного JSON керування переходило до запуску гри. HTTP 503 симулює недоступність сервісу. Справжній обрив мережі та окремий текст повторної спроби — NOT RUN. Синтетичний EXE не замінювався й не перезапускався. |

Для Windows використовуй `WINDOWS_QA_README.md`, `WINDOWS_QA_CHECKLIST.md` і `WINDOWS_QA_RESULTS.md` поруч із QA ZIP. Запиши платформу, Windows build, SHA EXE, мову, роздільність, Windows DPI, масштаб UI і точний шлях відтворення. Updater продовжуй на окремому debug fixture із локальним endpoint. Основний QA-пакет має порожній updater repo.
