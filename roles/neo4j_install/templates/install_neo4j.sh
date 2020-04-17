#!/bin/bash

####################
##安装路径/opt
##默认的管理员用户/密码:neo4j/neo4j
##但是需要在前端更改,访问地址为:http://${ip}:7474/browser/   可以更改为:k18k18
##注意的配置:内存大小,线程数(内存大小见脚本输出)
#####################

#启动neo4j的用户和密码,如果之前部署其他大数据组件已经创建了某个用户,则这里不需要再创建。
NEO4J='neo4j'
PASSWORD='neo4j'


host_ip=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/'`
data_path='{{data_path}}'
import_path='{{import_path}}'
data_paths={{data_paths}}

#日志保存天数,大小
log_days="7\ days"
log_size="10g\ size"

#线程数大小
work_count='30'


#创建启动用户neo4j
groupadd $NEO4J
useradd  -g $NEO4J $NEO4J && echo $PASSWORD | passwd --stdin $NEO4J

#授权
chown -R ${NEO4J}:${NEO4J} /opt/neo4j*


#修改neo4j配置文件

cd /opt/neo4j/conf/
cp neo4j.conf neo4j.conf.bak

sleep 1s
#修改线程数
sed -i 's#.*dbms.threads.worker_count.*#dbms.threads.worker_count='${work_count}'#g' neo4j.conf

#修改日志保存天数、大小
sed -i 's#.*dbms.tx_log.rotation.retention_policy.*#dbms.tx_log.rotation.retention_policy='${log_days}'\ndbms.tx_log.rotation.retention_policy='${log_size}'#g' neo4j.conf

#数据存储位置
sed -i 's#.*dbms.directories.data.*#dbms.directories.data='${data_path}'#g' neo4j.conf

#去掉插件注释
sed -i '/#dbms.directories.plugins/s/^#//' neo4j.conf

#import位置
sed -i 's#.*dbms.directories.import.*#dbms.directories.import='${import_path}'#g' neo4j.conf

#证书位置
sed -i '/#dbms.directories.certificates/s/^#//' neo4j.conf

#log、lib、run位置(默认)
sed -i '/#dbms.directories.logs/s/^#//' neo4j.conf
sed -i '/#dbms.directories.lib/s/^#//' neo4j.conf
sed -i '/#dbms.directories.run/s/^#//' neo4j.conf
sed -i '/#dbms.connectors.default_listen_address/s/^#//' neo4j.conf
sed -i '/#dbms.connector.bolt.tls_leve/s/^#//' neo4j.conf
sed -i 's/.*dbms.connector.bolt.listen_address=.*/dbms.connector.bolt.listen_address='"$host_ip"':7687/g' neo4j.conf
sed -i 's/.*dbms.connector.http.listen_address=.*/dbms.connector.http.listen_address='"$host_ip"':7474/g' neo4j.conf
sed -i 's/.*dbms.connector.https.listen_address=.*/dbms.connector.https.listen_address='"$host_ip"':7473/g' neo4j.conf
sed -i '/#dbms.security.allow_csv_import_from_file_urls=true/s/^#//' neo4j.conf
sed -i '/#dbms.shell.enabled/s/^#//' neo4j.conf
sed -i 's/.*dbms.shell.host=.*/dbms.shell.host='"$host_ip"'/g' neo4j.conf
sed -i '/#dbms.shell.port=1337/s/^#//' neo4j.conf
mkdir -p ${data_path}
mkdir -p ${import_path}
chown -R neo4j:neo4j /opt/neo4j /opt/neo4j-community-3.4.9
chown -R neo4j:neo4j $data_paths


#配置环境变量
echo -e '\nexport NEO4J_HOME=/opt/neo4j\nexport PATH=${NEO4J_HOME}/bin:$PATH'> /etc/profile.d/neo4j.sh
source /etc/profile.d/neo4j.sh


#内存优化及启动
su - neo4j <<EOF
/opt/neo4j/bin/neo4j-admin  memrec | grep = | awk 'NR==1 {print}'
/opt/neo4j/bin/neo4j-admin  memrec | grep = | awk 'NR==2 {print}'
/opt/neo4j/bin/neo4j-admin  memrec | grep = | awk 'NR==3 {print}'
/opt/neo4j/bin/neo4j start
EOF