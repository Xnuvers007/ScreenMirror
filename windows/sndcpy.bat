@echo off
//Automatically Run As Administrator

setlocal EnableDelayedExpansion

Title Screen Mirroring by Xnuvers007 (As Administrator)
 
PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas

:startt
echo "Have you installed VLC, scrcpy, and sndcpy? [1,2,3,4]"
echo 1. Download VLC (64-bit)
echo 2. Download VLC (32-bit)
echo 3. Download scrcpy (64-bit)
echo 4. Download scrcpy (32-bit)
echo 5. Download sndcpy
echo 6. Exit
echo 7. Start sndcpy (USB Cable)
echo 8. Start sndcpy (LAN Connection)
echo 9. Start scrcpy

echo Enter your choice: 
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
echo "Downloading VLC (64-bit)"
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe' -OutFile 'vlc-3.0.18-win64.exe'"
echo "Downloading VLC (64-bit) done"
echo "Installing VLC (64-bit)"
powershell -Command "Start-Process -FilePath 'vlc-3.0.18-win64.exe' -ArgumentList '/S' -Verb runAs"
echo "Installing VLC (64-bit) done"
goto startt

:vlc32
echo "Downloading VLC (32-bit)"
powershell -Command "Invoke-WebRequest -Uri 'https://mirror.mangohost.net/videolan/vlc/3.0.18/win32/vlc-3.0.18-win32.exe' -OutFile 'vlc-3.0.18-win32.exe'"
echo "Downloading VLC (32-bit) done"
echo "Installing VLC (32-bit)"
powershell -Command "Start-Process -FilePath 'vlc-3.0.18-win32.exe' -ArgumentList '/S' -Verb runAs"
echo "Installing VLC (32-bit) done"
goto startt

:scrcpy64
echo "Downloading scrcpy (64-bit)"
powershell -Command "curl https://github.com/Genymobile/scrcpy/releases/download/v2.1.1/scrcpy-win64-v2.1.1.zip -o scrcpy-win64-v2.1.1.zip"
echo "Downloading scrcpy (64-bit) done"
echo "Extracting scrcpy (64-bit)"
powershell -Command "Expand-Archive -Path 'scrcpy-win64-v2.1.1.zip' -DestinationPath 'C:\scrcpy-win64-v2.1.1'"
echo "Extracting scrcpy (64-bit) done"
goto startt

:scrcpy32
echo "Downloading scrcpy (32-bit)"
powershell -Command "curl https://github.com/Genymobile/scrcpy/releases/download/v2.1.1/scrcpy-win32-v2.1.1.zip -o scrcpy-win32-v2.1.1.zip"
echo "Downloading scrcpy (32-bit) done"
echo "Extracting scrcpy (32-bit)"
powershell -Command "Expand-Archive -Path 'scrcpy-win32-v2.1.1.zip' -DestinationPath 'C:\scrcpy-win32-v2.1.1'"
echo "Extracting scrcpy (32-bit) done"
goto startt

:sndcpy
echo "Downloading sndcpy"
powershell -Command "curl https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-with-adb-windows-v1.1.zip -o sndcpy-with-adb-windows-v1.1.zip"
echo "Downloading sndcpy done"
echo "Extracting sndcpy"
powershell -Command "Expand-Archive -Path 'sndcpy-with-adb-windows-v1.1.zip' -DestinationPath 'C:\sndcpy-with-adb-windows-v1.1'"
echo "Extracting sndcpy done"
goto startt

:USBsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
adb.exe kill-server
adb.exe start-server
sndcpy.bat
echo

:LANsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
echo Enter your IP address:
set /p ip=
if not '%ip%'=='' set ip=%ip%
adb.exe kill-server
adb.exe start-server
adb.exe tcpip 5555
adb.exe connect %ip%:5555
sndcpy.bat
echo

:ex
echo "Exiting"
exit
