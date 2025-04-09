#!  /usr/bin/bash 

echo "
========= Alredy Existing DataBase =========
"

cd ../Data_Backup

echo "Database Available"
echo "------------------------"

# list all db 
ls -F | grep / | tr / " "

echo "------------------------"


cd - &> ~/../../dev/null
