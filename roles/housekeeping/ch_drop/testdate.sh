#! /bin/bash

#250 days after seconds
#latertime=`date -d "250 day" +"%s"`
latertime=1586673931
#now seconds
ftime=`date +"%s"`
#distince days
distime=`expr $latertime - $ftime`
trueday=`expr $distime / 3600 / 24 `
deltime=`date -d "${trueday} day ago" +"%Y-%m-%d %T"`

if [ $trueday -gt 90 ];then 
    ftime=$deltime
else
    ftime=`date -d "90 day ago" +"%Y-%m-%d %T"`
fi
echo $ftime


