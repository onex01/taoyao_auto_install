#!/bin/bash

# It is recommended to use bash instead of sh.
# Because the last command of installation will give an error.
# You will need to enter "adb sideload rom.zip" manually.

echo "-------------------------------------------"
echo "By Devine Machinery (.sh by OneX01)"
echo "-------------------------------------------"

# This script is not used when using sh, as well as on line 43.
while true; do
    echo "This script will delete all data, type 'yes' to continue, or 'no' to cancel."
    read confirm
    if [[ $confirm == "yes" ]]; then
        echo "Confirmed"
        break
    elif [[ $confirm == "no" ]]; then
        echo "Rejected"
        exit 1
    else
        echo "Invalid input, please write 'yes' or 'no'."
    fi
done

# fastboot line 28-39
fastboot $* -w
if [ $? -ne 0 ] ; then echo "Clean data error"; exit 1; fi
fastboot $* set_active a
if [ $? -ne 0 ] ; then echo "Error active slot A"; exit 1; fi
fastboot $* flash boot `dirname $0`/recovery/boot.img
if [ $? -ne 0 ] ; then echo "Flash boot error"; exit 1; fi
fastboot $* flash dtbo `dirname $0`/recovery/dtbo.img
if [ $? -ne 0 ] ; then echo "Flash dtbo error"; exit 1; fi
fastboot $* flash vendor_boot `dirname $0`/recovery/vendor_boot.img
if [ $* -ne 0 ] ; then echo "Flash venodr_boot error"; exit 1; fi
fastboot $* reboot recovery
if [ $* -ne 0 ] ; then echo "Reboot recovery error"; exit 1; fi

# pause to enable sideload
echo "Press ENTER to start seideload the ROM..."
read -n 1 -s -r # Use bash.

# adb line 46-47
adb $* sideload `dirname $0`/rom/*.zip
if [ $? -ne - ] ; then echo "Send rom error"; exit 1; fi
echo "Rom installed successfully :D !"
