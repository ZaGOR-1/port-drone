> Історичний матеріал з `toolchain/performance/perf02/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## PERF-01

На базі `beta c91e0e6` відтворено поступове погіршення відгуку при масовому виборі цілей ОТРК. Перехід 199 → 200 → 201 показав продовження загальної залежності. Клік виконував повний план тільки для перевірки запасу. Статичні приціли генерували 12 примітивів на ціль у кожному кадрі.

Клік ОТРК тепер читає готовий боєзапас штатним методом. Для попередніх цілей RouteOverlay використовує приціл, запечений із PathKit. Активний приціл, траєкторія, підписи й ігрові команди використовують чинні шляхи. Джерело PATCH-версії кандидата — `130dce257aa0f94aed09d1db3e62efcaf1671802`.

| Цілей | Клік A → B, мс | FPS A → B | Кадр p95 A → B, мс | Кадр p99 A → B, мс |
| ---: | ---: | ---: | ---: | ---: |
| 200 | 24,93 → 0,69 | 11,5 → 15,1 | 106,76 → 86,20 | 112,74 → 92,74 |
| 300 | 38,12 → 0,29 | 8,6 → 12,4 | 141,14 → 107,06 | 144,35 → 110,50 |
| 500 | 53,29 → 0,46 | 6,0 → 9,2 | 201,25 → 147,10 | 206,05 → 152,25 |

Дві пари A/B виконано в Linux GUI на llvmpipe з однаковим початковим NetHash. На 500 цілях підготовка рендерингу зменшилась з 25,41 до 12,67 мс/кадр і draw calls з 8 809 до 4 817. Підтвердження 500 цілей залишилося приблизно 106 мс. [Повна A/B таблиця](https://github.com/ZaGOR-1/port-drone/blob/6748e3e3cd76116ed46d18c2729bc405f911b46f/docs/perf01/PERF01_AB_RESULTS.md)

- Однакові wire payload, порядок, черги і NetHash для 50, 200, 300 і 500 цілей. Simulation 2476/2476, Python discovery 43/43, UI 20/20, keyboard 130/130, scale 26/26. [Детермінізм](https://github.com/ZaGOR-1/port-drone/blob/6748e3e3cd76116ed46d18c2729bc405f911b46f/docs/perf01/PERF01_DETERMINISM.md)
- Локальний Windows ZIP 0.36.1 через `df`, official Godot 4.7.2. Wine headless і GUI smoke та Linux smoke пройшли. ZIP SHA256 `9988c5be2ab641d67eb61b7cfaa4acfb8b1b99e7425f09aaebb1973cc7ab76e5`. [Пакет і план QA](https://github.com/ZaGOR-1/port-drone/blob/6748e3e3cd76116ed46d18c2729bc405f911b46f/docs/perf01/PERF01_WINDOWS_QA.md)
- Фізична Windows 11 GUI, Steam і LAN — NOT RUN. Потрібна повторна перевірка на ПК, де повідомлено про лаги. PR #7 і #8 залишаються окремими.


## PERF-02. Підтвердження й preview

Для синхронного залпу лише ОТРК план ETA застосовується в тому самому виклику. Змішані та відкладені залпи використовують свіжі перевірки. Спільний планувальник читає готовність і координати установок один раз за виклик. Періодичність preview збережена.

| Цілей | Підтвердження A → B, мс | CPU preview A → B, мс/кадр | p95 / p99 A → B, мс |
| ---: | ---: | ---: | ---: |
| 200 | 56,94 → 8,20 | 2,227 → 0,956 | 88,11 / 88,22 → 74,51 / 80,45 |
| 300 | 77,83 → 13,12 | 3,149 → 1,317 | 113,48 / 118,40 → 83,59 / 85,44 |
| 500 | 107,27 → 16,62 | 4,604 → 2,046 | 149,70 / 153,27 → 106,35 / 112,80 |

Підтвердження на 500 цілях викликає планувальник один раз. У 15 парах сценаріїв збіглися черги, wire payload, перша хвиля, RNG і NetHash. Перша хвиля звичайного залпу стартує на кроці 92. Simulation regression 2476/2476 і Python discovery 43/43. [A/B](https://github.com/ZaGOR-1/port-drone/blob/c2cbb9086cad700a34ab03f978267633d2427602/docs/perf02/PERF02_AB_RESULTS.md) · [Детермінізм](https://github.com/ZaGOR-1/port-drone/blob/c2cbb9086cad700a34ab03f978267633d2427602/docs/perf02/PERF02_DETERMINISM.md)

Контрольовані CPU заміри виконано headless. Frame-time отримано окремо в Linux GUI на llvmpipe. При 500 цілях і зменшенні запасу до 420 ракет у кандидата залишився дорогий пошук причин для непризначених цілей, близько 91 мс загалом. [CPU і ризики](https://github.com/ZaGOR-1/port-drone/blob/c2cbb9086cad700a34ab03f978267633d2427602/docs/perf02/PERF02_ANALYSIS.md)

Windows x64 ZIP `DroneFlames-PERF02-Windows-x64-c2cbb908.zip` із HEAD `c2cbb9086cad700a34ab03f978267633d2427602`. Версія `0.36.1`, Godot `4.7.2.stable.official.ed1daf0bf`, SHA256 ZIP `771d9e19e3985147278e55e6eb291ed02f760779003a05ebc1dc54ed1cf1d0f9`. Перевірено EXE і DLL. Wine headless/GUI і Linux headless smoke пройшли. Native Windows GUI/LAN/Steam — NOT RUN. Windows FPS — INCONCLUSIVE. Потрібен A/B зі старим ZIP PERF-01 на одному фізичному ПК. [План Windows QA](https://github.com/ZaGOR-1/port-drone/blob/c2cbb9086cad700a34ab03f978267633d2427602/docs/perf02/PERF02_WINDOWS_QA.md)
