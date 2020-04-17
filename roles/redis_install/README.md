该ansible脚本完成redis-5.0.2三主三从自动化部署
执行之前，需要检查var/main.yml中redis_master定义的机器上的yum源是否有expect这个依赖(使用Centos7的源，离线源放在172.24.4.169:/etc/yum.repos.d/expect下了,jio本可以改成离线安装，该版本jio本省略......)
cd /etc/ansible
ansible-playbook ansible-playbook playbooks/redis.yml
使用时，需要修改一下内容：
1.hosts文件[redis_hosts]下的ip信息
2.var/main.yml文件修改机器IP信息
3.如果想更换服务端口,修改templates/redis7000.conf.j2和templates/redis7001.conf.j2两个配置文件中端口相关的配置,并对应修改task/main.yml中创建目录的名称、启动命令中指定配置文件的目录以及启动脚本中创建集群命令中的端口信息
