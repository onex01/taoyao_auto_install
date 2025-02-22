echo "-------------------------------------------"
echo "			OneX01"
echo "-------------------------------------------"


echo "Press ENTER to start seideload the ROM..."
read -n 1 -s -r # Use bash.

# adb line 46-47
adb $* sideload `dirname $0`/rom/*.zip
if [ $? -ne - ] ; then echo "Send rom error"; exit 1; fi
echo "Rom installed successfully :D !"
