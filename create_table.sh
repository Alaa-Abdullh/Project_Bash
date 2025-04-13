#! /usr/bin/bash

echo "
========= Create Table =========
"

# عرض الجداول الحالية
echo "
...... Existing Tables ......
"
ls -p | grep -v /

# إدخال اسم الجدول والتحقق منه
while true; do
    read -p "Enter your table name to create: " table_name

    case $table_name in
        "")
            echo "The name cannot be empty. Please try again."
            continue ;;
        *[[:space:]]* )
            echo "Table name cannot contain spaces."
            continue ;;
        [0-9]* )
            echo "Table name cannot start with a number."
            continue ;;
        [a-zA-Z_][a-zA-Z0-9_]* )
            if [ -f "$table_name" ]; then
                echo "Table already exists."
                continue
            else
                read -p "Are you sure you want to create table '$table_name'? (Yes/No): " confirmation
                case $confirmation in
                    [Yy]* )
                        touch $table_name
                        echo "Table created successfully."
                        break ;;
                    [Nn]* )
                        echo "Table creation cancelled."
                        continue ;;
                    * )
                        echo "Please answer Yes or No."
                        continue ;;
                esac
            fi ;;
        * )
            echo "Invalid table name."
            continue ;;
    esac
done

# إدخال عدد الأعمدة
while true; do
    read -p "Insert number of fields for $table_name table: " fields_num

    if [[ "$fields_num" =~ ^[1-9][0-9]*$ ]]; then
        echo "Number of fields: $fields_num"
        break
    else
        echo "Please enter a valid number greater than 0."
    fi
done

# إدخال الميتا داتا (أسماء الأعمدة، وأنواعها)
row_name=""
row_type=""
primary_key=""

echo "
------ Insert Column Names ------
"

for ((i=1; i<=$fields_num; i++)); do
    while true; do
        read -p "Column $i name: " col_name
        case $col_name in
            "")
                echo "Column name cannot be empty."
                continue ;;
            *[[:space:]]* )
                echo "Column name cannot contain spaces."
                continue ;;
            [0-9]* )
                echo "Column name cannot start with a number."
                continue ;;
            [a-zA-Z_][a-zA-Z0-9_]* )
                # check for duplicate
                if [[ ":$row_name" == *":$col_name:"* ]]; then
                    echo "Column name already exists."
                    continue
                fi

                # سؤال عن الـ Primary Key
                if [ -z "$primary_key" ]; then
                    read -p "Do you want to make '$col_name' the Primary Key? (y/n): " pk_answer
                    case $pk_answer in
                        [Yy]* ) primary_key=$col_name ;;
                    esac
                fi

                row_name+="$col_name:"
                break ;;
            * )
                echo "Invalid column name."
                continue ;;
        esac
    done
done

# حذف الـ : الأخير
row_name=${row_name%:}

# اختيار نوع كل عمود
echo "
------ Insert Column Types ------
"

PS3="Choose column type: "
for ((i=1; i<=$fields_num; i++)); do
    col=$(echo $row_name | cut -d: -f$i)
    echo "Column '$col' type:"
    select choice in string integer; do
        case $choice in
            string )
                row_type+="string:"
                break ;;
            integer )
                row_type+="integer:"
                break ;;
            * )
                echo "Invalid choice. Please choose 1 or 2."
                continue ;;
        esac
    done
done

# حذف الـ : الأخير
row_type=${row_type%:}

# حفظ الميتا داتا في الجدول
echo "$row_name" >> $table_name
echo "$row_type" >> $table_name
echo "PK:$primary_key" >> $table_name

echo "
🎉 Table '$table_name' created successfully with meta data:
Columns: $row_name
Types  : $row_type
Primary Key: $primary_key
"
