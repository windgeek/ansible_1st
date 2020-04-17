#!/usr/bin/env bash
#The script is ys clickhouse initialization creation of national data center(TSE).The following parameter variables need to be modified before execution.



####################################
#定位当前目录
BATHPATH=$(cd `dirname $0`; pwd)
ck_init_script_path=${BATHPATH}/sql/almaty

#单节点创建本地表脚本名
local_table_sql=ck_almaty_local_replica.sql


#almaty local table hostname
almaty_local_host_name=(
platform-server-1
platform-server-1
platform-server-3
platform-server-4
)
#####################################

user=writer

password=k18

tcp_port=9000


echo "almaty local table init ddl begin"

#create local table

function almaty_create_local_table(){

for ((i=0;i<${#almaty_local_host_name[*]};i++))
do

    echo "执行 ${ck_init_script_path}/${local_table_sql} 在 ${almaty_local_host_name[i]} 上创建本地表"
    clickhouse-client --host=${almaty_local_host_name[i]} --port=${tcp_port} --user=${user} --password=${password} -n < ${ck_init_script_path}/${local_table_sql}


done
}


function check(){

for ((i=0;i<${#almaty_local_host_name[*]};i++))
do
    echo "在${almaty_local_host_name[i]}执行本地表建表检查"
    if [[  `clickhouse-client -m -d k19_ods -h ${almaty_local_host_name[i]} --port=9000 -q "show tables;"|wc -l` -lt 11  ]]; then
        echo ${almaty_local_host_name[i]}
    fi

done
}



#创建本地表
almaty_create_local_table
#检查建表情况
check


