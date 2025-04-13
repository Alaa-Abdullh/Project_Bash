#!/usr/bin/bash

zenity --info --title="Existing Databases" --text="========= Already Existing DataBase =========" --width=300 --height=100

cd ../Data_Backup

# List databases
db_list=($(ls -F | grep / | tr -d '/'))

if [ ${#db_list[@]} -eq 0 ]; then
    zenity --error --title="No Databases" --text="No databases available!" --width=300 --height=100
    cd - &> /dev/null
    exit 1
fi

# Prepare list for zenity
list=""
for db in "${db_list[@]}"; do
    list="$list $db"
done

# Database selection
choice=$(zenity --list --title="Select a Database" --text="Database Available\n------------------------\nPlease select a database to view:" --column="Database" $list --width=400 --height=300)

# Check if user canceled or made no selection
if [ $? -ne 0 ] || [ -z "$choice" ]; then
    zenity --info --title="Cancelled" --text="No database selected. Operation cancelled." --width=300 --height=100
else
    zenity --info --title="Selected Database" --text="You selected: $choice" --width=300 --height=100
fi

cd - &> /dev/null