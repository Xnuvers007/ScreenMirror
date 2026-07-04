#!/bin/bash
# ============================================================
#  ScreenMirror - Main Script (Linux - English)
#  Coded by Xnuvers007
#  Don't modify without credit/original source
# ============================================================
# LICENSE: MIT | GitHub: https://github.com/Xnuvers007/ScreenMirror
# ============================================================

# --- Terminal Colors ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
PURPLE='\033[1;35m'
RESET='\033[0m'
BOLD='\033[1m'

# --- Configuration ---
CONFIG_FILE="$HOME/.screenmirror.conf"
SCRCPY_VERSION="2.1.1"

# ============================================================
# UTILITY FUNCTIONS
# ============================================================

banner() {
    clear
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║       📱  S C R E E N   M I R R O R  📺            ║"
    echo "  ║          Android → Laptop  |  by Xnuvers007         ║"
    echo "  ║           Linux Edition  |  English                 ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

separator() { echo -e "${BLUE}  ──────────────────────────────────────────────────────${RESET}"; }
info()    { echo -e "${GREEN}  [✔] $1${RESET}"; }
warn()    { echo -e "${YELLOW}  [⚠] $1${RESET}"; }
error()   { echo -e "${RED}  [✘] $1${RESET}"; }
title()   { echo -e "\n${PURPLE}${BOLD}  ═══ $1 ═══${RESET}\n"; }
step()    { echo -e "${CYAN}  ▶ $1${RESET}"; }
note()    { echo -e "${WHITE}  ℹ  $1${RESET}"; }

press_enter() {
    echo ""
    read -rp "$(echo -e "${YELLOW}  Press [ENTER] to continue...${RESET}")"
}

# ============================================================
# SAVE & LOAD CONFIGURATION (Per-Mode: USB / WiFi / Wireless Debug)
# ============================================================

save_config() {
    cat > "$CONFIG_FILE" <<EOF
# ScreenMirror Configuration - Auto-saved
# Last updated: $(date)
LAST_CONNECTION="$LAST_CONNECTION"

# --- USB Config ---
USB_FPS="$USB_FPS"
USB_BITRATE="$USB_BITRATE"
USB_RESOLUTION="$USB_RESOLUTION"
USB_CODEC="$USB_CODEC"
USB_STAY_AWAKE="$USB_STAY_AWAKE"
USB_NO_CONTROL="$USB_NO_CONTROL"
USB_TURN_SCREEN_OFF="$USB_TURN_SCREEN_OFF"

# --- WiFi TCP/IP Config ---
WIFI_IP="$WIFI_IP"
WIFI_PORT="$WIFI_PORT"
WIFI_FPS="$WIFI_FPS"
WIFI_BITRATE="$WIFI_BITRATE"
WIFI_RESOLUTION="$WIFI_RESOLUTION"
WIFI_CODEC="$WIFI_CODEC"
WIFI_STAY_AWAKE="$WIFI_STAY_AWAKE"
WIFI_NO_CONTROL="$WIFI_NO_CONTROL"
WIFI_TURN_SCREEN_OFF="$WIFI_TURN_SCREEN_OFF"

# --- Wireless Debug Config ---
WD_IP="$WD_IP"
WD_PORT="$WD_PORT"
WD_FPS="$WD_FPS"
WD_BITRATE="$WD_BITRATE"
WD_RESOLUTION="$WD_RESOLUTION"
WD_CODEC="$WD_CODEC"
WD_STAY_AWAKE="$WD_STAY_AWAKE"
WD_NO_CONTROL="$WD_NO_CONTROL"
WD_TURN_SCREEN_OFF="$WD_TURN_SCREEN_OFF"
EOF
    info "Configuration saved to: $CONFIG_FILE"
}

load_config() {
    # Defaults for all modes
    LAST_CONNECTION="1"

    # USB defaults
    USB_FPS="60"; USB_BITRATE="8M"; USB_RESOLUTION="1080"; USB_CODEC="h264"
    USB_STAY_AWAKE="y"; USB_NO_CONTROL="n"; USB_TURN_SCREEN_OFF="n"; USB_AUDIO_MODE="1"

    # WiFi defaults
    WIFI_IP=""; WIFI_PORT="5555"
    WIFI_FPS="60"; WIFI_BITRATE="8M"; WIFI_RESOLUTION="1080"; WIFI_CODEC="h264"
    WIFI_STAY_AWAKE="y"; WIFI_NO_CONTROL="n"; WIFI_TURN_SCREEN_OFF="n"; WIFI_AUDIO_MODE="1"

    # Wireless Debug defaults
    WD_IP=""; WD_PORT="5555"
    WD_FPS="60"; WD_BITRATE="8M"; WD_RESOLUTION="1080"; WD_CODEC="h264"
    WD_STAY_AWAKE="y"; WD_NO_CONTROL="n"; WD_TURN_SCREEN_OFF="n"; WD_AUDIO_MODE="1"

    if [ -f "$CONFIG_FILE" ]; then
        # Backward compatibility: check if old format (has LAST_IP but no USB_FPS)
        if grep -q "^LAST_IP=" "$CONFIG_FILE" && ! grep -q "^USB_FPS=" "$CONFIG_FILE"; then
            # Migrate old config: load old values into USB config
            # shellcheck source=/dev/null
            source "$CONFIG_FILE"
            USB_FPS="${LAST_FPS:-60}"; USB_BITRATE="${LAST_BITRATE:-8M}"
            USB_RESOLUTION="${LAST_RESOLUTION:-1080}"; USB_CODEC="${LAST_CODEC:-h264}"
            USB_STAY_AWAKE="${STAY_AWAKE:-y}"; USB_NO_CONTROL="${NO_CONTROL:-n}"
            USB_TURN_SCREEN_OFF="${TURN_SCREEN_OFF:-n}"; USB_AUDIO_MODE="1"
            if [ "$LAST_CONNECTION" = "2" ]; then
                WIFI_IP="${LAST_IP:-}"; WIFI_PORT="${LAST_PORT:-5555}"
                WIFI_FPS="${LAST_FPS:-60}"; WIFI_BITRATE="${LAST_BITRATE:-8M}"
                WIFI_RESOLUTION="${LAST_RESOLUTION:-1080}"; WIFI_CODEC="${LAST_CODEC:-h264}"
                WIFI_STAY_AWAKE="${STAY_AWAKE:-y}"; WIFI_NO_CONTROL="${NO_CONTROL:-n}"
                WIFI_TURN_SCREEN_OFF="${TURN_SCREEN_OFF:-n}"; WIFI_AUDIO_MODE="1"
            elif [ "$LAST_CONNECTION" = "3" ]; then
                WD_IP="${LAST_IP:-}"; WD_PORT="${LAST_PORT:-5555}"
                WD_FPS="${LAST_FPS:-60}"; WD_BITRATE="${LAST_BITRATE:-8M}"
                WD_RESOLUTION="${LAST_RESOLUTION:-1080}"; WD_CODEC="${LAST_CODEC:-h264}"
                WD_STAY_AWAKE="${STAY_AWAKE:-y}"; WD_NO_CONTROL="${NO_CONTROL:-n}"
                WD_TURN_SCREEN_OFF="${TURN_SCREEN_OFF:-n}"; WD_AUDIO_MODE="1"
            fi
            info "Old configuration migrated to new per-mode format."
            save_config
        else
            # shellcheck source=/dev/null
            source "$CONFIG_FILE"
        fi
        info "Configuration loaded from: $CONFIG_FILE"
    fi
}

# Load mode-specific config into LAST_* working variables
load_mode_config() {
    local mode="$1"  # USB, WIFI, WD
    case "$mode" in
        USB)
            LAST_FPS="$USB_FPS"; LAST_BITRATE="$USB_BITRATE"
            LAST_RESOLUTION="$USB_RESOLUTION"; LAST_CODEC="$USB_CODEC"
            STAY_AWAKE="$USB_STAY_AWAKE"; NO_CONTROL="$USB_NO_CONTROL"
            TURN_SCREEN_OFF="$USB_TURN_SCREEN_OFF"; AUDIO_MODE="$USB_AUDIO_MODE"
            ;;
        WIFI)
            LAST_IP="$WIFI_IP"; LAST_PORT="$WIFI_PORT"
            LAST_FPS="$WIFI_FPS"; LAST_BITRATE="$WIFI_BITRATE"
            LAST_RESOLUTION="$WIFI_RESOLUTION"; LAST_CODEC="$WIFI_CODEC"
            STAY_AWAKE="$WIFI_STAY_AWAKE"; NO_CONTROL="$WIFI_NO_CONTROL"
            TURN_SCREEN_OFF="$WIFI_TURN_SCREEN_OFF"; AUDIO_MODE="$WIFI_AUDIO_MODE"
            ;;
        WD)
            LAST_IP="$WD_IP"; LAST_PORT="$WD_PORT"
            LAST_FPS="$WD_FPS"; LAST_BITRATE="$WD_BITRATE"
            LAST_RESOLUTION="$WD_RESOLUTION"; LAST_CODEC="$WD_CODEC"
            STAY_AWAKE="$WD_STAY_AWAKE"; NO_CONTROL="$WD_NO_CONTROL"
            TURN_SCREEN_OFF="$WD_TURN_SCREEN_OFF"; AUDIO_MODE="$WD_AUDIO_MODE"
            ;;
    esac
}

