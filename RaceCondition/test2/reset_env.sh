echo "Hello user!" > user_file
echo "Hello root!" > root_file
chown root:root root_file
ln -sf ./user_file temp_file
gcc ./test.c -o test
chown root:root test
chmod +s test
