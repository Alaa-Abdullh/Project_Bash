#!  /usr/bin/bash 

# Meanu
select choice in "Create Database" "List Database" "Connect To Database" "Drop Database"
do 
case $choice in 
"Create Database" ) 
        echo "Create Database....."
         source  ./create_DB.sh
      ;;
"List Database" )
        echo "Listing  Database....."
        chmod +x list_db.sh
        ./list_db.sh
;;
"Connect To Database" ) 
        echo "Connect To Database....."
        chmod +x connect_db.sh
        ./connect_db.sh
        ;;
"Drop Database" )
       echo "Drop Database"
        chmod +x drop_db.sh
        ./drop_db.sh

       ;;
esac
done
