#!/bin/bash

# This script allows you to choose between prepared folders with images and zip files.

# Define available image folders
IMG_FOLDERS=("ammarbahtiarasli_img" "dkpost3_img")

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

# Step 1: Ask for confirmation before proceeding
echo "-------------------------------------------"
echo "                  OneX01"
echo "-------------------------------------------"

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

# Step 2: Choose the folder containing the images
echo "Select the folder containing the images:"
select_option "${IMG_FOLDERS[@]}"
CHOSEN_IMG_FOLDER=$opt

# Step 3: Choose the ZIP file
echo "Available .zip files in '$ROM_DIR':"
select_option "${ZIP_FILES[@]}"
CHOSEN_ZIP_FILE=$opt

# Step 4: Perform the actual commands based on user's choices
fastboot $* -w
if [ $? -ne 0 ] ; then echo "Clean data error"; exit 1; fi
fastboot $* set_active a
if [ $? -ne 0 ] ; then echo "Error active slot A"; exit 1; fi
fastboot $* flash boot "$CHOSEN_IMG_FOLDER"/boot.img
if [ $? -ne 0 ] ; then echo "Flash boot error"; exit 1; fi
fastboot $* flash dtbo "$CHOSEN_IMG_FOLDER"/dtbo.img
if [ $? -ne 0 ] ; then echo "Flash dtbo error"; exit 1; fi
fastboot $* flash vendor_boot "$CHOSEN_IMG_FOLDER"/vendor_boot.img
if [ $? -ne 0 ] ; then echo "Flash vendor_boot error"; exit 1; fi
fastboot $* reboot recovery
if [ $? -ne 0 ] ; then echo "Reboot recovery error"; exit 1; fi

# Pause to enable sideload
echo "Press ENTER to start sideloading the ROM..."
read -n 1 -s -r

# Sideload the chosen ZIP file
adb $* sideload "$ROM_DIR/$CHOSEN_ZIP_FILE"
if [ $? -ne 0 ] ; then echo "Send rom error"; exit 1; fi
echo "ROM installed successfully :D!"
