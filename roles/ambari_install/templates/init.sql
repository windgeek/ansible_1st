create database ambari character set utf8;
create user ambari identified by '{{ambari_mysql_password}}';
grant all privileges on ambari.* to 'ambari'@'localhost' identified BY '{{ambari_mysql_password}}';
grant all privileges on ambari.* to 'ambari'@'%' identified BY '{{ambari_mysql_password}}';

create database hive character set utf8;
grant all privileges on hive.* to 'hive'@'localhost' identified BY '{{hive_mysql_password}}';
grant all privileges on hive.* to 'hive'@'%' identified BY '{{hive_mysql_password}}';
flush privileges;
