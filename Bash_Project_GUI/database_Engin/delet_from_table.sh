#!/usr/bin/bash

zenity --info --title="Table Selection" --text="===== Select your Table from the menu =====" --width=300 --height=100

# Safer way to read file names into an array
mapfile -t array < <(ls)

# Table selection
table_name=$(zenity --list --title="Select a Table" --text="Please select a table:" --column="Table" "${array[@]}" --width=400 --height=300)

# Check if user canceled
if [ $? -ne 0 ] || [ -z "$table_name" ]; then
    zenity --info --title="Cancelled" --text="No table selected. Operation cancelled." --width=300 --height=100
    exit 0
fi

zenity --info --title="Selected Table" --text="You selected '$table_name' table." --width=300 --height=100

# Delete table menu
delete_choice=$(zenity --list --title="Delete Table Menu" --text="========= Delete Table Menu =========" --column="Option" --column="Description" \
    1 "Delete all tables" \
    2 "Delete a specific table" \
    --width=400 --height=250)

# If table exists
if [[ -f "$table_name" ]]; then
    case $delete_choice in
        1)
            zenity --question --title="Confirm Deletion" --text="Are you sure you want to delete ALL tables?" --width=400 --height=150
            if [ $? -eq 0 ]; then
                rm -f *
                zenity --info --title="Success" --text="All tables have been deleted." --width=300 --height=100
            else
                zenity --info --title="Cancelled" --text="Deletion cancelled." --width=300 --height=100
            fi
            ;;
        
        2)
            selected_pk=$(zenity --entry --title="Primary Key Input" --text="Enter the primary key (PK) to delete:" --width=400 --height=200)

            if [ $? -ne 0 ]; then
                zenity --info --title="Cancelled" --text="Deletion cancelled." --width=300 --height=100
                exit 0
            fi

            if grep -Fxq "$selected_pk" "$table_name"; then
                zenity --question --title="Confirm Deletion" --text="Are you sure you want to delete the row with PK '$selected_pk' from table '$table_name'?" --width=400 --height=150
                if [ $? -eq 0 ]; then
                    sed -i "/^$selected_pk,/d" "$table_name"
                    zenity --info --title="Success" --text="Table row with PK '$selected_pk' has been deleted." --width=300 --height=100
                else
                    zenity --info --title="Cancelled" --text="Deletion cancelled." --width=300 --height=100
                fi
            else
                zenity --error --title="Error" --text="PK '$selected_pk' does not exist in the table." --width=300 --height=100
            fi
            ;;
        
        *)
            zenity --error --title="Error" --text="Invalid choice. Please select 1 or 2." --width=300 --height=100
            ;;
    esac
else
    zenity --error --title="Error" --text="Table '$table_name' does not exist." --width=300 --height=100
fi
