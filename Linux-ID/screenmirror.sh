#!/bin/bash
# ============================================================
#  ScreenMirror - Script Utama (Linux - Bahasa Indonesia)
#  Dibuat oleh Xnuvers007
#  Jangan dimodifikasi tanpa mencantumkan kredit/sumber asli
# ============================================================
# LISENSI: MIT | GitHub: https://github.com/Xnuvers007/ScreenMirror
# ============================================================

# --- Warna Terminal ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
PURPLE='\033[1;35m'
RESET='\033[0m'
BOLD='\033[1m'

# --- Konfigurasi ---
CONFIG_FILE="$HOME/.screenmirror.conf"
SCRCPY_VERSION="2.1.1"

# ============================================================
# FUNGSI UTILITAS
# ============================================================

banner() {
    clear
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║       📱  S C R E E N   M I R R O R  📺            ║"
    echo "  ║          Android → Laptop  |  by Xnuvers007         ║"
    echo "  ║        Linux Edition  |  Bahasa Indonesia           ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

separator() {
    echo -e "${BLUE}  ──────────────────────────────────────────────────────${RESET}"
}

info()    { echo -e "${GREEN}  [✔] $1${RESET}"; }
warn()    { echo -e "${YELLOW}  [⚠] $1${RESET}"; }
error()   { echo -e "${RED}  [✘] $1${RESET}"; }
title()   { echo -e "\n${PURPLE}${BOLD}  ═══ $1 ═══${RESET}\n"; }
step()    { echo -e "${CYAN}  ▶ $1${RESET}"; }
note()    { echo -e "${WHITE}  ℹ  $1${RESET}"; }

tekan_enter() {
    echo ""
    read -rp "$(echo -e "${YELLOW}  Tekan [ENTER] untuk melanjutkan...${RESET}")"
}

# ============================================================
# SIMPAN & MUAT KONFIGURASI
# ============================================================

simpan_config() {
    cat > "$CONFIG_FILE" <<EOF
# ScreenMirror Configuration - Disimpan otomatis
# Terakhir diperbarui: $(date)
LAST_CONNECTION="$LAST_CONNECTION"
LAST_IP="$LAST_IP"
LAST_PORT="$LAST_PORT"
LAST_FPS="$LAST_FPS"
LAST_BITRATE="$LAST_BITRATE"
LAST_RESOLUTION="$LAST_RESOLUTION"
LAST_CODEC="$LAST_CODEC"
STAY_AWAKE="$STAY_AWAKE"
NO_CONTROL="$NO_CONTROL"
TURN_SCREEN_OFF="$TURN_SCREEN_OFF"
EOF
    info "Konfigurasi berhasil disimpan ke: $CONFIG_FILE"
}

muat_config() {
    # Nilai default
    LAST_CONNECTION="1"
    LAST_IP=""
    LAST_PORT="5555"
    LAST_FPS="60"
    LAST_BITRATE="8M"
    LAST_RESOLUTION="1080"
    LAST_CODEC="h264"
    STAY_AWAKE="y"
    NO_CONTROL="n"
    TURN_SCREEN_OFF="n"

    if [ -f "$CONFIG_FILE" ]; then
        # shellcheck source=/dev/null
        source "$CONFIG_FILE"
        info "Konfigurasi terakhir dimuat dari: $CONFIG_FILE"
        separator
        note "IP Terakhir      : ${LAST_IP:-Belum diset}"
        note "Port Terakhir    : $LAST_PORT"
        note "FPS Terakhir     : $LAST_FPS"
        note "Bitrate Terakhir : $LAST_BITRATE"
        note "Koneksi Terakhir : $([ "$LAST_CONNECTION" = "1" ] && echo "USB" || ([ "$LAST_CONNECTION" = "2" ] && echo "WiFi/TCP" || echo "Wireless Debug"))"
        separator
        echo ""
        read -rp "$(echo -e "${YELLOW}  Gunakan konfigurasi terakhir? [y/n] (default: y): ${RESET}")" USE_LAST
        USE_LAST="${USE_LAST:-y}"
        if [[ "$USE_LAST" =~ ^[Yy]$ ]]; then
            return 0  # Gunakan config tersimpan
        fi
    fi
    return 1  # Minta input baru
}

# ============================================================
# CEK DEPENDENSI & KOMPATIBILITAS
# ============================================================

cek_dependensi() {
    title "CEK DEPENDENSI"
    local missing=0

    for cmd in adb scrcpy; do
        if command -v "$cmd" &>/dev/null; then
            info "$cmd ditemukan: $(which $cmd)"
        else
            error "$cmd TIDAK ditemukan!"
            missing=$((missing + 1))
        fi
    done

    if [ $missing -gt 0 ]; then
        warn "Ada dependensi yang kurang. Coba install dengan:"
        note "sudo apt-get install -y adb scrcpy"
        echo ""
        read -rp "$(echo -e "${YELLOW}  Install otomatis sekarang? [y/n]: ${RESET}")" INSTALL_NOW
        if [[ "$INSTALL_NOW" =~ ^[Yy]$ ]]; then
            step "Menginstall dependensi..."
            sudo apt-get update -q
            sudo apt-get install -y adb scrcpy
            info "Instalasi selesai!"
        else
            error "Silakan install dependensi terlebih dahulu, lalu jalankan ulang script ini."
            exit 1
        fi
    fi
}

cek_perangkat() {
    title "CEK PERANGKAT ANDROID"

    step "Memulai ADB server..."
    adb kill-server &>/dev/null
    adb start-server &>/dev/null

    local devices
    devices=$(adb devices | awk 'NR>1 && $2=="device" {print $1}')

    if [ -z "$devices" ]; then
        error "Tidak ada perangkat Android yang terdeteksi!"
        separator
        echo -e "${YELLOW}"
        echo "  Kemungkinan penyebab:"
        echo "  1. Kabel USB belum terpasang (untuk koneksi USB)"
        echo "  2. USB Debugging belum diaktifkan di HP"
        echo "  3. Pilih 'Izinkan' saat muncul popup 'Izinkan USB Debugging?'"
        echo "  4. Driver USB belum terinstall"
        echo -e "${RESET}"
        tekan_enter
        return 1
    fi

    info "Perangkat terdeteksi:"
    separator
    local device_id
    device_id=$(echo "$devices" | head -1)

    local model serial sdk
    model=$(adb -s "$device_id" shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    serial=$(adb -s "$device_id" shell getprop ro.serialno 2>/dev/null | tr -d '\r')
    sdk=$(adb -s "$device_id" shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r')
    android_ver=$(adb -s "$device_id" shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')

    note "Model       : ${model:-Tidak diketahui}"
    note "Serial      : ${serial:-Tidak diketahui}"
    note "Android SDK : API $sdk (Android $android_ver)"
    note "Device ID   : $device_id"

    separator

    # Cek kompatibilitas minimum
    if [ -n "$sdk" ] && [ "$sdk" -lt 21 ]; then
        error "Android Anda terlalu lama (API $sdk / Android $android_ver)"
        error "ScreenMirror membutuhkan minimal Android 5.0 (API 21)"
        exit 1
    elif [ -n "$sdk" ] && [ "$sdk" -lt 28 ]; then
        warn "Android Anda (API $sdk) didukung, namun fitur terbatas."
        warn "Direkomendasikan Android 9+ (API 28) untuk performa optimal."
    else
        info "Perangkat kompatibel! ✓"
    fi

    # Cek USB Debugging aktif
    local usb_debug
    usb_debug=$(adb -s "$device_id" shell settings get global development_settings_enabled 2>/dev/null | tr -d '\r')
    if [ "$usb_debug" = "1" ]; then
        info "USB Debugging: AKTIF ✓"
    else
        warn "Opsi Developer mungkin perlu diaktifkan. Lihat tutorial di bawah."
    fi

    # Simpan device_id untuk dipakai fungsi lain
    ACTIVE_DEVICE="$device_id"
    ACTIVE_SDK="$sdk"

    separator
    return 0
}

# ============================================================
# TUTORIAL LANGKAH DEMI LANGKAH
# ============================================================

tutorial_usb_debugging() {
    banner
    title "TUTORIAL: CARA AKTIFKAN USB DEBUGGING"
    echo -e "${WHITE}"
    cat <<'TUTORIAL'
  USB Debugging adalah fitur tersembunyi di HP Android yang memungkinkan
  komputer berkomunikasi langsung dengan HP Anda. Fitur ini AMAN digunakan
  selama HP tidak dipinjamkan ke orang yang tidak dikenal.

  ────────────────────────────────────────────────────────
  LANGKAH 1: Aktifkan Mode Pengembang (Developer Mode)
  ────────────────────────────────────────────────────────
  1. Buka aplikasi "Pengaturan" (Settings) di HP Anda
  2. Gulir ke bawah, cari "Tentang Ponsel" (About Phone)
     → Pada Samsung: Pengaturan > Tentang Ponsel > Info Perangkat Lunak
     → Pada Xiaomi: Pengaturan > Tentang Ponsel
     → Pada Oppo/Realme: Pengaturan > Tentang Ponsel
  3. Cari tulisan "Nomor Build" (Build Number) atau "Versi MIUI"
  4. Ketuk tulisan "Nomor Build" sebanyak 7 KALI berturut-turut
  5. Akan muncul pesan: "Anda sekarang adalah pengembang!" ✓

  ────────────────────────────────────────────────────────
  LANGKAH 2: Aktifkan USB Debugging
  ────────────────────────────────────────────────────────
  1. Kembali ke "Pengaturan" utama
  2. Cari menu "Opsi Pengembang" (Developer Options)
     → Biasanya di bagian paling bawah Pengaturan
     → Pada Samsung: Pengaturan > Opsi Pengembang
     → Pada Xiaomi: Pengaturan > Setelan Tambahan > Opsi Pengembang
  3. Aktifkan toggle "Opsi Pengembang" (geser ke ON)
  4. Gulir ke bawah, cari "USB Debugging"
  5. Aktifkan toggle "USB Debugging"
  6. Akan muncul popup peringatan, pilih "OK" atau "Izinkan"

  ────────────────────────────────────────────────────────
  LANGKAH 3: Hubungkan ke Laptop
  ────────────────────────────────────────────────────────
  1. Colokkan kabel USB dari HP ke laptop
  2. Di HP akan muncul popup: "Izinkan USB Debugging?"
  3. Centang "Selalu izinkan dari komputer ini"
  4. Ketuk "Izinkan" / "OK"
  5. Di laptop, jalankan: adb devices
     → Harus muncul ID perangkat Anda ✓

  ────────────────────────────────────────────────────────
  ⚠  CATATAN KEAMANAN
  ────────────────────────────────────────────────────────
  • USB Debugging memberi akses penuh ke HP saat terhubung
  • Jangan aktifkan di HP orang lain
  • Nonaktifkan kembali setelah selesai jika HP sering dipinjam
  • Jangan pilih "Izinkan" pada popup dari komputer yang tidak dikenal

TUTORIAL
    echo -e "${RESET}"
    tekan_enter
}

tutorial_wireless_debugging() {
    banner
    title "TUTORIAL: CARA AKTIFKAN WIRELESS DEBUGGING (Android 11+)"
    echo -e "${WHITE}"
    cat <<'TUTORIAL'
  Wireless Debugging adalah cara menghubungkan HP ke laptop tanpa kabel,
  menggunakan jaringan WiFi yang sama. Tersedia di Android 11 ke atas.

  ────────────────────────────────────────────────────────
  SYARAT: HP dan Laptop harus terhubung ke WiFi yang SAMA
  ────────────────────────────────────────────────────────

  LANGKAH 1: Aktifkan Wireless Debugging
  ────────────────────────────────────────────────────────
  1. Buka Pengaturan > Opsi Pengembang
     (Jika belum, aktifkan dulu — lihat Tutorial USB Debugging)
  2. Cari "Wireless Debugging" atau "Debug Nirkabel"
  3. Aktifkan toggle "Wireless Debugging"
  4. Akan muncul popup, pilih "Izinkan"
  5. Ketuk tulisan "Wireless Debugging" untuk masuk ke menunya

  LANGKAH 2: Dapatkan Kode 6-Digit untuk Pairing
  ────────────────────────────────────────────────────────
  ⚠  Langkah ini WAJIB dilakukan sebelum koneksi pertama kali!

  1. Di dalam menu Wireless Debugging, ketuk:
     ► "Pasangkan perangkat dengan kode penyambungan"
       (atau "Pair device with pairing code")

  2. Layar HP akan menampilkan 3 informasi penting:
     ┌─────────────────────────────────────────────┐
     │  IP Address   : contoh  192.168.1.5          │
     │  Port PAIRING : contoh  43521   ← untuk pair │
     │  Kode 6-digit : contoh  986143  ← kode rahasia│
     └─────────────────────────────────────────────┘

  3. Di script ini, saat diminta, masukkan:
     • IP:PORT pairing  →  192.168.1.5:43521
     • Kode 6-digit     →  986143

  ⚠  PENTING: Port PAIRING (43521) BERBEDA dengan port KONEKSI!
     Port pairing hanya muncul saat menu "Pasangkan perangkat".
     Port koneksi ada di layar utama Wireless Debugging.

  LANGKAH 3: Catat IP dan Port Koneksi
  ────────────────────────────────────────────────────────
  Setelah pairing selesai, kembali ke layar utama Wireless Debugging.
  Di bagian atas akan tertera:
  • "IP address & Port" → contoh: 192.168.1.5:39465
    → INI yang dipakai untuk adb connect (BUKAN port pairing!)

  LANGKAH 4: Hubungkan via Script
  ────────────────────────────────────────────────────────
  Pilih menu 3 (Wireless Debugging) di menu utama, lalu:
  • Pilih "y" untuk pairing jika pertama kali
  • Masukkan IP:PORT pairing dan kode 6-digit
  • Setelah pairing berhasil, masukkan IP dan Port koneksi

  ────────────────────────────────────────────────────────
  ⚠  CATATAN PENTING
  ────────────────────────────────────────────────────────
  • Port Wireless Debugging BERUBAH setiap kali WiFi di-reconnect
  • Kode 6-digit hanya berlaku beberapa detik, jangan sampai habis!
  • Pastikan firewall laptop tidak memblokir koneksi ADB
  • Performa tergantung kualitas sinyal WiFi Anda
  • Untuk Android 10 ke bawah, gunakan metode WiFi via USB (tcpip 5555)

TUTORIAL
    echo -e "${RESET}"
    tekan_enter
}

tutorial_keamanan_input() {
    banner
    title "INFORMASI KEAMANAN: INPUT EVENT INJECTION"
    echo -e "${WHITE}"
    cat <<'TUTORIAL'
  ────────────────────────────────────────────────────────
  APA ITU INPUT EVENT INJECTION?
  ────────────────────────────────────────────────────────
  Saat Anda menggunakan ScreenMirror, keyboard dan mouse laptop
  dapat mengontrol HP (mengklik, mengetik, menggesek layar).
  Ini disebut "Input Event Injection" — laptop mengirim sinyal
  sentuhan/ketikan ke HP secara virtual via ADB.

  ────────────────────────────────────────────────────────
  APAKAH INI AMAN?
  ────────────────────────────────────────────────────────
  ✓ AMAN jika:
  • Anda sendiri yang mengontrol laptop
  • Laptop terhubung ke jaringan WiFi yang aman (bukan publik)
  • Anda menggunakan kabel USB langsung
  • HP Anda tidak dipinjam ke orang lain

  ⚠ PERHATIKAN jika:
  • Menggunakan WiFi publik (cafe, mall, kampus) — lebih rentan
  • Laptop Anda diakses orang lain secara remote
  • HP berisi data sensitif (banking, password)

  ────────────────────────────────────────────────────────
  CARA MIRRORING TANPA INPUT INJECTION (Lebih Aman)
  ────────────────────────────────────────────────────────
  Pilih mode "Mirror Only (No Control)" saat menjalankan script.
  Dengan mode ini, layar HP bisa dilihat tapi tidak bisa dikontrol
  dari laptop — hanya tampil seperti TV.

  Flag yang digunakan: scrcpy --no-control

  ────────────────────────────────────────────────────────
  REKOMENDASI
  ────────────────────────────────────────────────────────
  • Untuk presentasi atau nonton: gunakan mode No Control
  • Untuk produktivitas pribadi: mode normal aman digunakan
  • Matikan USB Debugging saat HP tidak terhubung ke laptop

TUTORIAL
    echo -e "${RESET}"
    tekan_enter
}

# ============================================================
# PENGATURAN SCRCPY (KONFIGURASI LANJUTAN)
# ============================================================

atur_scrcpy_options() {
    title "PENGATURAN SCRCPY"

    # FPS
    echo -e "${CYAN}  Pilih FPS (Frame Per Detik):${RESET}"
    echo "    1. 30 FPS  (hemat baterai, cocok untuk presentasi)"
    echo "    2. 60 FPS  (halus, rekomendasi) [DEFAULT]"
    echo "    3. 120 FPS (ultra halus, butuh HP gaming)"
    echo "    4. Custom (masukkan angka sendiri)"
    read -rp "$(echo -e "${YELLOW}  Pilihan FPS [1-4] (default: 2): ${RESET}")" fps_choice
    fps_choice="${fps_choice:-2}"
    case "$fps_choice" in
        1) LAST_FPS="30" ;;
        3) LAST_FPS="120" ;;
        4) read -rp "$(echo -e "${YELLOW}  Masukkan FPS: ${RESET}")" LAST_FPS; LAST_FPS="${LAST_FPS:-60}" ;;
        *) LAST_FPS="60" ;;
    esac
    info "FPS diset ke: $LAST_FPS"

    # Bitrate
    echo ""
    echo -e "${CYAN}  Pilih Bitrate (Kualitas Video):${RESET}"
    echo "    1. 4M  - Standar (koneksi lemah/jauh)"
    echo "    2. 8M  - Bagus   (rekomendasi) [DEFAULT]"
    echo "    3. 16M - Sangat bagus (WiFi cepat)"
    echo "    4. 40M - Maksimal (kabel USB langsung)"
    echo "    5. Custom"
    read -rp "$(echo -e "${YELLOW}  Pilihan Bitrate [1-5] (default: 2): ${RESET}")" br_choice
    br_choice="${br_choice:-2}"
    case "$br_choice" in
        1) LAST_BITRATE="4M" ;;
        3) LAST_BITRATE="16M" ;;
        4) LAST_BITRATE="40M" ;;
        5) read -rp "$(echo -e "${YELLOW}  Masukkan bitrate (contoh: 10M): ${RESET}")" LAST_BITRATE; LAST_BITRATE="${LAST_BITRATE:-8M}" ;;
        *) LAST_BITRATE="8M" ;;
    esac
    info "Bitrate diset ke: $LAST_BITRATE"

    # Resolusi
    echo ""
    echo -e "${CYAN}  Pilih Resolusi Maksimal:${RESET}"
    echo "    1. 720p  (ringan)"
    echo "    2. 1080p (rekomendasi) [DEFAULT]"
    echo "    3. 1440p (berat, butuh HP layar tinggi)"
    echo "    4. Penuh (resolusi asli HP)"
    read -rp "$(echo -e "${YELLOW}  Pilihan Resolusi [1-4] (default: 2): ${RESET}")" res_choice
    res_choice="${res_choice:-2}"
    case "$res_choice" in
        1) LAST_RESOLUTION="720" ;;
        3) LAST_RESOLUTION="1440" ;;
        4) LAST_RESOLUTION="0" ;;
        *) LAST_RESOLUTION="1080" ;;
    esac

    # Codec
    echo ""
    echo -e "${CYAN}  Pilih Codec Video:${RESET}"
    echo "    1. H.264  (kompatibel luas) [DEFAULT]"
    echo "    2. H.265  (lebih efisien, butuh Android 10+)"
    echo "    3. AV1    (eksperimental, butuh Android 14+)"
    read -rp "$(echo -e "${YELLOW}  Pilihan Codec [1-3] (default: 1): ${RESET}")" codec_choice
    codec_choice="${codec_choice:-1}"
    case "$codec_choice" in
        2) LAST_CODEC="h265" ;;
        3) LAST_CODEC="av1" ;;
        *) LAST_CODEC="h264" ;;
    esac
    info "Codec diset ke: $LAST_CODEC"

    separator
}

