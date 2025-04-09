#!  /usr/bin/bash 

echo "
========= Create  Table =========
"

# list table to the user
echo "
         ...... tables 

         ..........."

ls -s

# user create a valid table name

while true 
do 
# read input 
read -p "enter your table name to create "

table_name=$REPLY

case $table_name in
  # The Name is Empty 
        "")
          echo "The Name  can not be empty Plese Try Again :("
          continue ;;

        # The Name have spaces 
         *[[:space:]] | *[[:space:]]* | [[:space]]* )
            echo "The Name of Table Can not have any spaces :("
            continue ;;

        # The Name have Number 
        [0-9]* )
        echo "The Name of Table Can not start with digits :("
        continue ;;
      
        # Valid Name  
       [a-zA-Z_][a-zA-Z0-9_]*  )
           if (find $table_name `ls -F | grep /` &> ~/../../dev/null )
            then
                echo "Table already exists <( "
                 continue
           else 
            read -p "Are you shure to create Table this name'$table_name'؟ (Yes/No): " confirmation
            case $confirmation in 
              [Yy]* )
              touch $table_name
              echo "Create Table Successful :) "
              break
              ;;
              [Nn]* )
              echo "Create Table Cancelde :( Try Again !"
              continue
              ;;
              * )
              echo "Not Correct Must be replay y or N?!"
              continue 
              ;;
              esac
            fi
          continue
          ;;
        # Any Change 
       *) 
        echo "That Not Valid Name"
       continue
          ;;

esac
done
