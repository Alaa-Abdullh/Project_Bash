#!/usr/bin/bash

update_table() {
    table_name=$1

    cols=$(head -1 "$table_name")
    types=$(head -2 "$table_name")
    pk_col=$(head -3 "$table_name" | grep ^PK | cut -d':' -f2)

    IFS=':' read -ra col_arr <<< "$cols"
    IFS=':' read -ra type_arr <<< "$types"

    pk_index=$(printf "%s\n" "${col_arr[@]}" | grep -n "^$pk_col$" | cut -d: -f1)

    # Primary Key
    while true; do
        pk_val=$(zenity --entry --title="Primary Key Input" --text="Enter value of Primary Key ($pk_col):" --width=400 --height=200)

        if [ $? -ne 0 ]; then
            zenity --info --title="Cancelled" --text="Operation cancelled." --width=300 --height=100
            exit 0
        fi

        old_row=$(awk -F: -v i="$pk_index" -v val="$pk_val" 'NR>3 && $i==val {print}' "$table_name")
        
        if [[ -n "$old_row" ]]; then
            break
        fi
        zenity --error --title="Error" --text="PK not found. Please try again!" --width=300 --height=100
    done

    # New value
    new_row=""
    for i in "${!col_arr[@]}"; do
        col=${col_arr[$i]}
        type=${type_arr[$i]}

        if [[ "$col" == "$pk_col" ]]; then
            new_row+="$pk_val:"
        else
            while true; do
                val=$(zenity --entry --title="Input for $col" --text="Enter new value for [$col] (type: $type):" --width=400 --height=200)

                if [ $? -ne 0 ]; then
                    zenity --info --title="Cancelled" --text="Operation cancelled." --width=300 --height=100
                    exit 0
                fi
                
                # Data validation
                if [[ "$type" == "integer" && ! "$val" =~ ^[0-9]+$ ]]; then
                    zenity --error --title="Error" --text="Must be an integer. Please try again." --width=300 --height=100
                    continue
                fi
                new_row+="$val:"
                break
            done
        fi
    done

    new_row=${new_row%:}  

    # Update
    sed -i "s/^$old_row\$/$new_row/" "$table_name"
    zenity --info --title="Success" --text="Update successful!" --width=300 --height=100
}

# Start
zenity --info --title="Update Table" --text="========= Update Table =========" --width=300 --height=100

# Table selection
tables=($(ls))

# Prepare list for zenity
list=""
for table in "${tables[@]}"; do
    list="$list $table"
done

table_choice=$(zenity --list --title="Select a Table" --text="Select a table to update:" --column="Table" $list --width=400 --height=300)

# Check if table was selected
if [ $? -ne 0 ] || [ -z "$table_choice" ]; then
    zenity --info --title="Cancelled" --text="No table selected. Exiting." --width=300 --height=100
    exit 1
fi

update_table "$table_choice"