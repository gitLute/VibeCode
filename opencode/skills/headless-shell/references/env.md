# Переменные окружения, отключающие промпты

Проставляй префиксом к команде, если нужно точечно: `CI=true git ls-remote …`.
Для постоянного действия — экспортируй в окружение сессии.

| Переменная | Значение | Назначение |
|---|---|---|
| `CI` | `true` | Общий детект CI |
| `DEBIAN_FRONTEND` | `noninteractive` | Apt/dpkg |
| `GIT_TERMINAL_PROMPT` | `0` | Git auth: отказ вместо ожидания логина и пароля |
| `GIT_EDITOR` | `true` | Блокировка редактора git |
| `GIT_PAGER` | `cat` | Отключение пейджера git |
| `GIT_SEQUENCE_EDITOR` | неинтерактивная команда | Автоматизация `git rebase -i` |
| `PAGER` | `cat` | Общий пейджер |
| `MANPAGER` | `cat` | Справка `man` без пейджера |
| `SYSTEMD_PAGER` | `cat` | systemctl без пейджера |
| `GCM_INTERACTIVE` | `never` | Git credential manager |
| `HOMEBREW_NO_AUTO_UPDATE` | `1` | Homebrew |
| `npm_config_yes` | `true` | Промпты npm |
| `PIP_NO_INPUT` | `1` | Pip |
| `PIP_ROOT_USER_ACTION` | `ignore` | Pip не спрашивает про внешнее окружение (PEP 668) |
| `YARN_ENABLE_IMMUTABLE_INSTALLS` | `false` | Yarn lockfile |
| `NO_COLOR` | `1` | Отключение цветов в выводе |

## Готовые строки

```bash
# Полный набор для одной команды обёртки
CI=true DEBIAN_FRONTEND=noninteractive GIT_TERMINAL_PROMPT=0 \
  GIT_EDITOR=true GIT_PAGER=cat PAGER=cat MANPAGER=cat NO_COLOR=1 cmd

# Git без единого промпта
GIT_TERMINAL_PROMPT=0 GIT_EDITOR=true GIT_PAGER=cat git log -n 10

# Автоматизация интерактивного rebase: оставить только pick
GIT_SEQUENCE_EDITOR="sed -i '/^pick/!d'" git rebase -i main
```

## Осторожно с секретами

Токены и пароли передавай через уже существующие переменные окружения, а не
литералами в команде: литерал попадёт в историю, логи и `ps`. Не записывай
секреты в файлы проекта, отчёты и нотификации.
