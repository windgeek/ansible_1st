#! /bin/bash

source /etc/profile
source ~/.bash_profile
source ~/.bashrc

#clickhouse按照partition清理数据
host=`hostname`
port=9000
#时间换算变量
a=3600
b=24
#clickhouse存放表的位置
datadir=/data1/var/lib/clickhouse/data/k18_ods
basepath="$(cd `dirname $0`; pwd)"

#获取要删除前30天代表天数的日期
ftime=`date -d "90 day ago" +"%Y-%m-%d %T"`


echo " " > ${basepath}/drop_day_tables.txt

for day_tb in $(cat ${basepath}/day_tables | grep -v '^#' | grep -v '^$' )
do
  echo "=`date`===========================删除以Day为分区的表${day_tb} =============================="
    if [ "x$day_tb" != "x" ]; then
        day_temp=`date -d "${ftime}" +"%s"`
        day_part=`expr $day_temp / 3600 / 24`
    	echo "ALTER TABLE k18_ods.${day_tb}  DROP PARTITION ${day_part};" >> ${basepath}/drop_day_tables.txt
        clickhouse-client --host=${host} --port=${port} --user=writer --password=k18 --query="ALTER TABLE k18_ods.${day_tb}  DROP PARTITION ${day_part};"        
    fi
done

echo "---------------------------------------------------------------------------------------------------------------"

hour_tempp=`date -d "${ftime}" +"%Y-%m-%d"`

# 清空临时文件
echo " " > ${basepath}/hour_partition
# 将对应的4开头的时间节点写入到临时文件中
for((i=0;i<24;i++));
do
  hour_temp=`date -d "${hour_tempp} ${i}:00:00" +"%s"`
  hour_partition=`expr $hour_temp / 3600`
  echo $hour_partition >> ${basepath}/hour_partition
done

echo " " > ${basepath}/drop_hour_tables.txt
for hour_tb in $(cat ${basepath}/hour_tables | grep -v '^#' | grep -v '^$' )
do
  echo "=`date`========================删除以hour为分区的表${hour_tb} =============================="
    if [ "x$hour_tb" != "x" ]; then
        for hour_pt in $(cat ${basepath}/hour_partition | grep -v '^#' | grep -v '^$' )
        do
          if [ "x$hour_pt" != "x" ]; then
            echo "ALTER TABLE k18_ods.${hour_tb}  DROP PARTITION ${hour_pt};" >> ${basepath}/drop_hour_tables.txt
          fi
        done
    fi
done

clickhouse-client --host=${host} --port=${port} --user=writer --password=k18 -n < ${basepath}/drop_hour_tables.txt
