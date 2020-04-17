#!/usr/bin/env bash
expect -c "spawn /usr/sbin/ambari-server setup
    set timeout 30
    expect {
          \"*SELinux*\" {send \"y\r\";exp_continue}
          \"*Customize user account*\" {send \"y\r\";exp_continue}
          \"*Enter user account for*\" {send \"ambari\r\";exp_continue}
          \"*Enter choice*\" {send \"3\r\";exp_continue}
          \"*JAVA_HOME*\" {send \"{{java_home}}\r\";exp_continue}
          \"*change Oracle JDK*\" {send \"y\r\";exp_continue}
          \"*Enter advanced database configuration*\" {send \"y\r\";exp_continue}
          \"*MySQL / MariaDB*\" {send \"3\r\";exp_continue}
          \"Hostname*\" {send \"{{ansible_hostname}}\r\";exp_continue}
          \"*Port*\" {send \"{{mysql_port}}\r\";exp_continue}
          \"Database name*\" {send \"ambari\r\";exp_continue}
          \"*Username*\" {send \"ambari\r\";exp_continue}
          \"*Database Password*\" {send \"{{mysql_password}}\r\";exp_continue}
          \"*Re-enter password*\" {send \"{{mysql_password}}\r\";exp_continue}
          \"*connection properties*\" {send \"y\r\";exp_continue}
    }"