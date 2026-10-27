#!/bin/sh
set -e

# URL исходного файла
SOURCE_URL="https://raw.githubusercontent.com/dom404/blockAI-URLs/main/combined_AI_list.txt"
# Путь к итоговому файлу в репозитории
OUTPUT_FILE="ai_domains.lst"

# Скачиваем файл во временную директорию
wget -q -O /tmp/source_list.txt "$SOURCE_URL"

# Очищаем и преобразуем:
# - удаляем пустые строки и комментарии (начинающиеся с # или ;)
# - удаляем символы возврата каретки (\r)
# - удаляем пробелы в начале и конце строк
# - убираем пустые строки, которые могли остаться
grep -vE '^\s*(#|;|$)' /tmp/source_list.txt \
  | sed 's/\r$//' \
  | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
  | grep -v '^$' > "$OUTPUT_FILE"

echo "Файл $OUTPUT_FILE успешно обновлен."
