#!/bin/bash
# ============================================================
#  ScreenMirror - Universal Entry Point (Linux)
#  Coded by Xnuvers007
#  Pilih bahasa / Choose language
# ============================================================

Green='\033[1;32m'
Cyan='\033[1;36m'
Yellow='\033[1;33m'
RESET='\033[0m'

clear
echo ""
echo "  ============================================================"
echo "     Android to Laptop Screen Mirror  -  by Xnuvers007"
echo "  ============================================================"
echo ""
echo "  Choose Language / Pilih Bahasa:"
echo ""
echo "    1. Indonesia  (Bahasa Indonesia)"
echo "    2. English    (English)"
echo "    0. Exit / Keluar"
echo ""
echo "  ---------------------------------------------------------"

read -rp "$(echo -e "${Yellow}  Pilihan / Choice [1-2]: ${RESET}")" lang

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fix permissions
chmod +x "$SCRIPT_DIR/screenmirror.sh" 2>/dev/null
chmod +x "$SCRIPT_DIR/sndcpy.sh" 2>/dev/null
chmod +x "$SCRIPT_DIR/Linux-ID/screenmirror.sh" 2>/dev/null
chmod +x "$SCRIPT_DIR/Linux-ID/sndcpy.sh" 2>/dev/null
chmod +x "$SCRIPT_DIR/mulaism" 2>/dev/null

# Auto-add to PATH if not already there
if [[ ":$PATH:" != *":$SCRIPT_DIR:"* ]]; then
    if [ -f "$HOME/.bashrc" ] && ! grep -q "export PATH=.*$SCRIPT_DIR" "$HOME/.bashrc"; then
        echo "export PATH=\"\$PATH:$SCRIPT_DIR\"" >> "$HOME/.bashrc"
        echo -e "${Green}  [i] Added ScreenMirror to PATH in ~/.bashrc${RESET}"
    fi
    if [ -f "$HOME/.zshrc" ] && ! grep -q "export PATH=.*$SCRIPT_DIR" "$HOME/.zshrc"; then
        echo "export PATH=\"\$PATH:$SCRIPT_DIR\"" >> "$HOME/.zshrc"
        echo -e "${Green}  [i] Added ScreenMirror to PATH in ~/.zshrc${RESET}"
    fi
fi

if [ "$lang" = "1" ]; then
    echo "  Menjalankan versi Bahasa Indonesia..."
    "$SCRIPT_DIR/Linux-ID/screenmirror.sh"
elif [ "$lang" = "2" ]; then
    echo "  Starting English version..."
    "$SCRIPT_DIR/screenmirror.sh"
elif [ "$lang" = "0" ]; then
    exit 0
else
    echo "  Invalid choice. Defaulting to English..."
    sleep 2
    "$SCRIPT_DIR/screenmirror.sh"
fi
