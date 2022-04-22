@echo off

Title Screen Mirroring by Xnuvers007

PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas

echo 1. scrcpy (USB)
echo 2. scrcpy (LAN)
echo Masukan Pilihanmu :

set /p answer=
if not '%answer%'=='' set answer=%answer%
if '%answer%'=='1' goto scrcpyUSB
if '%answer%'=='2' goto scrcpyLAN

:scrcpyUSB
echo Memulai untuk Screen Mirroring
cd "C:\scrcpy-win64-v1.23"
adb.exe kill-server
adb.exe start-server
scrcpy.exe -b 40M --max-fps 30

:scrcpyLAN
echo Memulai Untuk Screen Mirroring
cd "C:\scrcpy-win64-v1.23"
echo Masukan Alamat ip kamu :
set /p ip=
if not '%ip%'=='' set ip=%ip%
adb.exe kill-server
adb.exe start-server
adb.exe tcpip 5555
adb.exe connect %ip%:5555
scrcpy.exe -b 40M --max-fps 30 --tcpip=%ip%:5555
