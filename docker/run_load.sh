#!/bin/bash

SOCKET=/var/run/mysqld/mysqld.sock
TABLE_SIZE=10000
TABLES=8
THREADS=2
MYSQL_USER=root
MYSQL_PASSWORD=

function prepare()
{
  mysql -e "CREATE DATABASE IF NOT EXISTS sbtest"
  sysbench --db-driver=mysql --db-ps-mode=disable \
  --mysql-socket=${SOCKET} \
  --mysql-user=${MYSQL_USER} --mysql-password=${MYSQL_PASSWORD} \
  --table_size=${TABLE_SIZE} --tables=${TABLES} /usr/share/sysbench/oltp_read_write.lua prepare
}

function run_load()
{
  sysbench --db-driver=mysql --db-ps-mode=disable \
  --mysql-socket=${SOCKET} \
  --mysql-user=${MYSQL_USER} --mysql-password=${MYSQL_PASSWORD} \
  --table_size=${TABLE_SIZE} --tables=${TABLES} --threads=${THREADS} --time=0 \
  --report-interval=1 /usr/share/sysbench/oltp_write_only.lua run
}

if [[ $# -ne 0 ]] ; then
  MODE=$1
  if [[ "${MODE}" == "prepare" ]]; then
    prepare
    exit 0
  elif [[ "${MODE}" == "run" ]]; then
    run_load
    exit 0
  fi
fi

echo "Usage: $0 [prepare|run]"
