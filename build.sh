#!/bin/bash

docker-compose down -v

# Clean data dir
rm -rf ./master/data/*
rm -rf ./slave/data/*
docker-compose build
docker-compose up -d

# Wait for mysql_master to be ready:
# Continuously tries to connect to MySQL inside mysql_master container using root user and password 111
# If the connection fails, prints a waiting message and retries after 4 seconds.
until docker exec mysql_master sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql_master database connection..."
    sleep 4
done

# Create replication user on master
# Create a replication user (mydb_slave_user)
# Grant replication privileges
# Flush privileges to apply changes

priv_stmt='ALTER USER 'mydb_slave_user'@'%' IDENTIFIED WITH mysql_native_password BY 'mydb_slave_pwd'; GRANT REPLICATION SLAVE ON *.* TO "mydb_slave_user"@"%"; FLUSH PRIVILEGES;'
docker exec mysql_master sh -c "export MYSQL_PWD=111; mysql -u root -e '$priv_stmt'"

# Wait for mysql_slave to be ready
# Repeatedly tries to connect to MySQL inside mysql_slave container using root user and password 111.
until docker-compose exec mysql_slave sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql_slave database connection..."
    sleep 4
done

# Get master status info
MS_STATUS=`docker exec mysql_master sh -c 'export MYSQL_PWD=111; mysql -u root -e "SHOW MASTER STATUS"'`

# Extracts the current binary log file and position needed to start replication.
CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`

# Prepares the SQL command to configure replication and start the slave.
start_slave_stmt="CHANGE MASTER TO MASTER_HOST='mysql_master',MASTER_USER='mydb_slave_user',MASTER_PASSWORD='mydb_slave_pwd',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"

# Builds the full command to be run inside the mysql_slave container.
start_slave_cmd='export MYSQL_PWD=111; mysql -u root -e "'
start_slave_cmd+="$start_slave_stmt"
start_slave_cmd+='"'

# Executes the replication setup command inside the slave container.
docker exec mysql_slave sh -c "$start_slave_cmd"

# Checks replication status on the slave to confirm it's running correctly.
docker exec mysql_slave sh -c "export MYSQL_PWD=111; mysql -u root -e 'SHOW SLAVE STATUS \G'"


# LogFile: mysql-bin.000001
# Position: 878