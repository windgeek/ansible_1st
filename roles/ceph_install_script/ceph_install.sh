#!/bin/bash
#需要注意修改本脚本变量（osdmaster处盘数）以及ceph.conf ceph_rgw.conf中的配置以及 osdadd.sh中盘数变量

BATHPATH=$(cd `dirname $0`; pwd)
script_path=${BATHPATH}
PORT=3222
mon_name=(
platform-server-4
platform-server-5
platform-server-6
)
node_all='platform-server-4 platform-server-5 platform-server-6'
node_name=(
platform-server-4
platform-server-5
platform-server-6
)

function base(){
  yum install zlib -y
  yum install zlib-devel -y
  yum install ceph-deploy -y
  unzip $script_path/distribute-0.7.3.zip
  cd $script_path/distribute-0.7.3
  python setup.py install
  easy_install distribute
  mkdir /etc/ceph
  cd /etc/ceph
  ceph-deploy new ${mon_name[0]} ${mon_name[1]} ${mon_name[2]}
  ceph-deploy install --no-adjust-repos $node_all
  cd /etc/ceph
  ceph-deploy mon create-initial
  cat $script_path/ceph.conf >> /etc/ceph/ceph.conf
  ceph-deploy --overwrite-conf admin $node_all
  chmod +r /etc/ceph/ceph.client.admin.keyring
  systemctl restart ceph-mon@${mon_name[0]}
  systemctl restart ceph-mon@${mon_name[1]}
  systemctl restart ceph-mon@${mon_name[2]}
}


function osdnode(){
cd /etc/ceph
  for ((i=0;i<${#node_name[*]};i++))
    do
    	scp $script_path/osdadd.sh ${node_name[i]}:/tmp/
    done
  for ((i=0;i<${#node_name[*]};i++))
    do
        ssh -Tqp ${PORT} root@${node_name[i]} <<remotessh
    sh /tmp/osdadd.sh
remotessh
    done
}


function osdmaster(){
a=1
cd /etc/ceph
        for ((i=0;i<${#node_name[*]};i++))
        do
          while [ $a -lt 2 ]                  #硬盘数量加1
          do
          j=`echo $a|awk '{printf "%c",97+$a}'` #系统盘是sda,如果是其它的需要修改脚本
          ceph-deploy osd create --data /dev/sd${j} ${node_name[i]}
          a=$(($a+1))
          done
          a=1
        done
}


function mgr(){
cd /etc/ceph
  ceph-deploy mgr create ${mon_name[0]} ${mon_name[1]} ${mon_name[2]}
  systemctl enable ceph-mgr@${mon_name[0]}
  systemctl start ceph-mgr@${mon_name[0]}
  systemctl enable ceph-mgr@${mon_name[1]}
  systemctl start ceph-mgr@${mon_name[1]}
  systemctl enable ceph-mgr@${mon_name[2]}
  systemctl start ceph-mgr@${mon_name[2]}
  echo -e "\n[mgr]\nmgr modules = dashboard" >> /etc/ceph/ceph.conf
  ceph-deploy --overwrite-conf config push $node_all
  ceph mgr dump
  ceph mgr module enable dashboard
}


function rgw(){
cd /etc/ceph
  ceph-deploy install --no-adjust-repos --rgw $node_all
  cat $script_path/ceph_rgw.conf >> /etc/ceph/ceph.conf
  ceph-deploy --overwrite-conf config push $node_all
  ceph-deploy rgw create $node_all
  for ((i=0;i<${#node_name[*]};i++))
        do
                ssh -Tqp ${PORT} root@${node_name[i]} <<remotessh
        systemctl restart ceph-radosgw@rgw.$HOSTNAME.service
remotessh
        done
}

function grant(){
cd /etc/ceph
  radosgw-admin user create --uid="admin" --display-name="admin"
  radosgw-admin caps add --uid=admin --caps="users=*"
  radosgw-admin caps add --uid=admin --caps="buckets=*"
  radosgw-admin caps add --uid=admin --caps="metadata=*"
  radosgw-admin caps add --uid=admin --caps="usage=*"
}

base
osdnode
osdmaster
mgr
rgw
grant




