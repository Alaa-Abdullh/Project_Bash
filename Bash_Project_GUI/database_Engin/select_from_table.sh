#!/usr/bin/bash

zenity --info --title="Select from Table" --text="========= Select from Table =========" --width=300 --height=100

array=($(ls))

# Prepare list for zenity
list=""
for table in "${array[@]}"; do
    list="$list $table"
done

# Table selection
table_choice=$(zenity --list --title="Select a Table" --text="Select a table:" --column="Table" $list --width=400 --height=300)

# Check if table exists or user canceled
if [ $? -ne 0 ] || [ -z "$table_choice" ]; then
    zenity --info --title="Cancelled" --text="No table selected. Exiting." --width=300 --height=100
    exit 1
fi

# Table name
table_name=$table_choice

# Metadata
col_names=$(head -1 "$table_name")
primary_key=$(head -3 "$table_name" | grep ^PK | cut -d':' -f2)
IFS=':' read -ra columns <<< "$col_names"

# Action selection
action=$(zenity --list --title="Select Action" --text="Select Action:" --column="Option" --column="Description" \
    1 "Select all" \
    2 "Select column" \
    3 "Select row (by PK)" \
    --width=400 --height=250)

case $action in
    1)
        zenity --info --title="Full Table" --text="Showing full table:" --width=300 --height=100
        column -t -s: "$table_name" | zenity --text-info --title="Table Contents" --width=600 --height=400
        ;;
    
    2)
        # Prepare column list for zenity
        col_list=""
        for col in "${columns[@]}"; do
            col_list="$col_list $col"
        done

        col_choice=$(zenity --list --title="Select a Column" --text="Select a column:" --column="Column" $col_list --width=400 --height=300)

        # Check if column was selected
        if [ $? -ne 0 ] || [ -z "$col_choice" ]; then
            zenity --info --title="Cancelled" --text="No column selected. Exiting." --width=300 --height=100
            exit 1
        fi

        # Index column
        col_index=$(printf "%s\n" "${columns[@]}" | grep -n "^$col_choice$" | cut -d: -f1)

        # Show values of column
        zenity --info --title="Column Values" --text="Values for column '$col_choice':" --width=300 --height=100
        awk -F: -v i="$col_index" 'NR>3 {print $i}' "$table_name" | zenity --text-info --title="Column '$col_choice' Values" --width=400 --height=300
        ;;
    
    3)
        # Choose Primary Key
        while true; do
            pk_value=$(zenity --entry --title="Primary Key Input" --text="Enter value of primary key ($primary_key):" --width=400 --height=200)

            if [ $? -ne 0 ]; then
                zenity --info --title="Cancelled" --text="Operation cancelled." --width=300 --height=100
                exit 0
            fi

            # Search Primary Key
            pk_index=$(printf "%s\n" "${columns[@]}" | grep -n "^$primary_key$" | cut -d: -f1)
            row=$(awk -F: -v i="$pk_index" -v val="$pk_value" 'NR>3 && $i==val {print}' "$table_name")

            if [ -z "$row" ]; then
                zenity --error --title="Not Found" --text="No row found with PK = $pk_value" --width=300 --height=100
            else
                zenity --info --title="Matched Row" --text="Matched Row:" --width=300 --height=100
                echo "$col_names" > temp_row.txt
                echo "$row" >> temp_row.txt
                column -t -s: temp_row.txt | zenity --text-info --title="Row Data" --width=600 --height=300
                rm temp_row.txt
                break
            fi
        done
        ;;
    
    *)
        zenity --info --title="Invalid Option" --text="Invalid option selected." --width=300 --height=100
        ;;
esac