# Save LAST_* working variables back to mode-specific variables
save_mode_config() {
    local mode="$1"  # USB, WIFI, WD
    case "$mode" in
        USB)
            USB_FPS="$LAST_FPS"; USB_BITRATE="$LAST_BITRATE"
            USB_RESOLUTION="$LAST_RESOLUTION"; USB_CODEC="$LAST_CODEC"
            USB_STAY_AWAKE="$STAY_AWAKE"; USB_NO_CONTROL="$NO_CONTROL"
            USB_TURN_SCREEN_OFF="$TURN_SCREEN_OFF"; USB_AUDIO_MODE="$AUDIO_MODE"
            ;;
        WIFI)
            WIFI_IP="$LAST_IP"; WIFI_PORT="$LAST_PORT"
            WIFI_FPS="$LAST_FPS"; WIFI_BITRATE="$LAST_BITRATE"
            WIFI_RESOLUTION="$LAST_RESOLUTION"; WIFI_CODEC="$LAST_CODEC"
            WIFI_STAY_AWAKE="$STAY_AWAKE"; WIFI_NO_CONTROL="$NO_CONTROL"
            WIFI_TURN_SCREEN_OFF="$TURN_SCREEN_OFF"; WIFI_AUDIO_MODE="$AUDIO_MODE"
            ;;
        WD)
            WD_IP="$LAST_IP"; WD_PORT="$LAST_PORT"
            WD_FPS="$LAST_FPS"; WD_BITRATE="$LAST_BITRATE"
            WD_RESOLUTION="$LAST_RESOLUTION"; WD_CODEC="$LAST_CODEC"
            WD_STAY_AWAKE="$STAY_AWAKE"; WD_NO_CONTROL="$NO_CONTROL"
            WD_TURN_SCREEN_OFF="$TURN_SCREEN_OFF"; WD_AUDIO_MODE="$AUDIO_MODE"
            ;;
    esac
}

# Ask user if they want to reuse saved config for the chosen mode
ask_reuse_mode_config() {
    local mode="$1"
    local mode_label="$2"
    local has_config=false

    case "$mode" in
        USB)   [ -n "$USB_FPS" ] && [ "$USB_FPS" != "" ] && has_config=true ;;
        WIFI)  [ -n "$WIFI_IP" ] && [ "$WIFI_IP" != "" ] && has_config=true ;;
        WD)    [ -n "$WD_IP" ] && [ "$WD_IP" != "" ] && has_config=true ;;
    esac

    if [ -f "$CONFIG_FILE" ] && [ "$has_config" = true ]; then
        separator
        note "Saved $mode_label config:"
        case "$mode" in
            USB)
                note "  FPS: $USB_FPS | Bitrate: $USB_BITRATE | Resolution: $USB_RESOLUTION | Codec: $USB_CODEC"
                ;;
            WIFI)
                note "  IP: $WIFI_IP | Port: $WIFI_PORT"
                note "  FPS: $WIFI_FPS | Bitrate: $WIFI_BITRATE | Resolution: $WIFI_RESOLUTION | Codec: $WIFI_CODEC"
                ;;
            WD)
                note "  IP: $WD_IP | Port: $WD_PORT"
                note "  FPS: $WD_FPS | Bitrate: $WD_BITRATE | Resolution: $WD_RESOLUTION | Codec: $WD_CODEC"
                ;;
        esac
        separator
        echo ""
        read -rp "$(echo -e "${YELLOW}  Use saved $mode_label configuration? [y/n] (default: y): ${RESET}")" USE_SAVED
        USE_SAVED="${USE_SAVED:-y}"
        if [[ "$USE_SAVED" =~ ^[Yy]$ ]]; then
            return 0  # reuse
        fi
    fi
    return 1  # don't reuse, ask for new config
}

