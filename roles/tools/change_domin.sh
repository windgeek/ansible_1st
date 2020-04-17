#!/bin/sh

#file_dir='/etc/nginx'
#file_dir='/opt/application'
#file_dir='/opt/k18web'



old_domin=(
bigdata.kf.kz
bigdata-system.kf.kz
bigdata-cas.kf.kz
bigdata-discover.kf.kz
bigdata-analy.kf.kz
bigdata-eventwarn.kf.kz
bigdata-data.kf.kz
bigdata-network.kf.kz
bigdata-bi.kf.kz
kf.kz
)

new_domin=(
k18-test.com.cn
k18-test-system.com.cn
k18-test-cas.com.cn
k18-test-discover.com.cn
k18-test-analy.com.cn
k18-test-eventwarn.com.cn
k18-test-data.com.cn
k18-test-network.com.cn
k18-test-bi.com.cn
com.cn
)


function change_begin(){

#替换
for ((i=0;i<${#old_domin[*]};i++))
do
	
	for file in `grep -i ${old_domin[i]} -rl ${file_dir} | grep -v -E '*.log$' | grep -v -E '*.jar$' | grep -v -E '*.tar.gz$' | grep -v -E '*.war$'`
	do
		echo $file
        	sed -i "s|${old_domin[i]}|${new_domin[i]}|ig" $file
	done

done

echo "替换成功"

}


change_begin

