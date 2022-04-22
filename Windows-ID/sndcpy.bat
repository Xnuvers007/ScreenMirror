@echo off
//Automatically Run As Administrator

setlocal EnableDelayedExpansion

Title Screen Mirroring by Xnuvers007
 
PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas

echo "Apakah anda sudah mendownload vlc, scrcpy, and sndcpy ? [1,2,3,4]"
echo 1. Download vlc
echo 2. Download scrcpy
echo 3. Download sndcpy
echo 4. exit
echo 5. Mulai sndcpy (Kabel USB)
echo 6. Mulai sndcpy (Koneksi Jaringan Internet LAN)

echo Masukan Pilihan : 
set /p answer=
if not '%answer%'=='' set answer=%answer%
if '%answer%'=='1' goto vlc
if '%answer%'=='2' goto scrcpy
if '%answer%'=='3' goto sndcpy
if '%answer%'=='4' goto ex
if '%answer%'=='5' goto USBsndcpy
if '%answer%'=='6' goto LANsndcpy

:vlc
echo "Mendownload VLC"
powershell -Command "Invoke-WebRequest -Uri 'https://get.videolan.org/vlc/3.0.17.4/win64/vlc-3.0.17.4-win64.exe' -OutFile 'vlc-3.0.17.4-win64.exe'"
echo "Mendownload VLC sudah selesai"
echo "Memasang VLC"
powershell -Command "Start-Process -FilePath 'vlc-3.0.17.4-win64.exe' -ArgumentList '/S' -Verb runAs"
echo "pemasangan VLC sudah selesai"
exit

:scrcpy
echo "Mendownload Scrcpy"
powershell -Command "curl https://github.com/Genymobile/scrcpy/releases/download/v1.23/scrcpy-win64-v1.23.zip -o scrcpy-win64-v1.23.zip"
echo "Mendownload Scrcpy telah selesai"
echo "Mengekstrak Scrcpy"
powershell -Command "Expand-Archive -Path 'scrcpy-win64-v1.23.zip' -DestinationPath 'C:\scrcpy-win64-v1.23'"
echo "Ekstrak Scrcpy Sudah selesai"

:sndcpy
echo "Mendownload Sndcpy"
powershell -Command "curl https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-with-adb-windows-v1.1.zip -o sndcpy-with-adb-windows-v1.1.zip"
echo "Download Sndcpy sudah selesai"
echo "ekstrak Sndcpy"
powershell -Command "Expand-Archive -Path 'sndcpy-with-adb-windows-v1.1.zip' -DestinationPath 'C:\sndcpy-with-adb-windows-v1.1'"
echo "ekstrak Sndcpy selesai"
pause
exit

:USBsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
adb.exe kill-server
adb.exe start-server
sndcpy.bat
echo

:LANsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
echo Masukan Alamat IP Kamu :
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
