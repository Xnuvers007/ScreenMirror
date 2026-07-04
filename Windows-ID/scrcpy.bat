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
:: SAVE & LOAD CONFIGURATION (Per-Mode: USB / WiFi / Wireless Debug)
:: ============================================================

:SAVE_CONFIG
(
    echo ; ScreenMirror Configuration - Indonesia
    echo ; Last saved: %DATE% %TIME%
    echo LAST_CONNECTION=%LAST_CONNECTION%
    echo ; --- USB Config ---
    echo USB_FPS=%USB_FPS%
    echo USB_BITRATE=%USB_BITRATE%
    echo USB_RESOLUTION=%USB_RESOLUTION%
    echo USB_CODEC=%USB_CODEC%
    echo USB_STAY_AWAKE=%USB_STAY_AWAKE%
    echo USB_NO_CONTROL=%USB_NO_CONTROL%
    echo USB_TURN_SCREEN_OFF=%USB_TURN_SCREEN_OFF%
    echo ; --- WiFi Config ---
    echo WIFI_IP=%WIFI_IP%
    echo WIFI_PORT=%WIFI_PORT%
    echo WIFI_FPS=%WIFI_FPS%
    echo WIFI_BITRATE=%WIFI_BITRATE%
    echo WIFI_RESOLUTION=%WIFI_RESOLUTION%
    echo WIFI_CODEC=%WIFI_CODEC%
    echo WIFI_STAY_AWAKE=%WIFI_STAY_AWAKE%
    echo WIFI_NO_CONTROL=%WIFI_NO_CONTROL%
    echo WIFI_TURN_SCREEN_OFF=%WIFI_TURN_SCREEN_OFF%
    echo ; --- Wireless Debug Config ---
    echo WD_IP=%WD_IP%
    echo WD_PORT=%WD_PORT%
    echo WD_FPS=%WD_FPS%
    echo WD_BITRATE=%WD_BITRATE%
    echo WD_RESOLUTION=%WD_RESOLUTION%
    echo WD_CODEC=%WD_CODEC%
    echo WD_STAY_AWAKE=%WD_STAY_AWAKE%
    echo WD_NO_CONTROL=%WD_NO_CONTROL%
    echo WD_TURN_SCREEN_OFF=%WD_TURN_SCREEN_OFF%
) > "%CONFIG_FILE%"
call :OK "Konfigurasi disimpan di: %CONFIG_FILE%"
goto :eof

:LOAD_CONFIG
:: Defaults semua mode
set "LAST_CONNECTION=1"
:: USB defaults
set "USB_FPS=60"
set "USB_BITRATE=8M"
set "USB_RESOLUTION=1080"
set "USB_CODEC=h264"
set "USB_STAY_AWAKE=y"
set "USB_NO_CONTROL=n"
set "USB_TURN_SCREEN_OFF=n"
set "USB_AUDIO_MODE=1"
:: WiFi defaults
set "WIFI_IP="
set "WIFI_PORT=5555"
set "WIFI_FPS=60"
set "WIFI_BITRATE=8M"
set "WIFI_RESOLUTION=1080"
set "WIFI_CODEC=h264"
set "WIFI_STAY_AWAKE=y"
set "WIFI_NO_CONTROL=n"
set "WIFI_TURN_SCREEN_OFF=n"
set "WIFI_AUDIO_MODE=1"
:: Wireless Debug defaults
set "WD_IP="
set "WD_PORT=5555"
set "WD_FPS=60"
set "WD_BITRATE=8M"
set "WD_RESOLUTION=1080"
set "WD_CODEC=h264"
set "WD_STAY_AWAKE=y"
set "WD_NO_CONTROL=n"
set "WD_TURN_SCREEN_OFF=n"
set "WD_AUDIO_MODE=1"

