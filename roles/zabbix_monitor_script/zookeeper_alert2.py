#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Created by wind on 2019-12-03
import subprocess


def run_cmd(cmd):
    # Popen call wrapper.return (code, stdout, stderr)
    child = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = child.communicate()
    ret = child.wait()
    # return (ret, out, err)
    return (out)


if __name__ == '__main__':
    r=run_cmd('su zookeeper -c "/opt/zookeeper/bin/zkServer.sh status"')
    # print(r, type(r))
    # strip()去除头尾空格\n \t \r， replace替换中间的空格
    zkStatus = r.strip().replace(" ", "").split(':')[1]
    if zkStatus == "leader" or "follower" or "standalone":
        print(0)
    else:
        print(1)
