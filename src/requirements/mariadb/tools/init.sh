#!/bin/sh
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
PID=$!

until mariadb -u root --socket=/run/mysqld/mysqld.sock -e "SELECT 1" > /dev/null 2>&1; do
    sleep 1
done

mariadb -u root --socket=/run/mysqld/mysqld.sock <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

kill $PID
wait $PID

exec mysqld --user=mysql --datadir=/var/lib/mysql