atur_fitur_tambahan() {
    title "FITUR TAMBAHAN"

    # Stay Awake
    echo -e "${CYAN}  Stay Awake (Layar HP tetap menyala selama mirroring?):${RESET}"
    read -rp "$(echo -e "${YELLOW}  Aktifkan Stay Awake? [y/n] (default: y): ${RESET}")" STAY_AWAKE
    STAY_AWAKE="${STAY_AWAKE:-y}"

    # Turn Screen Off
    echo ""
    echo -e "${CYAN}  Turn Screen Off (Matikan layar HP tapi mirror tetap jalan?):${RESET}"
    note "Berguna untuk hemat baterai HP, layar HP mati tapi di laptop tetap tampil"
    read -rp "$(echo -e "${YELLOW}  Matikan layar HP? [y/n] (default: n): ${RESET}")" TURN_SCREEN_OFF
    TURN_SCREEN_OFF="${TURN_SCREEN_OFF:-n}"

    # No Control
    echo ""
    echo -e "${CYAN}  No Control Mode (Mirror saja, tidak bisa kontrol HP dari laptop?):${RESET}"
    note "Mode aman untuk presentasi — keyboard/mouse tidak mempengaruhi HP"
    read -rp "$(echo -e "${YELLOW}  Aktifkan No Control? [y/n] (default: n): ${RESET}")" NO_CONTROL
    NO_CONTROL="${NO_CONTROL:-n}"

    # Record Screen
    echo ""
    echo -e "${CYAN}  Rekam Layar (Simpan tampilan HP ke file video?):${RESET}"
    read -rp "$(echo -e "${YELLOW}  Rekam layar? [y/n] (default: n): ${RESET}")" RECORD_SCREEN
    RECORD_SCREEN="${RECORD_SCREEN:-n}"
    if [[ "$RECORD_SCREEN" =~ ^[Yy]$ ]]; then
        RECORD_FILENAME="screenmirror_$(date +%Y%m%d_%H%M%S).mp4"
        read -rp "$(echo -e "${YELLOW}  Nama file rekaman (default: $RECORD_FILENAME): ${RESET}")" custom_name
        RECORD_FILENAME="${custom_name:-$RECORD_FILENAME}"
        info "Rekaman akan disimpan ke: $RECORD_FILENAME"
    fi

    separator
}

