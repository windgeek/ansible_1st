#!/bin/bash

source /etc/profile
source ~/.bash_profile
source ~/.bashrc

time=`date +%s%N`
ctime=$[time/1000000]

day=15
betime=$[$day*24*60*60*1000]
atime=$[ctime-betime]

mysql -uroot -pk18k18 << EOF
use k18_stream_monitor;
delete from k18_monitor_data where created_time < $atime;
delete from k18_monitor_kafka_exception where created_time < $atime;
EOF