#!/bin/bash
# ============================================================
#  ScreenMirror - Info & Prerequisite Check (Linux English)
#  Coded by Xnuvers007
# ============================================================

Red='\033[1;31m'
Green='\033[1;32m'
Yellow='\033[1;33m'
Blue='\033[1;34m'
Cyan='\033[1;36m'
RESET='\033[0m'

clear
echo -e "${Cyan}"
echo "  ╔══════════════════════════════════════════════════════╗"
echo "  ║       📱  S C R E E N   M I R R O R  📺            ║"
echo "  ║        System Information  |  English               ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${Green}  ─── Hostname Information ───────────────────────────${RESET}"
hostnamectl 2>/dev/null || hostname

echo ""
echo -e "${Green}  ─── IP Addresses ────────────────────────────────────${RESET}"
for iface in wlan0 wlan1 eth0 eth1 usb0 usb1; do
    ip_addr=$(ip addr show "$iface" 2>/dev/null | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    if [ -n "$ip_addr" ]; then
        echo -e "${Yellow}  IP $iface : ${Green}$ip_addr${RESET}"
    fi
done

echo ""
echo -e "${Green}  ─── All Active Interfaces ───────────────────────────${RESET}"
ip -br addr show 2>/dev/null | grep -v "^lo" | while read -r line; do
    echo "  $line"
done

echo ""
echo -e "${Green}  ─── Linux OS Info ───────────────────────────────────${RESET}"
lsb_release -a 2>/dev/null || cat /etc/os-release 2>/dev/null | head -5

echo ""
echo -e "${Green}  ─── ADB Version ─────────────────────────────────────${RESET}"
if command -v adb &>/dev/null; then
    adb version 2>/dev/null | head -2
    echo -e "${Green}  ✔ ADB is available${RESET}"
else
    echo -e "${Red}  ✘ ADB NOT found - install with: sudo apt-get install adb${RESET}"
fi

echo ""
echo -e "${Green}  ─── scrcpy Version ──────────────────────────────────${RESET}"
if command -v scrcpy &>/dev/null; then
    scrcpy --version 2>/dev/null | head -1
    echo -e "${Green}  ✔ scrcpy is available${RESET}"
else
    echo -e "${Red}  ✘ scrcpy NOT found - install with: sudo apt-get install scrcpy${RESET}"
fi

echo ""
echo -e "${Blue}  ─── Requirements ────────────────────────────────────${RESET}"
echo -e "${Yellow}  • Android minimum API 21 (Android 5.0), recommended Android 10+
  • USB Debugging must be enabled on your phone
  • USB cable connected to laptop (for USB mode)
  • Phone and laptop on same WiFi (for WiFi mode)"
echo -e "${RESET}"

echo ""
read -rp "$(echo -e "${Yellow}  Press [ENTER] to continue to the main script...${RESET}")"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$SCRIPT_DIR/screenmirror.sh" 2>/dev/null
"$SCRIPT_DIR/screenmirror.sh"