#!/usr/bin/bash

echo "
========= Insert into Table =========
"

array=(`ls`)
select choice in  ${array[*]}; do
	if [ $REPLY -gt ${#array[*]} ]; then
		echo "$REPLY is not on the menu"
		continue
	else
		table_name=${array[${REPLY}-1]} 
		break 
	fi
done

# اقرأ الميتا داتا
col_names=$(head -1 "$table_name")
col_types=$(head -2 "$table_name" | tail -1)
primary_key=$(head -3 "$table_name" | grep ^PK | cut -d':' -f2)

IFS=':' read -ra columns <<< "$col_names"
IFS=':' read -ra types <<< "$col_types"

row=""

for ((i=0; i<${#columns[@]}; i++)); do
	col=${columns[$i]}
	type=${types[$i]}

	while true; do
		read -p "Enter value for [$col] (type: $type): " value

		# Validate PK uniqueness
		if [[ "$col" == "$primary_key" ]]; then
			if cut -d: -f$((i+1)) "$table_name" | tail -n +4 | grep -xq "$value"; then
				echo "❌ Value already exists for Primary Key '$primary_key'. Try another."
				continue
			fi
		fi

		# Validate type
		if [[ "$type" == "integer" && ! "$value" =~ ^[0-9]+$ ]]; then
			echo "❌ Expected integer, got something else. Try again."
			continue
		fi

		# passed all validation
		row+="$value:"
		break
	done
done

# احذف الـ : الأخير
row=${row%:}
echo "$row" >> "$table_name"
echo "✅ Data inserted successfully into '$table_name'"
