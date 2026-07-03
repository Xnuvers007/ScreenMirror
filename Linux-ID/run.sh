#!/bin/bash
# ============================================================
#  ScreenMirror - Entry Point Linux Indonesia
#  Dibuat oleh Xnuvers007
# ============================================================

Red='\033[1;31m'
Green='\033[1;32m'
RESET='\033[0m'

clear
echo -e "${Green}"
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║  📱  ScreenMirror - Entry Point Linux Indonesia  📺 ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo -e "${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "$SCRIPT_DIR/screenmirror.sh" 2>/dev/null
chmod +x "$SCRIPT_DIR/sndcpy.sh" 2>/dev/null
chmod +x "$SCRIPT_DIR/../mulaism" 2>/dev/null

# Auto-add to PATH if not already there
if [[ ":$PATH:" != *":$(dirname "$SCRIPT_DIR"):"* ]]; then
    if [ -f "$HOME/.bashrc" ] && ! grep -q "export PATH=.*$(dirname "$SCRIPT_DIR")" "$HOME/.bashrc"; then
        echo "export PATH=\"\$PATH:$(dirname "$SCRIPT_DIR")\"" >> "$HOME/.bashrc"
        echo -e "${Green}  [i] Menambahkan ScreenMirror ke PATH di ~/.bashrc${RESET}"
    fi
    if [ -f "$HOME/.zshrc" ] && ! grep -q "export PATH=.*$(dirname "$SCRIPT_DIR")" "$HOME/.zshrc"; then
        echo "export PATH=\"\$PATH:$(dirname "$SCRIPT_DIR")\"" >> "$HOME/.zshrc"
        echo -e "${Green}  [i] Menambahkan ScreenMirror ke PATH di ~/.zshrc${RESET}"
    fi
fi

"$SCRIPT_DIR/screenmirror.sh"
