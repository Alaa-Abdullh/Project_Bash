#!/usr/bin/bash

zenity --info --title="Drop Table" --text="========= Drop Table =========" --width=300 --height=100

# List tables
array=($(ls))

# Prepare list for zenity
list=""
for table in "${array[@]}"; do
    list="$list $table"
done

# Table selection
choice=$(zenity --list --title="Select a Table" --text="Please select a table to delete:" --column="Table" $list --width=400 --height=300)

# Check if user canceled or made no selection
if [ $? -ne 0 ] || [ -z "$choice" ]; then
    zenity --info --title="Cancelled" --text="No table selected. Operation cancelled." --width=300 --height=100
    exit 0
fi

# Confirmation
zenity --question --title="Confirm Deletion" --text="Are you sure you want to delete the table '$choice'?" --width=400 --height=150
if [ $? -eq 0 ]; then
    # Drop table
    rm "$choice"
    zenity --info --title="Success" --text="Table '$choice' deleted successfully." --width=300 --height=100
else
    zenity --info --title="Cancelled" --text="Deletion of table '$choice' cancelled." --width=300 --height=100
fi