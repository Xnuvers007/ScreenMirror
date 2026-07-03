@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1

:: Define ESC character for colors
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESC=%%E"

:: ============================================================
::  ScreenMirror - Main Script (Windows - Indonesia)
::  Dibuat oleh Xnuvers007
::  Jangan ubah tanpa menyertakan sumber asli
:: ============================================================
:: LICENSE: MIT | GitHub: https://github.com/Xnuvers007/ScreenMirror
:: ============================================================

title ScreenMirror by Xnuvers007 - Windows Indonesia

:: --- Run as Administrator ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Script ini membutuhkan hak Administrator.
    echo [!] Meminta izin Administrator...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: --- Config File ---
set "CONFIG_FILE=%APPDATA%\screenmirror_config.ini"
set "SCRCPY_DOWNLOAD_VER=4.0"

:: --- Load saved config ---
call :LOAD_CONFIG

:: --- Detect Architecture ---
set "ARCH=64"
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if not defined PROCESSOR_ARCHITEW6432 set "ARCH=32"
)

:: Find scrcpy in PATH or common folders
set "SCRCPY_PATH="
where scrcpy.exe >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=*" %%i in ('where scrcpy.exe 2^>nul') do set "SCRCPY_EXE=%%i"
) else (
    for /f "tokens=*" %%d in ('dir /b /ad /o-n "C:\scrcpy-win!ARCH!*v*" 2^>nul') do (
        if not defined SCRCPY_PATH (
            if exist "C:\%%d\%%d\scrcpy.exe" (
                set "SCRCPY_PATH=C:\%%d\%%d"
            ) else if exist "C:\%%d\scrcpy.exe" (
                set "SCRCPY_PATH=C:\%%d"
            )
            if defined SCRCPY_PATH (
                set "SCRCPY_EXE=!SCRCPY_PATH!\scrcpy.exe"
                set "ADB_EXE=!SCRCPY_PATH!\adb.exe"
            )
        )
    )
)

where adb.exe >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=*" %%i in ('where adb.exe 2^>nul') do set "ADB_EXE=%%i"
)

:: --- Auto Add to Environment PATH ---
set "PROJECT_DIR=%~dp0.."
call :ADD_TO_PATH "!PROJECT_DIR!"
if defined SCRCPY_PATH call :ADD_TO_PATH "!SCRCPY_PATH!"

goto :MAIN_MENU

:: ============================================================
:: UTILITY FUNCTIONS
:: ============================================================

