#!/bin/bash

# 1. Автоматическая проверка и установка зависимостей (Ubuntu / Debian / Termux)
echo "Проверка установленных программ..."
if command -v pkg &> /dev/null; then
    # Настройки для Termux
    pkg update -y
    command -v curl &> /dev/null || pkg install curl -y
    command -v ffmpeg &> /dev/null || pkg install ffmpeg -y
    command -v python &> /dev/null || pkg install python -y
else
    # Настройки для Ubuntu / Debian
    sudo apt update -y
    command -v curl &> /dev/null || sudo apt install curl -y
    command -v ffmpeg &> /dev/null || sudo apt install ffmpeg -y
    command -v python3 &> /dev/null || sudo apt install python3 -y
fi

# 2. Установка/Обновление самого yt-dlp
if command -v pkg &> /dev/null; then
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $PREFIX/bin/yt-dlp
    chmod a+rx $PREFIX/bin/yt-dlp
else
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
fi

clear
echo "=================================================="
echo "    Универсальный загрузчик с YouTube готов!     "
echo "=================================================="
echo ""

# 3. Запрос ссылки
echo -n "Вставьте ссылку на видео: "
read -r URL

if [ -z "$URL" ]; then
    echo "Ошибка: Ссылка не может быть пустой!"
    exit 1
fi

# 4. Меню выбора режима
echo ""
echo "Что нужно сделать?"
echo "1) Скачать обычное видео (Макс. качество + Звук)"
echo "2) Скачать только видеоряд (Без звука)"
echo "3) Скачать только аудиодорожку (В формате MP3)"
echo "--------------------------------------------------"
echo -n "Выберите вариант (1, 2 или 3): "
read -r REZHIM

echo ""
case $REZHIM in
    1)
        echo "Скачиваю видео со звуком в лучшем качестве..."
        yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 "$URL"
        ;;
    2)
        echo "Скачиваю только видео (без звука)..."
        yt-dlp -f "bestvideo" --merge-output-format mp4 "$URL"
        ;;
    3)
        echo "Скачиваю аудио и конвертирую в MP3..."
        yt-dlp -x --audio-format mp3 --audio-quality 0 "$URL"
        ;;
    *)
        echo "Неверный выбор! Отмена."
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo ""
    echo "Успешно скачано в текущую папку!"
else
    echo ""
    echo "Произошла ошибка при скачивании."
fi
