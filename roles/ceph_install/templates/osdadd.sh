 #!/bin/bash  
i=1
while [[ $i -lt {{number}} ]]                  #硬盘数量,除系统盘之外是12块
do
j=`echo $i|awk '{printf "%c",97+$i}'` #系统盘是sda,如果是其它的需要修改脚本 
parted /dev/{{disk_lable}}${j} mklabel gpt -s     #磁盘初始化
ceph-volume lvm zap /dev/{{disk_lable}}${j}       #清理磁盘
i=$(($i+1))
done
