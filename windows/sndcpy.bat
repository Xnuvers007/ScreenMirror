@echo off
//Automatically Run As Administrator

setlocal EnableDelayedExpansion

Title Screen Mirroring by Xnuvers007
 
PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas

:startt
echo "have u installed vlc, scrcpy, and sndcpy ? [1,2,3,4]"
echo 1. Download vlc
echo 2. Download scrcpy
echo 3. Download sndcpy
echo 4. exit
echo 5. Start sndcpy (USB Cable)
echo 6. Start sndcpy (LAN Connection)

echo enter your Choice : 
set /p answer=
if not '%answer%'=='' set answer=%answer%
if '%answer%'=='1' goto vlc
if '%answer%'=='2' goto scrcpy
if '%answer%'=='3' goto sndcpy
if '%answer%'=='4' goto ex
if '%answer%'=='5' goto USBsndcpy
if '%answer%'=='6' goto LANsndcpy

:vlc
echo "Downloading VLC"
powershell -Command "Invoke-WebRequest -Uri 'https://get.videolan.org/vlc/3.0.17.4/win64/vlc-3.0.17.4-win64.exe' -OutFile 'vlc-3.0.17.4-win64.exe'"
echo "Downloading VLC done"
echo "Installing VLC"
powershell -Command "Start-Process -FilePath 'vlc-3.0.17.4-win64.exe' -ArgumentList '/S' -Verb runAs"
echo "Installing VLC done"
goto startt

:scrcpy
echo "Downloading Scrcpy"
powershell -Command "curl https://github.com/Genymobile/scrcpy/releases/download/v1.23/scrcpy-win64-v1.23.zip -o scrcpy-win64-v1.23.zip"
echo "Downloading Scrcpy done"
echo "Extract Scrcpy"
powershell -Command "Expand-Archive -Path 'scrcpy-win64-v1.23.zip' -DestinationPath 'C:\scrcpy-win64-v1.23'"
echo "Extract Scrcpy done"
goto startt

:sndcpy
echo "Downloading Sndcpy"
powershell -Command "curl https://github.com/rom1v/sndcpy/releases/download/v1.1/sndcpy-with-adb-windows-v1.1.zip -o sndcpy-with-adb-windows-v1.1.zip"
echo "Downloading Sndcpy done"
echo "Extract Sndcpy"
powershell -Command "Expand-Archive -Path 'sndcpy-with-adb-windows-v1.1.zip' -DestinationPath 'C:\sndcpy-with-adb-windows-v1.1'"
echo "Extract Sndcpy done"
goto startt

:USBsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
adb.exe kill-server
adb.exe start-server
sndcpy.bat
echo

:LANsndcpy
cd "C:\sndcpy-with-adb-windows-v1.1"
echo Enter your ip :
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