# ============================================================
# BANGUN PERINTAH SCRCPY
# ============================================================

bangun_perintah_scrcpy() {
    local args=()

    # Video settings
    args+=("--video-codec=$LAST_CODEC")
    args+=("-b" "$LAST_BITRATE")
    args+=("--max-fps" "$LAST_FPS")

    # Resolusi (jika bukan 0 = full)
    if [ "$LAST_RESOLUTION" != "0" ]; then
        args+=("--max-size" "$LAST_RESOLUTION")
    fi

    # Stay Awake
    if [[ "$STAY_AWAKE" =~ ^[Yy]$ ]]; then
        args+=("--stay-awake")
    fi

    # Turn Screen Off
    if [[ "$TURN_SCREEN_OFF" =~ ^[Yy]$ ]]; then
        args+=("--turn-screen-off")
    fi

    # No Control
    if [[ "$NO_CONTROL" =~ ^[Yy]$ ]]; then
        args+=("--no-control")
    fi

    # Rekam layar
    if [[ "$RECORD_SCREEN" =~ ^[Yy]$ ]]; then
        args+=("--record" "$RECORD_FILENAME")
    fi

    echo "${args[@]}"
}

# ============================================================
# KONEKSI USB
# ============================================================

koneksi_usb() {
    title "KONEKSI USB"
    step "Menyiapkan koneksi USB..."

    adb kill-server &>/dev/null
    adb start-server &>/dev/null

    if ! cek_perangkat; then
        return 1
    fi

    LAST_CONNECTION="1"
    atur_scrcpy_options
    atur_fitur_tambahan
    simpan_config

    local args
    args=$(bangun_perintah_scrcpy)

    title "MEMULAI SCREEN MIRRORING (USB)"
    step "Menjalankan: scrcpy $args"
    separator
    info "Jendela mirror akan muncul sebentar lagi..."
    info "Tekan Ctrl+C untuk menghentikan mirroring"
    note "Shortcut: Ctrl+H = Home | Ctrl+B = Back | Ctrl+M = Menu"
    separator
    echo ""

    # shellcheck disable=SC2086
    scrcpy $args
}

