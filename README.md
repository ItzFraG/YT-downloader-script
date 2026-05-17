📥 Universal YouTube Downloader (Bash Script)
A simple and powerful Bash script for downloading video and audio from YouTube. Works automatically on Ubuntu, Debian, and Termux.
The script automatically checks, installs, and updates all necessary dependencies (yt-dlp, ffmpeg, curl), and then provides a user-friendly menu for downloading.

🚀 Features:
🎥 Standard Video: Downloads both video and audio at the maximum available quality and automatically merges them into .mp4 format.
🔇 Video Only: Downloads the video stream only (no sound) at the highest quality.
🎵 Audio Only: Extracts the audio track from the video and converts it into a clean .mp3 with the maximum bitrate.
📦 Full Automation: No need to manually install codecs or utilities — the script handles everything during the first run.
🛠 One-Command Launch
To quickly download and run the script without any extra setup, just paste this command into your terminal:
```bash
curl -LO https://raw.githubusercontent.com/ItzFraG/YT-downloader-script/main/dlyt.sh && bash dlyt.sh
