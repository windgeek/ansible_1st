#!/usr/bin/env bash
sed -i '' 's/k19-bigdata-1:8020/{{hdfsHAClusterName}}/g' templates/*.sh
sed -i '' 's/https-kafka2es-2.3-jar-with-dependencies.jar/{{jar_version}}/g' templates/*.sh
