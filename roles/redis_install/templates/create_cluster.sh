#!/bin/bash
set timeout 300
expect -c"
   spawn  /opt/redis-5.0.2/src/redis-cli --cluster create {{redis1}}:7000 {{redis2}}:7001 {{redis2}}:7000 {{redis3}}:7001 {{redis3}}:7000 {{redis1}}:7001 --cluster-replicas 1
   expect {
      \"*(type 'yes' to accept)*\" {send \"yes\r\";exp_continue}
   }"
