#!  /usr/bin/bash 

echo "
========= Drop  Table =========
"
array=(`ls`)


# menu to drop Table 
select choice in ${array[*]}2
do
  if [ $REPLY -gt  ${#array[*]} ]
  then
       echo " Invalid $REPLY is not on the Menu"
       continue
  else 
     read -p "Are you sure you want to delete  Table in DB this name'$choice'؟ (Yes/No): " confirmation
            case $confirmation in 
              [Yy]* )
              rm ${array[${REPLY}-1]}
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