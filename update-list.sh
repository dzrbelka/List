#!/bin/sh
set -e

# URL исходного файла и файла-исключения
SOURCE_URL="https://raw.githubusercontent.com/dom404/blockAI-URLs/main/combined_AI_list.txt"
EXCLUDE_URL="https://raw.githubusercontent.com/haritos90/allow-domains/main/Categories/06-google-ai.lst"
EXCLUDE_URL=""

# Путь к итоговому файлу
OUTPUT_FILE="ai_domains.lst"

# Скачиваем оба файла во временную директорию
wget -q -O /tmp/source_list.txt "$SOURCE_URL"
wget -q -O /tmp/exclude_list.txt "$EXCLUDE_URL"

# --- Очистка основного списка ---
# Удаляем пустые строки, комментарии, символы \r, пробелы по краям и префикс 'www.'
grep -vE '^\s*(#|;|$)' /tmp/source_list.txt \
  | sed 's/\r$//' \
  | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
  | sed 's/^www\.//' \
  | grep -v '^$' > /tmp/cleaned_source.txt

# --- Очистка списка-исключения ---
# Делаем то же самое, чтобы формат строк совпадал
grep -vE '^\s*(#|;|$)' /tmp/exclude_list.txt \
  | sed 's/\r$//' \
  | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
  | sed 's/^www\.//' \
  | grep -v '^$' > /tmp/cleaned_exclude.txt

# --- Исключение совпадений ---
# -v: инвертировать (показать строки, НЕ совпадающие)
# -F: воспринимать шаблоны как фиксированные строки (без regex)
# -x: совпадать со всей строкой целиком
# -f: читать шаблоны из файла
grep -v -F -x -f /tmp/cleaned_exclude.txt /tmp/cleaned_source.txt > "$OUTPUT_FILE"

echo "Файл $OUTPUT_FILE успешно обновлен и очищен от совпадений с googleai.lst."
