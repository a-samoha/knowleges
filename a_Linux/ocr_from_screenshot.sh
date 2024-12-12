#!/bin/bash

# VAR 1
#spectacle -r -b -n -o /tmp/screenshot.png  # Захват скриншота
#tesseract /tmp/screenshot.png stdout -l rus | xclip -selection clipboard
#notify-send "OCR" "Текст скопирован в буфер обмена"

#!/bin/bash

# VAR 2

# должны быть установлены:
# tesseract-ocr
# tesseract-ocr-ukr
# tesseract-ocr-rus
# xclip
#
# sudo apt install tesseract-ocr tesseract-ocr-ukr tesseract-ocr-rus xclip

# Задаем языки для OCR
LANGUAGES="rus+eng+ukr"

# Сохраняем скриншот
spectacle -r -b -n -o /tmp/screenshot.png
if [ $? -ne 0 ]; then
    notify-send "Ошибка" "Не удалось сделать скриншот"
    exit 1
fi

# Распознаем текст с выбором языков
TEXT=$(tesseract /tmp/screenshot.png stdout -l $LANGUAGES 2>/dev/null)
if [ $? -ne 0 ]; then
    notify-send "Ошибка" "Не удалось распознать текст"
    exit 1
fi

# Копируем текст в буфер обмена
echo "$TEXT" | xclip -selection clipboard
if [ $? -ne 0 ]; then
    notify-send "Ошибка" "Не удалось скопировать текст в буфер"
    exit 1
fi

notify-send "OCR завершено" "Текст скопирован в буфер обмена"
