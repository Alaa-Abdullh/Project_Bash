#!  /usr/bin/bash 

echo "
========= Connect  DataBase =========
"
ps3="Type your DB number to connect with :"

echo "------>
select Database Number from Menu  
<------"

cd ../Data_Backup

echo "------------------------"


# list all db in array 
array=(`ls -F | grep / | tr / " "`)

# echo ${array[*]}

# menu to connect db 
select choice in ${array[*]}
do
  if [ $REPLY -gt ${#array[*]} ]
  then
       echo " Invalid $REPLY is not on the Menu"
       continue
  else 
     read -p "Are you sure you want to Connect to DB this name'$choice'؟ (Yes/No): " confirmation
            case $confirmation in 
              [Yy]* )
              cd ../Data_Backup/${array[${REPLY}-1]}
              echo "Your Connect to ${array[${REPLY}-1]}  DB  Successfully :) "
              break
              ;;
              [Nn]* )
              echo "Your ${array[${REPLY}-1]} in DB  Cancelde :( Try Again !"
              continue
              ;;
              * )
              echo "Not Correct Must be replay y or N?!"
              continue 
              ;;
              esac

     
     
    
   fi
done

echo "------------------------"

select choice in "Create Table" "List Table" "Drop Table" "Insert in Table" "select from Table " "Delete from Table" "Update from Table"
do 
case $choice in 
"Create Table" ) 
        echo "Create Table....."
        
         source  ../../softweare/create_table.sh
      ;;
"List Table" )
        echo "Listing  Table....."
        
        source ../../softweare/list_table.sh
;;
"Insert in Table" ) 
        echo "Insert in Table....."
       
        source ../../softweare/insert_in_table.sh
        ;;

"select from Table " ) 
         echo "SElect From Table....."
        
         source ../../softweare/select_from_table.sh

;;

"Update from Table")
        echo "Update From Table....."
        
        source ../../softweare/update_table.sh

;;


"Drop Table" )
       echo "Drop Table"
      
        source ../../softweare/drop_table.sh

       ;;

"Delete from Table" )
         echo "Delete Table"
       
         source ../../softweare/delet_from_table.sh
;;
esac
done


cd - &> ~/../../dev/null
