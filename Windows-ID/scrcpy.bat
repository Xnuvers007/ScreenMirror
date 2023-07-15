@echo off

Title Screen Mirroring by Xnuvers007

REM Periksa apakah 32-bit atau 64-bit
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set "scrcpyPath=C:\scrcpy-win32-v2.1.1\scrcpy-win32-v2.1.1"
) else (
    set "scrcpyPath=C:\scrcpy-win64-v2.1.1\scrcpy-win64-v2.1.1"
)

REM Tambahkan direktori scrcpy ke PATH
setx PATH "%PATH%;%scrcpyPath%" /M

PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas

echo 1. scrcpy (USB)
echo 2. scrcpy (LAN)
echo Masukkan pilihan Anda:

set /p answer=
if not '%answer%'=='' set answer=%answer%
if '%answer%'=='1' goto scrcpyUSB
if '%answer%'=='2' goto scrcpyLAN

:scrcpyUSB
echo Memulai Screen Mirroring

echo 1. scrcpy (32-bit)
echo 2. scrcpy (64-bit)
echo Masukkan pilihan Anda:

set /p scrcpyOption=
if not '%scrcpyOption%'=='' set scrcpyOption=%scrcpyOption%
if '%scrcpyOption%'=='1' goto scrcpyUSB32
if '%scrcpyOption%'=='2' goto scrcpyUSB64

:scrcpyUSB32
echo Memulai Screen Mirroring (32-bit)
cd "%scrcpyPath%"
echo Masukkan maksimum FPS (frame per detik) tanpa "fps". Contoh: 30 (30 fps)
set /p maxFPS=
if not '%maxFPS%'=='' set maxFPS=%maxFPS%
adb.exe kill-server
adb.exe start-server
scrcpy.exe -b 40M --max-fps %maxFPS%
goto :end

:scrcpyUSB64
echo Memulai Screen Mirroring (64-bit)
cd "%scrcpyPath%"
echo Masukkan maksimum FPS (frame per detik) tanpa "fps". Contoh: 30 (30 fps)
set /p maxFPS=
if not '%maxFPS%'=='' set maxFPS=%maxFPS%
adb.exe kill-server
adb.exe start-server
scrcpy.exe -b 40M --max-fps %maxFPS%
goto :end

:scrcpyLAN
echo Memulai Screen Mirroring

echo 1. scrcpy (32-bit)
echo 2. scrcpy (64-bit)
echo Masukkan pilihan Anda:

set /p scrcpyOption=
if not '%scrcpyOption%'=='' set scrcpyOption=%scrcpyOption%
if '%scrcpyOption%'=='1' goto scrcpyLAN32
if '%scrcpyOption%'=='2' goto scrcpyLAN64

:scrcpyLAN32
echo Memulai Screen Mirroring (32-bit)
cd "%scrcpyPath%"
echo Masukkan alamat IP Anda:
set /p ip=
if not '%ip%'=='' set ip=%ip%
adb.exe kill-server
adb.exe start-server
adb.exe tcpip 5555
adb.exe connect %ip%:5555
echo Masukkan maksimum FPS (frame per detik) tanpa "fps". Contoh: 30 (30 fps)
set /p maxFPS=
if not '%maxFPS%'=='' set maxFPS=%maxFPS%
scrcpy.exe -b 40M --max-fps %maxFPS% --tcpip=%ip%:5555
goto :end

:scrcpyLAN64
echo Memulai Screen Mirroring (64-bit)
cd "%scrcpyPath%"
echo Masukkan alamat IP Anda:
set /p ip=
if not '%ip%'=='' set ip=%ip%
adb.exe kill-server
adb.exe start-server
adb.exe tcpip 5555
adb.exe connect %ip%:5555
echo Masukkan maksimum FPS (frame per detik) tanpa "fps". Contoh: 30 (30 fps)
set /p maxFPS=
if not '%maxFPS%'=='' set maxFPS=%maxFPS%
scrcpy.exe -b 40M --max-fps %maxFPS% --tcpip=%ip%:5555
goto :end

:end
