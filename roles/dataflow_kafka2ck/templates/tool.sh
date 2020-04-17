#!/usr/bin/env bash

#kafka消费
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server 172.16.3.203:6667,172.16.3.205:6667,172.16.3.206:6667 --topic K19_ASTANA_DM_HDR_LOG  --from-beginning

#kafka生产
/opt/kafka/bin/kafka-console-producer.sh --broker-list 172.16.3.203:6667,172.16.3.205:6667,172.16.3.206:6667 --topic K19_ASTANA_DM_HDR_LOG

#ck连接
clickhouse-client --host=k182nd-stg-03 --port=9001

#sftp登陆
sftp k18@k182nd-stg-03 && cd /home/k18/dzn/dm/allot/

#文件内容替换
find -name '*.yaml' | xargs perl -pi -e 's|192.168.162.95:36667,192.168.162.95:46667|192.168.162.95:6667,192.168.162.96:6667|g'
