#!/usr/bin/env bash
env="conf"
jarName="{{jar_version}}"
JAR_HDFS_PATH=hdfs://{{hdfsHAClusterName}}/user/k18/dm/lib/*.jar #依赖包的上传地址。


fullName=$(readlink -f $0)
fullPath=$(dirname ${fullName})
cd $fullPath/../

pwdPath=`pwd`

jar uvf ${jarName} ${env}/dm_monitor.yaml
spark-submit --class com.bfd.k19.application.DmMonitor2CKApplication \
    --name dm_conv_application \
	--master yarn \
	--deploy-mode cluster \
	--executor-memory 1G \
	--num-executors 1 \
	--files ${pwdPath}/conf/log4j.properties \
	--conf spark.streaming.kafka.maxRatePerPartition=20000 \
	--conf spark.streaming.backpressure.initialRate=10000 \
	--conf spark.streaming.backpressure.enabled=true \
	--conf spark.memory.fraction=0.2 \
	--conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
	--conf spark.executor.cores=1 \
	--conf spark.yarn.jars=${JAR_HDFS_PATH} \
	${jarName} ${env} dm_monitor.yaml
