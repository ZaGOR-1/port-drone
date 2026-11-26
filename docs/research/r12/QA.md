# R12 · QA кандидата e1cd267

> Історичний матеріал з `toolchain/performance/r12.VIKojgL3/evidence/QA.md`. [Реєстр досліджень](../INDEX.md)

- Python discovery 49/49 без SKIP. Simulation 2476, watchdog 101, ring 8, differential R10 49×2 з ідентичним JSON, HUD/input 36, L10N і version guard пройшли.
- C1200, D2100 та Late E пройшли 150/150 тіків. Покроково збіглися NetHash, RNG, маршрути, поля юнітів і споруд, Operations, watchdog, artillery та порядок команд. Late E підтвердив `f19767f333c29101` на 4693, `c9301a1dcbcd76e8` на 4746 і `3c338abc3ec9d5c7` на 4800. RNG `1940658711`. Wires чотирьох команд збіглися з історичним fixture.
- Активний D2100 Save/Load зі спільного базового та власного save збігся 66/66. ENet loopback, admission, reconnect, resync пройшли. Контракти PROTO 7, SIM_REV v036-integration-1, Save.FORMAT 1, 30 тіків/с, wire і допуск за повною версією збережено.
- Візуальні assertions 43/43 на варіант. Вісім PNG-пар попіксельно однакові, ordered binary draw traces ідентичні. Lifecycle 8/8 на варіант. У реальному Main під час teardown обидва варіанти повідомили 448 ObjectDB instances і 45 resources still in use. У цьому A-прогоні також був renderer Texture RID warning. Відомі resource issues, зокрема DummyTexture і mesh is null, лишаються відкритими.
- Unified df з DEV-02, official Godot 4.7.2, Linux x86_64 build і native smoke, Windows x64 build і Wine headless smoke пройшли. PCK обох платформ SHA256 `08b871436bf7bb2e466c012ccbdef65e4069f79d1911603c2edc13cae6a229c2`. Фізичний Windows GUI/A/B, LAN і Steam — NOT RUN. Linux native використано для QA.
