#!/bin/bash

#############
#postgres数据库用户密码设置成k18k18
#
#
#
##############

#系统版本号
RELEASE=''
#postgresql安装包名
POSTGRESQL_VERSION='{{postgresql_version}}'

#postgresql安装的位置
POSTGRESQL_INSTALL_PATH='{{postgresql_install_path}}'

#数据目录的位置
DATA_PATH='{{data_path}}'


#普通用户,用来启动postgresql数据库
PSQL_USER='postgres'
PASSWORD='postgres'


#获取操作系统的版本号
RELEASE=`lsb_release -a |grep  Release |awk '{print $2}'|awk -F '.' '{print $1}'`

#1 步骤输出 紫色
#2 正确输出 绿色
#3 错误输出 红色
#4 提示输出 蓝色
#5 警告输出 黄色
function echo_fun(){
  if [ $# -ge 2 ];then
     params_num=$1
     shift 1
     params_mes=$@
  else
    echo_fun 3 请至少输入两个参数 echo_fun ..
    exit
  fi
  case $params_num in
        1)
        echo -e "\033[35;40;1m  ***************************** ${params_mes} *****************************\033[0m\r\n"
        ;;
        2)
        echo -e "\033[32;40;1m ${params_mes}\033[0m\r\n"
        ;;
        3)
        echo -e "\033[31;40;1m ${params_mes}\033[0m\r\n"
        ;;
        4)
        echo -e "\033[36;40;1m ${params_mes}\033[0m\r\n"
        ;;
        5)
        echo -e "\033[33;40;1m ${params_mes} \033[0m\r\n"
        ;;
        *)
        echo_fun 3 参数异常第一个参数应为1,2,3,4,5
        ;;
   esac
}


#部署
echo_fun 1 postgresql部署安装

#postgresql源码编译
mkdir -p ${POSTGRESQL_INSTALL_PATH}/log

#编译的时候可能需要解决下面3个依赖
yum install -y gcc gcc-c++
yum install -y readline-devel
yum install -y zlib-devel

#编译安装到/opt/postgresql下
cd /tmp/${POSTGRESQL_VERSION}
./configure --prefix=${POSTGRESQL_INSTALL_PATH}
sleep 10s
make && make install
sleep 10s


#配置环境变量和指定PGDATA位置
echo_fun 4 配置环境变量和指定PGDATA位置
echo -e '\nexport POSTGRESQL_HOME='${POSTGRESQL_INSTALL_PATH}'\nexport PATH=${POSTGRESQL_HOME}/bin:$PATH\nexport PGDATA='${DATA_PATH}'\n'> /etc/profile.d/postgresql.sh
source /etc/profile.d/postgresql.sh


#创建用户,用来启动postgresql
echo_fun 4 创建用户,用来启动postgresql
#useradd  ${PSQL_USER}
useradd  ${PSQL_USER} && echo ${PASSWORD} | passwd --stdin ${PSQL_USER}

#创建目录并授权
cd ${POSTGRESQL_INSTALL_PATH}/../
chown -R ${PSQL_USER}:${PSQL_USER} ${POSTGRESQL_INSTALL_PATH}
mkdir -p ${DATA_PATH}
last_path=`echo ${DATA_PATH} | awk -F "/" '{print"/"$2"/"$3"/"}'`
chown -R ${PSQL_USER}:${PSQL_USER} ${last_path}


#初始化postgresql数据库
echo_fun 4 初始化postgresql数据库
su - ${PSQL_USER} <<EOF
initdb
sleep 10s
EOF


#修改postgresql的配置文件
echo_fun 4 修改postgresql的配置文件
cd ${DATA_PATH}
sed -i 's/127.0.0.1\/32            trust/0.0.0.0\/0               md5/g' pg_hba.conf
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" postgresql.conf
sed -i 's/#port = 5432/port = 5432/g' postgresql.conf


#启动postgresql
echo_fun 4 启动postgresql
ln -s /opt/postgresql/lib/libpq.so.5 /usr/lib/libpq.so.5
ln -s /opt/postgresql/lib/libpq.so.5 /usr/lib64/libpq.so.5
su - ${PSQL_USER} <<EOF
pg_ctl -D ${DATA_PATH} -l ${POSTGRESQL_INSTALL_PATH}/log/pg_server.log start
EOF

#检查postgresql启动进程
psql_pid_num=`ps -ef |grep ${DATA_PATH}|grep -v grep|wc -l`
if [ $psql_pid_num -eq 1 ];then
  echo_fun 2 安装成功,并已经启动postgresql服务
else
  echo_fun 3 安装失败
fi
