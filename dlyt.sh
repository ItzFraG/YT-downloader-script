#!/bin/bash

# --- Цветовая палитра Aqua ---
AQUA='\033[0;36m'
NC='\033[0m'

# --- Логика выбора языка ---
echo -e "${AQUA}Select language / Выберите язык:${NC}"
echo "1) English"
echo "2) Русский"
read -r LAN_CHOICE

if [ "$LAN_CHOICE" == "2" ]; then
    # Тексты на русском
    T_PREP="=== Подготовка окружения... ==="
    T_TERMUX="Настройка доступа к памяти Android..."
    T_YTDLP="Проверка и обновление yt-dlp..."
    T_PATH="Файлы будут сохранены в:"
    T_INSERT="Вставьте ссылку на видео: "
    T_MODE="Выберите режим:"
    T_M1="Видео (MP4, Макс качество)"
    T_M2="Только видеоряд (Без звука)"
    T_M3="Только аудио (MP3)"
    T_ERR="Ошибка выбора"
    T_DONE="Готово! Проверьте папку."
else
    # Тексты на английском
    T_PREP="=== Preparing environment... ==="
    T_TERMUX="Setting up Android storage access..."
    T_YTDLP="Checking and updating yt-dlp..."
    T_PATH="Files will be saved to:"
    T_INSERT="Insert video link: "
    T_MODE="Select mode:"
    T_M1="Video (MP4, Best quality)"
    T_M2="Video only (No sound)"
    T_M3="Audio only (MP3)"
    T_ERR="Selection error"
    T_DONE="Done! Check your folder."
fi

clear
echo -e "${AQUA}$T_PREP${NC}"

# --- Проверка платформы (Termux vs Linux) ---
if [ -d "$HOME/.termux" ]; then
    # Это Termux
    if [ ! -d "$HOME/storage" ]; then
        echo "$T_TERMUX"
        termux-setup-storage
        sleep 2
    fi
    pkg update -y && pkg install python ffmpeg curl -y
    BIN_PATH="$PREFIX/bin/yt-dlp"
    # Создаем папку в загрузках телефона для удобства
    mkdir -p /sdcard/Download/YT-Downloads
    cd /sdcard/Download/YT-Downloads
else
    # Это Ubuntu/Debian
    sudo apt update && sudo apt install python3 ffmpeg curl -y
    BIN_PATH="/usr/local/bin/yt-dlp"
fi

# --- Установка/Обновление yt-dlp ---
if [ -d "$HOME/.termux" ]; then
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $BIN_PATH
else
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $BIN_PATH
fi
chmod a+rx $BIN_PATH

clear
echo -e "${AQUA}========================================"
echo "    YOUTUBE DOWNLOADER (STABLE)        "
echo -e "========================================${NC}"
echo -e "$T_PATH ${AQUA}$(pwd)${NC}\n"

echo -n "$T_INSERT"
read -r URL

if [ -z "$URL" ]; then
    echo "URL is empty!"
    exit 1
fi

echo -e "\n$T_MODE"
echo "1) $T_M1"
echo "2) $T_M2"
echo "3) $T_M3"
read -r OPT

case $OPT in
    1) yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 "$URL" ;;
    2) yt-dlp -f "bestvideo" --merge-output-format mp4 "$URL" ;;
    3) yt-dlp -x --audio-format mp3 "$URL" ;;
    *) echo "$T_ERR"; exit 1 ;;
esac

echo -e "\n${AQUA}$T_DONE${NC}"
