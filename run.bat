@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1

:: ============================================================
::  ScreenMirror - run.bat (Universal Entry Point Windows)
::  Dibuat oleh Xnuvers007 | Coded by Xnuvers007
::  Pilih bahasa / Choose language
:: ============================================================

title ScreenMirror - Choose Language

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Auto-add to PATH if not already there
powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('PATH','User'); if($p -split ';' -contains '%~dp0') { exit 0 } else { exit 1 }" >nul 2>&1
if %errorLevel% equ 1 (
    powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('PATH','User'); [Environment]::SetEnvironmentVariable('PATH', $p + ';%~dp0', 'User')" >nul 2>&1
)

cls
echo.
echo   ============================================================
echo      Android to Laptop Screen Mirror  -  by Xnuvers007
echo   ============================================================
echo.
echo   Choose Language / Pilih Bahasa:
echo.
echo     1. Indonesia  (Bahasa Indonesia)
echo     2. English    (English)
echo     0. Exit / Keluar
echo.
echo   ---------------------------------------------------------
set /p "lang=  Pilihan / Choice [1-2]: "

if "%lang%"=="1" (
    echo   Menjalankan versi Bahasa Indonesia...
    cd /d "%~dp0Windows-ID"
    call scrcpy.bat
) else if "%lang%"=="2" (
    echo   Starting English version...
    cd /d "%~dp0windows"
    call scrcpy.bat
) else if "%lang%"=="0" (
    exit /b 0
) else (
    echo   Invalid choice. Defaulting to English...
    timeout /t 2 /nobreak >nul
    cd /d "%~dp0windows"
    call scrcpy.bat
)