# ============================================================
# CHECK DEPENDENCIES & COMPATIBILITY
# ============================================================

check_dependencies() {
    title "CHECKING DEPENDENCIES"
    local missing=0

    for cmd in adb scrcpy; do
        if command -v "$cmd" &>/dev/null; then
            info "$cmd found: $(which $cmd)"
        else
            error "$cmd NOT found!"
            missing=$((missing + 1))
        fi
    done

    if [ $missing -gt 0 ]; then
        warn "Missing dependencies. Try installing with:"
        note "sudo apt-get install -y adb scrcpy"
        echo ""
        read -rp "$(echo -e "${YELLOW}  Install automatically now? [y/n]: ${RESET}")" INSTALL_NOW
        if [[ "$INSTALL_NOW" =~ ^[Yy]$ ]]; then
            step "Installing dependencies..."
            sudo apt-get update -q
            sudo apt-get install -y adb scrcpy
            info "Installation complete!"
        else
            error "Please install dependencies first, then re-run this script."
            exit 1
        fi
    fi
}

check_device() {
    title "CHECKING ANDROID DEVICE"

    step "Starting ADB server..."
    adb kill-server &>/dev/null
    adb start-server &>/dev/null

    local devices
    devices=$(adb devices | awk 'NR>1 && $2=="device" {print $1}')

    if [ -z "$devices" ]; then
        error "No Android device detected!"
        separator
        echo -e "${YELLOW}"
        echo "  Possible causes:"
        echo "  1. USB cable not connected (for USB mode)"
        echo "  2. USB Debugging not enabled on your phone"
        echo "  3. You need to tap 'Allow' on the 'Allow USB Debugging?' popup"
        echo "  4. USB driver not installed"
        echo -e "${RESET}"
        press_enter
        return 1
    fi

    info "Device detected:"
    separator
    local device_id
    device_id=$(echo "$devices" | head -1)

    local model serial sdk android_ver brand platform abi
    model=$(adb -s "$device_id" shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    brand=$(adb -s "$device_id" shell getprop ro.product.brand 2>/dev/null | tr -d '\r')
    serial=$(adb -s "$device_id" shell getprop ro.serialno 2>/dev/null | tr -d '\r')
    sdk=$(adb -s "$device_id" shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r')
    android_ver=$(adb -s "$device_id" shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    platform=$(adb -s "$device_id" shell getprop ro.board.platform 2>/dev/null | tr -d '\r')
    abi=$(adb -s "$device_id" shell getprop ro.product.cpu.abi 2>/dev/null | tr -d '\r')

    note "Brand       : ${brand:-Unknown}"
    note "Model       : ${model:-Unknown}"
    note "Serial      : ${serial:-Unknown}"
    note "Android SDK : API $sdk (Android $android_ver)"
    note "Platform    : ${platform:-Unknown}"
    note "CPU ABI     : ${abi:-Unknown}"
    note "Device ID   : $device_id"

    separator

    if [ -n "$sdk" ] && [ "$sdk" -lt 21 ]; then
        error "Your Android is too old (API $sdk / Android $android_ver)"
        error "ScreenMirror requires at least Android 5.0 (API 21)"
        exit 1
    elif [ -n "$sdk" ] && [ "$sdk" -lt 28 ]; then
        warn "Your Android (API $sdk) is supported but with limited features."
        warn "Recommended: Android 9+ (API 28) for best performance."
    else
        info "Device is compatible! ✓"
    fi

    local usb_debug
    usb_debug=$(adb -s "$device_id" shell settings get global development_settings_enabled 2>/dev/null | tr -d '\r')
    if [ "$usb_debug" = "1" ]; then
        info "USB Debugging: ENABLED ✓"
    else
        warn "Developer Options may need to be enabled. See tutorial."
    fi

    ACTIVE_DEVICE="$device_id"
    ACTIVE_SDK="$sdk"

    separator
    return 0
}

# ============================================================
# TUTORIALS
# ============================================================

tutorial_usb_debugging() {
    banner
    title "TUTORIAL: HOW TO ENABLE USB DEBUGGING"
    echo -e "${WHITE}"
    cat <<'TUTORIAL'
  USB Debugging is a hidden feature in Android phones that allows
  a computer to communicate directly with your phone. It is SAFE
  to use as long as you don't lend your phone to untrusted people.

  ────────────────────────────────────────────────────────
  STEP 1: Enable Developer Mode
  ────────────────────────────────────────────────────────
  1. Open "Settings" on your Android phone
  2. Scroll down and find "About Phone"
     → On Samsung: Settings > About Phone > Software Information
     → On Xiaomi: Settings > About Phone
     → On Oppo/Realme: Settings > About Phone
  3. Find "Build Number" (or "MIUI Version" on Xiaomi)
  4. Tap "Build Number" 7 TIMES in a row
  5. A message will appear: "You are now a developer!" ✓

  ────────────────────────────────────────────────────────
  STEP 2: Enable USB Debugging
  ────────────────────────────────────────────────────────
  1. Go back to main Settings
  2. Find "Developer Options" (usually at the very bottom)
     → On Samsung: Settings > Developer Options
     → On Xiaomi: Settings > Additional Settings > Developer Options
  3. Enable the "Developer Options" toggle (slide to ON)
  4. Scroll down and find "USB Debugging"
  5. Enable the "USB Debugging" toggle
  6. A warning popup will appear — tap "OK" or "Allow"

  ────────────────────────────────────────────────────────
  STEP 3: Connect to Your Laptop
  ────────────────────────────────────────────────────────
  1. Plug in the USB cable from your phone to your laptop
  2. A popup will appear on your phone: "Allow USB Debugging?"
  3. Check "Always allow from this computer"
  4. Tap "Allow" / "OK"
  5. On your laptop, run: adb devices
     → Your device ID should appear ✓

  ────────────────────────────────────────────────────────
  ⚠  SECURITY NOTE
  ────────────────────────────────────────────────────────
  • USB Debugging gives full access to your phone when connected
  • Do not enable it on someone else's phone
  • Disable it after use if your phone is shared
  • Never tap "Allow" on popups from computers you don't trust

TUTORIAL
    echo -e "${RESET}"
    press_enter
}

tutorial_wireless_debugging() {
    banner
    title "TUTORIAL: HOW TO ENABLE WIRELESS DEBUGGING (Android 11+)"
    echo -e "${WHITE}"
    cat <<'TUTORIAL'
  Wireless Debugging lets you connect your phone to your laptop
  without a USB cable, using the same WiFi network.
  Available on Android 11 and above.

  ────────────────────────────────────────────────────────
  REQUIREMENT: Phone and Laptop on the SAME WiFi Network
  ────────────────────────────────────────────────────────

  STEP 1: Enable Wireless Debugging
  ────────────────────────────────────────────────────────
  1. Go to Settings > Developer Options
     (Enable it first if not done — see USB Debugging tutorial)
  2. Find "Wireless Debugging" or "Wi-Fi Debugging"
  3. Enable the "Wireless Debugging" toggle
  4. A popup will appear — tap "Allow"
  5. Tap on the "Wireless Debugging" text to enter its menu

  STEP 2: Get the 6-Digit Pairing Code
  ────────────────────────────────────────────────────────
  ⚠  This step is REQUIRED before your first connection!

  1. Inside the Wireless Debugging menu, tap:
     ► "Pair device with pairing code"

  2. Your phone screen will show 3 pieces of info:
     ┌──────────────────────────────────────────────────┐
     │  IP Address    : example  192.168.1.5             │
     │  Pairing PORT  : example  43521   ← for adb pair  │
     │  6-digit code  : example  986143  ← secret code   │
     └──────────────────────────────────────────────────┘

  3. In this script, when prompted, enter:
     • Pairing IP:PORT  →  192.168.1.5:43521
     • 6-digit code     →  986143

  ⚠  IMPORTANT: The PAIRING port (43521) is DIFFERENT from the CONNECTION port!
     The pairing port only appears in the "Pair device" screen.
     The connection port is shown on the main Wireless Debugging screen.

  STEP 3: Note the Connection IP and Port
  ────────────────────────────────────────────────────────
  After pairing, go back to the main Wireless Debugging screen.
  At the top you will see:
  • "IP address & Port" → example: 192.168.1.5:39465
    → THIS is used for connecting (NOT the pairing port!)

  STEP 4: Connect via Script
  ────────────────────────────────────────────────────────
  Choose menu 3 (Wireless Debugging) from the main menu, then:
  • Choose "y" for pairing if it's your first time
  • Enter the pairing IP:PORT and 6-digit code
  • After pairing succeeds, enter the connection IP and Port

  ────────────────────────────────────────────────────────
  ⚠  IMPORTANT NOTES
  ────────────────────────────────────────────────────────
  • The Wireless Debugging port CHANGES each time WiFi reconnects
  • The 6-digit code expires in seconds — enter it quickly!
  • Make sure your laptop firewall doesn't block ADB connections
  • Performance depends on your WiFi signal quality
  • For Android 10 and below, use the WiFi via USB method instead

TUTORIAL
    echo -e "${RESET}"
    press_enter
}

tutorial_input_security() {
    banner
    title "SECURITY INFO: INPUT EVENT INJECTION"
    echo -e "${WHITE}"
    cat <<'TUTORIAL'
  ────────────────────────────────────────────────────────
  WHAT IS INPUT EVENT INJECTION?
  ────────────────────────────────────────────────────────
  When using ScreenMirror, your laptop keyboard and mouse can
  control your phone (clicks, typing, swiping). This is called
  "Input Event Injection" — the laptop sends virtual touch/key
  signals to your phone via ADB.

  ────────────────────────────────────────────────────────
  IS IT SAFE?
  ────────────────────────────────────────────────────────
  ✓ SAFE when:
  • You are the only one controlling the laptop
  • Laptop is connected to a secure WiFi (not public)
  • You are using a direct USB cable
  • Your phone is not shared with others

  ⚠ BE CAREFUL when:
  • Using public WiFi (cafe, mall, campus) — more vulnerable
  • Your laptop is accessed by someone else remotely
  • Your phone contains sensitive data (banking, passwords)

  ────────────────────────────────────────────────────────
  HOW TO MIRROR WITHOUT INPUT INJECTION (Safer)
  ────────────────────────────────────────────────────────
  Choose "Mirror Only (No Control)" mode when running the script.
  In this mode, the phone screen can be viewed but not controlled
  from the laptop — like watching a TV stream.

  Flag used: scrcpy --no-control

  ────────────────────────────────────────────────────────
  RECOMMENDATIONS
  ────────────────────────────────────────────────────────
  • For presentations or watching: use No Control mode
  • For personal productivity: normal mode is safe
  • Disable USB Debugging when not connected to your laptop

TUTORIAL
    echo -e "${RESET}"
    press_enter
}

# ============================================================
# SCRCPY OPTIONS
# ============================================================

configure_scrcpy() {
    title "SCRCPY SETTINGS"

    echo -e "${CYAN}  Choose FPS (Frames Per Second):${RESET}"
    echo "    1. 30 FPS  (saves battery, good for presentations)"
    echo "    2. 60 FPS  (smooth, recommended) [DEFAULT]"
    echo "    3. 120 FPS (ultra smooth, requires gaming phone)"
    echo "    4. Custom"
    read -rp "$(echo -e "${YELLOW}  FPS choice [1-4] (default: 2): ${RESET}")" fps_choice
    fps_choice="${fps_choice:-2}"
    case "$fps_choice" in
        1) LAST_FPS="30" ;;
        3) LAST_FPS="120" ;;
        4) read -rp "$(echo -e "${YELLOW}  Enter FPS: ${RESET}")" LAST_FPS; LAST_FPS="${LAST_FPS:-60}" ;;
        *) LAST_FPS="60" ;;
    esac
    info "FPS set to: $LAST_FPS"

    echo ""
    echo -e "${CYAN}  Choose Bitrate (Video Quality):${RESET}"
    echo "    1. 4M  - Standard (slow/distant connection)"
    echo "    2. 8M  - Good   (recommended) [DEFAULT]"
    echo "    3. 16M - Very good (fast WiFi)"
    echo "    4. 40M - Maximum (direct USB cable)"
    echo "    5. Custom"
    read -rp "$(echo -e "${YELLOW}  Bitrate choice [1-5] (default: 2): ${RESET}")" br_choice
    br_choice="${br_choice:-2}"
    case "$br_choice" in
        1) LAST_BITRATE="4M" ;;
        3) LAST_BITRATE="16M" ;;
        4) LAST_BITRATE="40M" ;;
        5) read -rp "$(echo -e "${YELLOW}  Enter bitrate (e.g. 10M): ${RESET}")" LAST_BITRATE; LAST_BITRATE="${LAST_BITRATE:-8M}" ;;
        *) LAST_BITRATE="8M" ;;
    esac
    info "Bitrate set to: $LAST_BITRATE"

    echo ""
    echo -e "${CYAN}  Choose Max Resolution:${RESET}"
    echo "    1. 720p  (lightweight)"
    echo "    2. 1080p (recommended) [DEFAULT]"
    echo "    3. 1440p (high quality, requires high-res phone)"
    echo "    4. Full (native phone resolution)"
    read -rp "$(echo -e "${YELLOW}  Resolution [1-4] (default: 2): ${RESET}")" res_choice
    res_choice="${res_choice:-2}"
    case "$res_choice" in
        1) LAST_RESOLUTION="720" ;;
        3) LAST_RESOLUTION="1440" ;;
        4) LAST_RESOLUTION="0" ;;
        *) LAST_RESOLUTION="1080" ;;
    esac

    echo ""
    echo -e "${CYAN}  Choose Video Codec:${RESET}"
    echo "    1. H.264  (widely compatible) [DEFAULT]"
    echo "    2. H.265  (more efficient, needs Android 10+)"
    echo "    3. AV1    (experimental, needs Android 14+)"
    read -rp "$(echo -e "${YELLOW}  Codec [1-3] (default: 1): ${RESET}")" codec_choice
    codec_choice="${codec_choice:-1}"
    case "$codec_choice" in
        2) LAST_CODEC="h265" ;;
        3) LAST_CODEC="av1" ;;
        *) LAST_CODEC="h264" ;;
    esac
    info "Codec set to: $LAST_CODEC"
    separator
}

