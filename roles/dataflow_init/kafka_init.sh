#!/bin/bash
#tse
tse_zookeeper='172.24.9.40:2181/kafka'
tse_tag='ASTANA'
#ala
ala_zookeeper='172.24.9.54:2181/kafka'
ala_tag='ALMATY'
#other
other_zookeeper='172.24.9.57:2181/kafka'
other_tag='OTHER'
function astana() {
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-NTC-COLLECT-VOIP-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-NTC-CONN-RECORD-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-NTC-COLLECT-MAIL-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-NTC-COLLECT-HTTP-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-NTC-COLLECT-ACCOUNT-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-NTC-COLLECT-LBS-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-NTC-COLLECT-RADIUS-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19_${tse_tag}_NTC_COLLECT_IM_LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-DM-HDR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-DM-CONV-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${tse_tag}-DM-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-OSS-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-OSS-ES
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-CKQUERY-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${tse_zookeeper} --replication-factor 2 --partitions 3 --topic K19-TEST-EXCEPTION-MESSAGE
}

function almaty() {
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-NTC-COLLECT-VOIP-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-NTC-CONN-RECORD-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-NTC-COLLECT-MAIL-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-NTC-COLLECT-HTTP-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-NTC-COLLECT-ACCOUNT-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-NTC-COLLECT-LBS-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-NTC-COLLECT-RADIUS-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19_${ala_tag}_NTC_COLLECT_IM_LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-DM-HDR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-DM-CONV-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${ala_tag}-DM-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-OSS-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-OSS-ES
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-CKQUERY-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${ala_zookeeper} --replication-factor 2 --partitions 3 --topic K19-TEST-EXCEPTION-MESSAGE
}


function other() {
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-NTC-COLLECT-VOIP-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-NTC-CONN-RECORD-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-NTC-COLLECT-MAIL-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-NTC-COLLECT-HTTP-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-NTC-COLLECT-ACCOUNT-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-NTC-COLLECT-LBS-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-NTC-COLLECT-RADIUS-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19_${other_tag}_NTC_COLLECT_IM_LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-DM-HDR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-DM-CONV-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-${other_tag}-DM-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-OSS-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-OSS-ES
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic NTC-CKQUERY-MONITOR-LOG
sh /opt/kafka/bin/kafka-topics.sh --create --zookeeper ${other_zookeeper} --replication-factor 2 --partitions 3 --topic K19-TEST-EXCEPTION-MESSAGE
}



astana
#almaty
#other
