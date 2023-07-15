@echo off
//Menjalankan Otomatis Sebagai Administrator

setlocal EnableDelayedExpansion

Title Screen Mirroring oleh Xnuvers007 (Sebagai Administrator)
 
PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas

:startt
echo "Apakah Anda sudah menginstal VLC, scrcpy, dan sndcpy? [1,2,3,4]"
echo 1. Unduh VLC (64-bit)
echo 2. Unduh VLC (32-bit)
echo 3. Unduh scrcpy (64-bit)
echo 4. Unduh scrcpy (32-bit)
echo 5. Unduh sndcpy
echo 6. Keluar
echo 7. Mulai sndcpy (Kabel USB)
echo 8. Mulai sndcpy (Koneksi LAN)
echo 9. Mulai scrcpy

echo Masukkan pilihan Anda: 
set /p answer=
if not '%answer%'=='' set answer=%answer%
if '%answer%'=='1' goto vlc64
if '%answer%'=='2' goto vlc32
if '%answer%'=='3' goto scrcpy64
if '%answer%'=='4' goto scrcpy32
if '%answer%'=='5' goto sndcpy
if '%answer%'=='6' goto ex
if '%answer%'=='7' goto USBsndcpy
if '%answer%'=='8' goto LANsndcpy
if '%answer%'=='9' goto scrcpy

:scrcpy
./scrcpy.bat

:vlc64
echo "Mengunduh VLC (64-bit)"
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe' -OutFile 'vlc-3.0.18-win64.exe'"
echo "Unduhan VLC (64-bit) selesai"
echo "Menginstal VLC (64-bit)"
powershell -Command "Start-Process -FilePath 'vlc-3.0.18-win64.exe' -ArgumentList '/S' -Verb runAs"
echo "Instalasi VLC (64-bit) selesai"
goto startt

:vlc32
echo "Mengunduh VLC (32-bit)"
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win32/vlc-3.0.18-win32.exe' -OutFile 'vlc-3.0.18-win32.exe'"
echo "Unduhan VLC (32-bit) selesai"
echo "Menginstal VLC (32-bit)"
powershell -Command "Start-Process -FilePath 'vlc-3.0.18-win32.exe' -ArgumentList '/S' -Verb runAs"
echo "Instalasi VLC (32-bit) selesai"
goto startt

:scrcpy64
echo "Mengunduh scrcpy (64-bit)"
powershell -Command "curl https://github.com/Genymobile/scrcpy/releases/download/v2.1.1/scrcpy-win64-v2.1.1.zip -o scrcpy-win64-v2.1.1.zip"
echo "Unduhan scrcpy (64-bit) selesai"
echo "Mengekstrak scrcpy (64-bit)"
powershell -Command "Expand-Archive -Path 'scrcpy-win64-v2.1.1.zip' -DestinationPath 'C:\scrcpy-win64-v2.1.1'"
echo "Ekstraksi scrcpy (64-bit) selesai"
goto startt

:scrcpy32
echo "Mengunduh scrcpy (32-bit)"
powershell -Command "curl https://github.com/Genymobile/scrcpy/releases/download/v2.1.1/scrcpy-win32-v2.1.1.zip -o scrcpy-win32-v2.1.1.zip"
echo "Unduhan scrcpy (32-bit) selesai"
echo "Mengekstrak scrcpy (32-bit)"
powershell -Command "Expand-Archive -Path 'scrcpy-win32-v2.1.1.zip' -DestinationPath 'C:\scrcpy-win32-v2.1.1'"
echo "Ekstraksi scrcpy (32-bit) selesai"
goto startt

:sndcpy
echo "Mengunduh sndcpy"
powershell -Command "curl https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-with-adb-windows-v1.1.zip -o sndcpy-with-adb-windows-v1.1.zip"
echo "Unduhan sndcpy selesai"
echo "Mengekstrak sndcpy"
powershell -Command "Expand-Archive -Path 'sndcpy-with-adb-windows-v1.1.zip' -DestinationPath 'C:\sndcpy-with-adb-windows-v1.1'"
echo "Ekstraksi sndcpy selesai"
goto startt

:USBsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
adb.exe kill-server
adb.exe start-server
sndcpy.bat
echo

:LANsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
echo Masukkan alamat IP Anda:
set /p ip=
if not '%ip%'=='' set ip=%ip%
adb.exe kill-server
adb.exe start-server
adb.exe tcpip 5555
adb.exe connect %ip%:5555
sndcpy.bat
echo

:ex
echo "Keluar"
exit
