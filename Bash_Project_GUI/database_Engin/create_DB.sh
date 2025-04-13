#!/usr/bin/bash

# change directory
cd ../Data_Backup

while true
do
    # Use zenity to prompt user for database name
    db_Name=$(zenity --entry --title="Database Name Input" --text="Please enter your database name:" --width=400 --height=200)

    # Check if user canceled the input
    if [ $? -ne 0 ]; then
        zenity --info --title="Cancelled" --text="Operation canceled." --width=300 --height=100
        break
    fi

    # ...........validate input............
    case $db_Name in 

        # The Name is Empty 
        "")
          zenity --error --title="Error" --text="The database name cannot be empty. Please try again." --width=300 --height=100
          continue ;;

        # The Name has spaces 
        *[[:space:]]* )
            zenity --error --title="Error" --text="The database name cannot contain spaces." --width=300 --height=100
            continue ;;

        # The Name starts with a number 
        [0-9]* )
            zenity --error --title="Error" --text="The database name cannot start with a number." --width=300 --height=100
            continue ;;

        # Valid Name  
        [a-zA-Z_][a-zA-Z0-9_]* )
           if [ -d "$db_Name" ]; then
                zenity --error --title="Error" --text="Database '$db_Name' already exists." --width=300 --height=100
                continue
           else 
            # Confirm creation
            zenity --question --title="Confirm Creation" --text="Are you sure you want to create the database '$db_Name'?" --width=400 --height=150
            if [ $? -eq 0 ]; then
                mkdir "$db_Name"
                zenity --info --title="Success" --text="Database '$db_Name' created successfully!" --width=300 --height=100
                break
            else
                zenity --info --title="Cancelled" --text="Database creation canceled. Please try again!" --width=300 --height=100
                continue
            fi
           fi
          continue
          ;;

        # Any invalid name
        *) 
        zenity --error --title="Error" --text="The name '$db_Name' is not valid. Please try again." --width=300 --height=100
        continue
          ;;

    esac
done

cd - &> /dev/null