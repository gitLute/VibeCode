# Шпаргалка: плохой вариант → хороший вариант

В колонке ХОРОШО — неинтерактивный эквивалент той же операции.

## Пакетные менеджеры

| Действие | ПЛОХО | ХОРОШО |
|---|---|---|
| npm init | `npm init` | `npm init -y` |
| npm install | `npm install` | `npm_config_yes=true npm install` |
| yarn | `yarn install` | `yarn install --non-interactive` |
| pnpm | `pnpm install` | `pnpm install --reporter=silent` |
| bun | `bun init` | `bun init -y` |
| apt | `apt-get install pkg` | `apt-get install -y pkg` — нужны права root, см. «Жёсткий запрет» в `SKILL.md`: остановись и попроси пользователя |
| pip | `pip install pkg` | `pip install --no-input pkg` |
| brew | `brew install pkg` | `HOMEBREW_NO_AUTO_UPDATE=1 brew install pkg` |

## Git

| Действие | ПЛОХО | ХОРОШО |
|---|---|---|
| коммит | `git commit` | `git commit -m "сообщение"` |
| merge | `git merge branch` | `git merge --no-edit branch` |
| pull | `git pull` | `git pull --no-rebase` (обычное поведение, без диалога) |
| rebase | `git rebase -i` | `git rebase --onto base branch` либо `GIT_SEQUENCE_EDITOR=… git rebase -i` — неинтерактивного флага нет |
| add | `git add -p` | `git add .` или `git add <файл>` |
| log | `git log` | `git --no-pager log -n 10` |
| diff | `git diff` | `git --no-pager diff` |
| теги | `git tag -a v1.0` | `git tag -a v1.0 -m "сообщение"` |

## Файлы и система

| Действие | ПЛОХО | ХОРОШО |
|---|---|---|
| rm | `rm -i file` | `rm -f file` |
| cp | `cp -i a b` | `cp -f a b` |
| mv | `mv -i a b` | `mv -f a b` |
| unzip | `unzip file.zip` | `unzip -o file.zip` |
| ssh | `ssh host` | `ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new host` |
| scp | `scp file host:` | `scp -o BatchMode=yes file host:` |
| ssh-keygen | `ssh-keygen -t ed25519` | `ssh-keygen -N "" -t ed25519 -f ~/.ssh/id_ed25519` |
| systemctl | `systemctl start unit` | `systemctl --no-pager --no-ask-password start unit` |
| crontab | `crontab -e` | `crontab -` со списком задач на stdin |
| curl | `curl url` | `curl -fsSL url` |
| wget | `wget url` | `wget -q --tries=1 url` — прогресс-бар в headless недоступен |

## GitHub CLI

| Действие | ПЛОХО | ХОРОШО |
|---|---|---|
| PR | `gh pr create` | `gh pr create --title "…" --body-file tmp/pr.md` |
| issue | `gh issue create` | `gh issue create --title "…" --body-file tmp/issue.md` |
| auth | `gh auth login` | `GITHUB_TOKEN=… gh api …` или попроси пользователя авторизоваться сам |

## Docker и REPL

| Действие | ПЛОХО | ХОРОШО |
|---|---|---|
| docker run | `docker run -it image` | `docker run image` |
| docker exec | `docker exec -it container bash` | `docker exec container cmd` |
| docker build | `docker build .` | `docker build --progress=plain .` |
| python | `python` | `python -c "код"` или `python script.py` |
| node | `node` | `node -e "код"` или `node script.js` |
| REPL в пайпе | `echo "1+1" \| python` | `python -c "1+1"` |

## Замечание про ssh

`StrictHostKeyChecking=accept-new` достаточно, чтобы не было промпта, и не
отключает проверку ключа хоста. `StrictHostKeyChecking=no` убирает вопрос, но
делает соединение уязвимым для MITM — не используй его как способ избежать
интерактивности.
