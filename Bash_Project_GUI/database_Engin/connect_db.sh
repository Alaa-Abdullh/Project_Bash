#!/usr/bin/bash

zenity --info --title="Welcome" --text="========= Connect to DataBase =========" --width=300 --height=100

cd ../Data_Backup

array=($(ls -F | grep / | tr / " "))

# Prepare list for zenity
list=""
for db in "${array[@]}"; do
    list="$list $db"
done

# Database selection
db_choice=$(zenity --list --title="Select Database" --text="Choose a database to connect" --column="Database" $list --width=400 --height=300)

# Check if a database was selected
if [ $? -eq 0 ] && [ -n "$db_choice" ]; then
    # Confirmation
    zenity --question --title="Confirmation" --text="Are you sure you want to connect to DB: $db_choice?" --width=300 --height=100
    response=$?
    if [ $response -eq 0 ]; then
        cd "../Data_Backup/$db_choice"
        zenity --info --title="Success" --text="Connected to database $db_choice successfully." --width=300 --height=100
    else
        zenity --info --title="Cancelled" --text="Connection to $db_choice cancelled." --width=300 --height=100
        exit 0
    fi
else
    zenity --error --title="Error" --text="No database selected. Exiting." --width=300 --height=100
    exit 1
fi

# Main menu loop
while true; do
    choice=$(zenity --list --title="Main Menu" --text="Select an operation" --column="Operation" --column="Description" \
        "Create Table" "Create a new table" \
        "List Table" "List all tables" \
        "Drop Table" "Drop an existing table" \
        "Insert into Table" "Insert data into a table" \
        "Select from Table" "Select data from a table" \
        "Update Table" "Update data in a table" \
        "Delete from Table" "Delete data from a table" \
        --width=500 --height=400)

    case $choice in
        "Create Table")
            zenity --info --title="Operation" --text="Create Table operation selected." --width=300 --height=100
            source ../../database_Engin/create_table.sh
            ;;
        "List Table")
            zenity --info --title="Operation" --text="List Tables operation selected." --width=300 --height=100
            source ../../database_Engin/list_table.sh
            ;;
        "Insert into Table")
            zenity --info --title="Operation" --text="Insert Data operation selected." --width=300 --height=100
            source ../../database_Engin/insert_in_table.sh
            ;;
        "Select from Table")
            zenity --info --title="Operation" --text="Select Data operation selected." --width=300 --height=100
            source ../../database_Engin/select_from_table.sh
            ;;
        "Update Table")
            zenity --info --title="Operation" --text="Update Table operation selected." --width=300 --height=100
            source ../../database_Engin/update_table.sh
            ;;
        "Drop Table")
            zenity --info --title="Operation" --text="Drop Table operation selected." --width=300 --height=100
            source ../../database_Engin/drop_table.sh
            ;;    
        "Delete from Table")
            zenity --info --title="Operation" --text="Delete Data operation selected." --width=300 --height=100
            source ../../database_Engin/delet_from_table.sh
            ;;
        *)
            break
            ;;
    esac
done

cd - &> /dev/null
