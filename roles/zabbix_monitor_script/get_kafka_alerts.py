#!/usr/bin/env python
# -*- coding:UTF-8 -*-

# 1、broker数量 < 既定个数
# 2、controller存活一个：sum(kafka_controller_kafkacontroller_activecontrollercount) !=1
# 3、parition下线：max(kafka_controller_kafkacontroller_offlinepartitionscount) > 0
# 4、掉出ISR数量过多：sum(kafka_cluster_partition_underreplicated) / sum(kafka_server_replicamanager_partitioncount) > 10
# 5、Lag > 5000W; partition > 500w

import os
import json

# 执行查询的curl命令
get_controller = r'curl -s "http://$HOSTNAME:9090/api/v1/query?query=sum(kafka_controller_kafkacontroller_activecontrollercount)"'
get_offline_partition = r'curl -s "http://$HOSTNAME:9090/api/v1/query?query=max(kafka_controller_kafkacontroller_offlinepartitionscount)"'
get_isr_under = r'curl -s "http://$HOSTNAME:9090/api/v1/query?query=sum(kafka_cluster_partition_underreplicated)"'
get_isr_manager = r'curl -s "http://$HOSTNAME:9090/api/v1/query?query=sum(kafka_server_replicamanager_partitioncount)"'
get_partition_lag = r'curl -s "http://$HOSTNAME:9090/api/v1/query?query=max(kafka_burrow_partition_lag)"'


def load(url):
    item_alerts = os.popen(url)
    data = json.load(item_alerts)
    result = data["data"]["result"][0]["value"][1]
    item_alerts.close()
    return result


if __name__ == '__main__':
    controller = load(get_controller)
    offline_partition = load(get_offline_partition)
    isr_under = load(get_isr_under)
    isr_manager = load(get_isr_manager)
    partition_lag = load(get_partition_lag)
    print('{} {} {} {} {}'.format(controller, offline_partition, isr_under, isr_manager, partition_lag))

    # 判断警告状态
    if controller != 1 or offline_partition > 0 or isr_under/isr_manager > 10 or partition_lag > 500000:
        print(1)
    else:
        print(0)





