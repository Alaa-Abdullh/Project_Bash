#!/usr/bin/bash

# Drop DataBase menu
zenity --info --title="Drop Database" --text="========= Drop DataBase =========" --width=300 --height=100

cd ../Data_Backup

# Create list of databases
array=($(ls -F | grep / | tr / " "))

# Prepare list for zenity
list=""
for db in "${array[@]}"; do
    list="$list $db"
done

# Select Database
zenity --info --title="Select Database" --text="Select Database To drop" --width=300 --height=100

# Database selection
choice=$(zenity --list --title="Select a Database" --text="Please select a database to delete:" --column="Database" $list --width=400 --height=300)

# Check if user canceled or made no selection
if [ $? -ne 0 ] || [ -z "$choice" ]; then
    zenity --info --title="Cancelled" --text="No database selected. Operation cancelled." --width=300 --height=100
    cd - &> /dev/null
    exit 0
fi

# Confirmation
zenity --question --title="Confirm Deletion" --text="Are you sure you want to delete the database '$choice'?" --width=400 --height=150
if [ $? -eq 0 ]; then
    # Drop database
    rm -r "$choice"
    zenity --info --title="Success" --text="Database '$choice' deleted successfully." --width=300 --height=100
else
    zenity --info --title="Cancelled" --text="Deletion of database '$choice' cancelled." --width=300 --height=100
fi

cd - &> /dev/null