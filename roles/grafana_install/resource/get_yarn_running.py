#!/usr/bin/env python
# -*- coding:UTF-8 -*-
# Created by wind on 2019-2-15
import requests
import json
import arrow
import time
import influxdb


def get_json(yarn_ip):
    url = 'http://{}:8088/ws/v1/cluster/metrics?v&format=json'.format(yarn_ip)
    r = requests.get(url)
    decode = json.loads(r.text)
    return decode


if __name__ == '__main__':
    while True:
        if int(time.time()) % 10 == 0:
            js = get_json('192.168.162.95')
            print (js, type(js))
            app_running = int(js[u'clusterMetrics'][u'appsRunning'])
            print (app_running)
            now = str(arrow.now()).split('.')[0] + 'Z'
            client = influxdb.InfluxDBClient('10.0.40.10', 8086, 'root', ' ')
            client.create_database('yarn_collector')
            client.switch_database('yarn_collector')
            json_body = [
                {
                    "measurement": "app_running",
                    "tags": {
                        "area": "astana",
                        "site": "nc"
                    },
                    "fields": {
                        "app_running": app_running,
                        "time": now
                    }
                }
            ]
            client.write_points(json_body)

        time.sleep(1)