# ============================================================
# KONEKSI WIFI (ADB TCP/IP — Semua Android)
# ============================================================

koneksi_wifi() {
    title "KONEKSI WiFi (via ADB TCP/IP)"

    step "LANGKAH 1: Pastikan kabel USB masih terhubung untuk setup awal"
    adb kill-server &>/dev/null
    adb start-server &>/dev/null

    if ! cek_perangkat; then
        return 1
    fi

    LAST_PORT="${LAST_PORT:-5555}"
    echo ""
    read -rp "$(echo -e "${YELLOW}  Masukkan port TCP [default: $LAST_PORT]: ${RESET}")" input_port
    LAST_PORT="${input_port:-$LAST_PORT}"

    step "LANGKAH 2: Mengaktifkan mode TCP/IP di HP..."
    adb -s "$ACTIVE_DEVICE" tcpip "$LAST_PORT"
    sleep 1

    echo ""
    note "Cari IP address HP Anda di:"
    note "  Pengaturan > Tentang Ponsel > Status > Alamat IP"
    note "  ATAU Pengaturan > WiFi > (nama WiFi Anda) > Detail"
    echo ""
    read -rp "$(echo -e "${YELLOW}  Masukkan IP address HP Android Anda: ${RESET}")" LAST_IP

    if [ -z "$LAST_IP" ]; then
        error "IP tidak boleh kosong!"
        return 1
    fi

    step "LANGKAH 3: Lepas kabel USB sekarang, lalu tekan Enter"
    echo -e "${RED}  ⚡ Lepas kabel USB dari HP terlebih dahulu!${RESET}"
    tekan_enter

    step "LANGKAH 4: Menghubungkan via WiFi ke $LAST_IP:$LAST_PORT..."
    adb connect "${LAST_IP}:${LAST_PORT}"
    sleep 3

    # Verifikasi koneksi
    if ! adb devices | grep -q "${LAST_IP}:${LAST_PORT}"; then
        error "Koneksi WiFi gagal!"
        warn "Pastikan HP dan laptop terhubung ke WiFi yang sama"
        warn "Pastikan mode TCP/IP masih aktif (jalankan ulang dan colok USB jika perlu)"
        warn "Coba matikan firewall sementara: sudo ufw disable"
        return 1
    fi

    info "Koneksi WiFi berhasil! ✓"
    LAST_CONNECTION="2"
    atur_scrcpy_options
    atur_fitur_tambahan
    simpan_config

    local args
    args=$(bangun_perintah_scrcpy)

    title "MEMULAI SCREEN MIRRORING (WiFi)"
    step "Menjalankan: scrcpy $args"
    separator
    info "Jendela mirror akan muncul sebentar lagi..."
    info "Tekan Ctrl+C untuk menghentikan mirroring"
    separator

    # shellcheck disable=SC2086
    scrcpy $args
}

