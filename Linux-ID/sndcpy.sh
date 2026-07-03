#!/bin/bash
# ============================================================
#  ScreenMirror - sndcpy Script (Audio Mirror - Linux Indonesia)
#  Dibuat oleh Xnuvers007
# ============================================================

Green='\033[1;32m'
Red='\033[1;31m'
Yellow='\033[1;33m'
RESET='\033[0m'

SNDCPY_DIR="$HOME/.screenmirror/sndcpy"
SNDCPY_VERSION="1.1"
SNDCPY_URL="https://github.com/rom1v/sndcpy/releases/download/v${SNDCPY_VERSION}/sndcpy-v${SNDCPY_VERSION}.zip"
SNDCPY_ZIP="sndcpy-v${SNDCPY_VERSION}.zip"

banner() {
    echo -e "${Green}"
    echo "  ╔═══════════════════════════════════════╗"
    echo "  ║    🔊  sndcpy - Audio Mirroring   🎵  ║"
    echo "  ║     Android Audio → Laptop Speaker    ║"
    echo "  ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
}

banner

# Cek VLC
if ! command -v vlc &>/dev/null; then
    echo -e "${Yellow}  [⚠] VLC tidak ditemukan. Menginstall VLC...${RESET}"
    sudo apt-get install -y vlc
fi

# Cek apakah sndcpy sudah ada
if [ -f "$SNDCPY_DIR/sndcpy" ]; then
    echo -e "${Green}  [✔] sndcpy sudah tersedia di: $SNDCPY_DIR${RESET}"
else
    echo -e "${Yellow}  [⚠] sndcpy belum terinstall. Mengunduh...${RESET}"
    mkdir -p "$SNDCPY_DIR"

    if command -v wget &>/dev/null; then
        wget -q --show-progress -P /tmp/ "$SNDCPY_URL"
    elif command -v curl &>/dev/null; then
        curl -L "$SNDCPY_URL" -o "/tmp/$SNDCPY_ZIP"
    else
        echo -e "${Red}  [✘] wget atau curl tidak ditemukan!${RESET}"
        exit 1
    fi

    unzip -q "/tmp/$SNDCPY_ZIP" -d "$SNDCPY_DIR/"
    chmod +x "$SNDCPY_DIR/sndcpy"
    rm -f "/tmp/$SNDCPY_ZIP"
    echo -e "${Green}  [✔] sndcpy berhasil diinstall!${RESET}"
fi

# Jalankan sndcpy
echo -e "${Green}  [▶] Memulai audio mirroring...${RESET}"
echo -e "${Yellow}  [ℹ] Pastikan HP sudah terhubung via ADB${RESET}"
cd "$SNDCPY_DIR" || exit 1
./sndcpy
