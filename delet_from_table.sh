#!/usr/bin/bash


echo "
-----> Select your Table number from the menu <--------
"
array=(`ls`)


# echo ${#array[*]}

select choice in  ${array[*]}
do
	if [ $REPLY -gt ${#array[*]} ]
	then
		echo "
		$REPLY is not on the menu
		"
		continue
	else
		echo "
		... You selected ${array[${REPLY}-1]} Table...
		"
			table_name=${array[${REPLY}-1]} 
		break 
	fi
done	

echo "
========= Delete Table Menu =========
1) Delete all tables
2) Delete a specific table
====================================="
read -p "Enter your choice (1 or 2): " delete_choice

# check if table is exist
if [[ -f $table_name ]] ;
then
select delete_choice
do
case $delete_choice in
   1 )
        read -p "Are you sure you want to delete ALL tables? (y/n): " confirm_all
        case $confirm_all in
            [Yy]* )
                # Delete all files (tables) in current directory
                sed -i '/^[[:digit:]]/d' $table_name
                echo "All tables have been deleted."
                ;;
            [Nn]* )
                echo "Deletion cancelled."
                ;;
            * )
                echo "Invalid input. Please type y or n."
                ;;
        esac
        ;;
    
    2)
        echo "Available tables:"
        ls
        echo
        read -p "Enter the input your id(PK) want to delete: "  pk 
        row=`awk -F':' ' {  if($1=='$pk')  print $0}' $table_name`

        if grep -Fxq "$row" "$table_name" > /dev/null;
         then
            read -p "Are you sure you want to delete table '$table_name'? (y/n): " confirm_one
            case $confirm_one in
                [Yy]* )
                    sed -i '/'$row'/d' $table_name
                    echo "Table '$table_name' has been deleted."
                    ;;
                [Nn]* )
                    echo "Table deletion cancelled."
                    ;;
                * )
                    echo "id(PK) '$pk' Invalid input. Please type y or n."
                    ;;
            esac
        else
            echo "Table '$table_name' does not exist."
        fi
        ;;
    
    *)
        echo "$table_name Invalid choice. Please select 1 or 2."
        ;;
esac
done 
fi