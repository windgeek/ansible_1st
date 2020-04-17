#!/usr/bin/env bash
mysql  -uroot << EOF
set password = password("{{root_pass}}");
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '{{root_pass}}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@localhost IDENTIFIED BY '{{root_pass}}';
CREATE USER 'servent'@'%' IDENTIFIED BY '{{servent_pass}}';
GRANT ALL PRIVILEGES ON *.* TO 'servent'@'%' IDENTIFIED BY '{{servent_pass}}' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'servent'@'localhost' IDENTIFIED BY '{{servent_pass}}' WITH GRANT OPTION;
GRANT REPLICATION SLAVE,REPLICATION CLIENT ON *.* to 'servent'@'%' identified by '{{servent_pass}}';
GRANT REPLICATION SLAVE,REPLICATION CLIENT ON *.* to 'servent'@'localhost' identified by '{{servent_pass}}';
flush privileges;
EOF
