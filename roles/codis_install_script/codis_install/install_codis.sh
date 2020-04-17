# README
#脚本分两个部分执行，注意要将两个脚本放在同级目录下。
#codis安装的集群机器ip，第一台一定为脚本运行的机器


#安装时，需要将脚本与codis安装包放在同一目录
##################需要改的地方,ip#########################
host_ip=(
10.4.43.8
10.4.43.9
)
##################需要改的地方,端口,密码#########################
port=22
USER_CODIS='codis'
PASSWORD='codis'
User_home='/home/codis'
product_auth='k18k18'  ###这个不能改,如果需要更改请全局替换
product_name='codis_cluster'
##################需要改的地方,zk###############################
ZK_ADDR='10.4.41.75:2181,10.4.41.76:2181,10.4.41.77:2181'


###############################################################################################
basepath=$(cd `dirname $0`; pwd)
SOFTWARE_PATH=$basepath                          #codis二进制安装包存放路径
CODIS_VERSION='codis-3.2.94'  				#codis的版本，注意这里不加.tar.gz
GO_VERSION='go1.8.3.linux-amd64'
INSTALL_PATH='/opt'                         #codis的安装路径

conf_path='/opt/codis/config'            

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
        echo -e "\033[35;40;1m ****************************** ${params_mes} ******************************\033[0m\r\n"
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


# 初始化配置
function init_fun(){
  echo_fun 4 检查两台机器vm.overcommit_memory是否为1，如果不存在或者不是1，修改为1
  for i in ${host_ip[@]}
  do
ssh -Tqp ${port} ${i} <<remotessh
  hostname
  if [ `cat /etc/sysctl.conf | grep vm.overcommit_memory\ =\ 1 | wc -l` -ne 0 ];then
    echo -e "\033[36;40;1m ${i} 上存在vm.overcommit_memory = 1\033[0m\r\n"
	echo -e "\033[36;40;1m 无需修改！\033[0m\r\n"
  else
    echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
    echo -e "\033[36;40;1m 修改成功\033[0m\r\n"
  fi
  sysctl -p
remotessh
  done
}



user_add(){
  echo -e "创建codis用户"
  for i in ${host_ip[@]}
  do
ssh -Tqp ${port} ${i} <<remotessh
groupadd ${USER_CODIS}
useradd -g ${USER_CODIS} ${USER_CODIS} && echo ${PASSWORD} | passwd --stdin ${USER_CODIS}
yum install git autoconf -y -q
remotessh
done
}



#解压安装包，并设置软连接，和改变其属组属性。
function extract_tar(){
  #拷贝本地到指定第一台机器
  scp -o StrictHostKeyChecking=no -rq -P ${port} $SOFTWARE_PATH/${CODIS_VERSION}.tar.gz root@${host_ip[0]}:/$INSTALL_PATH/
  echo_fun 4 解压Codis，Go
  echo_fun 4 安装GO语言
ssh -Tqp ${port} ${host_ip[0]} <<EOF
  cd $INSTALL_PATH
  sleep 1s

  tar -xf ${CODIS_VERSION}.tar.gz -C ${INSTALL_PATH}
  sleep 2s
  
  cd ${INSTALL_PATH}/codis
  tar -xf ${GO_VERSION}.tar.gz -C .

  chown -R ${USER_CODIS}:${USER_CODIS} ${INSTALL_PATH}/codis
  sleep 1s
  exit
EOF
}

#定义修改配置文件

function alter_config(){
  echo_fun 4 修改codis配置文件内容
for i in ${host_ip[0]}
  do
ssh -Tqp ${port} ${i} <<EOF
  sleep 1s
  cd ${INSTALL_PATH}/codis/config
  sed -i 's/\(coordinator_addr = \)\S*/\1"'${ZK_ADDR}'"/g' dashboard.toml
  sed -i 's/\(admin_addr = \)\S*/\1"'${i}:18080'"/g' dashboard.toml
  sed -i 's/\(product_name = \)\S*/\1"'${product_name}'"/g' dashboard.toml
  sed -i 's/\(product_auth = \)\S*/\1"'${product_auth}'"/g' dashboard.toml

  # 修改proxy6900.toml
  sed -i 's/\(product_name = \)\S*/\1"'${product_name}'"/g' proxy6900.toml
  sed -i 's/\(product_auth = \)\S*/\1"'${product_auth}'"/g' proxy6900.toml
  sed -i 's/\(admin_addr = \)\S*/\1"'${i}:11080'"/g' proxy6900.toml
  sed -i 's/\(proxy_addr = \)\S*/\1"'${i}:19000'"/g' proxy6900.toml
  sed -i 's/\(jodis_addr = \)\S*/\1"'${ZK_ADDR}'"/g' proxy6900.toml
  # 修改proxy6901.toml
  sed -i 's/\(product_name = \)\S*/\1"'${product_name}'"/g' proxy6901.toml
  sed -i 's/\(product_auth = \)\S*/\1"'${product_auth}'"/g' proxy6901.toml
  sed -i 's/\(admin_addr = \)\S*/\1"'${i}:11081'"/g' proxy6901.toml
  sed -i 's/\(proxy_addr = \)\S*/\1"'${i}:19001'"/g' proxy6901.toml
  sed -i 's/\(jodis_addr = \)\S*/\1"'${ZK_ADDR}'"/g' proxy6901.toml
  exit
EOF
  done
  echo_fun 2 配置修改完成
}

