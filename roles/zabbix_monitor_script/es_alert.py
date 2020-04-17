#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Created by wind on 2019-12-03
import os


def resultProcess(cmd, index):
    ShellAlert = os.popen(cmd)
    resultProcess = ShellAlert.read()
    ShellStatus = resultProcess.split()[index]
    ShellAlert.close()
    return ShellStatus


if __name__ == '__main__':
    if resultProcess('curl -s http://$HOSTNAME:9200/_cat/health?v', 17) == 'green':
        print(0)
    else:
        print(1)