configure_extra_features() {
    title "EXTRA FEATURES"

    # Camera Mirroring
    echo -e "${CYAN}  Camera Mirroring (Use phone camera as display?):${RESET}"
    read -rp "$(echo -e "${YELLOW}  Use phone camera? [y/n] (default: n): ${RESET}")" MIRROR_CAMERA
    MIRROR_CAMERA="${MIRROR_CAMERA:-n}"
    if [[ "$MIRROR_CAMERA" =~ ^[Yy]$ ]]; then
        read -rp "$(echo -e "${YELLOW}  Select camera [front/back/external] (default: back): ${RESET}")" CAMERA_FACING
        CAMERA_FACING="${CAMERA_FACING:-back}"
    fi

    echo ""
    # OTG Mode
    echo -e "${CYAN}  OTG Mode (Bypass screen blocks like games/banks. Requires USB cable):${RESET}"
    read -rp "$(echo -e "${YELLOW}  Enable OTG Mode? [y/n] (default: n): ${RESET}")" ENABLE_OTG
    ENABLE_OTG="${ENABLE_OTG:-n}"

    if [[ ! "$ENABLE_OTG" =~ ^[Yy]$ ]]; then
        echo ""
        # Window Options
        echo -e "${CYAN}  Window Options (Always on Top / Borderless):${RESET}"
        echo "    1. Normal"
        echo "    2. Always on Top"
        echo "    3. Borderless"
        echo "    4. Top & Borderless"
        read -rp "$(echo -e "${YELLOW}  Choose option [1-4] (default: 1): ${RESET}")" WINDOW_OPTIONS
        WINDOW_OPTIONS="${WINDOW_OPTIONS:-1}"

        echo ""
        # Audio Control
        echo -e "${CYAN}  Audio Settings (Android 11+):${RESET}"
        echo "    1. Audio on Laptop only (Default)"
        echo "    2. Audio on Phone and Laptop (Audio Duplication)"
        echo "    3. Audio on Phone only (Disable forwarding)"
        echo "    4. Forward Phone Microphone to Laptop"
        read -rp "$(echo -e "${YELLOW}  Select audio mode [1-4] (default: 1): ${RESET}")" AUDIO_MODE
        AUDIO_MODE="${AUDIO_MODE:-1}"

        echo ""
        # Advanced Keyboard
        echo -e "${CYAN}  Keyboard Mode (100% accurate physical simulation):${RESET}"
        read -rp "$(echo -e "${YELLOW}  Use physical keyboard mode (uhid)? [y/n] (default: n): ${RESET}")" ADVANCED_KEYBOARD
        ADVANCED_KEYBOARD="${ADVANCED_KEYBOARD:-n}"

        echo ""
        read -rp "$(echo -e "${YELLOW}  Enable Stay Awake (keep phone screen on during mirroring)? [y/n] (default: y): ${RESET}")" STAY_AWAKE
        STAY_AWAKE="${STAY_AWAKE:-y}"

        echo ""
        note "Turn Screen Off: Phone screen turns off but mirroring continues on laptop"
        read -rp "$(echo -e "${YELLOW}  Turn phone screen off? [y/n] (default: n): ${RESET}")" TURN_SCREEN_OFF
        TURN_SCREEN_OFF="${TURN_SCREEN_OFF:-n}"

        echo ""
        note "No Control mode: View phone screen but cannot control it from laptop (safer for presentations)"
        read -rp "$(echo -e "${YELLOW}  Enable No Control mode? [y/n] (default: n): ${RESET}")" NO_CONTROL
        NO_CONTROL="${NO_CONTROL:-n}"
    fi

    echo ""
    read -rp "$(echo -e "${YELLOW}  Record screen to video file? [y/n] (default: n): ${RESET}")" RECORD_SCREEN
    RECORD_SCREEN="${RECORD_SCREEN:-n}"
    if [[ "$RECORD_SCREEN" =~ ^[Yy]$ ]]; then
        RECORD_FILENAME="screenmirror_$(date +%Y%m%d_%H%M%S).mp4"
        read -rp "$(echo -e "${YELLOW}  Recording filename (default: $RECORD_FILENAME): ${RESET}")" custom_name
        RECORD_FILENAME="${custom_name:-$RECORD_FILENAME}"
        info "Recording will be saved to: $RECORD_FILENAME"
    fi
    separator
}

