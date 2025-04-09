#!  /usr/bin/bash 

# change directory 
cd ../Data_Backup

while true
do
    # ead input
    read -p " Write Your Database Name..."  db_Name

# ...........validate input............

    case $db_Name in 

        # The Name is Empty 
        "")
          echo "The Name  can not be empty Plese Try Again :("
          continue ;;

        # The Name have spaces 
         *[[:space:]] | *[[:space:]]* | [[:space]]* )
            echo "The Name Can not have any spaces :("
            continue ;;

        # The Name have Number 
        [0-9]* )
        echo "The Name Can not start with digits :("
        continue ;;
      
        # Valid Name  
       [a-zA-Z_][a-zA-Z0-9_]*  )
           if (find $db_Name `ls -F | grep /` &> ~/../../dev/null )
            then
                echo "Database already exists <( "
                 continue
           else 
            read -p "Are you shure to create DB this name'$db_Name'؟ (Yes/No): " confirmation
            case $confirmation in 
              [Yy]* )
              mkdir $db_Name
              echo "Create DataBase Successful :) "
              break
              ;;
              [Nn]* )
              echo "Create DataBase Cancelde :( Try Again !"
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




cd - &> ~/../../dev/null