#!/bin/bash

# Someone dropped titles database

mysql -e "DROP TABLE titles" employees && echo "Someone did bad things on the database"