# ============================================================
# BUILD SCRCPY COMMAND
# ============================================================

build_scrcpy_args() {
    local args=()
    
    if [ "$LAST_CONNECTION" = "1" ]; then
        args+=("-d")
    elif [ "$LAST_CONNECTION" = "2" ] || [ "$LAST_CONNECTION" = "3" ]; then
        args+=("-s" "${LAST_IP}:${LAST_PORT}")
    fi

    args+=("--video-codec=$LAST_CODEC")
    args+=("-b" "$LAST_BITRATE")
    args+=("--max-fps" "$LAST_FPS")
    [ "$LAST_RESOLUTION" != "0" ] && args+=("--max-size" "$LAST_RESOLUTION")
    [[ "$STAY_AWAKE" =~ ^[Yy]$ ]] && args+=("--stay-awake")
    [[ "$TURN_SCREEN_OFF" =~ ^[Yy]$ ]] && args+=("--turn-screen-off")
    [[ "$NO_CONTROL" =~ ^[Yy]$ ]] && args+=("--no-control")
    [[ "$RECORD_SCREEN" =~ ^[Yy]$ ]] && args+=("--record" "$RECORD_FILENAME")
    [[ "$MIRROR_CAMERA" =~ ^[Yy]$ ]] && args+=("--video-source=camera" "--camera-facing=$CAMERA_FACING")
    
    if [[ "$ENABLE_OTG" =~ ^[Yy]$ ]]; then
        args=("--otg")
        echo "${args[@]}"
        return
    fi
    
    [ "$WINDOW_OPTIONS" = "2" ] && args+=("--always-on-top")
    [ "$WINDOW_OPTIONS" = "3" ] && args+=("--window-borderless")
    [ "$WINDOW_OPTIONS" = "4" ] && args+=("--always-on-top" "--window-borderless")
    
    # Audio Control
    [ "$AUDIO_MODE" = "2" ] && args+=("--audio-source=playback" "--audio-dup")
    [ "$AUDIO_MODE" = "3" ] && args+=("--no-audio")
    [ "$AUDIO_MODE" = "4" ] && args+=("--audio-source=mic")
    
    [[ "$ADVANCED_KEYBOARD" =~ ^[Yy]$ ]] && args+=("--keyboard=uhid")

    echo "${args[@]}"
}