#同步安装包和软连接到其他的集群机器上并修改配置内容
function rsync_tar(){
  echo_fun 4 同步codis安装包到其他的机器上、修改配置内容和环境变量
ssh -Tqp ${port} ${host_ip[0]} <<EOF
  sleep 1s
  #for ((i=1;i<${#host_ip[*]};i++))
  #do
  #rsync -av "-e ssh -p ${port}" ${INSTALL_PATH}/codis ${host_ip[1]}:/opt > /dev/null
  scp -o StrictHostKeyChecking=no -P ${port} -rq ${INSTALL_PATH}/codis ${host_ip[1]}:/opt
  
ssh -Tqp ${port} ${host_ip[1]} <<remotessh
  chown -R ${USER_CODIS}.${USER_CODIS} ${INSTALL_PATH}/codis
  cd ${INSTALL_PATH}/codis/config
  # 修改proxy6900.toml
  sed -i 's/\(admin_addr = \)\S*/\1"'${host_ip[1]}:11080'"/g' proxy6900.toml
  sed -i 's/\(proxy_addr = \)\S*/\1"'${host_ip[1]}:19000'"/g' proxy6900.toml
  # 修改proxy6901.toml
  sed -i 's/\(admin_addr = \)\S*/\1"'${host_ip[1]}:11081'"/g' proxy6901.toml
  sed -i 's/\(proxy_addr = \)\S*/\1"'${host_ip[1]}:19001'"/g' proxy6901.toml

  exit
remotessh
  exit
  #done
EOF

  echo_fun 2 同步成功
}

#设置环境变量
function edit_env(){
  for i in ${host_ip[@]}
  do
ssh -Tqp ${port} $i <<remotessh
  echo "添加GO的环境变量"
  echo -e '\nexport GOROOT=/opt/codis/go\nexport PATH=\$PATH:\$GOROOT/bin\nexport GOPATH=/opt/codis' > /etc/profile.d/codis.sh
  source /etc/profile.d/codis.sh
  if [ `go version &>/dev/null;echo $?` -eq 0 ];then
	echo "GO Have SetUp Seccessful..."
  else
	echo "Please Checkup You Go Before Install Codis"
	exit
  fi
remotessh
  done
}



#启动dashboard和fe
function start_service(){
  echo_fun 4 启动dashboard, fe
  zk_addr=${ZK_ADDR}  
  echo -e "zk的地址是${zk_addr}"
ssh -Tqp ${port} ${host_ip[0]} <<EOF
  echo -e "切换到codis用户"
  su - codis <<eof
  cd ${INSTALL_PATH}/codis
  nohup ./bin/codis-dashboard > /dev/null  --ncpu=4 --config=config/dashboard.toml --log=logs/dashboard.log --log-level=WARN 2>&1 &
  nohup ./bin/codis-fe > /dev/null --ncpu=4 --log=logs/fe.log --log-level=WARN --zookeeper=${zk_addr} --listen=${host_ip[0]}:8080 2>&1 &
  exit
eof
  echo -e "退出codis用户"
EOF
echo_fun 2 dashboard,fe 启动成功
}



#启动主节点服务
function start_service2(){
ssh -Tqp ${port} ${host_ip[0]} <<remotessh
su - codis <<EOF
  cd ${INSTALL_PATH}/codis
  echo -e "\033[36;40;1m 启动主机器的proxy\033[0m\r\n"
  echo "时间有点长请稍等"
  nohup ./bin/codis-proxy > /dev/null --ncpu=4 --config=config/proxy6900.toml --log=logs/proxy6900.log --log-level=WARN &
   sleep 1
  nohup ./bin/codis-proxy > /dev/null --ncpu=4 --config=config/proxy6901.toml --log=logs/proxy6901.log --log-level=WARN &
  sleep 1
  echo   "proxy 启动成功"
  echo -e "\033[36;40;1m 启动codis server\033[0m\r\n"
  nohup ./bin/codis-server > /dev/null config/redis6900.conf &
  sleep 1
  nohup ./bin/codis-server > /dev/null  config/redis6901.conf &
  sleep 1
  echo  "codis server 启动成功"
EOF
remotessh
}


#修改主节点密码
function start_service3(){
ssh -Tqp ${port} ${host_ip[0]} <<remotessh
su - codis <<EOF
  cd ${INSTALL_PATH}/codis
  echo -e "\033[36;40;1m 设置codis密码\033[0m\r\n"
  sleep 1s
  /opt/codis/bin/redis-cli -h ${host_ip[0]} -p 6900 <<eof
  CONFIG SET requirepass "k18k18"
  AUTH k18k18
  exit
eof
  echo -e "设置另一个密码"
  sleep 1s
  /opt/codis/bin/redis-cli -h ${host_ip[0]} -p 6901 <<eof
  CONFIG SET requirepass "k18k18"
  AUTH k18k18
  exit
eof
EOF
remotessh
}



