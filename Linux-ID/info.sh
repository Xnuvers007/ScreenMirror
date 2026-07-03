#!/bin/bash
# ============================================================
#  ScreenMirror - Linux Indonesia - Info & Prerequisite Check
#  Dibuat oleh Xnuvers007
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
echo "  ║        Informasi Sistem  |  Bahasa Indonesia        ║"
echo "  ╚══════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${Green}  ─── Informasi Hostname ─────────────────────────────${RESET}"
hostnamectl 2>/dev/null || hostname

echo ""
echo -e "${Green}  ─── Alamat IP ───────────────────────────────────────${RESET}"

for iface in wlan0 wlan1 eth0 eth1 usb0 usb1; do
    ip_addr=$(ip addr show "$iface" 2>/dev/null | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    if [ -n "$ip_addr" ]; then
        echo -e "${Yellow}  IP $iface : ${Green}$ip_addr${RESET}"
    fi
done

# Tampilkan semua interface aktif
echo ""
echo -e "${Green}  ─── Semua Interface Aktif ───────────────────────────${RESET}"
ip -br addr show 2>/dev/null | grep -v "^lo" | while read -r line; do
    echo "  $line"
done

echo ""
echo -e "${Green}  ─── Informasi OS Linux ──────────────────────────────${RESET}"
lsb_release -a 2>/dev/null || cat /etc/os-release 2>/dev/null | head -5

echo ""
echo -e "${Green}  ─── Versi ADB ───────────────────────────────────────${RESET}"
if command -v adb &>/dev/null; then
    adb version 2>/dev/null | head -2
    echo -e "${Green}  ✔ ADB tersedia${RESET}"
else
    echo -e "${Red}  ✘ ADB TIDAK tersedia - install dengan: sudo apt-get install adb${RESET}"
fi

echo ""
echo -e "${Green}  ─── Versi scrcpy ────────────────────────────────────${RESET}"
if command -v scrcpy &>/dev/null; then
    scrcpy --version 2>/dev/null | head -1
    echo -e "${Green}  ✔ scrcpy tersedia${RESET}"
else
    echo -e "${Red}  ✘ scrcpy TIDAK tersedia - install dengan: sudo apt-get install scrcpy${RESET}"
fi

echo ""
echo -e "${Blue}  ─── Persyaratan ─────────────────────────────────────${RESET}"
echo -e "${Yellow}  • Android minimal API 21 (Android 5.0), disarankan Android 10+"
echo "  • USB Debugging harus diaktifkan di HP"
echo "  • Hubungkan kabel USB ke laptop (untuk koneksi USB)"
echo "  • HP dan laptop di WiFi yang sama (untuk koneksi WiFi)"
echo -e "${RESET}"

echo ""
read -rp "$(echo -e "${Yellow}  Tekan [ENTER] untuk melanjutkan ke script utama...${RESET}")"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$SCRIPT_DIR/screenmirror.sh" 2>/dev/null
"$SCRIPT_DIR/screenmirror.sh"
