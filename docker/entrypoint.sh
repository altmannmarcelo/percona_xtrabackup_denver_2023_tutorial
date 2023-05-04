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

# Start MinIO
MINIO_ROOT_USER=admin MINIO_ROOT_PASSWORD=password minio server /mnt/data --address ":9090" --console-address ":9091" &
mkdir ~/.aws/
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = admin
aws_secret_access_key = password
EOF

cat <<EOF > ~/.aws/config
[default]
region = us-east-1
EOF
aws configure set default.s3.signature_version s3v4
aws --endpoint-url http://127.0.0.1:9090 s3 mb s3://perconalive


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