:PRINT_BANNER
cls
echo.
echo   %ESC%[34m============================================================%ESC%[0m
echo   %ESC%[36m      Android to Laptop Screen Mirror  -  by Xnuvers007%ESC%[0m
echo   %ESC%[36m           Windows Edition  ^|  Indonesia%ESC%[0m
echo   %ESC%[34m============================================================%ESC%[0m
echo.
goto :eof

:PRINT_SEP
echo   %ESC%[34m  ------------------------------------------------------%ESC%[0m
goto :eof

:OK
echo   %ESC%[32m  [OK] %~1%ESC%[0m
goto :eof

:WARN
echo   %ESC%[33m  [!]  %~1%ESC%[0m
goto :eof

:ERR
echo   %ESC%[31m  [X]  %~1%ESC%[0m
goto :eof

:NOTE
echo   %ESC%[37m  [i]  %~1%ESC%[0m
goto :eof

:: ============================================================
:: SAVE & LOAD CONFIGURATION
:: ============================================================

:SAVE_CONFIG
(
    echo ; ScreenMirror Configuration - Indonesia
    echo ; Last saved: %DATE% %TIME%
    echo LAST_IP=%LAST_IP%
    echo LAST_PORT=%LAST_PORT%
    echo LAST_FPS=%LAST_FPS%
    echo LAST_BITRATE=%LAST_BITRATE%
    echo LAST_RESOLUTION=%LAST_RESOLUTION%
    echo LAST_CODEC=%LAST_CODEC%
    echo LAST_CONNECTION=%LAST_CONNECTION%
    echo STAY_AWAKE=%STAY_AWAKE%
    echo NO_CONTROL=%NO_CONTROL%
    echo TURN_SCREEN_OFF=%TURN_SCREEN_OFF%
) > "%CONFIG_FILE%"
call :OK "Konfigurasi disimpan di: %CONFIG_FILE%"
goto :eof

:LOAD_CONFIG
set "LAST_IP="
set "LAST_PORT=5555"
set "LAST_FPS=60"
set "LAST_BITRATE=8M"
set "LAST_RESOLUTION=1080"
set "LAST_CODEC=h264"
set "LAST_CONNECTION=1"
set "STAY_AWAKE=y"
set "NO_CONTROL=n"
set "TURN_SCREEN_OFF=n"

if exist "%CONFIG_FILE%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG_FILE%") do (
        if not "%%a"=="" if not "%%a:~0,1%"==";" (
            set "%%a=%%b"
        )
    )
)
goto :eof

:: ============================================================
:: CHECK DEVICE
:: ============================================================

:CHECK_DEVICE
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === CEK PERANGKAT ANDROID ===%ESC%[0m
echo.
call :NOTE "Memulai ADB server..."

if defined ADB_EXE (
    "%ADB_EXE%" kill-server >nul 2>&1
    "%ADB_EXE%" start-server >nul 2>&1
    "%ADB_EXE%" devices
) else (
    call :ERR "ADB tidak ditemukan! Silakan install scrcpy terlebih dahulu."
    goto :INSTALL_MENU
)

echo.
for /f "skip=1 tokens=1,2" %%a in ('"%ADB_EXE%" devices 2^>nul') do (
    if "%%b"=="device" (
        set "DEVICE_ID=%%a"
        call :OK "Perangkat terdeteksi: %%a"

        for /f "tokens=*" %%m in ('"%ADB_EXE%" -s %%a shell getprop ro.product.model 2^>nul') do set "DEVICE_MODEL=%%m"
        for /f "tokens=*" %%s in ('"%ADB_EXE%" -s %%a shell getprop ro.build.version.sdk 2^>nul') do set "DEVICE_SDK=%%s"
        for /f "tokens=*" %%v in ('"%ADB_EXE%" -s %%a shell getprop ro.build.version.release 2^>nul') do set "DEVICE_VER=%%v"

        call :PRINT_SEP
        call :NOTE "Model   : !DEVICE_MODEL!"
        call :NOTE "Android : !DEVICE_VER! (API !DEVICE_SDK!)"
        call :NOTE "DeviceID: %%a"
        call :PRINT_SEP

        if defined DEVICE_SDK (
            if !DEVICE_SDK! LSS 21 (
                call :ERR "Android terlalu lama (API !DEVICE_SDK!). Minimal Android 5.0 (API 21)"
                pause
                exit /b 1
            ) else if !DEVICE_SDK! LSS 28 (
                call :WARN "Android (API !DEVICE_SDK!) didukung tapi dengan fitur terbatas. Disarankan: Android 9+"
            ) else (
                call :OK "Perangkat kompatibel!"
            )
        )
        goto :DEVICE_FOUND
    )
)

call :ERR "Tidak ada perangkat Android terdeteksi!"
echo.
call :NOTE "Kemungkinan penyebab:"
call :NOTE "1. Kabel USB tidak terhubung"
call :NOTE "2. USB Debugging belum aktif"
call :NOTE "3. Tekan 'Izinkan' (Allow) pada popup di HP Anda"
call :NOTE "4. Coba cabut dan colok kembali kabel USB"
echo.
pause
exit /b 1

:DEVICE_FOUND
goto :eof

:: ============================================================
:: CONFIGURE SCRCPY
:: ============================================================

:CONFIGURE_SCRCPY
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === PENGATURAN SCRCPY ===%ESC%[0m
echo.

echo   %ESC%[36m  Pilih FPS:%ESC%[0m
echo     1. 30 FPS  - Hemat baterai, cocok untuk presentasi
echo     2. 60 FPS  - Mulus (DIREKOMENDASIKAN)
echo     3. 120 FPS - Sangat mulus, butuh HP gaming
echo     4. Custom
echo.
set /p "fps_choice=  Pilihan FPS [1-4] (default: 2): "
if "!fps_choice!"=="" set "fps_choice=2"
if "!fps_choice!"=="1" set "LAST_FPS=30"
if "!fps_choice!"=="2" set "LAST_FPS=60"
if "!fps_choice!"=="3" set "LAST_FPS=120"
if "!fps_choice!"=="4" set /p "LAST_FPS=  Masukkan FPS: "
if "!LAST_FPS!"=="" set "LAST_FPS=60"
call :OK "FPS: !LAST_FPS!"

echo.
echo   %ESC%[36m  Pilih Bitrate (Kualitas Video):%ESC%[0m
echo     1. 4M  - Standar (koneksi lambat/jauh)
echo     2. 8M  - Bagus (DIREKOMENDASIKAN)
echo     3. 16M - Sangat bagus (WiFi cepat)
echo     4. 40M - Maksimal (kabel USB langsung)
echo     5. Custom
echo.
set /p "br_choice=  Pilihan Bitrate [1-5] (default: 2): "
if "!br_choice!"=="" set "br_choice=2"
if "!br_choice!"=="1" set "LAST_BITRATE=4M"
if "!br_choice!"=="2" set "LAST_BITRATE=8M"
if "!br_choice!"=="3" set "LAST_BITRATE=16M"
if "!br_choice!"=="4" set "LAST_BITRATE=40M"
if "!br_choice!"=="5" set /p "LAST_BITRATE=  Masukkan bitrate (contoh: 10M): "
if "!LAST_BITRATE!"=="" set "LAST_BITRATE=8M"
call :OK "Bitrate: !LAST_BITRATE!"

echo.
echo   %ESC%[36m  Pilih Resolusi:%ESC%[0m
echo     1. 720p  - Ringan
echo     2. 1080p - DIREKOMENDASIKAN
echo     3. 1440p - Kualitas tinggi
echo     4. Penuh (resolusi asli HP)
echo.
set /p "res_choice=  Resolusi [1-4] (default: 2): "
if "!res_choice!"=="" set "res_choice=2"
if "!res_choice!"=="1" set "LAST_RESOLUTION=720"
if "!res_choice!"=="2" set "LAST_RESOLUTION=1080"
if "!res_choice!"=="3" set "LAST_RESOLUTION=1440"
if "!res_choice!"=="4" set "LAST_RESOLUTION=0"
call :OK "Resolusi: !LAST_RESOLUTION!"

echo.
echo   %ESC%[36m  Pilih Video Codec:%ESC%[0m
echo     1. H.264  - Kompatibilitas luas (DEFAULT)
echo     2. H.265  - Lebih efisien (Android 10+)
echo     3. AV1    - Eksperimental (Android 14+)
echo.
set /p "codec_choice=  Codec [1-3] (default: 1): "
if "!codec_choice!"=="" set "codec_choice=1"
if "!codec_choice!"=="1" set "LAST_CODEC=h264"
if "!codec_choice!"=="2" set "LAST_CODEC=h265"
if "!codec_choice!"=="3" set "LAST_CODEC=av1"
call :OK "Codec: !LAST_CODEC!"
goto :eof

:CONFIGURE_FEATURES
echo.
echo   %ESC%[35m  === FITUR TAMBAHAN ===%ESC%[0m
echo.
set /p "STAY_AWAKE=  Biarkan layar HP tetap menyala (Stay Awake)? [y/n] (default: y): "
if "!STAY_AWAKE!"=="" set "STAY_AWAKE=y"

echo.
call :NOTE "Matikan Layar: Layar HP mati tapi mirroring tetap berjalan di laptop"
set /p "TURN_SCREEN_OFF=  Matikan layar HP? [y/n] (default: n): "
if "!TURN_SCREEN_OFF!"=="" set "TURN_SCREEN_OFF=n"

echo.
call :NOTE "No Control: Hanya melihat, tidak bisa mengontrol HP dari laptop (aman untuk presentasi)"
set /p "NO_CONTROL=  Aktifkan mode No Control? [y/n] (default: n): "
if "!NO_CONTROL!"=="" set "NO_CONTROL=n"

echo.
set /p "RECORD_SCREEN=  Rekam layar ke video? [y/n] (default: n): "
if "!RECORD_SCREEN!"=="" set "RECORD_SCREEN=n"
if /i "!RECORD_SCREEN!"=="y" (
    set "RECORD_FILENAME=screenmirror_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.mp4"
    set /p "custom_rec=  Nama file rekaman (tekan Enter untuk default): "
    if not "!custom_rec!"=="" set "RECORD_FILENAME=!custom_rec!"
    call :OK "Merekam ke: !RECORD_FILENAME!"
)
goto :eof

:: ============================================================
:: LAUNCH SCRCPY
:: ============================================================

:LAUNCH_SCRCPY
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === MEMULAI SCREEN MIRROR ===%ESC%[0m
echo.
set "SCRCPY_ARGS=--video-codec=!LAST_CODEC! -b !LAST_BITRATE! --max-fps !LAST_FPS!"
if not "!LAST_RESOLUTION!"=="0" set "SCRCPY_ARGS=!SCRCPY_ARGS! --max-size !LAST_RESOLUTION!"
set "SCRCPY_ARGS=!SCRCPY_ARGS! --video-buffer=50"
if /i "!STAY_AWAKE!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --stay-awake"
if /i "!TURN_SCREEN_OFF!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --turn-screen-off"
if /i "!NO_CONTROL!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --no-control"
if /i "!RECORD_SCREEN!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --record !RECORD_FILENAME!"
if "!LAST_CONNECTION!"=="2" set "SCRCPY_ARGS=!SCRCPY_ARGS! --tcpip=!LAST_IP!:!LAST_PORT!"
if "!LAST_CONNECTION!"=="3" set "SCRCPY_ARGS=!SCRCPY_ARGS! --tcpip=!LAST_IP!:!LAST_PORT!"

call :NOTE "Perintah: scrcpy !SCRCPY_ARGS!"
call :PRINT_SEP
call :OK "Jendela mirror akan segera muncul..."
call :NOTE "Pintasan: Ctrl+H=Home - Ctrl+B=Back - Ctrl+M=Menu - Ctrl+S=Screenshot"
call :PRINT_SEP
echo.

if defined SCRCPY_PATH (
    cd /d "!SCRCPY_PATH!"
    "!SCRCPY_EXE!" !SCRCPY_ARGS!
) else (
    scrcpy.exe !SCRCPY_ARGS!
)
goto :eof

:: ============================================================
:: CONNECTIONS
:: ============================================================

:CONNECT_USB
call :CHECK_DEVICE
if not defined DEVICE_ID goto :MAIN_MENU
set "LAST_CONNECTION=1"
call :CONFIGURE_SCRCPY
call :CONFIGURE_FEATURES
call :SAVE_CONFIG
call :LAUNCH_SCRCPY
pause
goto :MAIN_MENU

:CONNECT_WIFI
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === KONEKSI WiFi (ADB TCP/IP) ===%ESC%[0m
echo.
call :NOTE "LANGKAH 1: Pastikan kabel USB masih terhubung untuk setup awal"
call :CHECK_DEVICE
if not defined DEVICE_ID goto :MAIN_MENU

echo.
set /p "input_port=  Masukkan port TCP [default: %LAST_PORT%]: "
if not "!input_port!"=="" set "LAST_PORT=!input_port!"

call :NOTE "LANGKAH 2: Mengaktifkan mode TCP/IP di HP..."
"%ADB_EXE%" -s "%DEVICE_ID%" tcpip %LAST_PORT%
timeout /t 2 /nobreak >nul

echo.
call :NOTE "Cari IP HP: Pengaturan -> Tentang Ponsel -> Status -> Alamat IP"
call :NOTE "      ATAU: Pengaturan -> WiFi -> (jaringan Anda) -> Detail"
echo.
set /p "LAST_IP=  Masukkan alamat IP HP Android: "
if "!LAST_IP!"=="" ( call :ERR "IP tidak boleh kosong!"; pause; goto :MAIN_MENU )

echo.
call :WARN "LANGKAH 3: Cabut kabel USB sekarang, lalu tekan sembarang tombol!"
echo   %ESC%[31m  Cabut kabel USB dari HP terlebih dahulu!%ESC%[0m
pause

call :NOTE "LANGKAH 4: Menghubungkan via WiFi ke !LAST_IP!:!LAST_PORT!..."
"%ADB_EXE%" connect "!LAST_IP!:!LAST_PORT!"
timeout /t 3 /nobreak >nul

"%ADB_EXE%" devices | findstr "!LAST_IP!" >nul
if %errorLevel% neq 0 (
    call :ERR "Koneksi WiFi gagal!"
    call :WARN "Pastikan HP dan laptop berada di WiFi yang sama"
    call :WARN "Coba matikan sementara Windows Firewall"
    pause
    goto :MAIN_MENU
)

call :OK "Koneksi WiFi berhasil!"
set "LAST_CONNECTION=2"
call :CONFIGURE_SCRCPY
call :CONFIGURE_FEATURES
call :SAVE_CONFIG
call :LAUNCH_SCRCPY
pause
goto :MAIN_MENU

:CONNECT_WIRELESS_DEBUG
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === WIRELESS DEBUGGING (Android 11+) ===%ESC%[0m
echo.
call :WARN "Fitur ini membutuhkan Android 11 atau yang lebih baru!"
call :NOTE "Untuk Android 10 ke bawah, gunakan opsi koneksi WiFi."
echo.
set /p "DO_PAIR=  Pertama kali? (Butuh Pairing) [y/n] (default: y): "
if "!DO_PAIR!"=="" set "DO_PAIR=y"

if /i "!DO_PAIR!"=="y" (
    echo.
    call :NOTE "Di HP: Pengaturan -> Opsi Pengembang -> Wireless Debugging"
    call :NOTE "     -> 'Pasangkan perangkat dengan kode'"
    call :NOTE "Catat IP:PORT dan 6-digit kode"
    echo.
    set /p "PAIR_ADDR=  Masukkan IP:PORT pairing (contoh: 192.168.1.5:43521): "
    set /p "PAIR_CODE=  Masukkan 6-digit kode dari HP: "
    if "!PAIR_ADDR!"=="" ( call :ERR "Alamat pairing tidak boleh kosong!"; pause; goto :MAIN_MENU )
    call :NOTE "Pairing dengan !PAIR_ADDR!..."
    "%ADB_EXE%" pair "!PAIR_ADDR!" "!PAIR_CODE!"
    if %errorLevel% neq 0 ( call :ERR "Pairing gagal!"; pause; goto :MAIN_MENU )
    call :OK "Pairing berhasil!"
)

echo.
call :NOTE "Di HP: catat 'Alamat IP & Port' di menu Wireless Debugging"
set /p "LAST_IP=  Masukkan IP HP: "
set /p "LAST_PORT=  Masukkan Port (dari Wireless Debugging): "
if "!LAST_IP!"=="" ( call :ERR "IP tidak boleh kosong!"; pause; goto :MAIN_MENU )

call :NOTE "Menghubungkan ke !LAST_IP!:!LAST_PORT!..."
"%ADB_EXE%" connect "!LAST_IP!:!LAST_PORT!"
timeout /t 2 /nobreak >nul

"%ADB_EXE%" devices | findstr "!LAST_IP!" >nul
if %errorLevel% neq 0 ( call :ERR "Koneksi gagal!"; call :WARN "Pastikan di jaringan WiFi yang sama"; pause; goto :MAIN_MENU )

call :OK "Wireless Debugging terhubung!"
set "LAST_CONNECTION=3"
call :CONFIGURE_SCRCPY
call :CONFIGURE_FEATURES
call :SAVE_CONFIG
call :LAUNCH_SCRCPY
pause
goto :MAIN_MENU

:: ============================================================
:: TUTORIALS
:: ============================================================

:TUTORIAL_USB
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === TUTORIAL: CARA AKTIFKAN USB DEBUGGING ===%ESC%[0m
echo.
echo   USB Debugging adalah fitur tersembunyi Android yang
echo   mengizinkan komputer berkomunikasi langsung dengan HP Anda.
echo.
echo   %ESC%[36m  --- LANGKAH 1: Aktifkan Mode Pengembang --------------------%ESC%[0m
echo   1. Buka "Pengaturan" di HP Anda
echo   2. Cari "Tentang Ponsel"
echo      Samsung : Pengaturan ^^> Tentang Ponsel ^^> Informasi Perangkat Lunak
echo      Xiaomi  : Pengaturan ^^> Tentang Ponsel
echo      Oppo    : Pengaturan ^^> Tentang Ponsel
echo   3. Cari "Nomor Build" (Atau Versi MIUI)
echo   4. Ketuk 7 KALI berturut-turut
echo   5. Pesan "Anda sekarang adalah pengembang!" muncul [OK]
echo.
echo   %ESC%[36m  --- LANGKAH 2: Aktifkan USB Debugging ---------------------%ESC%[0m
echo   1. Kembali ke Pengaturan utama
echo   2. Cari "Opsi Pengembang" (biasanya di paling bawah)
echo      Samsung : Pengaturan ^^> Opsi Pengembang
echo      Xiaomi  : Pengaturan ^^> Setelan Tambahan ^^> Opsi Pengembang
echo   3. Aktifkan toggle "Opsi Pengembang"
echo   4. Aktifkan "USB Debugging"
echo   5. Ketuk "OK" pada popup peringatan
echo.
echo   %ESC%[36m  --- LANGKAH 3: Hubungkan ke Laptop -------------------------%ESC%[0m
echo   1. Colokkan kabel USB
echo   2. Popup HP: "Izinkan USB Debugging?"
echo   3. Centang "Selalu izinkan dari komputer ini"
echo   4. Ketuk "Izinkan"
echo.
echo   %ESC%[33m  CATATAN KEAMANAN:%ESC%[0m
echo   - USB Debugging memberi akses penuh saat terhubung
echo   - Matikan jika sedang tidak butuh
echo   - Jangan pernah ketuk "Izinkan" di komputer tak dikenal
echo.
pause
goto :MAIN_MENU

:TUTORIAL_WIRELESS
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === TUTORIAL: WIRELESS DEBUGGING (Android 11+) ===%ESC%[0m
echo.
echo   Hubungkan HP secara nirkabel via jaringan WiFi yang sama.
echo.
echo   %ESC%[36m  --- LANGKAH 1: Aktifkan Wireless Debugging ----------------%ESC%[0m
echo   1. Pengaturan ^^> Opsi Pengembang
echo   2. Cari "Wireless Debugging"
echo   3. Aktifkan toggle ^^> ketuk "Izinkan"
echo.
echo   %ESC%[36m  --- LANGKAH 2: Catat IP dan Port --------------------------%ESC%[0m
echo   Di dalam menu Wireless Debugging, catat:
echo   Alamat IP dan Port (contoh 192.168.1.5:39465)
echo.
echo   %ESC%[36m  --- LANGKAH 3: Pairing (Hanya Pertama Kali) ---------------%ESC%[0m
echo   1. Ketuk "Pasangkan perangkat dengan kode"
echo   2. Catat IP:PORT dan 6-digit kode
echo   3. Di Command Prompt: adb pair IP:PAIR_PORT
echo   4. Masukkan 6-digit kode
echo   5. "Successfully paired" [OK]
echo.
echo   %ESC%[36m  --- LANGKAH 4: Hubungkan ----------------------------------%ESC%[0m
echo   adb connect IP:PORT
echo   Contoh: adb connect 192.168.1.5:39465
echo.
echo   %ESC%[33m  CATATAN:%ESC%[0m
echo   - Port berubah setiap kali WiFi terhubung ulang
echo   - Pastikan Windows Firewall mengizinkan ADB
echo.
pause
goto :MAIN_MENU

:TUTORIAL_SECURITY
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === KEAMANAN: INPUT EVENT INJECTION ===%ESC%[0m
echo.
echo   Saat mirroring, keyboard/mouse Anda bisa mengontrol HP.
echo   Ini disebut "Input Event Injection".
echo.
echo   %ESC%[32m  AMAN ketika:%ESC%[0m
echo   - Hanya Anda yang mengontrol laptop
echo   - Terhubung via kabel USB langsung
echo   - Menggunakan jaringan WiFi pribadi
echo.
echo   %ESC%[33m  HATI-HATI ketika:%ESC%[0m
echo   - Menggunakan WiFi publik (kafe, kampus)
echo   - Laptop Anda diakses secara remote
echo   - HP memiliki data sensitif
echo.
echo   %ESC%[36m  MIRROR TANPA KONTROL (Lebih Aman):%ESC%[0m
echo   Aktifkan mode "No Control": scrcpy --no-control
echo   Hanya melihat - keyboard/mouse tidak akan mempengaruhi HP
echo.
echo   %ESC%[36m  REKOMENDASI:%ESC%[0m
echo   - Presentasi: gunakan mode No Control
echo   - Penggunaan pribadi: mode normal aman
echo   - Matikan USB Debugging setelah selesai
echo.
pause
goto :MAIN_MENU

:: ============================================================
:: INSTALL MENU
:: ============================================================

:INSTALL_MENU
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === INSTALL DEPENDENSI ===%ESC%[0m
echo.
call :NOTE "Mengecek versi scrcpy terbaru online..."
for /f "usebackq tokens=*" %%v in (`powershell -NoProfile -Command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/Genymobile/scrcpy/releases/latest' -ErrorAction SilentlyContinue).tag_name.TrimStart('v')"`) do set "SCRCPY_DOWNLOAD_VER=%%v"
if "!SCRCPY_DOWNLOAD_VER!"=="" set "SCRCPY_DOWNLOAD_VER=4.0"
call :OK "Versi terbaru tersedia: !SCRCPY_DOWNLOAD_VER!"
echo.
echo     1. Download ^& Install scrcpy v!SCRCPY_DOWNLOAD_VER! (64-bit) - DIREKOMENDASIKAN
echo     2. Download ^& Install scrcpy v!SCRCPY_DOWNLOAD_VER! (32-bit)
echo     3. Download ^& Install VLC (64-bit) - untuk audio
echo     4. Download ^& Install VLC (32-bit)
echo     5. Download sndcpy (audio mirroring)
echo     6. Kembali ke Menu Utama
echo.
set /p "inst_choice=  Pilihan [1-6]: "
if "!inst_choice!"=="1" goto :INSTALL_SCRCPY64
if "!inst_choice!"=="2" goto :INSTALL_SCRCPY32
if "!inst_choice!"=="3" goto :INSTALL_VLC64
if "!inst_choice!"=="4" goto :INSTALL_VLC32
if "!inst_choice!"=="5" goto :INSTALL_SNDCPY
if "!inst_choice!"=="6" goto :MAIN_MENU
goto :INSTALL_MENU

:INSTALL_SCRCPY64
call :NOTE "Mengunduh scrcpy v!SCRCPY_DOWNLOAD_VER! (64-bit)..."
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v!SCRCPY_DOWNLOAD_VER!/scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!.zip' -OutFile '%TEMP%\scrcpy-win64.zip' -UseBasicParsing"
call :NOTE "Mengekstrak ke C:\scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!..."
powershell -Command "Expand-Archive -Path '%TEMP%\scrcpy-win64.zip' -DestinationPath 'C:\' -Force"
call :OK "scrcpy 64-bit terinstall di C:\scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!!"
pause
goto :INSTALL_MENU

:INSTALL_SCRCPY32
call :NOTE "Mengunduh scrcpy v!SCRCPY_DOWNLOAD_VER! (32-bit)..."
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v!SCRCPY_DOWNLOAD_VER!/scrcpy-win32-v!SCRCPY_DOWNLOAD_VER!.zip' -OutFile '%TEMP%\scrcpy-win32.zip' -UseBasicParsing"
powershell -Command "Expand-Archive -Path '%TEMP%\scrcpy-win32.zip' -DestinationPath 'C:\' -Force"
call :OK "scrcpy 32-bit terinstall!"
pause
goto :INSTALL_MENU

:INSTALL_VLC64
call :NOTE "Mengunduh VLC 64-bit..."
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe' -OutFile '%TEMP%\vlc-win64.exe' -UseBasicParsing"
powershell -Command "Start-Process -FilePath '%TEMP%\vlc-win64.exe' -ArgumentList '/S' -Verb runAs -Wait"
call :OK "VLC 64-bit terinstall!"
pause
goto :INSTALL_MENU

:INSTALL_VLC32
call :NOTE "Mengunduh VLC 32-bit..."
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win32/vlc-3.0.18-win32.exe' -OutFile '%TEMP%\vlc-win32.exe' -UseBasicParsing"
powershell -Command "Start-Process -FilePath '%TEMP%\vlc-win32.exe' -ArgumentList '/S' -Verb runAs -Wait"
call :OK "VLC 32-bit terinstall!"
pause
goto :INSTALL_MENU

:INSTALL_SNDCPY
call :NOTE "Mengunduh sndcpy..."
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-with-adb-windows-v1.1.zip' -OutFile '%TEMP%\sndcpy.zip' -UseBasicParsing"
powershell -Command "Expand-Archive -Path '%TEMP%\sndcpy.zip' -DestinationPath 'C:\sndcpy' -Force"
call :OK "sndcpy terinstall di C:\sndcpy!"
pause
goto :INSTALL_MENU

:: ============================================================
:: SCREENSHOT
:: ============================================================

:TAKE_SCREENSHOT
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === AMBIL SCREENSHOT ===%ESC%[0m
echo.
call :NOTE "Mengambil screenshot dari HP..."
set "SS_FILE=screenshot_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.png"
"%ADB_EXE%" exec-out screencap -p > "!SS_FILE!"
if exist "!SS_FILE!" (
    call :OK "Screenshot disimpan: !SS_FILE!"
) else (
    call :ERR "Gagal mengambil screenshot. Pastikan HP terhubung."
)
pause
goto :MAIN_MENU

:: ============================================================
:: VIEW CONFIG
:: ============================================================

:VIEW_CONFIG
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === KONFIGURASI TERSIMPAN ===%ESC%[0m
echo.
if exist "%CONFIG_FILE%" (
    type "%CONFIG_FILE%"
    echo.
    set /p "del_conf=  Hapus konfigurasi? [y/n]: "
    if /i "!del_conf!"=="y" (
        del "%CONFIG_FILE%"
        call :OK "Konfigurasi dihapus."
    )
) else (
    call :WARN "Belum ada konfigurasi yang tersimpan."
)
echo.
pause
goto :MAIN_MENU

:: ============================================================
:: MAIN MENU
:: ============================================================

:MAIN_MENU
call :PRINT_BANNER

if defined LAST_IP (
    if not "!LAST_IP!"=="" (
        call :NOTE "Info terakhir: IP=!LAST_IP! PORT=!LAST_PORT! FPS=!LAST_FPS! Bitrate=!LAST_BITRATE!"
    )
)

echo.
echo   %ESC%[36m  --- KONEKSI -----------------------------------------%ESC%[0m
echo   %ESC%[37m  1.%ESC%[0m Koneksi USB (kabel)
echo   %ESC%[37m  2.%ESC%[0m Koneksi WiFi (Semua Android, butuh USB sekali)
echo   %ESC%[37m  3.%ESC%[0m Wireless Debugging (Android 11+, tanpa kabel)
echo.
echo   %ESC%[36m  --- TUTORIAL ^& INFO ---------------------------------%ESC%[0m
echo   %ESC%[37m  4.%ESC%[0m Tutorial: Cara Aktifkan USB Debugging
echo   %ESC%[37m  5.%ESC%[0m Tutorial: Cara Aktifkan Wireless Debugging
echo   %ESC%[37m  6.%ESC%[0m Keamanan: Input Event Injection
echo.
echo   %ESC%[36m  --- ALAT --------------------------------------------%ESC%[0m
echo   %ESC%[37m  7.%ESC%[0m Ambil Screenshot dari HP
echo   %ESC%[37m  8.%ESC%[0m Download ^& Install Dependensi
echo   %ESC%[37m  9.%ESC%[0m Lihat/Hapus Konfigurasi Tersimpan
echo   %ESC%[37m  0.%ESC%[0m Keluar
echo.
call :PRINT_SEP

set /p "choice=  Masukkan pilihan [0-9]: "

if "!choice!"=="1" goto :CONNECT_USB
if "!choice!"=="2" goto :CONNECT_WIFI
if "!choice!"=="3" goto :CONNECT_WIRELESS_DEBUG
if "!choice!"=="4" goto :TUTORIAL_USB
if "!choice!"=="5" goto :TUTORIAL_WIRELESS
if "!choice!"=="6" goto :TUTORIAL_SECURITY
if "!choice!"=="7" goto :TAKE_SCREENSHOT
if "!choice!"=="8" goto :INSTALL_MENU
if "!choice!"=="9" goto :VIEW_CONFIG
if "!choice!"=="0" (
    echo.
    echo   Selamat tinggal! Terima kasih telah menggunakan ScreenMirror.
    echo.
    exit /b 0
)
call :WARN "Pilihan tidak valid. Coba lagi."
timeout /t 1 /nobreak >nul
goto :MAIN_MENU

:ADD_TO_PATH
set "NEW_PATH=%~1"
:: Remove trailing backslashes if present
if "!NEW_PATH:~-1!"=="\" set "NEW_PATH=!NEW_PATH:~0,-1!"

:: Check if already in PATH
powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('PATH','User'); if($p -split ';' -contains '%NEW_PATH%') { exit 0 } else { exit 1 }" >nul 2>&1
if !errorlevel! equ 1 (
    call :NOTE "Menambahkan !NEW_PATH! ke Environment PATH (Permanen)..."
    powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('PATH','User'); [Environment]::SetEnvironmentVariable('PATH', $p + ';%NEW_PATH%', 'User')" >nul 2>&1
    call :OK "Berhasil ditambahkan ke PATH."
)
goto :eof