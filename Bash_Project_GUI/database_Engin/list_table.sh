#!/usr/bin/bash

zenity --info --title="List Tables" --text="========= List Tables =========" --width=300 --height=100

if [ -z "$(ls -A)" ]; then
    zenity --error --title="No Tables" --text="No Tables created here!" --width=300 --height=100

    create_choice=$(zenity --list --title="Create a New Table" --text="Do you want to create a new table?" --column="Option" --column="Description" \
        1 "Yes" \
        2 "No" \
        --width=400 --height=200)

    case $create_choice in
        1)
            # Redirect to another script for table creation
            if [ -f "../../database_Engin/create_table.sh" ]; then
               source ../../database_Engin/create_table.sh
            else
                zenity --error --title="Error" --text="Create table script not found!" --width=300 --height=100
                exit 1
            fi
            ;;
        2)
            zenity --info --title="Ended" --text="Process Ended." --width=300 --height=100
            ;;
        *)
            zenity --info --title="Ended" --text="Invalid choice. Process Ended." --width=300 --height=100
            ;;
    esac
else
zenity --info --title="Tables Exist" --text="Tables already created!" --width=300 --height=100
   
    tables=`ls`
    list=()
    for table in $tables; do
        list+=("$table")
    done

    table_choice=$(zenity --list --title="Select a Table" --text="Select a table:" --column="Table" "${list[@]}" --width=400 --height=300)


    if [ -n "$table_choice" ]; then
        zenity --info --title="Selected Table" --text="You selected table: $table_choice" --width=300 --height=100
    else
        zenity --info --title="No Selection" --text="No table selected." --width=300 --height=100
    fi
fi

