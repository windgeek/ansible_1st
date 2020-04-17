#!/bin/sh
#Author:jianlong.zhang
#Date:2018-09-16
###########################################################
#1、此脚本开启真正服务器上的IP
#2、需要传一个参数{start|stop|restart|status}
#3、注意VIP地址的正确性
###########################################################


##########################以下变量请严格配置################################
VIP={{vip}}
##########################以上变量请严格配置################################


LOCK=/var/lock/ipvsadm.lock
. /etc/rc.d/init.d/functions


	#1 步骤输出 紫色
	#2 正确输出 绿色
	#3 错误输出 红色
	#4 提示输出 蓝色
	#5 警告输出 黄色

function echo_fun(){
	if [ $# -ge 2 ]
	then
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


start() {
	PID=`ifconfig | grep lo:0: | wc -l`
	if [ $PID -ne 0 ];
	then
		echo_fun 5 "The LVS-RIP Server is already running !"
	else
		# 配置tunl0网卡 255.255.255.255 建议不要动
		/sbin/ifconfig lo:0 $VIP netmask 255.255.255.255 broadcast $VIP up
		# 配置lo网卡的反向路由策略
		echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
		echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
		echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
		echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
		# 配置防火墙允许ipip协议的数据包通过
		##############################################
		#iptables -I INPUT 1 -p 4 -j ACCEPT
		###############################################
		/bin/touch $LOCK
		echo_fun 2 "starting LVS-RIP server is ok !"
	fi
}


stop() {
	if [ -e $LOCK ];
	then
		#关闭lo:0网卡
		/sbin/ifconfig lo:0 down
		# 删除防火墙中允许ipip协议的数据包通过策略
		##############################################
		#iptables -D INPUT -p 4 -j ACCEPT
		#############################################
		echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
		echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
		echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
		echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
		rm -rf $LOCK
		echo_fun 2 "stopping LVS-RIP server is ok !"
	else
		echo_fun 5 "LVS-RIP was not running"
	fi
}



status() {
	if [ -e $LOCK ];
	then
		echo_fun 2 "The LVS-RIP Server is already running !"
	else
		echo_fun 3 "The LVS-RIP Server is not running !"
	fi
}

case "$1" in
	start)
		start
	;;
	stop)
		stop
	;;
	restart)
		stop
	sleep 1s
		start
	;;
	status)
		status
	;;
	*)
		echo_fun 3 "Usage: $1 {start|stop|restart|status}"
	exit 1
esac
exit 0
