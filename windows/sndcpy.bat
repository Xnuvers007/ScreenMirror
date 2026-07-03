@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1

:: Define ESC character for colors
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESC=%%E"

:: ============================================================
::  ScreenMirror - sndcpy (Audio Mirror - Windows English)
::  Coded by Xnuvers007
:: ============================================================

title ScreenMirror Audio - sndcpy by Xnuvers007

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

cls
echo.
echo   %ESC%[32m  ======================================%ESC%[0m
echo   %ESC%[32m    Android Audio Mirroring - sndcpy    %ESC%[0m
echo   %ESC%[32m    Phone Audio to Laptop Speaker      %ESC%[0m
echo   %ESC%[32m  ======================================%ESC%[0m
echo.

set "SNDCPY_DIR=C:\sndcpy"
set "ADB_PATH="

where adb >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=*" %%i in ('where adb') do set "ADB_PATH=%%i"
) else (
    set "ADB_PATH=%SNDCPY_DIR%\adb.exe"
)

:MENU_SNDCPY
echo   Choose option:
echo.
echo     1. Download ^& Install VLC (64-bit)
echo     2. Download ^& Install VLC (32-bit)
echo     3. Download sndcpy (audio mirroring)
echo     4. Start audio mirroring (USB)
echo     5. Start audio mirroring (WiFi/LAN)
echo     6. Exit
echo.
set /p "schoice=  Choice [1-6]: "

if "!schoice!"=="1" goto :VLC64
if "!schoice!"=="2" goto :VLC32
if "!schoice!"=="3" goto :DL_SNDCPY
if "!schoice!"=="4" goto :USB_SNDCPY
if "!schoice!"=="5" goto :LAN_SNDCPY
if "!schoice!"=="6" exit /b 0
goto :MENU_SNDCPY

:VLC64
echo   %ESC%[37m  Downloading VLC 64-bit...%ESC%[0m
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe' -OutFile '%TEMP%\vlc-win64.exe' -UseBasicParsing"
powershell -Command "Start-Process -FilePath '%TEMP%\vlc-win64.exe' -ArgumentList '/S' -Verb runAs -Wait"
echo   %ESC%[32m  VLC 64-bit installed!%ESC%[0m
pause
goto :MENU_SNDCPY

:VLC32
echo   %ESC%[37m  Downloading VLC 32-bit...%ESC%[0m
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win32/vlc-3.0.18-win32.exe' -OutFile '%TEMP%\vlc-win32.exe' -UseBasicParsing"
powershell -Command "Start-Process -FilePath '%TEMP%\vlc-win32.exe' -ArgumentList '/S' -Verb runAs -Wait"
echo   %ESC%[32m  VLC 32-bit installed!%ESC%[0m
pause
goto :MENU_SNDCPY

:DL_SNDCPY
echo   %ESC%[37m  Downloading sndcpy...%ESC%[0m
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-with-adb-windows-v1.1.zip' -OutFile '%TEMP%\sndcpy.zip' -UseBasicParsing"
echo   %ESC%[37m  Extracting sndcpy...%ESC%[0m
powershell -Command "Expand-Archive -Path '%TEMP%\sndcpy.zip' -DestinationPath 'C:\sndcpy' -Force"
echo   %ESC%[32m  sndcpy installed at C:\sndcpy!%ESC%[0m
pause
goto :MENU_SNDCPY

:USB_SNDCPY
if not exist "%SNDCPY_DIR%" (
    echo   %ESC%[31m  sndcpy not installed! Choose option 3 first.%ESC%[0m
    pause
    goto :MENU_SNDCPY
)
echo   %ESC%[37m  Starting audio mirroring via USB...%ESC%[0m
"%ADB_PATH%" kill-server >nul 2>&1
"%ADB_PATH%" start-server >nul 2>&1
cd /d "%SNDCPY_DIR%"
sndcpy.bat
goto :MENU_SNDCPY

:LAN_SNDCPY
if not exist "%SNDCPY_DIR%" (
    echo   %ESC%[31m  sndcpy not installed! Choose option 3 first.%ESC%[0m
    pause
    goto :MENU_SNDCPY
)
echo.
set /p "snd_ip=  Enter phone IP address: "
if "!snd_ip!"=="" ( echo   %ESC%[31m  IP cannot be empty!%ESC%[0m; pause; goto :MENU_SNDCPY )
"%ADB_PATH%" kill-server >nul 2>&1
"%ADB_PATH%" start-server >nul 2>&1
"%ADB_PATH%" tcpip 5555
"%ADB_PATH%" connect "!snd_ip!:5555"
cd /d "%SNDCPY_DIR%"
sndcpy.bat
goto :MENU_SNDCPY