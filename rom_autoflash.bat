@echo off
echo -------------------------------------------
echo By Devine Machinery (edit style OneX01)
echo -------------------------------------------

: again 
echo This script will delete all data, type 'yes' to continue, or 'no' to cancel.
set /p confirm=Enter your choice:
if /i "%confirm%"=="yes" (
    echo Confirmed   
) else if /i "%confirm%"=="no" (
    echo Rejected
    exit /b 1
) else (
    echo Invalid input, please write 'yes' or 'no'.
    goto again
)

set ADB_PATH=%~dp0adb/
cd /d "%ADB_PATH%"
set RECOVERY_PATH=%~dp0recovery

%ADB_PATH%/fastboot.exe -w || @echo "Clean data error" && exit 1
echo Cleaning completed successfully
%ADB_PATH%/fastboot.exe set_active a || @echo "Error active slot A" && exit 1
echo Slot A was successfully selected
%ADB_PATH%/fastboot.exe flash boot %RECOVERY_PATH%/boot.img || @echo "Flash boot error" && exit 1
echo boot.img successfully flashed
%ADB_PATH%/fastboot.exe flash dtbo %RECOVERY_PATH%/dtbo.img || @echo "Flash dtbo error" && exit 1
echo dtbo.img successfully flashed
%ADB_PATH%/fastboot.exe flash vendor_boot %RECOVERY_PATH%/vendor_boot.img || @echo "Flash venodr_boot error" && exit 1
echo vendor_boot.img successfully flashed
%ADB_PATH%/fastboot.exe reboot recovery || @echo "Reboot recovery error" && exit 1
echo Successfully rebooted into recovery
echo Press ENTER to start sideloading the ROM... 
pause
for %%f in (%~dp0recovery\*.zip) do (
    echo Processing file: %%f
    %ADB_PATH%/adb.exe sideload "%%f" || (
        echo Send rom error
        exit /b 1
    )
)
echo Rom installed successfully :D !
