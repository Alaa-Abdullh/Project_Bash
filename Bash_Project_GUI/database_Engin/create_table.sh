#!/usr/bin/bash

# change directory to the database backup folder


# Show existing tables using zenity
existing_tables=$(ls -p | grep -v /)
tables_list=$(echo "$existing_tables" | tr '\n' ' ')

zenity --info --title="Existing Tables" --text="Existing tables:\n$tables_list" --width=400 --height=200

# Table creation loop
while true; do
    table_name=$(zenity --entry --title="Table Name Input" --text="Enter your table name to create:" --width=400 --height=200)

    # Check if user canceled
    if [ $? -ne 0 ]; then
        zenity --info --title="Cancelled" --text="Table creation cancelled." --width=300 --height=100
        break
    fi

    case $table_name in
        "")
            zenity --error --title="Error" --text="The name cannot be empty. Please try again." --width=300 --height=100
            continue ;;
        *[[:space:]]* )
            zenity --error --title="Error" --text="Table name cannot contain spaces." --width=300 --height=100
            continue ;;
        [0-9]* )
            zenity --error --title="Error" --text="Table name cannot start with a number." --width=300 --height=100
            continue ;;
        [a-zA-Z_][a-zA-Z0-9_]* )
            if [ -f "$table_name" ]; then
                zenity --error --title="Error" --text="Table '$table_name' already exists." --width=300 --height=100
                continue
            else
                zenity --question --title="Confirm Creation" --text="Are you sure you want to create table '$table_name'?" --width=400 --height=150
                if [ $? -eq 0 ]; then
                    touch "$table_name"
                    zenity --info --title="Success" --text="Table '$table_name' created successfully." --width=300 --height=100
                    break
                else
                    zenity --info --title="Cancelled" --text="Table creation cancelled." --width=300 --height=100
                    continue
                fi
            fi ;;
        * )
            zenity --error --title="Error" --text="Invalid table name." --width=300 --height=100
            continue ;;
    esac
done

# If creation was cancelled, exit
[ -z "$table_name" ] && cd - &> /dev/null && exit 0

# Number of fields input with validation
while true; do
    fields_num=$(zenity --entry --title="Fields Number Input" --text="Insert number of fields for table '$table_name':" --width=400 --height=200)

    if [ $? -ne 0 ]; then
        zenity --info --title="Cancelled" --text="Operation cancelled." --width=300 --height=100
        cd - &> /dev/null
        exit 0
    fi

    if [[ "$fields_num" =~ ^[1-9][0-9]*$ ]]; then
        zenity --info --title="Confirmation" --text="Number of fields: $fields_num" --width=300 --height=100
        break
    else
        zenity --error --title="Error" --text="Please enter a valid number greater than 0." --width=300 --height=100
    fi
done

# Insert column names
row_name=""
row_type=""
primary_key=""

zenity --info --title="Column Names" --text="------ Insert Column Names ------" --width=300 --height=100

for ((i=1; i<=$fields_num; i++)); do
    while true; do
        col_name=$(zenity --entry --title="Column $i Name Input" --text="Column $i name:" --width=400 --height=200)

        if [ $? -ne 0 ]; then
            zenity --info --title="Cancelled" --text="Operation cancelled." --width=300 --height=100
            cd - &> /dev/null
            exit 0
        fi

        case $col_name in
            "")
                zenity --error --title="Error" --text="Column name cannot be empty." --width=300 --height=100
                continue ;;
            *[[:space:]]* )
                zenity --error --title="Error" --text="Column name cannot contain spaces." --width=300 --height=100
                continue ;;
            [0-9]* )
                zenity --error --title="Error" --text="Column name cannot start with a number." --width=300 --height=100
                continue ;;
            [a-zA-Z_][a-zA-Z0-9_]* )
                # Check for duplicate column name
                if [[ ":$row_name" == *":$col_name:"* ]]; then
                    zenity --error --title="Error" --text="Column name '$col_name' already exists." --width=300 --height=100
                    continue
                fi

                # Ask about Primary Key
                if [ -z "$primary_key" ]; then
                    zenity --question --title="Primary Key Option" --text="Do you want to make '$col_name' the Primary Key?" --width=400 --height=150
                    if [ $? -eq 0 ]; then
                        primary_key=$col_name
                    fi
                fi

                row_name+="$col_name:"
                break ;;
            * )
                zenity --error --title="Error" --text="Invalid column name." --width=300 --height=100
                continue ;;
        esac
    done
done

# Remove the last ":"
row_name=${row_name%:}

# Select column types
zenity --info --title="Column Types" --text="------ Insert Column Types ------" --width=300 --height=100

for ((i=1; i<=$fields_num; i++)); do
    col=$(echo $row_name | cut -d: -f$i)
    choice=$(zenity --list --title="Select Type for Column '$col'" --text="Choose the type for column '$col':" --column="Type" "string" "integer" --width=400 --height=250)

    if [ $? -ne 0 ]; then
        zenity --info --title="Cancelled" --text="Operation cancelled." --width=300 --height=100
        cd - &> /dev/null
        exit 0
    fi

    case $choice in
        "string" )
            row_type+="string:" ;;
        "integer" )
            row_type+="integer:" ;;
        * )
            zenity --error --title="Error" --text="Invalid choice. Please try again." --width=300 --height=100
            continue ;;
    esac
done

# Remove the last ":"
row_type=${row_type%:}

# Save the metadata to the table
echo "$row_name" >> "$table_name"
echo "$row_type" >> "$table_name"
echo "PK:$primary_key" >> "$table_name"

# Show success message
zenity --info --title="Success" --text="Table '$table_name' created successfully with meta data:\nColumns: $row_name\nTypes: $row_type\nPrimary Key: $primary_key" --width=500 --height=300

cd - &> /dev/null