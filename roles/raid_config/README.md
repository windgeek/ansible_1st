_example_


firstly，use cat.sh to cat the config now

`ansible-playbook /etc/ansible/playbooks/raid_config.yml --extra-vars "hosts=mysql_host raid_sh=raid5.sh"`