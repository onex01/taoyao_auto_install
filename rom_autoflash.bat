@echo off
setlocal EnableDelayedExpansion

:: Define variables
set ROM_DIR=%~dp0rom
set IMG_FOLDERS[0]=ammarbahtiarasli_img
set IMG_FOLDERS[1]=dkpost3_img

:: Find all .zip files in the 'rom' directory
set ZIP_FILES=
for /R %ROM_DIR% %%f in (*.zip) do (
    set ZIP_FILES=!ZIP_FILES! "%%~nxF"
)

:: Function to display menu and get user choice
:menu_select
cls
echo Select an option:
set /A i = 0
for %%F in (%*) do (
    echo [%i%] %%F
    set options[!i!]=%%F
    set /A i += 1
)
set /P choice=Enter your choice: 
if defined options[%choice%] (
    set CHOSEN_OPTION=!options[%choice%]!
    goto :continue
) else (
    echo Invalid option. Try again.
    pause >nul
    goto :menu_select
)

:: Step 1: Ask for confirmation before proceeding
cls
echo -------------------------------------------
echo                  OneX01
echo -------------------------------------------
echo This script will delete all data.
set /P confirm=Type 'yes' to continue, or 'no' to cancel: 
if /i "%confirm%"=="yes" (
    echo Confirmed
) else if /i "%confirm%"=="no" (
    echo Rejected
    exit /B 1
) else (
    echo Invalid input. Type 'yes' or 'no'.
    goto step1
)

:: Step 2: Choose the folder containing the images
call :menu_select %IMG_FOLDERS[0]% %IMG_FOLDERS[1]%
set CHOSEN_IMG_FOLDER=%CHOSEN_OPTION%

:: Step 3: Choose the ZIP file
call :menu_select %ZIP_FILES%
set CHOSEN_ZIP_FILE=%CHOSEN_OPTION%

:: Step 4: Perform the actual commands based on user's choices
set ADB_PATH=%~dp0adb
cd /d "%ADB_PATH%"

%ADB_PATH%/fastboot.exe -w || @echo "Clean data error" && exit 1
echo Cleaning completed successfully
%ADB_PATH%/fastboot.exe set_active a || @echo "Error active slot A" && exit 1
echo Slot A was successfully selected
%ADB_PATH%/fastboot.exe flash boot %CHOSEN_IMG_FOLDER%\recovery\boot.img || @echo "Flash boot error" && exit 1
echo [boot.img](boot.img) successfully flashed
%ADB_PATH%/fastboot.exe flash dtbo %CHOSEN_IMG_FOLDER%\recovery\dtbo.img || @echo "Flash dtbo error" && exit 1
echo [dtbo.img](dtbo.img) successfully flashed
%ADB_PATH%/fastboot.exe flash vendor_boot %CHOSEN_IMG_FOLDER%\recovery\vendor_boot.img || @echo "Flash vendor_boot error" && exit 1
echo [vendor_boot.img](vendor_boot.img) successfully flashed
%ADB_PATH%/fastboot.exe reboot recovery || @echo "Reboot recovery error" && exit 1
echo Successfully rebooted into recovery
echo Press ENTER to start sideloading the ROM... 
pause

%ADB_PATH%/adb.exe sideload %ROM_DIR%\%CHOSEN_ZIP_FILE% || (
    echo Send rom error
    exit /b 1
)
echo Rom installed successfully :D !

:end
exit /B 0
