echo Starting for Screen Mirroring
cd "C:\scrcpy-win64-v1.23"
adb.exe kill-server
adb.exe start-server
scrcpy.exe -b 40M --max-fps 30