#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Created by wind on 2019-12-03
import os
zkAlert = os.popen('su zookeeper -c "/opt/zookeeper/bin/zkServer.sh status" 2>&1 > /tmp/zk.print && cat /tmp/zk.print')
resultProcess = zkAlert.read()
zkStatus = resultProcess.split()[8]
zkAlert.close()
if zkStatus == "leader" or "follower" or "standalone":
    print(0)
else:
    print(1)

