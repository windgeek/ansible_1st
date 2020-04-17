# 使用说明

## 注意事项
确保 yum 源中包含 clickhouse 的rpm安装包。
ansible server 和 被安装主机之间免密。

## 变量修改
1.在 template/metrika.xml 中修改循环的ranger范围
有三处地方需要修改
示例如下：{% for i in range(1,5,2) %}
- 第一处：设置读集群主机名的编号部分的范围
如："1,5,2" 表示主机名编号范围为1-4 步长为2 `包含头，不包含尾` (步长为2 适用于有副本的读集群)

- 第二处：设置写集群的主机名编号部分的范围
如："1,5,2" 表示主机名编号范围为1-4 步长为2 `包含头，不包含尾` (步长为2 适用于有副本的写集群)

- 第三处：设置zk集群的主机名编号部分的范围
如："1,4,1" 表示主机名编号范围为1-3 步长为1 `包含头，不包含尾` 

2.在 template/metrika.xml 中修改集群名称
- 括号内引用变量`<{{network_write_clutser_name}}>`

3.修改 vars/main.yml 下的变量
- 变量上方有注释，按照注释内容修改即可

4.修改hosts文件自定义变量
- 如 `macros_shard="1" macros_replica="01"`


## 执行方式
ansible-playbook /etc/ansible/playbooks/clickhouse_cluster_replica.yml 
