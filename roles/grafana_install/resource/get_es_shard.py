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
    url = 'http://{}:9200/_cat/shards/k19*?v&format=json'.format(ip)
    r = requests.get(url)
    decode = json.loads(r.text)
    return decode


def index_generate():
    suffix1 = time.strftime('%Y%m%d', time.localtime(time.time()))
    return suffix1


def unit_conversion_sort(list1):
    list2 = []
    for i in list1:
        if i[-2:] == 'kb':
            list2.append(1024 * float(i[:-2]))
        if i[-2:] == 'mb':
            list2.append(1024 * 1024 * float(i[:-2]))
        if i[-2:] == 'gb':
            list2.append(1024 * 1024 * 1024 * float(i[:-2]))
    list2.sort()
    min1 = list2[0]
    max1 = list2[-1]
    return list2, min1, max1


if __name__ == '__main__':
    while True:
        if int(time.time()) % 10 == 0:
            hostname = get_hostname_ipaddress()[0]
            ip = get_hostname_ipaddress()[1]
            suffix = index_generate()
            http_account = 'k19_http_account_{}'.format(suffix)
            http_content = 'k19_http_content_{}'.format(suffix)
            im_chat = 'k19_im_chat_{}'.format(suffix)
            im_profile = 'k19_im_profile_{}'.format(suffix)
            im_voip = 'k19_im_voip_{}'.format(suffix)
            mail_content = 'k19_mail_content_{}'.format(suffix)
            social_chat = 'k19_social_chat_{}'.format(suffix)
            social_posts = 'k19_social_posts_{}'.format(suffix)
            social_profile = 'k19_social_profile_{}'.format(suffix)
            web_mail = 'k19_web_mail_{}'.format(suffix)
            # js为list
            js = get_json(ip)
            # print(type('k19_http_account_{}'.format(suffix)), 'k19_http_account_{}'.format(suffix))
            list_http_account = []
            list_http_content = []
            list_im_chat = []
            list_im_voip = []
            list_im_profile = []
            list_mail_content = []
            list_social_profile = []
            list_social_posts = []
            list_social_chat = []
            list_web_mail = []
            # js = get_json('10.0.40.6')
            for item in js:
                if item["index"] == http_account:
                    list_http_account.append(item["store"].encode('utf-8'))
                elif item["index"] == http_content:
                    list_http_content.append(item["store"].encode('utf-8'))
                elif item["index"] == im_chat:
                    list_im_chat.append(item["store"].encode('utf-8'))
                elif item["index"] == im_profile:
                    list_im_profile.append(item["store"].encode('utf-8'))
                elif item["index"] == im_voip:
                    list_im_voip.append(item["store"].encode('utf-8'))
                elif item["index"] == mail_content:
                    list_mail_content.append(item["store"].encode('utf-8'))
                elif item["index"] == social_chat:
                    list_social_chat.append(item["store"].encode('utf-8'))
                elif item["index"] == social_posts:
                    list_social_posts.append(item["store"].encode('utf-8'))
                elif item["index"] == social_profile:
                    list_social_profile.append(item["store"].encode('utf-8'))
                elif item["index"] == web_mail:
                    list_web_mail.append(item["store"].encode('utf-8'))
            now = str(arrow.now()).split('.')[0] + 'Z'
            # tableName: measurement both tags---grafana filter
            client = influxdb.InfluxDBClient('10.0.40.2', 8086, 'root', ' ')
            client.create_database('es_collector')
            client.switch_database('es_collector')
            json_body = [
                {
                    "measurement": "es_shard",
                    "tags": {
                        "host_ip": ip,
                        "hostname": hostname
                    },
                    "fields": {
                        "http_account_min": unit_conversion_sort(list_http_account)[1],
                        "http_account_max": unit_conversion_sort(list_http_account)[2],
                        "http_content_min": unit_conversion_sort(list_http_content)[1],
                        "http_content_max": unit_conversion_sort(list_http_content)[2],
                        "im_chat_min": unit_conversion_sort(list_im_chat)[1],
                        "im_chat_max": unit_conversion_sort(list_im_chat)[2],
                        "im_profile_min": unit_conversion_sort(list_im_profile)[1],
                        "im_profile_max": unit_conversion_sort(list_im_profile)[2],
                        "im_voip_min": unit_conversion_sort(list_im_voip)[1],
                        "im_voip_max": unit_conversion_sort(list_im_voip)[2],
                        "mail_content_min": unit_conversion_sort(list_mail_content)[1],
                        "mail_content_max": unit_conversion_sort(list_mail_content)[2],
                        "social_chat_min": unit_conversion_sort(list_social_chat)[1],
                        "social_chat_max": unit_conversion_sort(list_social_chat)[2],
                        "social_posts_min": unit_conversion_sort(list_social_posts)[1],
                        "social_posts_max": unit_conversion_sort(list_social_posts)[2],
                        "social_profile_min": unit_conversion_sort(list_social_profile)[1],
                        "social_profile_max": unit_conversion_sort(list_social_profile)[2],
                        "web_mail_min": unit_conversion_sort(list_web_mail)[1],
                        "web_mail_max": unit_conversion_sort(list_web_mail)[2],
                        "time": now
                    }
                }
            ]
            client.write_points(json_body)

        time.sleep(1)