if exist "%CONFIG_FILE%" (
    findstr /b "LAST_IP=" "%CONFIG_FILE%" >nul 2>&1
    if !errorlevel! equ 0 (
        findstr /b "USB_FPS=" "%CONFIG_FILE%" >nul 2>&1
        if !errorlevel! neq 0 (
            for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG_FILE%") do (
                set "_line_first=%%a"
                if not "!_line_first!"=="" if not "!_line_first:~0,1!"==";" if not "!_line_first:~0,1!"=="#" (
                    set "%%a=%%b"
                )
            )
            set "USB_FPS=!LAST_FPS!"
            set "USB_BITRATE=!LAST_BITRATE!"
            set "USB_RESOLUTION=!LAST_RESOLUTION!"
            set "USB_CODEC=!LAST_CODEC!"
            set "USB_STAY_AWAKE=!STAY_AWAKE!"
            set "USB_NO_CONTROL=!NO_CONTROL!"
            set "USB_TURN_SCREEN_OFF=!TURN_SCREEN_OFF!"
            if "!LAST_CONNECTION!"=="2" (
                set "WIFI_IP=!LAST_IP!"
                set "WIFI_PORT=!LAST_PORT!"
                set "WIFI_FPS=!LAST_FPS!"
                set "WIFI_BITRATE=!LAST_BITRATE!"
                set "WIFI_RESOLUTION=!LAST_RESOLUTION!"
                set "WIFI_CODEC=!LAST_CODEC!"
                set "WIFI_STAY_AWAKE=!STAY_AWAKE!"
                set "WIFI_NO_CONTROL=!NO_CONTROL!"
                set "WIFI_TURN_SCREEN_OFF=!TURN_SCREEN_OFF!"
            )
            if "!LAST_CONNECTION!"=="3" (
                set "WD_IP=!LAST_IP!"
                set "WD_PORT=!LAST_PORT!"
                set "WD_FPS=!LAST_FPS!"
                set "WD_BITRATE=!LAST_BITRATE!"
                set "WD_RESOLUTION=!LAST_RESOLUTION!"
                set "WD_CODEC=!LAST_CODEC!"
                set "WD_STAY_AWAKE=!STAY_AWAKE!"
                set "WD_NO_CONTROL=!NO_CONTROL!"
                set "WD_TURN_SCREEN_OFF=!TURN_SCREEN_OFF!"
            )
            call :OK "Konfigurasi lama berhasil dimigrasi ke format per-mode."
            call :SAVE_CONFIG
            goto :eof
        )
    )
    for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG_FILE%") do (
        set "_line_first=%%a"
        if not "!_line_first!"=="" if not "!_line_first:~0,1!"==";" if not "!_line_first:~0,1!"=="#" (
            set "%%a=%%b"
        )
    )
)
goto :eof

:LOAD_MODE_CONFIG
if "%~1"=="USB" (
    set "LAST_FPS=!USB_FPS!"
    set "LAST_BITRATE=!USB_BITRATE!"
    set "LAST_RESOLUTION=!USB_RESOLUTION!"
    set "LAST_CODEC=!USB_CODEC!"
    set "STAY_AWAKE=!USB_STAY_AWAKE!"
    set "NO_CONTROL=!USB_NO_CONTROL!"
    set "TURN_SCREEN_OFF=!USB_TURN_SCREEN_OFF!"
    set "AUDIO_MODE=!USB_AUDIO_MODE!"
)
if "%~1"=="WIFI" (
    set "LAST_IP=!WIFI_IP!"
    set "LAST_PORT=!WIFI_PORT!"
    set "LAST_FPS=!WIFI_FPS!"
    set "LAST_BITRATE=!WIFI_BITRATE!"
    set "LAST_RESOLUTION=!WIFI_RESOLUTION!"
    set "LAST_CODEC=!WIFI_CODEC!"
    set "STAY_AWAKE=!WIFI_STAY_AWAKE!"
    set "NO_CONTROL=!WIFI_NO_CONTROL!"
    set "TURN_SCREEN_OFF=!WIFI_TURN_SCREEN_OFF!"
    set "AUDIO_MODE=!WIFI_AUDIO_MODE!"
)
if "%~1"=="WD" (
    set "LAST_IP=!WD_IP!"
    set "LAST_PORT=!WD_PORT!"
    set "LAST_FPS=!WD_FPS!"
    set "LAST_BITRATE=!WD_BITRATE!"
    set "LAST_RESOLUTION=!WD_RESOLUTION!"
    set "LAST_CODEC=!WD_CODEC!"
    set "STAY_AWAKE=!WD_STAY_AWAKE!"
    set "NO_CONTROL=!WD_NO_CONTROL!"
    set "TURN_SCREEN_OFF=!WD_TURN_SCREEN_OFF!"
    set "AUDIO_MODE=!WD_AUDIO_MODE!"
)
goto :eof

