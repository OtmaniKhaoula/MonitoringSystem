#!/bin/bash

file=/home/green/MonitoringSys/MonitoringSystem/monitoring.db
sqlite3 $file <<EOF
.timeout 3000
CREATE TABLE mem(date_time date NOT NULL, user text NOT NULL, mem_usage integer);
CREATE TABLE cpu(date_time date NOT NULL, user text NOT NULL, cpu_usage integer);
EOF

for user in $(who | sed 's/ .*//' | sort -u)
do 
	
	sum=$(top -b -n 1 -u $user | awk 'NR>7 {sum += $10;} END {print sum;}')
       	sqlite3 $file "INSERT INTO mem (date_time, user, mem_usage) values (datetime(), '$user', '$sum');"
done
sum=$(top -b -n 1 -u "root" | awk 'NR>7 {sum += $10;} END {print sum;}')
sqlite3 $file "INSERT INTO mem (date_time, user, mem_usage) values (datetime(), 'root', '$sum');"

