#!/bin/bash

# Find all .zip files in the 'rom' directory
ROM_DIR="$(dirname $0)/rom"
ZIP_FILES=()
for file in $(find "$ROM_DIR" -maxdepth 1 -name '*.zip'); do
    ZIP_FILES+=("${file##*/}")
done

# Function to display menu and get user choice
select_option() {
    PS3="Please select an option: "
    options=("$@")
    select opt in "${options[@]}"; do
        if [ "$opt" ]; then
            echo "You selected: $opt"
            return
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

echo "-------------------------------------------"
echo "			OneX01"
echo "-------------------------------------------"

# Choose the ZIP file
echo "Available .zip files in '$ROM_DIR':"
select_option "${ZIP_FILES[@]}"
CHOSEN_ZIP_FILE=$opt

# Pause to enable sideload
echo "Press ENTER to start seideload the ROM..."
read -n 1 -s -r # Use bash.

# adb line 46-47
adb $* sideload "$ROM_DIR/$CHOSEN_ZIP_FILE"
if [ $? -ne 0 ] ; then echo "Send rom error"; exit 1; fi
echo "ROM installed successfully :D!"