:SAVE_MODE_CONFIG
if "%~1"=="USB" (
    set "USB_FPS=!LAST_FPS!"
    set "USB_BITRATE=!LAST_BITRATE!"
    set "USB_RESOLUTION=!LAST_RESOLUTION!"
    set "USB_CODEC=!LAST_CODEC!"
    set "USB_STAY_AWAKE=!STAY_AWAKE!"
    set "USB_NO_CONTROL=!NO_CONTROL!"
    set "USB_TURN_SCREEN_OFF=!TURN_SCREEN_OFF!"
    set "USB_AUDIO_MODE=!AUDIO_MODE!"
)
if "%~1"=="WIFI" (
    set "WIFI_IP=!LAST_IP!"
    set "WIFI_PORT=!LAST_PORT!"
    set "WIFI_FPS=!LAST_FPS!"
    set "WIFI_BITRATE=!LAST_BITRATE!"
    set "WIFI_RESOLUTION=!LAST_RESOLUTION!"
    set "WIFI_CODEC=!LAST_CODEC!"
    set "WIFI_STAY_AWAKE=!STAY_AWAKE!"
    set "WIFI_NO_CONTROL=!NO_CONTROL!"
    set "WIFI_TURN_SCREEN_OFF=!TURN_SCREEN_OFF!"
    set "WIFI_AUDIO_MODE=!AUDIO_MODE!"
)
if "%~1"=="WD" (
    set "WD_IP=!LAST_IP!"
    set "WD_PORT=!LAST_PORT!"
    set "WD_FPS=!LAST_FPS!"
    set "WD_BITRATE=!LAST_BITRATE!"
    set "WD_RESOLUTION=!LAST_RESOLUTION!"
    set "WD_CODEC=!LAST_CODEC!"
    set "WD_STAY_AWAKE=!STAY_AWAKE!"
    set "WD_NO_CONTROL=!NO_CONTROL!"
    set "WD_TURN_SCREEN_OFF=!TURN_SCREEN_OFF!"
    set "WD_AUDIO_MODE=!AUDIO_MODE!"
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
    echo.
    set /p "DO_AUTO=  Apakah Anda ingin mengunduh dan menginstallnya sekarang secara otomatis? [y/n] (default: y): "
    if "!DO_AUTO!"=="" set "DO_AUTO=y"
    if /i "!DO_AUTO!"=="y" (
        goto :AUTO_INSTALL
    ) else (
        goto :INSTALL_MENU
    )
)