# ============================================================
# KONEKSI WIRELESS DEBUGGING (Android 11+)
# ============================================================

koneksi_wireless_debug() {
    title "KONEKSI WIRELESS DEBUGGING (Android 11+)"

    warn "Fitur ini membutuhkan Android 11 atau lebih baru!"
    note "Jika HP Anda Android 10 ke bawah, pilih opsi 'Koneksi WiFi' sebagai gantinya."
    echo ""

    echo -e "${CYAN}  Apakah ini pertama kali? (Perlu Pairing)${RESET}"
    read -rp "$(echo -e "${YELLOW}  Lakukan pairing dulu? [y/n] (default: y): ${RESET}")" DO_PAIR
    DO_PAIR="${DO_PAIR:-y}"

    if [[ "$DO_PAIR" =~ ^[Yy]$ ]]; then
        echo ""
        note "Di HP: Pengaturan > Opsi Pengembang > Wireless Debugging"
        note "       > 'Pasangkan perangkat dengan kode'"
        note "Catat IP:PORT dan Kode 6 digit yang muncul di HP"
        echo ""
        read -rp "$(echo -e "${YELLOW}  Masukkan IP:PORT untuk pairing (contoh: 192.168.1.5:43521): ${RESET}")" PAIR_ADDR
        read -rp "$(echo -e "${YELLOW}  Masukkan kode 6 digit dari HP: ${RESET}")" PAIR_CODE

        if [ -z "$PAIR_ADDR" ] || [ -z "$PAIR_CODE" ]; then
            error "Alamat pairing dan kode tidak boleh kosong!"
            return 1
        fi

        step "Melakukan pairing ke $PAIR_ADDR..."
        adb pair "$PAIR_ADDR" "$PAIR_CODE"

        if [ $? -ne 0 ]; then
            error "Pairing gagal! Pastikan kode dan alamat benar."
            return 1
        fi
        info "Pairing berhasil! ✓"
    fi

    echo ""
    note "Di HP: Pengaturan > Opsi Pengembang > Wireless Debugging"
    note "Catat 'IP address & Port' yang tertulis di bagian atas"
    echo ""
    read -rp "$(echo -e "${YELLOW}  Masukkan IP HP: ${RESET}")" LAST_IP
    read -rp "$(echo -e "${YELLOW}  Masukkan Port (dari Wireless Debugging): ${RESET}")" LAST_PORT

    if [ -z "$LAST_IP" ] || [ -z "$LAST_PORT" ]; then
        error "IP dan Port tidak boleh kosong!"
        return 1
    fi

    step "Menghubungkan ke ${LAST_IP}:${LAST_PORT}..."
    adb connect "${LAST_IP}:${LAST_PORT}"
    sleep 3

    if ! adb devices | grep -q "${LAST_IP}:${LAST_PORT}"; then
        error "Koneksi gagal!"
        warn "Pastikan HP dan laptop di jaringan WiFi yang sama"
        warn "Pastikan Wireless Debugging masih aktif di HP"
        warn "Port berubah setiap kali WiFi reconnect — periksa port baru di HP"
        return 1
    fi

    info "Koneksi Wireless Debugging berhasil! ✓"
    LAST_CONNECTION="3"
    atur_scrcpy_options
    atur_fitur_tambahan
    simpan_config

    local args
    args=$(bangun_perintah_scrcpy)

    title "MEMULAI SCREEN MIRRORING (Wireless Debugging)"
    step "Menjalankan: scrcpy $args"
    separator

    # shellcheck disable=SC2086
    scrcpy $args
}

