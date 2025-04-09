#!  /usr/bin/bash 

echo "
========= Drop DataBase =========
"
cd ../Data_Backup

echo "
select Database To drop 
"

echo "------------------------"

# list all db in array 
array=(`ls -F | grep / | tr / " "`)

# echo ${array[*]}

# menu to drop db 
select choice in ${array[*]}
do
  if [ -z $choice ]
  then
       echo " Invalid $REPLY is not on the Menu"
       continue
  else 
     read -p "Are you sure you want to delete  DB this name'$choice'؟ (Yes/No): " confirmation
            case $confirmation in 
              [Yy]* )
              rm -r $choice
              echo "Your $choice in DB deleted Successfully :) "
              break
              ;;
              [Nn]* )
              echo "Your $choice in DB  Cancelde db not deleted:( Try Again !"
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


cd - &> ~/../../dev/null
