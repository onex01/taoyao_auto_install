#!/bin/bash

# It is recommended to use bash instead of sh.
# Because the last command of installation will give an error.

echo "-------------------------------------------"
echo "                 By OneX01"
echo "-------------------------------------------"

fastboot $* boot `dirname $0`/ofox/*.img
if [ $? -ne 0 ] ; then echo "Error boot to OrangeFox"; exit 1; fi

echo "Wait for OrangeFox to load, then press enter, the process of copying ofox.zip to the /sdcard/ path will begin. from it you flash the archive"
read

adb $* push `dirname $0`/ofox/ofox.zip /sdcard/
