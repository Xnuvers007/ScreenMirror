@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1

:: Define ESC character for colors
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESC=%%E"

:: ============================================================
::  ScreenMirror - Main Script (Windows - English)
::  Coded by Xnuvers007
::  Don't modify without credit/original source
:: ============================================================
:: LICENSE: MIT | GitHub: https://github.com/Xnuvers007/ScreenMirror
:: ============================================================

title ScreenMirror by Xnuvers007 - Windows English

:: --- Run as Administrator ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] This script requires Administrator privileges.
    echo [!] Requesting Administrator permission...
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
echo   %ESC%[36m           Windows Edition  ^|  English%ESC%[0m
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
    echo ; ScreenMirror Configuration - English
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
call :OK "Configuration saved to: %CONFIG_FILE%"
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
        set "_line_first=%%a"
        if not "!_line_first!"=="" if not "!_line_first:~0,1!"==";" if not "!_line_first:~0,1!"=="#" (
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
echo   %ESC%[35m  === CHECK ANDROID DEVICE ===%ESC%[0m
echo.
call :NOTE "Starting ADB server..."

if defined ADB_EXE (
    "%ADB_EXE%" kill-server >nul 2>&1
    "%ADB_EXE%" start-server >nul 2>&1
    "%ADB_EXE%" devices
) else (
    call :ERR "ADB not found! Please install scrcpy first."
    goto :INSTALL_MENU
)

echo.
for /f "skip=1 tokens=1,2" %%a in ('"%ADB_EXE%" devices 2^>nul') do (
    if "%%b"=="device" (
        set "DEVICE_ID=%%a"
        call :OK "Device detected: %%a"

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
                call :ERR "Android too old (API !DEVICE_SDK!). Need at least Android 5.0 (API 21)"
                pause
                exit /b 1
            ) else if !DEVICE_SDK! LSS 28 (
                call :WARN "Android (API !DEVICE_SDK!) supported but with limited features. Recommended: Android 9+"
            ) else (
                call :OK "Device is compatible!"
            )
        )
        goto :DEVICE_FOUND
    )
)

call :ERR "No Android device detected!"
echo.
call :NOTE "Possible causes:"
call :NOTE "1. USB cable not connected"
call :NOTE "2. USB Debugging not enabled"
call :NOTE "3. Tap 'Allow' on the popup on your phone"
call :NOTE "4. Try unplugging and re-plugging the USB cable"
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
echo   %ESC%[35m  === SCRCPY SETTINGS ===%ESC%[0m
echo.

echo   %ESC%[36m  Choose FPS:%ESC%[0m
echo     1. 30 FPS  - Saves battery, good for presentations
echo     2. 60 FPS  - Smooth (RECOMMENDED)
echo     3. 120 FPS - Ultra smooth, needs gaming phone
echo     4. Custom
echo.
set /p "fps_choice=  FPS choice [1-4] (default: 2): "
if "!fps_choice!"=="" set "fps_choice=2"
if "!fps_choice!"=="1" set "LAST_FPS=30"
if "!fps_choice!"=="2" set "LAST_FPS=60"
if "!fps_choice!"=="3" set "LAST_FPS=120"
if "!fps_choice!"=="4" set /p "LAST_FPS=  Enter FPS: "
if "!LAST_FPS!"=="" set "LAST_FPS=60"
call :OK "FPS: !LAST_FPS!"

echo.
echo   %ESC%[36m  Choose Bitrate (Video Quality):%ESC%[0m
echo     1. 4M  - Standard (slow/far connection)
echo     2. 8M  - Good (RECOMMENDED)
echo     3. 16M - Very good (fast WiFi)
echo     4. 40M - Maximum (direct USB)
echo     5. Custom
echo.
set /p "br_choice=  Bitrate choice [1-5] (default: 2): "
if "!br_choice!"=="" set "br_choice=2"
if "!br_choice!"=="1" set "LAST_BITRATE=4M"
if "!br_choice!"=="2" set "LAST_BITRATE=8M"
if "!br_choice!"=="3" set "LAST_BITRATE=16M"
if "!br_choice!"=="4" set "LAST_BITRATE=40M"
if "!br_choice!"=="5" set /p "LAST_BITRATE=  Enter bitrate (e.g. 10M): "
if "!LAST_BITRATE!"=="" set "LAST_BITRATE=8M"
call :OK "Bitrate: !LAST_BITRATE!"

echo.
echo   %ESC%[36m  Choose Resolution:%ESC%[0m
echo     1. 720p  - Lightweight
echo     2. 1080p - RECOMMENDED
echo     3. 1440p - High quality
echo     4. Full (native phone resolution)
echo.
set /p "res_choice=  Resolution [1-4] (default: 2): "
if "!res_choice!"=="" set "res_choice=2"
if "!res_choice!"=="1" set "LAST_RESOLUTION=720"
if "!res_choice!"=="2" set "LAST_RESOLUTION=1080"
if "!res_choice!"=="3" set "LAST_RESOLUTION=1440"
if "!res_choice!"=="4" set "LAST_RESOLUTION=0"
call :OK "Resolution: !LAST_RESOLUTION!"

echo.
echo   %ESC%[36m  Choose Video Codec:%ESC%[0m
echo     1. H.264  - Widely compatible (DEFAULT)
echo     2. H.265  - More efficient (Android 10+)
echo     3. AV1    - Experimental (Android 14+)
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
echo   %ESC%[35m  === EXTRA FEATURES ===%ESC%[0m
echo.
set /p "STAY_AWAKE=  Keep phone screen on (Stay Awake)? [y/n] (default: y): "
if "!STAY_AWAKE!"=="" set "STAY_AWAKE=y"

echo.
call :NOTE "Turn Screen Off: Phone screen turns off but mirroring continues on laptop"
set /p "TURN_SCREEN_OFF=  Turn phone screen off? [y/n] (default: n): "
if "!TURN_SCREEN_OFF!"=="" set "TURN_SCREEN_OFF=n"

echo.
call :NOTE "No Control: View only, cannot control phone from laptop (safer for presentations)"
set /p "NO_CONTROL=  Enable No Control mode? [y/n] (default: n): "
if "!NO_CONTROL!"=="" set "NO_CONTROL=n"

echo.
set /p "RECORD_SCREEN=  Record screen to video? [y/n] (default: n): "
if "!RECORD_SCREEN!"=="" set "RECORD_SCREEN=n"
if /i "!RECORD_SCREEN!"=="y" (
    set "RECORD_FILENAME=screenmirror_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.mp4"
    set /p "custom_rec=  Recording filename (press Enter for default): "
    if not "!custom_rec!"=="" set "RECORD_FILENAME=!custom_rec!"
    call :OK "Recording: !RECORD_FILENAME!"
)
goto :eof

:: ============================================================
:: LAUNCH SCRCPY
:: ============================================================

:LAUNCH_SCRCPY
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === STARTING SCREEN MIRROR ===%ESC%[0m
echo.
set "SCRCPY_ARGS=--video-codec=!LAST_CODEC! -b !LAST_BITRATE! --max-fps !LAST_FPS!"
if not "!LAST_RESOLUTION!"=="0" set "SCRCPY_ARGS=!SCRCPY_ARGS! --max-size !LAST_RESOLUTION!"
if /i "!STAY_AWAKE!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --stay-awake"
if /i "!TURN_SCREEN_OFF!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --turn-screen-off"
if /i "!NO_CONTROL!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --no-control"
if /i "!RECORD_SCREEN!"=="y" set "SCRCPY_ARGS=!SCRCPY_ARGS! --record !RECORD_FILENAME!"

call :NOTE "Command: scrcpy !SCRCPY_ARGS!"
call :PRINT_SEP
call :OK "Mirror window will appear shortly..."
call :NOTE "Shortcuts: Ctrl+H=Home - Ctrl+B=Back - Ctrl+M=Menu - Ctrl+S=Screenshot"
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
echo   %ESC%[35m  === WiFi CONNECTION (ADB TCP/IP) ===%ESC%[0m
echo.
call :NOTE "STEP 1: Make sure USB cable is still connected for initial setup"
call :CHECK_DEVICE
if not defined DEVICE_ID goto :MAIN_MENU

echo.
set /p "input_port=  Enter TCP port [default: %LAST_PORT%]: "
if not "!input_port!"=="" set "LAST_PORT=!input_port!"

call :NOTE "STEP 2: Enabling TCP/IP mode on phone..."
"%ADB_EXE%" -s "%DEVICE_ID%" tcpip %LAST_PORT%
timeout /t 2 /nobreak >nul

echo.
call :NOTE "Find phone IP: Settings -> About Phone -> Status -> IP Address"
call :NOTE "           OR: Settings -> WiFi -> (your network) -> Details"
echo.
set /p "LAST_IP=  Enter Android phone IP address: "
if "!LAST_IP!"=="" ( call :ERR "IP cannot be empty!"; pause; goto :MAIN_MENU )

echo.
call :WARN "STEP 3: Unplug USB cable now, then press any key!"
echo   %ESC%[31m  Unplug the USB cable from phone first!%ESC%[0m
pause

call :NOTE "STEP 4: Connecting via WiFi to !LAST_IP!:!LAST_PORT!..."
"%ADB_EXE%" connect "!LAST_IP!:!LAST_PORT!"
timeout /t 3 /nobreak >nul

"%ADB_EXE%" devices | findstr "!LAST_IP!" >nul
if !errorlevel! neq 0 (
    call :ERR "WiFi connection failed!"
    call :WARN "Make sure phone and laptop are on the same WiFi"
    call :WARN "Make sure TCP/IP mode is active (re-run and connect USB first)"
    call :WARN "Try temporarily disabling Windows Firewall"
    pause
    goto :MAIN_MENU
)

call :OK "WiFi connection successful!"
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
call :WARN "This requires Android 11 or newer!"
call :NOTE "For Android 10 and below, use the WiFi connection option."
echo.
set /p "DO_PAIR=  First time? (Pairing needed) [y/n] (default: y): "
if "!DO_PAIR!"=="" set "DO_PAIR=y"

if /i "!DO_PAIR!"=="y" goto :DO_PAIRING_WD
goto :WD_CONNECT

:DO_PAIRING_WD
echo.
call :NOTE "On phone: Settings -> Developer Options -> Wireless Debugging"
call :NOTE "          -> 'Pair device with pairing code'"
call :NOTE "Note the IP:PORT and 6-digit code"
echo.
set "PAIR_ADDR="
set "PAIR_CODE="
set /p "PAIR_ADDR=  Enter pairing IP:PORT (e.g. 192.168.1.5:43521): "
set /p "PAIR_CODE=  Enter 6-digit code from phone: "
if "!PAIR_ADDR!"=="" (
    call :ERR "Pairing address cannot be empty!"
    pause
    goto :MAIN_MENU
)
if "!PAIR_CODE!"=="" (
    call :ERR "Pairing code cannot be empty!"
    pause
    goto :MAIN_MENU
)
call :NOTE "Pairing with !PAIR_ADDR!..."
call :NOTE "Starting ADB server (please wait)..."
"%ADB_EXE%" start-server >nul 2>&1
timeout /t 2 /nobreak >nul
"%ADB_EXE%" pair "!PAIR_ADDR!" "!PAIR_CODE!"
if !errorlevel! neq 0 (
    call :ERR "Pairing failed! Check the code and address."
    call :WARN "Try reopening 'Pair device with code' on your phone to get a new code"
    call :WARN "Ensure IP:PORT is correct (format: 192.168.x.x:PORT_NOT_5555)"
    pause
    goto :MAIN_MENU
)
call :OK "Pairing successful!"

:WD_CONNECT
echo.
call :NOTE "On phone: note the IP address and Port in the Wireless Debugging menu"
set "LAST_IP="
set /p "LAST_IP=  Enter phone IP: "
set /p "LAST_PORT=  Enter Port (from Wireless Debugging): "
if "!LAST_IP!"=="" (
    call :ERR "IP cannot be empty!"
    pause
    goto :MAIN_MENU
)
if "!LAST_PORT!"=="" set "LAST_PORT=5555"

call :NOTE "Connecting to !LAST_IP!:!LAST_PORT!..."
"%ADB_EXE%" connect "!LAST_IP!:!LAST_PORT!"
timeout /t 3 /nobreak >nul

"%ADB_EXE%" devices | findstr "!LAST_IP!" >nul
if !errorlevel! neq 0 (
    call :ERR "Connection failed!"
    call :WARN "Make sure phone and laptop are on the same WiFi"
    call :WARN "Make sure Wireless Debugging is still active on your phone"
    call :WARN "The Wireless Debugging port changes each time WiFi reconnects"
    pause
    goto :MAIN_MENU
)

call :OK "Wireless Debugging connected!"
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
echo   %ESC%[35m  === TUTORIAL: HOW TO ENABLE USB DEBUGGING ===%ESC%[0m
echo.
echo   USB Debugging is a hidden Android feature that allows
echo   your computer to communicate directly with your phone.
echo.
echo   %ESC%[36m  --- STEP 1: Enable Developer Mode --------------------%ESC%[0m
echo   1. Open "Settings" on your phone
echo   2. Find "About Phone"
echo      Samsung : Settings ^^> About Phone ^^> Software Information
echo      Xiaomi  : Settings ^^> About Phone
echo      Oppo    : Settings ^^> About Phone
echo   3. Find "Build Number" (or MIUI Version)
echo   4. Tap it 7 TIMES in a row
echo   5. "You are now a developer!" message appears [OK]
echo.
echo   %ESC%[36m  --- STEP 2: Enable USB Debugging ---------------------%ESC%[0m
echo   1. Go back to main Settings
echo   2. Find "Developer Options" (usually at the bottom)
echo      Samsung : Settings ^^> Developer Options
echo      Xiaomi  : Settings ^^> Additional Settings ^^> Developer Options
echo   3. Enable the "Developer Options" toggle
echo   4. Enable "USB Debugging"
echo   5. Tap "OK" on the warning popup
echo.
echo   %ESC%[36m  --- STEP 3: Connect to Laptop -------------------------%ESC%[0m
echo   1. Plug in USB cable
echo   2. Phone popup: "Allow USB Debugging?"
echo   3. Check "Always allow from this computer"
echo   4. Tap "Allow"
echo.
echo   %ESC%[33m  SECURITY NOTE:%ESC%[0m
echo   - USB Debugging gives full access when connected
echo   - Disable it when you don't need it
echo   - Never tap "Allow" from unknown computers
echo.
pause
goto :MAIN_MENU

:TUTORIAL_WIRELESS
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === TUTORIAL: WIRELESS DEBUGGING (Android 11+) ===%ESC%[0m
echo.
echo   Connect your phone wirelessly via the same WiFi network.
echo.
echo   %ESC%[36m  --- STEP 1: Enable Wireless Debugging ----------------%ESC%[0m
echo   1. Open %ESC%[33mSettings%ESC%[0m on your phone
echo   2. Go to %ESC%[33mDeveloper Options%ESC%[0m
echo      (If not visible, tap Build Number 7x in "About Phone")
echo   3. Find and enable %ESC%[33m"Wireless Debugging"%ESC%[0m
echo   4. Tap "Allow" on the confirmation popup
echo.
echo   %ESC%[36m  --- STEP 2: Get the 6-Digit Pairing Code -------------%ESC%[0m
echo   %ESC%[33m  ^> This step is REQUIRED before the first connection%ESC%[0m
echo.
echo   1. Inside Wireless Debugging, tap:
echo      %ESC%[32m"Pair device with pairing code"%ESC%[0m
echo.
echo   2. Your phone will show 3 pieces of info:
echo      %ESC%[36m  * IP Address    : %ESC%[0mexample  192.168.1.5
echo      %ESC%[36m  * Pairing PORT  : %ESC%[0mexample  43521   ^<-- port for adb pair
echo      %ESC%[36m  * 6-digit code  : %ESC%[0mexample  986143  ^<-- the secret code
echo.
echo   3. In this script, enter:
echo      Pairing IP:PORT  ^-->  192.168.1.5:43521
echo      6-digit code     ^-->  986143
echo.
echo   %ESC%[33m  NOTE: The PAIRING port is different from the CONNECTION port!%ESC%[0m
echo   %ESC%[33m  After pairing, go back to the Wireless Debugging main screen%ESC%[0m
echo   %ESC%[33m  to see the actual IP ^& Port for connecting.%ESC%[0m
echo.
echo   %ESC%[36m  --- STEP 3: Note the Connection IP and Port -----------%ESC%[0m
echo   Go back to the Wireless Debugging main screen and note:
echo   %ESC%[36m  "IP address ^& Port"%ESC%[0m shown at the top
echo   Example: 192.168.1.5:39465  ^<-- used for adb connect
echo.
echo   %ESC%[36m  --- STEP 4: Connect via Script ------------------------%ESC%[0m
echo   Choose menu 3 (Wireless Debugging) from the main menu, then:
echo   - Choose "y" for pairing if it's your first time
echo   - Enter the pairing IP:PORT and 6-digit code
echo   - After pairing, enter the connection IP and Port
echo.
echo   %ESC%[33m  IMPORTANT NOTES:%ESC%[0m
echo   - Port changes every time WiFi reconnects
echo   - The 6-digit code expires quickly, don't let it time out
echo   - Make sure Windows Firewall doesn't block ADB
echo   - Phone and laptop MUST be on the same WiFi network
echo.
pause
goto :MAIN_MENU

:TUTORIAL_SECURITY
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === SECURITY: INPUT EVENT INJECTION ===%ESC%[0m
echo.
echo   When mirroring, your keyboard/mouse can control your phone.
echo   This is called "Input Event Injection".
echo.
echo   %ESC%[32m  SAFE when:%ESC%[0m
echo   - Only you control the laptop
echo   - Connected via direct USB cable
echo   - Using private WiFi network
echo.
echo   %ESC%[33m  BE CAREFUL when:%ESC%[0m
echo   - Using public WiFi (cafe, campus)
echo   - Your laptop is accessed remotely
echo   - Phone has sensitive data
echo.
echo   %ESC%[36m  MIRROR WITHOUT CONTROL (Safer):%ESC%[0m
echo   Enable "No Control" mode: scrcpy --no-control
echo   View only - keyboard/mouse won't affect the phone
echo.
echo   %ESC%[36m  RECOMMENDATIONS:%ESC%[0m
echo   - Presentations: use No Control mode
echo   - Personal use: normal mode is safe
echo   - Disable USB Debugging when done
echo.
pause
goto :MAIN_MENU

:: ============================================================
:: INSTALL MENU
:: ============================================================

:INSTALL_MENU
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === INSTALL DEPENDENCIES ===%ESC%[0m
echo.
call :NOTE "Checking for latest scrcpy version online..."
for /f "usebackq tokens=*" %%v in (`powershell -NoProfile -Command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/Genymobile/scrcpy/releases/latest' -ErrorAction SilentlyContinue).tag_name.TrimStart('v')"`) do set "SCRCPY_DOWNLOAD_VER=%%v"
if "!SCRCPY_DOWNLOAD_VER!"=="" set "SCRCPY_DOWNLOAD_VER=4.0"
call :OK "Latest version available: !SCRCPY_DOWNLOAD_VER!"
echo.
echo     1. Download ^& Install scrcpy v!SCRCPY_DOWNLOAD_VER! (64-bit) - RECOMMENDED
echo     2. Download ^& Install scrcpy v!SCRCPY_DOWNLOAD_VER! (32-bit)
echo     3. Download ^& Install VLC (64-bit) - for audio
echo     4. Download ^& Install VLC (32-bit)
echo     5. Download sndcpy (audio mirroring)
echo     6. Back to Main Menu
echo.
set /p "inst_choice=  Choice [1-6]: "
if "!inst_choice!"=="1" goto :INSTALL_SCRCPY64
if "!inst_choice!"=="2" goto :INSTALL_SCRCPY32
if "!inst_choice!"=="3" goto :INSTALL_VLC64
if "!inst_choice!"=="4" goto :INSTALL_VLC32
if "!inst_choice!"=="5" goto :INSTALL_SNDCPY
if "!inst_choice!"=="6" goto :MAIN_MENU
goto :INSTALL_MENU

:INSTALL_SCRCPY64
call :NOTE "Downloading scrcpy v!SCRCPY_DOWNLOAD_VER! (64-bit)..."
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v!SCRCPY_DOWNLOAD_VER!/scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!.zip' -OutFile '%TEMP%\scrcpy-win64.zip' -UseBasicParsing"
call :NOTE "Extracting to C:\scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!..."
powershell -Command "Expand-Archive -Path '%TEMP%\scrcpy-win64.zip' -DestinationPath 'C:\' -Force"
call :OK "scrcpy 64-bit installed at C:\scrcpy-win64-v!SCRCPY_DOWNLOAD_VER!!"
pause
goto :INSTALL_MENU

:INSTALL_SCRCPY32
call :NOTE "Downloading scrcpy v!SCRCPY_DOWNLOAD_VER! (32-bit)..."
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v!SCRCPY_DOWNLOAD_VER!/scrcpy-win32-v!SCRCPY_DOWNLOAD_VER!.zip' -OutFile '%TEMP%\scrcpy-win32.zip' -UseBasicParsing"
powershell -Command "Expand-Archive -Path '%TEMP%\scrcpy-win32.zip' -DestinationPath 'C:\' -Force"
call :OK "scrcpy 32-bit installed!"
pause
goto :INSTALL_MENU

:INSTALL_VLC64
call :NOTE "Downloading VLC 64-bit..."
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe' -OutFile '%TEMP%\vlc-win64.exe' -UseBasicParsing"
powershell -Command "Start-Process -FilePath '%TEMP%\vlc-win64.exe' -ArgumentList '/S' -Verb runAs -Wait"
call :OK "VLC 64-bit installed!"
pause
goto :INSTALL_MENU

:INSTALL_VLC32
call :NOTE "Downloading VLC 32-bit..."
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win32/vlc-3.0.18-win32.exe' -OutFile '%TEMP%\vlc-win32.exe' -UseBasicParsing"
powershell -Command "Start-Process -FilePath '%TEMP%\vlc-win32.exe' -ArgumentList '/S' -Verb runAs -Wait"
call :OK "VLC 32-bit installed!"
pause
goto :INSTALL_MENU

:INSTALL_SNDCPY
call :NOTE "Downloading sndcpy..."
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-with-adb-windows-v1.1.zip' -OutFile '%TEMP%\sndcpy.zip' -UseBasicParsing"
powershell -Command "Expand-Archive -Path '%TEMP%\sndcpy.zip' -DestinationPath 'C:\sndcpy' -Force"
call :OK "sndcpy installed at C:\sndcpy!"
pause
goto :INSTALL_MENU

:: ============================================================
:: SCREENSHOT
:: ============================================================

:TAKE_SCREENSHOT
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === TAKE SCREENSHOT ===%ESC%[0m
echo.
call :NOTE "Taking screenshot from phone..."
set "SS_FILE=screenshot_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.png"
set "SS_FILE=!SS_FILE: =0!"
"%ADB_EXE%" exec-out screencap -p > "!SS_FILE!"
if exist "!SS_FILE!" (
    for %%F in ("!SS_FILE!") do (
        if %%~zF gtr 0 (
            call :OK "Screenshot saved: !SS_FILE!"
        ) else (
            del "!SS_FILE!"
            call :ERR "Screenshot failed - empty file. Make sure phone is connected and ADB is active."
        )
    )
) else (
    call :ERR "Failed to take screenshot. Make sure phone is connected."
)
pause
goto :MAIN_MENU

:: ============================================================
:: VIEW CONFIG
:: ============================================================

:VIEW_CONFIG
call :PRINT_BANNER
echo.
echo   %ESC%[35m  === SAVED CONFIGURATION ===%ESC%[0m
echo.
if exist "%CONFIG_FILE%" (
    type "%CONFIG_FILE%"
    echo.
    set /p "del_conf=  Delete configuration? [y/n]: "
    if /i "!del_conf!"=="y" (
        del "%CONFIG_FILE%"
        call :OK "Configuration deleted."
    )
) else (
    call :WARN "No saved configuration yet."
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
        call :NOTE "Last config: IP=!LAST_IP! PORT=!LAST_PORT! FPS=!LAST_FPS! Bitrate=!LAST_BITRATE!"
    )
)

echo.
echo   %ESC%[36m  --- CONNECTION --------------------------------------%ESC%[0m
echo   %ESC%[37m  1.%ESC%[0m USB Connection (cable)
echo   %ESC%[37m  2.%ESC%[0m WiFi Connection (all Android, needs USB once)
echo   %ESC%[37m  3.%ESC%[0m Wireless Debugging (Android 11+, fully wireless)
echo.
echo   %ESC%[36m  --- TUTORIALS ^& INFO --------------------------------%ESC%[0m
echo   %ESC%[37m  4.%ESC%[0m Tutorial: Enable USB Debugging
echo   %ESC%[37m  5.%ESC%[0m Tutorial: Enable Wireless Debugging
echo   %ESC%[37m  6.%ESC%[0m Security: Input Event Injection
echo.
echo   %ESC%[36m  --- TOOLS -------------------------------------------%ESC%[0m
echo   %ESC%[37m  7.%ESC%[0m Take Screenshot from Phone
echo   %ESC%[37m  8.%ESC%[0m Download ^& Install Dependencies
echo   %ESC%[37m  9.%ESC%[0m View/Delete Saved Configuration
echo   %ESC%[37m  0.%ESC%[0m Exit
echo.
call :PRINT_SEP

set /p "choice=  Enter choice [0-9]: "

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
    echo   Goodbye! Thank you for using ScreenMirror.
    echo.
    exit /b 0
)
call :WARN "Invalid choice. Try again."
timeout /t 1 /nobreak >nul
goto :MAIN_MENU

:ADD_TO_PATH
set "NEW_PATH=%~1"
:: Remove trailing backslashes if present
if "!NEW_PATH:~-1!"=="\" set "NEW_PATH=!NEW_PATH:~0,-1!"

:: Check if already in PATH
powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('PATH','User'); if($p -split ';' -contains '%NEW_PATH%') { exit 0 } else { exit 1 }" >nul 2>&1
if !errorlevel! equ 1 (
    call :NOTE "Adding !NEW_PATH! to Environment PATH (Permanent)..."
    powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('PATH','User'); [Environment]::SetEnvironmentVariable('PATH', $p + ';%NEW_PATH%', 'User')" >nul 2>&1
    call :OK "Successfully added to PATH."
)
goto :eof