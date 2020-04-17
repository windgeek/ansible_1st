#!/bin/bash
###################################
#删除早于90天的ES集群的索引
###################################
source /etc/profile
source ~/.bash_profile
source ~/.bashrc

IP=10.4.42.22
Port=9200

curl -XGET http://${IP}:${Port}/_cat/indices | awk -F " " '{print $3}'| awk -F "_" '{print $NF}' | egrep "[0-9]*[0-9]*[0-9]*[0-9]*" | cut -c1-8 | sort | uniq | while read LINE
do
    comp_date=`date -d "90 day ago" +"%Y%m%d"`
    date1="${LINE} 00:00:00"
    date2="$comp_date 00:00:00"

    t1=`date -d "$date1" +%s`
    t2=`date -d "$date2" +%s`

    if [ $t1 -le $t2 ]; then
        echo "$LINE时间早于$comp_date，进行索引删除"
        echo "http://${IP}:${Port}/*_${LINE}*"
        curl -X DELETE "http://${IP}:${Port}/*_${LINE}*" > /root/tools/es_clean/es_clean.log  2>&1
    fi
done
