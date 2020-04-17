#!/usr/bin/env bash
sed -i '' 's/kafka2ck-4.6-jar-with-dependencies.jar/{{jar_version}}/g' templates/*.sh
sed -i '' 's/{{hdfsActiveNamenode}}/{{hdfsHAClusterName}}/g' templates/*.sh
