#!/bin/bash 
START_TIMEOUT=30

trap "echo Error initializing container. Exiting..." SIGTERM EXIT
function wait_mysql_start {
  echo "Waiting for MySQL to start..."
  for i in $(seq ${START_TIMEOUT}); do
    mysqladmin ping
    if [ $? -eq 0 ]; then
      return 0
    fi
    sleep 1
  done
  return 1
}

# Start MySQL
mysqld &

# Wait for MySQL to start
wait_mysql_start &&

# Install Employees Database
cd /opt/ && tar -zxvf test_db-1.0.7.tar.gz &&
cd /opt/test_db && mysql < employees.sql &&

# Prepare sysbench
run_load.sh prepare

# Everything up an running
echo "Everything is up and running."

# Keep it open
sleep infinity
