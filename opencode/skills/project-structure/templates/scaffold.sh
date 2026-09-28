#!/usr/bin/env bash
# Создаёт ожидаемую структуру проекта в целевом каталоге.
# Не перезаписывает существующие файлы и каталоги.
#
# Использование: bash scaffold.sh [каталог] [каталог-сборки]
# Пример:       bash scaffold.sh . out

set -euo pipefail

target="${1:-.}"
build_dir="${2:-out}"

if [ ! -d "$target" ]; then
  echo "Каталог не найден: $target" >&2
  exit 1
fi

created=()

for dir in src "$build_dir" img tmp; do
  if [ ! -d "$target/$dir" ]; then
    mkdir -p "$target/$dir"
    created+=("$dir/")
  fi
done

if [ ! -e "$target/README.md" ] && [ ! -e "$target/readme.md" ]; then
  printf '# Название проекта\n\nКраткое описание алгоритма.\n' > "$target/README.md"
  created+=("README.md")
fi

if [ ! -e "$target/.gitignore" ]; then
  {
    printf '%s/\n' "$build_dir"
    printf 'tmp/\n'
    printf '# добавь фактические артефакты сборки этого проекта\n'
  } > "$target/.gitignore"
  created+=(".gitignore")
else
  # Дописываем недостающие правила, не трогая существующие.
  for line in "$build_dir/" "tmp/"; do
    if ! grep -qxF "$line" "$target/.gitignore" 2>/dev/null; then
      printf '%s\n' "$line" >> "$target/.gitignore"
    fi
  done
fi

if [ ${#created[@]} -eq 0 ]; then
  echo "Структура уже полная, ничего не изменено."
else
  printf 'Создано: %s\n' "${created[@]}"
fi