launch_scrcpy() {
    local args
    args=$(build_scrcpy_args)
    title "STARTING SCREEN MIRROR"
    step "Running: scrcpy $args"
    separator
    info "Mirror window will appear shortly..."
    info "Press Ctrl+C to stop mirroring"
    note "Shortcuts: Ctrl+H = Home | Ctrl+B = Back | Ctrl+M = Menu"
    separator
    echo ""
    # shellcheck disable=SC2086
    scrcpy $args
}

# ============================================================
# CONNECTION MODES
# ============================================================

connect_usb() {
    title "USB CONNECTION"
    adb kill-server &>/dev/null; adb start-server &>/dev/null
    check_device || return 1
    LAST_CONNECTION="1"
    load_mode_config "USB"
    if ! ask_reuse_mode_config "USB" "USB"; then
        configure_scrcpy
        configure_extra_features
    fi
    save_mode_config "USB"
    save_config
    launch_scrcpy
}

connect_wifi() {
    title "WiFi CONNECTION (ADB TCP/IP)"
    step "STEP 1: Make sure USB cable is still connected for initial setup"
    adb kill-server &>/dev/null; adb start-server &>/dev/null
    check_device || return 1

    load_mode_config "WIFI"
    LAST_PORT="${LAST_PORT:-5555}"
    read -rp "$(echo -e "${YELLOW}  Enter TCP port [default: $LAST_PORT]: ${RESET}")" input_port
    LAST_PORT="${input_port:-$LAST_PORT}"

    step "STEP 2: Enabling TCP/IP mode on phone..."
    adb -s "$ACTIVE_DEVICE" tcpip "$LAST_PORT"
    sleep 1

    echo ""
    note "Find your phone's IP: Settings > About Phone > Status > IP Address"
    note "              OR: Settings > WiFi > (your WiFi name) > Details"
    echo ""
    read -rp "$(echo -e "${YELLOW}  Enter Android phone IP address${LAST_IP:+ [default: $LAST_IP]}: ${RESET}")" input_ip
    LAST_IP="${input_ip:-$LAST_IP}"
    [ -z "$LAST_IP" ] && { error "IP cannot be empty!"; return 1; }

    step "STEP 3: Unplug the USB cable now, then press Enter"
    echo -e "${RED}  ⚡ Unplug USB cable from phone first!${RESET}"
    press_enter

    step "STEP 4: Connecting via WiFi to $LAST_IP:$LAST_PORT..."
    adb connect "${LAST_IP}:${LAST_PORT}"
    sleep 3

    if ! adb devices | grep -q "${LAST_IP}:${LAST_PORT}"; then
        error "WiFi connection failed!"
        warn "Make sure phone and laptop are on the same WiFi network"
        warn "Make sure TCP/IP mode is still active (re-run and plug USB first if needed)"
        warn "Try temporarily disabling firewall: sudo ufw disable"
        return 1
    fi

    info "WiFi connection successful! ✓"
    LAST_CONNECTION="2"
    if ! ask_reuse_mode_config "WIFI" "WiFi"; then
        configure_scrcpy
        configure_extra_features
    fi
    save_mode_config "WIFI"
    save_config
    launch_scrcpy
}

