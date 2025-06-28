#!/bin/bash

# === НАСТРОЙКИ ===
MAX_SCREENSHOTS_PER_HOUR=2
SAVE_DIR="$HOME/Screenshots"

START_HOUR=$(date +%H)
END_HOUR=$(( (START_HOUR + 9) % 24 ))

# === НАСТРОЙКИ TELEGRAM (необязательно) ===
TELEGRAM_BOT_TOKEN="1234567890:ABCdefGhijKLMNOPQRS1234567"   # ← Вставь сюда токен
#TELEGRAM_CHAT_ID="111111111"     # ← Вставь сюда chat ID
TELEGRAM_CHAT_ID="-1111111111"     # ← Вставь сюда Group ID

# === ПОДГОТОВКА ===
mkdir -p "$SAVE_DIR"

# === УСТАНОВКА УТИЛИТЫ ===
install_tool() {
    TOOL="$1"
    if ! command -v "$TOOL" >/dev/null 2>&1; then
        echo "🔧 Устанавливаю '$TOOL'..."
        if [ -f /etc/debian_version ]; then
            sudo apt update && sudo apt install -y "$TOOL"
        elif [ -f /etc/arch-release ]; then
            sudo pacman -Sy --noconfirm "$TOOL"
        elif [ -f /etc/redhat-release ]; then
            sudo dnf install -y "$TOOL"
        else
            echo "❌ Неизвестный дистрибутив. Установите '$TOOL' вручную."
            exit 1
        fi
    fi
}

# === ОПРЕДЕЛЕНИЕ ОКРУЖЕНИЯ И ВЫБОР ИНСТРУМЕНТА ===
detect_environment() {
    if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
        install_tool scrot
        SCREENSHOT_TOOL="scrot"
    elif [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        install_tool spectacle
        SCREENSHOT_TOOL="spectacle"
    else
        echo "❌ Неизвестный XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
        exit 1
    fi
}

detect_environment

# === ОТПРАВКА В TELEGRAM ===
send_to_telegram() {
    local file_path="$1"
    if [[ -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]]; then
        curl -s -F "chat_id=$TELEGRAM_CHAT_ID" \
             -F "photo=@$file_path" \
             "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendPhoto" \
             >/dev/null
    fi
}

# === СКРИНШОТ В ЗАВИСИМОСТИ ОТ ОКРУЖЕНИЯ ===
take_screenshot() {
    TIMESTAMP=$(date '+%Y-%m-%d_%H:%M:%S')
    FILEPATH="$SAVE_DIR/s_${TIMESTAMP}.jpg"

    if [[ "$SCREENSHOT_TOOL" == "scrot" ]]; then
        scrot "$FILEPATH"
    elif [[ "$SCREENSHOT_TOOL" == "spectacle" ]]; then
        spectacle -n -b -o "$FILEPATH"
    fi

    if [[ -f "$FILEPATH" ]]; then
        echo "[$(date '+%H:%M:%S')] Скриншот сохранён: $FILEPATH"
        send_to_telegram "$FILEPATH"
    else
        echo "[$(date '+%H:%M:%S')] ❌ Скриншот не был создан: $FILEPATH"
    fi
}

# === ПРОВЕРКА ВРЕМЕННОГО ИНТЕРВАЛА ===
is_within_interval() {
    current_hour=$(date +%H)
    if (( START_HOUR < END_HOUR )); then
        (( current_hour >= START_HOUR && current_hour < END_HOUR ))
    else
        (( current_hour >= START_HOUR || current_hour < END_HOUR ))
    fi
}

# === ТЕСТОВЫЙ СКРИНШОТ ===
echo "⏳ Ожидание 30 секунд перед тестовым скриншотом..."
sleep 30
take_screenshot

# === ОСНОВНОЙ ЦИКЛ ===
echo "🚀 Screen Tracker ($SCREENSHOT_TOOL) запущен. Время работы: с $START_HOUR:00 до $END_HOUR:00"
while true; do
    if is_within_interval; then
        for ((i=1; i<=MAX_SCREENSHOTS_PER_HOUR; i++)); do
            MAX_DELAY=$(( 3600 / MAX_SCREENSHOTS_PER_HOUR ))
            DELAY=$(( RANDOM % MAX_DELAY ))
            sleep "$DELAY"

            if is_within_interval; then
                take_screenshot
            else
                echo "[$(date '+%H:%M:%S')] Вне интервала. Пропуск."
            fi
        done
    else
        echo "[$(date '+%H:%M:%S')] Вне интервала. Ожидание 5 минут..."
        sleep 300
    fi
done
