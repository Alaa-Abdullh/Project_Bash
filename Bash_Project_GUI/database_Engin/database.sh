#!/usr/bin/bash

# Loop for the menu
while true; do
    choice=$(zenity --list --title="Database Management" --text="Choose an option:" --column="Option" --column="Description" \
        1 "Create Database" \
        2 "List Databases" \
        3 "Connect To Database" \
        4 "Drop Database" \
        --width=400 --height=300)

    # Check if user canceled
    if [ $? -ne 0 ]; then
        zenity --info --title="Cancelled" --text="Operation cancelled." --width=300 --height=100
        break
    fi

    case $choice in
        1 ) 
            zenity --info --title="Operation" --text="You selected: Create Database" --width=300 --height=100
            source ./create_DB.sh
            ;;
        2 )
            zenity --info --title="Operation" --text="You selected: List Databases" --width=300 --height=100
            chmod +x list_db.sh
            ./list_db.sh
            ;;
        3 )
            zenity --info --title="Operation" --text="You selected: Connect To Database" --width=300 --height=100
            chmod +x connect_db.sh
            ./connect_db.sh
            ;;
        4 )
            zenity --info --title="Operation" --text="You selected: Drop Database" --width=300 --height=100
            chmod +x drop_db.sh
            ./drop_db.sh
            ;;
        * )
            zenity --error --title="Error" --text="Invalid option. Please select a valid option." --width=300 --height=100
            ;;
    esac
done