# ============================================================
# FITUR CEPAT: SCREENSHOT
# ============================================================

ambil_screenshot() {
    title "AMBIL SCREENSHOT HP"
    step "Mengambil screenshot dari HP..."
    local filename="screenshot_$(date +%Y%m%d_%H%M%S).png"
    adb exec-out screencap -p > "$filename"
    if [ -f "$filename" ] && [ -s "$filename" ]; then
        info "Screenshot disimpan: $filename"
    else
        [ -f "$filename" ] && rm -f "$filename"
        error "Gagal mengambil screenshot. Pastikan HP terhubung dan ADB aktif."
    fi
    tekan_enter
}

# ============================================================
# INSTALL SHORTCUT
# ============================================================

install_shortcut() {
    title "INSTALL SHORTCUT (JALANKAN DARI MANA SAJA)"
    echo -e "${CYAN}  Fitur ini akan membuat perintah 'screenmirror' dan 'mulaism' di /usr/local/bin${RESET}"
    echo -e "${CYAN}  sehingga Anda bisa menjalankan program ini dari mana saja di terminal.${RESET}"
    echo ""
    read -rp "$(echo -e "${YELLOW}  Lanjutkan instalasi? [y/n] (default: y): ${RESET}")" proceed
    proceed="${proceed:-y}"
    if [[ "$proceed" =~ ^[Yy]$ ]]; then
        step "Meminta izin sudo untuk membuat symlink..."
        local target_dir="/usr/local/bin"
        # Menunjuk ke run.sh utama di folder root proyek
        local source_file="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/run.sh"
        
        sudo ln -sf "$source_file" "$target_dir/screenmirror"
        sudo ln -sf "$source_file" "$target_dir/mulaism"
        
        if [ $? -eq 0 ]; then
            info "Shortcut berhasil dibuat!"
            info "Anda sekarang bisa mengetik 'screenmirror' atau 'mulaism' di terminal."
        else
            error "Gagal membuat shortcut. Pastikan Anda memiliki izin sudo."
        fi
    fi
    tekan_enter
}

