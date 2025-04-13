#!/usr/bin/bash


update_table() {
    table_name=$1

    cols=$(head -1 "$table_name")
    types=$(head -2 "$table_name")
    pk_col=$(head -3 "$table_name" | grep ^PK | cut -d':' -f2)

    IFS=':' read -ra col_arr <<< "$cols"
    IFS=':' read -ra type_arr <<< "$types"

  

    pk_index=$(printf "%s\n" "${col_arr[@]}" | grep -n "^$pk_col$" | cut -d: -f1)

    # Enter PK
    while true; do
        read -p "Enter value of Primary Key ($pk_col): " pk_val
        old_row=$(awk -F: -v i="$pk_index" -v val="$pk_val" 'NR>3 && $i==val {print}' "$table_name")
        [[ -n "$old_row" ]] && break
        echo "PK Not Founded Plese Try again !"
    done

    # new row
    new_row=""
    for i in "${!col_arr[@]}"; do
        col=${col_arr[$i]}
        type=${type_arr[$i]}

        if [[ "$col" == "$pk_col" ]]; then
            new_row+="$pk_val:"
        else
            while true; do
                read -p "Enter new value for [$col] (type: $type): " val
                # Type ?!
                [[ "$type" == "integer" && ! "$val" =~ ^[0-9]+$ ]] && { echo "Must be Integer :(" ; continue; }
                new_row+="$val:"
                break
            done
        fi
    done

    new_row=${new_row%:}  

    # Updated
    sed -i "s/^$old_row\$/$new_row/" "$table_name"
    echo "Update sussessed !"
}


echo "========= Update Table ========="

tables=(`ls`)
select table_name in "${tables[@]}"; do
    [[ -n "$table_name" ]] && break
    echo "$table_name not correct :( please Try again :)"
done

update_table "$table_name"
