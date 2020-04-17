#!/usr/bin/env bash
#The script is ys clickhouse initialization creation of national data center(TSE).The following parameter variables need to be modified before execution.



####################################
#定位当前目录
BATHPATH=$(cd `dirname $0`; pwd)
#调用sql的路径
ck_init_script_path=${BATHPATH}/sql

#创建分布式表脚本
distribute_table_sql=ck_distribute.sql


#clickhouse distribute cluster node hostname
distribute_host_name=(
platform-server-5
platform-server-6
)
#####################################

user=writer

password=k18

tcp_port=9000


echo "distribute table init ddl begin"

#create local table

function astana_create_distribute_table(){

for ((i=0;i<${#distribute_host_name[*]};i++))
do

    echo "在 ${distribute_host_name[i]} 上创建分布式表"
    clickhouse-client --host=${distribute_host_name[i]} --port=${tcp_port} --user=${user} --password=${password} -n < ${ck_init_script_path}/${distribute_table_sql}


done
}

function check(){

for ((i=0;i<${#distribute_host_name[*]};i++))
do
    echo "在 ${distribute_host_name[i]} 执行分布式表建表检查"
    if [[  `clickhouse-client -m -d k19_distribute -h ${distribute_host_name[i]} --port=9000 -q "show tables;"|wc -l` -lt 12  ]]; then
        echo ${distribute_host_name[i]}
    fi

done
}






#创建分布式表
astana_create_distribute_table

#检查
check


