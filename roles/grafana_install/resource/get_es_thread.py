#!/usr/bin/env python
# -*- coding:UTF-8 -*-
# Created by wind on 2019-12-5
import socket
import os
import arrow
import time
import influxdb
import re


def get_hostname_ipaddress():
    host_name = socket.gethostname()
    ip_address = socket.gethostbyname(host_name)
    return host_name, ip_address


if __name__ == '__main__':
   while True:
        if int(time.time()) % 10 == 0:
            ip = get_hostname_ipaddress()[1]
            url = '"http://{}:9200/_cat/thread_pool/write,index,search?v&h=id,name,host,active,queue,rejected,completed,queue_size"'.format(ip)
            file = os.popen('curl -s {}'.format(url))
            try:
                text_lines = file.readlines()
            finally:
                file.close()
            for i in range(1, len(text_lines)):
                iList = re.sub(' +', ' ', text_lines[i].strip()).split(' ')
                now = str(arrow.now()).split('.')[0] + 'Z'
                # print(now, regionCount, storeFileCount, compactionQueueLength, GCTimeMillisConcurrentMarkSweep, memStoreSize, updatesBlockedTime)
                # tableName: measurement both tags---grafana filter
                client = influxdb.InfluxDBClient("10.0.40.1", 8086, 'root', ' ')
                client.create_database('es_collector')
                client.switch_database('es_collector')
                json_body = [
                    {
                        "measurement": "es_thread",
                        "tags": {
                            "ip": ip
                        },
                        "fields": {
                            "name": iList[1],
                            "host": iList[2],
                            "active": iList[3],
                            "queue": iList[4],
                            "rejected": iList[5],
                            "completed": iList[6],
                            "queue_size": iList[7],
                            "time": now
                        }
                    }
                ]
                client.write_points(json_body)

        time.sleep(1)