connect_wireless_debug() {
    title "WIRELESS DEBUGGING (Android 11+)"
    warn "This feature requires Android 11 or newer!"
    note "For Android 10 and below, use the WiFi connection option instead."
    echo ""

    load_mode_config "WD"

    read -rp "$(echo -e "${YELLOW}  First time? (Pairing needed) [y/n] (default: y): ${RESET}")" DO_PAIR
    DO_PAIR="${DO_PAIR:-y}"

    if [[ "$DO_PAIR" =~ ^[Yy]$ ]]; then
        echo ""
        note "On your phone: Settings > Developer Options > Wireless Debugging"
        note "              > 'Pair device with pairing code'"
        note "Note the IP:PORT and the 6-digit pairing code"
        echo ""
        read -rp "$(echo -e "${YELLOW}  Enter pairing IP:PORT (e.g. 192.168.1.5:43521): ${RESET}")" PAIR_ADDR
        read -rp "$(echo -e "${YELLOW}  Enter 6-digit pairing code from phone: ${RESET}")" PAIR_CODE

        [ -z "$PAIR_ADDR" ] || [ -z "$PAIR_CODE" ] && { error "Pairing address and code cannot be empty!"; return 1; }

        step "Pairing with $PAIR_ADDR..."
        adb pair "$PAIR_ADDR" "$PAIR_CODE" || { error "Pairing failed! Check code and address."; return 1; }
        info "Pairing successful! ✓"
    fi

    echo ""
    read -rp "$(echo -e "${YELLOW}  Auto-detect phone IP on this WiFi network? [y/n] (default: y): ${RESET}")" DO_MDNS
    DO_MDNS="${DO_MDNS:-y}"

    if [[ "$DO_MDNS" =~ ^[Yy]$ ]]; then
        step "Scanning for Wireless Debugging devices..."
        local mdns_found
        mdns_found=$(adb mdns services 2>/dev/null | grep "adb-tls-connect" | awk '{print $3}')
        if [ -n "$mdns_found" ]; then
            info "Device found: $mdns_found"
            LAST_IP="${mdns_found%:*}"
            LAST_PORT="${mdns_found#*:}"
            DO_MANUAL="n"
        else
            warn "No auto-detected device, please enter manually."
            DO_MANUAL="y"
        fi
    else
        DO_MANUAL="y"
    fi

    if [ "$DO_MANUAL" = "y" ]; then
        echo ""
        note "On phone: Settings > Developer Options > Wireless Debugging"
        note "Note the 'IP address & Port' shown at the top"
        echo ""
        read -rp "$(echo -e "${YELLOW}  Enter phone IP${LAST_IP:+ [default: $LAST_IP]}: ${RESET}")" input_ip
        LAST_IP="${input_ip:-$LAST_IP}"
        read -rp "$(echo -e "${YELLOW}  Enter Port (from Wireless Debugging)${LAST_PORT:+ [default: $LAST_PORT]}: ${RESET}")" input_port
        LAST_PORT="${input_port:-$LAST_PORT}"
        [ -z "$LAST_IP" ] || [ -z "$LAST_PORT" ] && { error "IP and Port cannot be empty!"; return 1; }
    fi

    step "Connecting to ${LAST_IP}:${LAST_PORT}..."
    adb connect "${LAST_IP}:${LAST_PORT}"
    sleep 3

    if ! adb devices | grep -q "${LAST_IP}:${LAST_PORT}"; then
        error "Connection failed!"
        warn "Make sure phone and laptop are on the same WiFi network"
        warn "Make sure Wireless Debugging is still active on your phone"
        warn "The port changes every time WiFi reconnects — check the phone for the new port"
        return 1
    fi

    info "Wireless Debugging connection successful! ✓"
    LAST_CONNECTION="3"
    if ! ask_reuse_mode_config "WD" "Wireless Debug"; then
        configure_scrcpy
        configure_extra_features
    fi
    save_mode_config "WD"
    save_config
    launch_scrcpy
}

# ============================================================
# QUICK SCREENSHOT
# ============================================================

take_screenshot() {
    title "TAKE SCREENSHOT"
    step "Taking screenshot from phone..."
    local filename="screenshot_$(date +%Y%m%d_%H%M%S).png"
    adb exec-out screencap -p > "$filename"
    if [ -f "$filename" ] && [ -s "$filename" ]; then
        info "Screenshot saved: $filename"
    else
        [ -f "$filename" ] && rm -f "$filename"
        error "Failed to take screenshot. Make sure phone is connected and ADB is active."
    fi
    press_enter
}

# ============================================================
# INSTALL SHORTCUT
# ============================================================

install_shortcut() {
    title "INSTALL SHORTCUT (RUN FROM ANYWHERE)"
    echo -e "${CYAN}  This will create 'screenmirror' and 'mulaism' commands in /usr/local/bin${RESET}"
    echo -e "${CYAN}  so you can run the program from anywhere in your terminal.${RESET}"
    echo ""
    read -rp "$(echo -e "${YELLOW}  Proceed with installation? [y/n] (default: y): ${RESET}")" proceed
    proceed="${proceed:-y}"
    if [[ "$proceed" =~ ^[Yy]$ ]]; then
        step "Requesting sudo permission to create symlinks..."
        local target_dir="/usr/local/bin"
        # Point to the root run.sh
        local source_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/run.sh"
        
        sudo ln -sf "$source_file" "$target_dir/screenmirror"
        sudo ln -sf "$source_file" "$target_dir/mulaism"
        
        if [ $? -eq 0 ]; then
            info "Shortcuts created successfully!"
            info "You can now type 'screenmirror' or 'mulaism' in your terminal."
        else
            error "Failed to create shortcuts. Make sure you have sudo privileges."
        fi
    fi
    press_enter
}

# ============================================================
# CHECK UPDATE
# ============================================================

