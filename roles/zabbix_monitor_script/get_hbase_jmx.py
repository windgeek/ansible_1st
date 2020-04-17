#!/usr/bin/env python
# -*- coding:UTF-8 -*-
# Created by wind on 2019-12-5
import socket
import requests
import json
import arrow
import time
import influxdb


def get_hostname_ipaddress():
    host_name = socket.gethostname()
    ip_address = socket.gethostbyname(host_name)
    return host_name, ip_address


def get_json(ip):
    url = 'http://{}:16030/jmx'.format(ip)
    r = requests.get(url)
    decode = json.loads(r.text)
    return decode


def write_influxdb(hostname, ip, js, influxdb_ip):
    while True:
        if int(time.time()) % 10 == 0:
            # js = get_json('10.0.40.6')
            regionCount = int(js['beans'][22]['regionCount'])
            storeFileCount = int(js['beans'][22]['storeFileCount'])
            compactionQueueLength = int(js['beans'][22]['compactionQueueLength'])
            GCTimeMillisConcurrentMarkSweep = int(js['beans'][19]['GcTimeMillisConcurrentMarkSweep'])
            memStoreSize = int(js['beans'][22]['memStoreSize'])
            updatesBlockedTime = int(js['beans'][22]['updatesBlockedTime'])
            now = str(arrow.now()).split('.')[0] + 'Z'
            # print(now, regionCount, storeFileCount, compactionQueueLength, GCTimeMillisConcurrentMarkSweep, memStoreSize, updatesBlockedTime)

            # tableName: measurement both tags---grafana filter
            client = influxdb.InfluxDBClient(influxdb_ip, 8086, 'root', ' ')
            client.create_database('hbase_collector')
            client.switch_database('hbase_collector')
            json_body = [
                {
                    "measurement": "hbase",
                    "tags": {
                        "host_ip": ip,
                        "hostname": hostname
                    },
                    "fields": {
                        "regionCount": regionCount,
                        "storeFileCount": storeFileCount,
                        "compactionQueueLength": compactionQueueLength,
                        "memStoreSize": memStoreSize,
                        "updatesBlockedTime": updatesBlockedTime,
                        "GCTimeMillisConcurrentMarkSweep": GCTimeMillisConcurrentMarkSweep,
                        "time": now
                    }
                }
            ]
            client.write_points(json_body)

        time.sleep(1)


if __name__ == '__main__':
    hostname = get_hostname_ipaddress()[0]
    ip = get_hostname_ipaddress()[1]
    js = get_json(ip)
    write_influxdb(hostname, ip, js, '10.0.40.2')

