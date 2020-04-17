#!/usr/bin/env bash
sed -i '' 's/192.168.5.75:6667,192.168.5.76:6667/{{kafkaBrokerList}}/g' templates/*.yaml
sed -i '' 's/192.168.5.75:6667/{{monKafkaBrokerList}}/g' templates/*.yaml
sed -i '' 's/index_data/{{esClusterName}}/g' templates/*.yaml
sed -i '' 's/192.168.5.75,192.168.5.76/{{esNode}}/g' templates/*.yaml
sed -i '' 's/TSE/{{region}}/g' templates/*.yaml
sed -i '' 's/192.168.5.75:8899/{{cephEndPoint}}/g' templates/*.yaml
sed -i '' 's/9F8YOOSILYZ4ZBFXTHXE/{{cephAccessKeyId}}/g' templates/*.yaml
sed -i '' 's/skMSk9RF6gn0rMiocsQPxEDLG9kPhnx0mMyI8O6i/{{cephAccessKeySecret}}/g' templates/*.yaml
sed -i '' 's/k19-bigdata-1,k19-bigdata-2/{{hbaseZkNodes}}/g' templates/*.yaml


