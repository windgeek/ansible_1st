#!/usr/bin/env bash
sed -i '' 's/192.168.162.95:6667,192.168.162.96:6667/{{kafkaBrokerList}}/g' templates/*.yaml
sed -i '' 's/192.168.162.95:36667,192.168.162.95:46667/{{kafkaBrokerList}}/g' templates/*.yaml
sed -i '' 's/bjlg-3p208-lisong:8123,bjlg-3p209-lisong:8123/{{clickhouseIpPort}}/g' templates/*.yaml
sed -i '' 's/172.16.3.209:3306/{{geoIpMysql}}/g' templates/*.yaml
sed -i '' 's/k18k18/{{geoIpMysqlRootPasswd}}/g' templates/*.yaml
sed -i '' 's/TSE/{{region}}/g' templates/*.yaml
sed -i '' '8,$s/{{kafkaBrokerList}}/{{monKafkaBrokerList}}/g' templates/*.yaml
sed -i '' 's#userName: ""#username: {{ck_username}}#g' templates/*.yaml
sed -i '' 's#password: ""#password: {{ck_password}}#g' templates/*.yaml
sed -i '' 's#username: {{ck_username}}#userName: {{ck_username}}#g' templates/*.yaml