echo.
for /f "skip=1 tokens=1,2" %%a in ('"%ADB_EXE%" devices 2^>nul') do (
    if "%%b"=="device" (
        set "DEVICE_ID=%%a"
        call :OK "Perangkat terdeteksi: %%a"

        for /f "tokens=*" %%m in ('"%ADB_EXE%" -s %%a shell getprop ro.product.model 2^>nul') do set "DEVICE_MODEL=%%m"
        for /f "tokens=*" %%b in ('"%ADB_EXE%" -s %%a shell getprop ro.product.brand 2^>nul') do set "DEVICE_BRAND=%%b"
        for /f "tokens=*" %%s in ('"%ADB_EXE%" -s %%a shell getprop ro.build.version.sdk 2^>nul') do set "DEVICE_SDK=%%s"
        for /f "tokens=*" %%v in ('"%ADB_EXE%" -s %%a shell getprop ro.build.version.release 2^>nul') do set "DEVICE_VER=%%v"
        for /f "tokens=*" %%p in ('"%ADB_EXE%" -s %%a shell getprop ro.board.platform 2^>nul') do set "DEVICE_PLATFORM=%%p"
        for /f "tokens=*" %%c in ('"%ADB_EXE%" -s %%a shell getprop ro.product.cpu.abi 2^>nul') do set "DEVICE_ABI=%%c"

        call :PRINT_SEP
        call :NOTE "Brand   : !DEVICE_BRAND!"
        call :NOTE "Model   : !DEVICE_MODEL!"
        call :NOTE "Android : !DEVICE_VER! (API !DEVICE_SDK!)"
        call :NOTE "Platform: !DEVICE_PLATFORM!"
        call :NOTE "CPU ABI : !DEVICE_ABI!"
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
set "MIRROR_CAMERA="
set "CAMERA_FACING="
set "ENABLE_OTG="
set "WINDOW_OPTIONS="
set "AUDIO_MODE="
set "ADVANCED_KEYBOARD="
set "STAY_AWAKE="
set "TURN_SCREEN_OFF="
set "NO_CONTROL="
set "RECORD_SCREEN="
set "RECORD_FILENAME="
set /p "MIRROR_CAMERA=  Gunakan kamera HP sebagai tampilan (Camera Mirroring)? [y/n] (default: n): "
if "!MIRROR_CAMERA!"=="" set "MIRROR_CAMERA=n"
if /i "!MIRROR_CAMERA!"=="y" (
    set /p "CAMERA_FACING=  Pilih kamera [front/back/external] (default: back): "
    if "!CAMERA_FACING!"=="" set "CAMERA_FACING=back"
)

echo.
call :NOTE "Mode OTG: Bypass blokir layar (game/bank). Harus pakai kabel USB, layar HP tidak tampil."
set /p "ENABLE_OTG=  Aktifkan Mode OTG? [y/n] (default: n): "
if "!ENABLE_OTG!"=="" set "ENABLE_OTG=n"

if /i not "!ENABLE_OTG!"=="y" (
    call :NOTE "Tampilan Jendela: Always on Top (selalu di atas) / Borderless (tanpa bingkai)"
    set /p "WINDOW_OPTIONS=  Pilih: [1] Normal [2] Always on Top [3] Borderless [4] Top & Borderless (default: 1): "
    if "!WINDOW_OPTIONS!"=="" set "WINDOW_OPTIONS=1"

    call :NOTE "Pengaturan Audio (Android 11+):"
    echo     1. Suara hanya di Laptop (Default)
    echo     2. Suara di HP dan Laptop (Audio Duplication)
    echo     3. Suara hanya di HP (Matikan forwarding)
    echo     4. Teruskan Mikrofon HP ke Laptop
    set /p "AUDIO_MODE=  Pilih mode audio [1-4] (default: 1): "
    if "!AUDIO_MODE!"=="" set "AUDIO_MODE=1"
    
    echo.
    call :NOTE "Mode Keyboard: 'uhid' mensimulasikan keyboard fisik 100%% akurat tanpa delay."
    set /p "ADVANCED_KEYBOARD=  Gunakan mode keyboard fisik (uhid)? [y/n] (default: n): "
    if "!ADVANCED_KEYBOARD!"=="" set "ADVANCED_KEYBOARD=n"

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
)

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
set "SCRCPY_ARGS="
if "!LAST_CONNECTION!"=="1" set "SCRCPY_ARGS=-d "
if "!LAST_CONNECTION!"=="2" set "SCRCPY_ARGS=-s !LAST_IP!:!LAST_PORT! "
if "!LAST_CONNECTION!"=="3" set "SCRCPY_ARGS=-s !LAST_IP!:!LAST_PORT! "
set "SCRCPY_ARGS=!SCRCPY_ARGS!--video-codec=!LAST_CODEC! -b !LAST_BITRATE! --max-fps !LAST_FPS!"
if not "!LAST_RESOLUTION!"=="0" set "SCRCPY_ARGS=!SCRCPY_ARGS! --max-size !LAST_RESOLUTION!"
if /i "!STAY_AWAKE!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --stay-awake"
if /i "!TURN_SCREEN_OFF!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --turn-screen-off"
if /i "!NO_CONTROL!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --no-control"
if /i "!RECORD_SCREEN!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --record !RECORD_FILENAME!"
if /i "!MIRROR_CAMERA!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --video-source=camera --camera-facing=!CAMERA_FACING!"
if /i "!ENABLE_OTG!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --otg"
if "!WINDOW_OPTIONS!"=="2" set "SCRCPY_ARGS=!SCRCPY_ARGS! --always-on-top"
if "!WINDOW_OPTIONS!"=="3" set "SCRCPY_ARGS=!SCRCPY_ARGS! --window-borderless"
if "!WINDOW_OPTIONS!"=="4" set "SCRCPY_ARGS=!SCRCPY_ARGS! --always-on-top --window-borderless"
if "!AUDIO_MODE!"=="2" set "SCRCPY_ARGS=!SCRCPY_ARGS! --audio-source=playback --audio-dup"
if "!AUDIO_MODE!"=="3" set "SCRCPY_ARGS=!SCRCPY_ARGS! --no-audio"
if "!AUDIO_MODE!"=="4" set "SCRCPY_ARGS=!SCRCPY_ARGS! --audio-source=mic"
if /i "!ADVANCED_KEYBOARD!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --keyboard=uhid"

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
call :LOAD_MODE_CONFIG "USB"
echo.
echo   %ESC%[36m  Config USB tersimpan: FPS=!LAST_FPS! Bitrate=!LAST_BITRATE! Resolusi=!LAST_RESOLUTION! Codec=!LAST_CODEC!%ESC%[0m
set /p "_reuse=  Gunakan konfigurasi USB tersimpan? [y/n] (default: y): "
if "!_reuse!"=="" set "_reuse=y"
if /i not "!_reuse!"=="y" (
    call :CONFIGURE_SCRCPY
    call :CONFIGURE_FEATURES
)
call :SAVE_MODE_CONFIG "USB"
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

call :LOAD_MODE_CONFIG "WIFI"
echo.
set /p "input_port=  Masukkan port TCP [default: !LAST_PORT!]: "
if not "!input_port!"=="" set "LAST_PORT=!input_port!"

call :NOTE "LANGKAH 2: Mengaktifkan mode TCP/IP di HP..."
"%ADB_EXE%" -s "%DEVICE_ID%" tcpip %LAST_PORT%
timeout /t 2 /nobreak >nul

echo.
call :NOTE "Cari IP HP: Pengaturan - Tentang Ponsel - Status - Alamat IP"
call :NOTE "      ATAU: Pengaturan - WiFi - (jaringan Anda) - Detail"
echo.
if defined LAST_IP (
    if not "!LAST_IP!"=="" (
        set /p "input_ip=  Masukkan alamat IP HP Android [default: !LAST_IP!]: "
        if not "!input_ip!"=="" set "LAST_IP=!input_ip!"
    ) else (
        set /p "LAST_IP=  Masukkan alamat IP HP Android: "
    )
) else (
    set /p "LAST_IP=  Masukkan alamat IP HP Android: "
)
if "!LAST_IP!"=="" ( call :ERR "IP tidak boleh kosong!"; pause; goto :MAIN_MENU )

echo.
call :WARN "LANGKAH 3: Cabut kabel USB sekarang, lalu tekan sembarang tombol!"
echo   %ESC%[31m  Cabut kabel USB dari HP terlebih dahulu!%ESC%[0m
pause

call :NOTE "LANGKAH 4: Menghubungkan via WiFi ke !LAST_IP!:!LAST_PORT!..."
"%ADB_EXE%" connect "!LAST_IP!:!LAST_PORT!"
timeout /t 3 /nobreak >nul

"%ADB_EXE%" devices | findstr "!LAST_IP!" >nul
if !errorlevel! neq 0 (
    call :ERR "Koneksi WiFi gagal!"
    call :WARN "Pastikan HP dan laptop berada di WiFi yang sama"
    call :WARN "Pastikan mode TCP/IP sudah aktif (jalankan ulang dan colok USB dulu)"
    call :WARN "Coba matikan sementara Windows Firewall"
    pause
    goto :MAIN_MENU
)

call :OK "Koneksi WiFi berhasil!"
set "LAST_CONNECTION=2"
echo.
echo   %ESC%[36m  Config WiFi tersimpan: FPS=!LAST_FPS! Bitrate=!LAST_BITRATE! Resolusi=!LAST_RESOLUTION! Codec=!LAST_CODEC!%ESC%[0m
set /p "_reuse=  Gunakan konfigurasi WiFi tersimpan? [y/n] (default: y): "
if "!_reuse!"=="" set "_reuse=y"
if /i not "!_reuse!"=="y" (
    call :CONFIGURE_SCRCPY
    call :CONFIGURE_FEATURES
)
call :SAVE_MODE_CONFIG "WIFI"
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
call :LOAD_MODE_CONFIG "WD"
set /p "DO_PAIR=  Pertama kali? (Butuh Pairing) [y/n] (default: y): "
if "!DO_PAIR!"=="" set "DO_PAIR=y"

if /i "!DO_PAIR!"=="y" goto :DO_PAIRING_WD
goto :WD_CONNECT

:DO_PAIRING_WD
echo.
call :NOTE "Di HP: Pengaturan - Opsi Pengembang - Wireless Debugging"
call :NOTE "     - 'Pasangkan perangkat dengan kode'"
call :NOTE "Catat IP:PORT dan 6-digit kode"
echo.
set "PAIR_ADDR="
set "PAIR_CODE="
set /p "PAIR_ADDR=  Masukkan IP:PORT pairing (contoh: 192.168.1.5:43521): "
set /p "PAIR_CODE=  Masukkan 6-digit kode dari HP: "
if "!PAIR_ADDR!"=="" (
    call :ERR "Alamat pairing tidak boleh kosong!"
    pause
    goto :MAIN_MENU
)
if "!PAIR_CODE!"=="" (
    call :ERR "Kode 6-digit tidak boleh kosong!"
    pause
    goto :MAIN_MENU
)
call :NOTE "Pairing dengan !PAIR_ADDR!..."
call :NOTE "Memulai ADB server (tunggu sebentar)..."
"%ADB_EXE%" start-server >nul 2>&1
timeout /t 2 /nobreak >nul
"%ADB_EXE%" pair "!PAIR_ADDR!" "!PAIR_CODE!"
if !errorlevel! neq 0 (
    call :ERR "Pairing gagal! Pastikan kode dan alamat benar."
    call :WARN "Coba buka menu 'Pasangkan perangkat' di HP lagi untuk kode baru"
    call :WARN "Pastikan IP:PORT benar (format: 192.168.x.x:PORT_BUKAN_5555)"
    pause
    goto :MAIN_MENU
)
call :OK "Pairing berhasil!"

:WD_CONNECT
echo.
set /p "DO_MDNS=  Cari IP HP secara otomatis di jaringan WiFi ini? [y/n] (default: y): "
if "!DO_MDNS!"=="" set "DO_MDNS=y"

if /i "!DO_MDNS!"=="y" (
    call :NOTE "Mencari perangkat Wireless Debugging..."
    set "MDNS_FOUND="
    for /f "tokens=1,2,3" %%A in ('"%ADB_EXE%" mdns services 2^>nul ^| findstr "adb-tls-connect"') do (
        set "MDNS_FOUND=%%C"
    )
    if defined MDNS_FOUND (
        call :OK "Perangkat ditemukan: !MDNS_FOUND!"
        set "LAST_IP_FULL=!MDNS_FOUND!"
        for /f "tokens=1,2 delims=:" %%X in ("!LAST_IP_FULL!") do (
            set "LAST_IP=%%X"
            set "LAST_PORT=%%Y"
        )
        goto :CONNECT_NOW
    ) else (
        call :WARN "Tidak ditemukan perangkat otomatis, silakan masukkan manual."
    )
)

echo.
call :NOTE "Di HP: catat Alamat IP dan Port di menu Wireless Debugging"
if defined LAST_IP (
    if not "!LAST_IP!"=="" (
        set /p "input_ip=  Masukkan IP HP [default: !LAST_IP!]: "
        if not "!input_ip!"=="" set "LAST_IP=!input_ip!"
    ) else (
        set /p "LAST_IP=  Masukkan IP HP: "
    )
) else (
    set /p "LAST_IP=  Masukkan IP HP: "
)
if defined LAST_PORT (
    if not "!LAST_PORT!"=="" (
        set /p "input_port=  Masukkan Port [default: !LAST_PORT!]: "
        if not "!input_port!"=="" set "LAST_PORT=!input_port!"
    ) else (
        set /p "LAST_PORT=  Masukkan Port (dari Wireless Debugging): "
    )
) else (
    set /p "LAST_PORT=  Masukkan Port (dari Wireless Debugging): "
)
if "!LAST_IP!"=="" (
    call :ERR "IP tidak boleh kosong!"
    pause
    goto :MAIN_MENU
)
if "!LAST_PORT!"=="" set "LAST_PORT=5555"

:CONNECT_NOW
call :NOTE "Menghubungkan ke !LAST_IP!:!LAST_PORT!..."
"%ADB_EXE%" connect "!LAST_IP!:!LAST_PORT!"
timeout /t 3 /nobreak >nul

"%ADB_EXE%" devices | findstr "!LAST_IP!" >nul
if !errorlevel! neq 0 (
    call :ERR "Koneksi gagal!"
    call :WARN "Pastikan HP dan laptop di jaringan WiFi yang sama"
    call :WARN "Pastikan Wireless Debugging masih aktif di HP"
    call :WARN "Port dari Wireless Debugging berubah setiap koneksi WiFi ulang"
    pause
    goto :MAIN_MENU
)

call :OK "Wireless Debugging terhubung!"
set "LAST_CONNECTION=3"
echo.
echo   %ESC%[36m  Config Wireless Debug tersimpan: FPS=!LAST_FPS! Bitrate=!LAST_BITRATE! Resolusi=!LAST_RESOLUTION! Codec=!LAST_CODEC!%ESC%[0m
set /p "_reuse=  Gunakan konfigurasi Wireless Debug tersimpan? [y/n] (default: y): "
if "!_reuse!"=="" set "_reuse=y"
if /i not "!_reuse!"=="y" (
    call :CONFIGURE_SCRCPY
    call :CONFIGURE_FEATURES
)
call :SAVE_MODE_CONFIG "WD"
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
echo   1. Buka %ESC%[33mPengaturan%ESC%[0m di HP
echo   2. Masuk ke %ESC%[33mOpsi Pengembang%ESC%[0m
echo      (Jika belum ada, ketuk Nomor Build 7x di "Tentang Ponsel")
echo   3. Cari dan aktifkan %ESC%[33m"Wireless Debugging"%ESC%[0m / "Debug Nirkabel"
echo   4. Ketuk "Izinkan" saat ada popup konfirmasi
echo.
echo   %ESC%[36m  --- LANGKAH 2: Dapatkan Kode 6-Digit (PAIRING) ------------%ESC%[0m
echo   %ESC%[33m  ^> Langkah ini WAJIB dilakukan sebelum koneksi pertama kali%ESC%[0m
echo.
echo   1. Di dalam menu Wireless Debugging, ketuk:
echo      %ESC%[32m"Pasangkan perangkat dengan kode penyambungan"%ESC%[0m
echo      (atau "Pair device with pairing code")
echo.
echo   2. Di HP akan muncul 3 informasi:
echo      %ESC%[36m  * IP Address   : %ESC%[0mcontoh  192.168.1.5
echo      %ESC%[36m  * Port PAIRING : %ESC%[0mcontoh  43521   ^<-- port untuk adb pair
echo      %ESC%[36m  * Kode 6-digit : %ESC%[0mcontoh  986143  ^<-- kode rahasia
echo.
echo   3. Di script ini, masukkan:
echo      IP:PORT pairing  ^-->  192.168.1.5:43521
echo      Kode 6-digit     ^-->  986143
echo.
echo   %ESC%[33m  PERHATIAN: Port PAIRING berbeda dengan port KONEKSI!%ESC%[0m
echo   %ESC%[33m  Setelah selesai pairing, kembali ke layar Wireless Debugging%ESC%[0m
echo   %ESC%[33m  untuk melihat IP ^& Port koneksi yang sesungguhnya.%ESC%[0m
echo.
echo   %ESC%[36m  --- LANGKAH 3: Catat IP dan Port Koneksi ------------------%ESC%[0m
echo   Kembali ke layar utama Wireless Debugging, catat:
echo   %ESC%[36m  "IP address ^& Port"%ESC%[0m yang tertera di bagian atas
echo   Contoh: 192.168.1.5:39465  ^<-- ini dipakai untuk adb connect
echo.
echo   %ESC%[36m  --- LANGKAH 4: Hubungkan via Script -----------------------%ESC%[0m
echo   Pilih menu 3 (Wireless Debugging) di menu utama, lalu:
echo   - Pilih "y" untuk pairing jika pertama kali
echo   - Masukkan IP:PORT pairing dan kode 6-digit
echo   - Setelah pairing, masukkan IP dan Port koneksi
echo.
echo   %ESC%[33m  CATATAN PENTING:%ESC%[0m
echo   - Port berubah setiap kali WiFi terhubung ulang
echo   - Kode 6-digit hanya berlaku beberapa detik, jangan sampai habis
echo   - Pastikan Windows Firewall tidak memblokir ADB
echo   - HP dan laptop HARUS di jaringan WiFi yang sama
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

:AUTO_INSTALL
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === AUTO INSTALL SCRCPY v!SCRCPY_DOWNLOAD_VER! ===%ESC%[0m
echo.
call :NOTE "Mengunduh scrcpy v!SCRCPY_DOWNLOAD_VER! (64-bit)... (Mungkin butuh beberapa menit)"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v!SCRCPY_DOWNLOAD_VER!/scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!.zip' -OutFile '%TEMP%\scrcpy-win64.zip' -UseBasicParsing"
call :NOTE "Mengekstrak ke C:\scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!..."
powershell -Command "Expand-Archive -Path '%TEMP%\scrcpy-win64.zip' -DestinationPath 'C:\' -Force"
call :OK "Instalasi selesai!"
set "SCRCPY_PATH=C:\scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!"
set "SCRCPY_EXE=!SCRCPY_PATH!\scrcpy.exe"
set "ADB_EXE=!SCRCPY_PATH!\adb.exe"
call :ADD_TO_PATH "!SCRCPY_PATH!"
call :OK "Tekan Enter untuk menghubungkan perangkat..."
pause
goto :CHECK_DEVICE

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
echo     5. Download sndcpy (Hanya jika suara scrcpy tidak keluar di Android 10 ke bawah)
echo     6. Kembali ke Menu Utama
echo.
call :NOTE "*Coba jalankan mirroring biasa dulu. Jika tidak ada suara, baru install sndcpy (opsi 5)."
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
set "SS_FILE=screenshot_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.png"
set "SS_FILE=!SS_FILE: =0!"
"%ADB_EXE%" exec-out screencap -p > "!SS_FILE!"
if exist "!SS_FILE!" (
    for %%F in ("!SS_FILE!") do (
        if %%~zF gtr 0 (
            call :OK "Screenshot disimpan: !SS_FILE!"
        ) else (
            del "!SS_FILE!"
            call :ERR "Screenshot gagal - file kosong. Pastikan HP terhubung dan ADB aktif."
        )
    )
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
    echo   %ESC%[36m  --- Config USB ------------------------------------------%ESC%[0m
    call :NOTE "FPS: !USB_FPS! ^| Bitrate: !USB_BITRATE! ^| Resolusi: !USB_RESOLUTION! ^| Codec: !USB_CODEC!"
    call :NOTE "Stay Awake: !USB_STAY_AWAKE! ^| No Control: !USB_NO_CONTROL! ^| Layar Mati: !USB_TURN_SCREEN_OFF!"
    echo.
    echo   %ESC%[36m  --- Config WiFi -----------------------------------------%ESC%[0m
    if defined WIFI_IP ( call :NOTE "IP: !WIFI_IP! ^| Port: !WIFI_PORT!" ) else ( call :NOTE "IP: Belum diset ^| Port: !WIFI_PORT!" )
    call :NOTE "FPS: !WIFI_FPS! ^| Bitrate: !WIFI_BITRATE! ^| Resolusi: !WIFI_RESOLUTION! ^| Codec: !WIFI_CODEC!"
    call :NOTE "Stay Awake: !WIFI_STAY_AWAKE! ^| No Control: !WIFI_NO_CONTROL! ^| Layar Mati: !WIFI_TURN_SCREEN_OFF!"
    echo.
    echo   %ESC%[36m  --- Config Wireless Debug -------------------------------%ESC%[0m
    if defined WD_IP ( call :NOTE "IP: !WD_IP! ^| Port: !WD_PORT!" ) else ( call :NOTE "IP: Belum diset ^| Port: !WD_PORT!" )
    call :NOTE "FPS: !WD_FPS! ^| Bitrate: !WD_BITRATE! ^| Resolusi: !WD_RESOLUTION! ^| Codec: !WD_CODEC!"
    call :NOTE "Stay Awake: !WD_STAY_AWAKE! ^| No Control: !WD_NO_CONTROL! ^| Layar Mati: !WD_TURN_SCREEN_OFF!"
    echo.
    call :PRINT_SEP
    set /p "del_conf=  Hapus semua konfigurasi? [y/n]: "
    if /i "!del_conf!"=="y" (
        del "%CONFIG_FILE%"
        call :OK "Konfigurasi dihapus."
        call :LOAD_CONFIG
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

if "!LAST_CONNECTION!"=="1" call :NOTE "Koneksi terakhir: USB  (FPS=!USB_FPS! Bitrate=!USB_BITRATE!)"
if "!LAST_CONNECTION!"=="2" call :NOTE "Koneksi terakhir: WiFi  (IP=!WIFI_IP! Port=!WIFI_PORT!)"
if "!LAST_CONNECTION!"=="3" call :NOTE "Koneksi terakhir: Wireless Debug  (IP=!WD_IP! Port=!WD_PORT!)"

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