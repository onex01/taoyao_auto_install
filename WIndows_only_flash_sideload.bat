@echo off
echo -------------------------------------------
echo 			OneX01
echo -------------------------------------------

set ADB_PATH=%~dp0adb/
cd /d "%ADB_PATH%"
set ROM_PATH=%~dp0rom

echo Press ENTER to start sideloading the ROM... 
pause
for %%f in (%~dp0rom\*.zip) do (
    echo Processing file: %%f
    %ADB_PATH%/adb.exe sideload "%%f" || (
        echo Send rom error
        exit /b 1
    )
)
echo Rom installed successfully :D !
