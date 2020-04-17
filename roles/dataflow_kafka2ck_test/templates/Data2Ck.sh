#!/usr/bin/env bash

fullName=$(readlink -f $0)
fullPath=$(dirname ${fullName})
cd $fullPath/../
jar uvf {{jar_version}} conf/conf.yaml
java -cp {{jar_version}} com.bfd.application.Data2CkTest
