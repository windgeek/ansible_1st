#!/bin/bash
#
find /data1/allot -mtime +2 -type f -name "*" -exec rm -rf {} \;
