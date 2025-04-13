#!/usr/bin/bash

zenity --info --title="Insert into Table" --text="========= Insert into Table =========" --width=300 --height=100

# List of tables
array=($(ls))

# Prepare list for zenity
list=""
for table in "${array[@]}"; do
    list="$list $table"
done

# Table selection
table_name=$(zenity --list --title="Select a Table" --text="Please select a table to insert data into:" --column="Table" $list --width=400 --height=300)

# Check if user canceled or made no selection
if [ $? -ne 0 ] || [ -z "$table_name" ]; then
    zenity --info --title="Cancelled" --text="No table selected. Operation cancelled." --width=300 --height=100
    exit 0
fi

# Metadata
col_names=$(head -1 "$table_name")
col_types=$(head -2 "$table_name" | tail -1)
primary_key=$(head -3 "$table_name" | grep ^PK | cut -d':' -f2)

IFS=':' read -ra columns <<< "$col_names"
IFS=':' read -ra types <<< "$col_types"

row=""

# Insert data
for ((i=0; i<${#columns[@]}; i++)); do
    col=${columns[$i]}
    type=${types[$i]}

    while true; do
        # Zenity input
        value=$(zenity --entry --title="Input for $col" --text="Enter value for [$col] (type: $type):" --width=400 --height=200)

        # Check if user canceled
        if [ $? -ne 0 ]; then
            zenity --info --title="Cancelled" --text="Input cancelled." --width=300 --height=100
            exit 0
        fi

        # PK found?
        if [[ "$col" == "$primary_key" ]]; then
            if cut -d: -f$((i+1)) "$table_name" | tail -n +4 | grep -xq "$value"; then
                zenity --error --title="Error" --text="Value already exists for Primary Key '$primary_key'. Try another." --width=300 --height=100
                continue
            fi
        fi

        # Type validation
        if [[ "$type" == "integer" && ! "$value" =~ ^[0-9]+$ ]]; then
            zenity --error --title="Error" --text="Expected integer, got something else. Try again." --width=300 --height=100
            continue
        fi

        row+="$value:"
        break
    done
done

# Remove final colon
row=${row%:}

# Save data
echo "$row" >> "$table_name"
zenity --info --title="Success" --text="Data inserted successfully into '$table_name'" --width=300 --height=100