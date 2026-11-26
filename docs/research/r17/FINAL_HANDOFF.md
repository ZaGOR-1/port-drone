# R17 Final Acceptance · NOT RUN

> Історичний матеріал з `toolchain/performance/r17-final.JUKtXIpX/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

Libvirt підтвердив `win11 running`, ID 2, процес QEMU PID 230788. Для фінальної серії Profile B власник задав вимогу вимкненої Windows VM. Серія має 0 з 4 нових пар. Медіани та новий детермінізм відсутні. QA після GO, коміти R17, push і PR відкладені.

Звірено локальний R17 diff з R17C, SHA256 обох PCK, runtime та Late E fixture, поточні refs і stash. Після штатного завершення Windows VM можна запустити чотири пари на точних артефактах попереднього Profile B handoff. Звичайні користувацькі програми можуть працювати, окремий preflight не потрібен.