#修改从节点密码，启动从节点上的服务
function start_service4(){
ssh -Tqp ${port} ${host_ip[1]} <<remotessh
su - codis <<EOF
  cd ${INSTALL_PATH}/codis
  echo -e "\033[36;40;1m 启动从机器的proxy\033[0m\r\n"
  echo "时间有点长请稍等"
  nohup ./bin/codis-proxy > /dev/null --ncpu=4 --config=config/proxy6900.toml --log=logs/proxy6900.log --log-level=WARN &
  sleep 1
  nohup ./bin/codis-proxy > /dev/null --ncpu=4 --config=config/proxy6901.toml --log=logs/proxy6901.log --log-level=WARN &
  sleep 1
  echo   "proxy 启动成功"
  echo -e "\033[36;40;1m 启动codis server\033[0m\r\n"
  nohup ./bin/codis-server > /dev/null config/redis6900.conf &
  sleep 1
  nohup ./bin/codis-server > /dev/null  config/redis6901.conf &
  sleep 1
  echo  "codis server 启动成功"
  echo -e "\033[36;40;1m 设置codis密码\033[0m\r\n"
  echo -e "修改6900的密码"
  sleep 1s
  /opt/codis/bin/redis-cli -h ${host_ip[1]} -p 6900 <<eof
  CONFIG SET requirepass "k18k18"
  AUTH k18k18
  exit
eof
  echo -e "修改6901的密码"
  sleep 1s
  /opt/codis/bin/redis-cli -h ${host_ip[1]} -p 6901 <<eof
  CONFIG SET requirepass "k18k18"
  AUTH k18k18
  exit
eof
EOF
remotessh
  echo_fun 2 服务启动成功
}



#添加组
function add_group(){
ssh -Tqp ${port} ${host_ip[0]} <<remotessh
  su - codis <<EOF
  cd ${INSTALL_PATH}/codis
  echo -e "\033[36;40;1m 添加proxy\033[0m\r\n"
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --create-proxy -x ${host_ip[0]}:11080
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --create-proxy -x ${host_ip[0]}:11081
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --create-proxy -x ${host_ip[1]}:11080
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --create-proxy -x ${host_ip[1]}:11081
  echo -e "\033[36;40;1m 添加组\033[0m\r\n"
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080  --create-group --gid=1
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --group-add --gid=1 --addr=${host_ip[0]}:6900
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --group-add --gid=1 --addr=${host_ip[1]}:6901
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080  --create-group --gid=2
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --group-add --gid=2 --addr=${host_ip[0]}:6901
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --group-add --gid=2 --addr=${host_ip[1]}:6900
EOF
remotessh
}


#后台rebalence和sync同步
function rebleance(){
ssh -Tqp ${port} ${host_ip[0]} <<remotessh
  su - codis <<EOF
  cd ${INSTALL_PATH}/codis
  echo -e "\033[36;40;1m reblance槽位分配\033[0m\r\n"
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --rebalance --confirm
  echo -e "\033[36;40;1m rync同步\033[0m\r\n"
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --sync-action --create --addr=${host_ip[0]}:6900
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --sync-action --create --addr=${host_ip[1]}:6901
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --sync-action --create --addr=${host_ip[0]}:6901
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --sync-action --create --addr=${host_ip[1]}:6900
EOF
remotessh
}

#添加额外监控页面
function sentinel(){
for i in ${host_ip[@]}
  do
ssh -Tqp ${port} ${i} <<remotessh
  su - codis <<EOF
  cd ${INSTALL_PATH}/codis
  mkdir sentinel
  sed -i 's#\(^dir \)[^$]*#\1"/opt/codis/sentinel"#g' config/sentinel.conf
  sed -i 's/# bind 127.0.0.1 192.168.1.1/bind '${i}'/g' config/sentinel.conf
  nohup /opt/codis/bin/codis-server > /dev/null config/sentinel.conf --sentinel &
  echo "启动${i}的sentinel"
  /opt/codis/bin/codis-admin --dashboard=${host_ip[0]}:18080 --sentinel-add --addr=${i}:26379
  echo "添加并rync"
  ./bin/codis-admin --dashboard=${host_ip[0]}:18080 --sentinel-resync
EOF
remotessh
  done
}





echo_fun 1 本脚本为Codis的部署安装（请在脚本中修改要安装的Host ip）
sleep 1
echo_fun 4 安装机器为 ${host_ip[0]} ${host_ip[1]}, 其中 ${host_ip[0]} 为dashboard, fe节点
sleep 3


#初始化
init_fun


#添加codis用户
user_add
#解压
extract_tar
#修改配置文件
alter_config
#传输到从节点
rsync_tar
#环境变量
edit_env



#开启dashboard,fe
start_service
#proxy,redis
start_service2
#设置密码
start_service3
#从节点开启
start_service4
#添加组
add_group

#后台rebalence和sync同步
rebleance
#添加额外监控页面
sentinel