check_update() {
    title "CHECK FOR UPDATES"
    info "Checking for the latest version on GitHub..."
    LATEST_VER=$(curl -s https://api.github.com/repos/Xnuvers007/ScreenMirror/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ -z "$LATEST_VER" ]; then
        error "Failed to check for updates. Please check your internet connection or install curl."
    else
        if [ "$LATEST_VER" = "$SCRIPT_VERSION" ]; then
            ok "ScreenMirror is up to date ($SCRIPT_VERSION)."
        else
            warn "A new version is available: $LATEST_VER (Current: $SCRIPT_VERSION)"
            echo ""
            info "Please download the latest version at:"
            info "https://github.com/Xnuvers007/ScreenMirror/releases/latest"
        fi
    fi
    echo ""
    press_enter
}

# ============================================================
# MAIN MENU
# ============================================================

main_menu() {
    while true; do
        banner
        title "MAIN MENU"
        echo -e "  ${CYAN}Choose connection method or option:${RESET}"
        echo ""
        echo -e "  ${GREEN}  ─── CONNECTION ──────────────────────────────${RESET}"
        echo -e "  ${WHITE}  1.${RESET} 🔌 USB Connection (cable)"
        echo -e "  ${WHITE}  2.${RESET} 📶 WiFi Connection (all Android, needs USB once)"
        echo -e "  ${WHITE}  3.${RESET} 🛜 Wireless Debugging (Android 11+, fully wireless)"
        echo ""
        echo -e "  ${GREEN}  ─── TUTORIALS & INFO ────────────────────────${RESET}"
        echo -e "  ${WHITE}  4.${RESET} 📖 Tutorial: Enable USB Debugging"
        echo -e "  ${WHITE}  5.${RESET} 📡 Tutorial: Enable Wireless Debugging"
        echo -e "  ${WHITE}  6.${RESET} 🔒 Security: Input Event Injection"
        echo ""
        echo -e "  ${GREEN}  ─── TOOLS ───────────────────────────────────${RESET}"
        echo -e "  ${WHITE}  7.${RESET} 📸 Take Screenshot from Phone"
        echo -e "  ${WHITE}  8.${RESET} 🔧 Check Device Compatibility"
        echo -e "  ${WHITE}  9.${RESET} ⚙  View/Edit Saved Configuration"
        echo -e "  ${WHITE} 10.${RESET} 🔗 Install Shortcut (Run from anywhere)"
        echo -e "  ${WHITE}  c.${RESET} 🔄 Check for ScreenMirror Updates"
        echo -e "  ${WHITE}  0.${RESET} 🚪 Exit"
        echo ""
        separator
        read -rp "$(echo -e "${YELLOW}  Enter choice [0-10,c]: ${RESET}")" choice

        case "$choice" in
            1) connect_usb ;;
            2) connect_wifi ;;
            3) connect_wireless_debug ;;
            4) tutorial_usb_debugging ;;
            5) tutorial_wireless_debugging ;;
            6) tutorial_input_security ;;
            7) take_screenshot ;;
            8) check_device; press_enter ;;
            9)
                title "SAVED CONFIGURATION"
                if [ -f "$CONFIG_FILE" ]; then
                    separator
                    echo -e "  ${CYAN}  ─── USB Config ──────────────────────────────${RESET}"
                    note "  FPS: $USB_FPS | Bitrate: $USB_BITRATE | Resolution: $USB_RESOLUTION | Codec: $USB_CODEC"
                    note "  Stay Awake: $USB_STAY_AWAKE | No Control: $USB_NO_CONTROL | Screen Off: $USB_TURN_SCREEN_OFF"
                    echo ""
                    echo -e "  ${CYAN}  ─── WiFi Config ─────────────────────────────${RESET}"
                    note "  IP: ${WIFI_IP:-Not set} | Port: $WIFI_PORT"
                    note "  FPS: $WIFI_FPS | Bitrate: $WIFI_BITRATE | Resolution: $WIFI_RESOLUTION | Codec: $WIFI_CODEC"
                    note "  Stay Awake: $WIFI_STAY_AWAKE | No Control: $WIFI_NO_CONTROL | Screen Off: $WIFI_TURN_SCREEN_OFF"
                    echo ""
                    echo -e "  ${CYAN}  ─── Wireless Debug Config ────────────────────${RESET}"
                    note "  IP: ${WD_IP:-Not set} | Port: $WD_PORT"
                    note "  FPS: $WD_FPS | Bitrate: $WD_BITRATE | Resolution: $WD_RESOLUTION | Codec: $WD_CODEC"
                    note "  Stay Awake: $WD_STAY_AWAKE | No Control: $WD_NO_CONTROL | Screen Off: $WD_TURN_SCREEN_OFF"
                    separator
                    echo ""
                    read -rp "$(echo -e "${YELLOW}  Delete all configuration? [y/n]: ${RESET}")" del_conf
                    if [[ "$del_conf" =~ ^[Yy]$ ]]; then
                        rm -f "$CONFIG_FILE"
                        info "Configuration deleted."
                        load_config
                    fi
                else
                    warn "No saved configuration yet."
                fi
                press_enter
                ;;
            10) install_shortcut ;;
            [cC]) check_update ;;
            0) echo -e "\n${GREEN}  Goodbye! 👋${RESET}\n"; exit 0 ;;
            *) warn "Invalid choice. Try again." ;;
        esac
    done
}

# ============================================================
# MAIN
# ============================================================

main() {
    banner
    check_dependencies

    # Auto Update Check
    echo -e "${CYAN}  Checking for ScreenMirror updates...${RESET}"
    LATEST_VER=$(curl -s --max-time 3 https://api.github.com/repos/Xnuvers007/ScreenMirror/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ -n "$LATEST_VER" ] && [ "$LATEST_VER" != "$SCRIPT_VERSION" ]; then
        echo ""
        echo -e "${YELLOW}  =================================================================${RESET}"
        echo -e "${YELLOW}   UPDATE AVAILABLE: $LATEST_VER (Current version: $SCRIPT_VERSION)${RESET}"
        echo -e "${YELLOW}   Manual download at: https://github.com/Xnuvers007/ScreenMirror/releases/latest${RESET}"
        echo -e "${YELLOW}  =================================================================${RESET}"
        echo ""
        read -rp "$(echo -e "${YELLOW}  Update now? (Auto download & install) [y/n] (default: n): ${RESET}")" DO_UPDATE
        DO_UPDATE="${DO_UPDATE:-n}"
        if [[ "$DO_UPDATE" =~ ^[Yy]$ ]]; then
            info "Downloading update ($LATEST_VER)..."
            curl -L -s -o update.zip "https://github.com/Xnuvers007/ScreenMirror/archive/refs/tags/${LATEST_VER}.zip"
            if [ -f "update.zip" ]; then
                info "Extracting update..."
                unzip -q update.zip -d update_tmp
                info "Installing update..."
                PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                cp -r update_tmp/ScreenMirror-${LATEST_VER#v}/* "$PROJECT_DIR/"
                rm -rf update_tmp update.zip
                ok "Update successful! Please restart ScreenMirror."
                exit 0
            else
                error "Failed to download update."
                sleep 3
            fi
        fi
    fi

    load_config
    main_menu
}

main