# ============================================================
# MENU UTAMA
# ============================================================

menu_utama() {
    while true; do
        banner
        title "MENU UTAMA"
        echo -e "  ${CYAN}Pilih metode koneksi atau opsi:${RESET}"
        echo ""
        echo -e "  ${GREEN}  ─── KONEKSI ───────────────────────────────${RESET}"
        echo -e "  ${WHITE}  1.${RESET} 🔌 Koneksi USB (kabel)"
        echo -e "  ${WHITE}  2.${RESET} 📶 Koneksi WiFi  (semua Android, butuh USB sekali)"
        echo -e "  ${WHITE}  3.${RESET} 🛜 Wireless Debugging (Android 11+, tanpa kabel sama sekali)"
        echo ""
        echo -e "  ${GREEN}  ─── TUTORIAL & INFO ───────────────────────${RESET}"
        echo -e "  ${WHITE}  4.${RESET} 📖 Tutorial: Cara Aktifkan USB Debugging"
        echo -e "  ${WHITE}  5.${RESET} 📡 Tutorial: Cara Aktifkan Wireless Debugging"
        echo -e "  ${WHITE}  6.${RESET} 🔒 Info Keamanan: Input Event Injection"
        echo ""
        echo -e "  ${GREEN}  ─── ALAT ─────────────────────────────────${RESET}"
        echo -e "  ${WHITE}  7.${RESET} 📸 Ambil Screenshot HP"
        echo -e "  ${WHITE}  8.${RESET} 🔧 Cek Kompatibilitas Perangkat"
        echo -e "  ${WHITE}  9.${RESET} ⚙  Lihat/Edit Konfigurasi Tersimpan"
        echo -e "  ${WHITE} 10.${RESET} 🔗 Install Shortcut (Jalankan dari mana saja)"
        echo -e "  ${WHITE}  0.${RESET} 🚪 Keluar"
        echo ""
        separator
        read -rp "$(echo -e "${YELLOW}  Masukkan pilihan [0-10]: ${RESET}")" choice

        case "$choice" in
            1) koneksi_usb ;;
            2) koneksi_wifi ;;
            3) koneksi_wireless_debug ;;
            4) tutorial_usb_debugging ;;
            5) tutorial_wireless_debugging ;;
            6) tutorial_keamanan_input ;;
            7) ambil_screenshot ;;
            8) cek_perangkat; tekan_enter ;;
            9)
                title "KONFIGURASI TERSIMPAN"
                if [ -f "$CONFIG_FILE" ]; then
                    cat "$CONFIG_FILE"
                    echo ""
                    read -rp "$(echo -e "${YELLOW}  Hapus konfigurasi? [y/n]: ${RESET}")" del_conf
                    if [[ "$del_conf" =~ ^[Yy]$ ]]; then
                        rm -f "$CONFIG_FILE"
                        info "Konfigurasi dihapus."
                    fi
                else
                    warn "Belum ada konfigurasi tersimpan."
                fi
                tekan_enter
                ;;
            10) install_shortcut ;;
            0) echo -e "\n${GREEN}  Sampai jumpa! 👋${RESET}\n"; exit 0 ;;
            *) warn "Pilihan tidak valid. Coba lagi." ;;
        esac
    done
}

# ============================================================
# MAIN
# ============================================================

main() {
    banner
    cek_dependensi
    muat_config
    menu_utama
}

main
