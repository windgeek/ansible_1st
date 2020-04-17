#!/usr/bin/env python
# -*- coding:UTF-8 -*-
# Created by wind on 2019-12-5
import socket
import os
import arrow
import time
import influxdb
import re


def index_today():
    suffix = time.strftime('%Y%m%d', time.localtime(time.time()))
    return suffix


b = 'k19_mail'

if __name__ == '__main__':
   while True:
        if int(time.time()) % 10 == 0:
            url = '"http://{}:9200/_cat/indices/{}*?v&s=index"'.format('192.168.162.95', b)
            file = os.popen('curl -s {}'.format(url))
            try:
                text_lines = file.readlines()
            finally:
                file.close()
            for i in range(1, len(text_lines)):
                iList = re.sub(' +', ' ', text_lines[i].strip()).split(' ')
                a = index_today()
                if a in iList[2] and b in iList[2]:
                    now = str(arrow.now()).split('.')[0] + 'Z'
                    # tableName: measurement both tags---grafana filter
                    client = influxdb.InfluxDBClient("10.0.40.10", 8086, 'root', ' ')
                    client.create_database('es_collector')
                    client.switch_database('es_collector')
                    json_body = [
                        {
                            "measurement": "es_index",
                            "tags": {
                                "area": "astana"
                            },
                            "fields": {
                                "index": iList[2],
                                "time_today": a,
                                "time": now
                            }
                        }
                    ]
                    client.write_points(json_body)
        time.sleep(1)
