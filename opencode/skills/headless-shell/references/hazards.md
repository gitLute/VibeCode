# Каталог зависаний

Команды ниже не требуют прав root, но без TTY зависают или уходят в интерактивный
диалог. Список шире, чем в шпаргалке: сюда попало всё, что не покрыто таблицами.

| Команда | Что запрашивает | Неинтерактивный вариант |
|---|---|---|
| `less`, `more`, `most`, `pg` | постраничный просмотр | `GIT_PAGER=cat`, `PAGER=cat`, либо флаг `--no-pager` у git |
| `man` | пагинация | `--no-pager` не помогает — читай `--help` или документацию через web-поиск |
| `git add -p` | выбор hunks по одному | `git add .` или `git add <файл>` |
| `git rebase -i` | редактор todo-списка | `git rebase --onto base branch` либо `GIT_SEQUENCE_EDITOR=…` |
| `git commit` без `-m` | открывает редактор | `git commit -m "…"` |
| `git tag -a` без `-m` | открывает редактор | `git tag -a v1.0 -m "…"` |
| `git notes` | открывает редактор | `git notes -m "…" add <commit>` |
| `git push` без токена | логин и пароль | `GIT_TERMINAL_PROMPT=0` — быстрый отказ вместо ожидания ввода |
| `python`, `node`, `irb`, `ghci` без скрипта | REPL ждёт строку | `-c "код"`, `script.py`, `< /dev/null` |
| `ssh`, `scp` без `BatchMode` | подтверждение ключа хоста, пароль | `-o BatchMode=yes -o StrictHostKeyChecking=accept-new` |
| `ssh-keygen` без `-N ""` | passphrase | `ssh-keygen -N "" -t ed25519 -f <путь>` |
| `gh pr create`, `gh issue create` | открывает `$EDITOR` | `--title "…" --body-file <файл>` |
| `gh auth login` | интерактивный вход | `GITHUB_TOKEN=… gh api …` либо попроси пользователя |
| `systemctl` | polkit может ждать пароль root | `--no-pager --no-ask-password` |
| `fzf`, `dialog`, `whiptail` | выбор из списка на экране | неинтерактивной альтернативы нет — перепиши на явные аргументы |
| `crontab -e` | редактор | `crontab -` со списком задач на stdin |
| `visudo -e` | редактор | не использовать; правь через `visudo -f <файл>` с неинтерактивной проверкой |
| `gpg --edit-key`, `pass`, `pinentry` | пароль на ключе | не использовать; работай через уже существующие несекретные операции |
| `apt-get` без `-y` | подтверждение установки | `-y`; при отсутствии root — остановись и попроси пользователя |
| скрипт `./configure`, `./install` | последовательные вопросы | heredoc или `yes \|` плюс `timeout` |

## Порядок реакции

1. Есть неинтерактивный флаг — используй его.
2. Флага нет — закрой stdin через `< /dev/null`.
3. Нужен ввод — heredoc или `yes |`.
4. Оборачивай всё спорное в `timeout` и проверяй код возврата.
