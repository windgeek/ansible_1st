#!/usr/bin/env python
# -*- coding:UTF-8 -*-

import os
import json

# 执行查询的curl命令
get_ambari_line = r'curl -s -u admin:admin -H "X-Requested-By: ambari" \
-X GET http://$HOSTNAME:8080/api/v1/clusters/bigdata/alerts?format=summary '

# 获取命令的返回结果
ambari_alerts = os.popen(get_ambari_line)

# 将获取结果转化为json格式
data = json.load(ambari_alerts)
# 获取对应的警告值
alert_num = data['alerts_summary']['WARNING']['count']

# 关闭连接
ambari_alerts.close()

# 判断警告状态
if alert_num >= 1:
    print(1)
else:
    print(0)



