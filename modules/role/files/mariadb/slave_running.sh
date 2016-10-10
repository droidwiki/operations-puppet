#!/bin/bash
MYSQL=`mysql --defaults-file=/etc/mysql/debian.cnf -e "SHOW SLAVE STATUS \G"`
IO=`echo "$MYSQL" | grep 'Slave_IO_Running:' | awk '{print $2}'`
SQL=`echo "$MYSQL" | grep 'Slave_SQL_Running:' | awk '{print $2}'`
if [ "Yes" == "$IO" ] && [ "Yes" == "$SQL" ]; then
	touch /data/mariadb/slave_running
fi
exit
