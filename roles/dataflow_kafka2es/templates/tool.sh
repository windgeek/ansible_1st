#!/usr/bin/env bash

```
#替换jar中对应文件
jar uvf k19-spark-streaming-1.0.jar dev/config_dev.yaml

#kafka客户端数据消费
/opt/kafka/bin/kafka-console-consumer.sh --zookeeper 172.16.3.202:2181/kafka --from-beginning --topic NTC-OSS-ES

#mvn 本地安装
mvn install:install-file -Dfile="/Users/pan.lu/bfd/code/mailparser/target/mail-parser-1.0.jar" -DgroupId=com.percent -DartifactId=mail-parser -Dversion=1.0 -Dpackaging=jar

#scp 拷贝
scp ../../target/k19-spark-streaming-1.0.jar k18@k182nd-stg-03:~/spark

mvn dependency:tree -Dverbose -Dincludes=com.alibaba:fastjson

ps -ef|grep container | wc
echo cons | nc 127.0.0.1 2181 | grep 73 |wc

scp /Users/pan.lu/bfd/code/k19-data-streaming/https-kafka2es/target/https-kafka2es-1.3.jar k18@bigdata-1:/home/k18/lupan/pre/
```

create_namespace 'k18_media'
create 'k18_media:http_cache','cache'

find -name '*.yaml' | xargs perl -pi -e 's|192.168.162.95:36667,192.168.162.95:46667|192.168.162.95:6667,192.168.162.96:6667|g'
