#!  /usr/bin/bash 

echo "
========= 
list  Table 
=========
"

if [ -z "$(ls -A)" ]; then
    echo "No Table create Here !?"
    
    read -p "Need to create Now? ? (y/n): " create_choice
    if [[ "$create_choice" == "y" || "$create_choice" == "Y" ]]; then
        read -p "write New table " table_name
        read -p "write coloumn ex:(id:int name:string): " columns
        echo "$columns" > "$table_name"
        echo "create Table Sccessed ! $table_name"
    else
        echo "process Ended"
    fi
else
    echo "Yes Table created"
    ls 
fi