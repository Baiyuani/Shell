#!/bin/bash
# Need SSH password free login required
# Configure yum is TURE
# redis-4.0.8.tar.gz place to /root/redis/
# 192.168.4.57 is manager host

CHECK (){
	if [ $? -eq 0 ] ;then
		echo "$1--->$i  -----------------------------------------YES"
	else
		echo "$1--->$i  -----------------------------------------NO"
	fi
}


for a in {51..59}
do
	if [ $a -eq 57 ] ;then
		continue
	else
		ssh 192.168.4.$a yum -y install gcc &> /dev/null
	fi
done &

for i in {51..59}
do
	if [ $i -eq 57 ] ;then
		continue
	else
		while :
		do
			sleep 1
			ssh 192.168.4.$i rpm -q gcc &> /dev/null
			if [ $? -eq 0 ] ;then
				break
			fi
		done
		ssh 192.168.4.$i tar -xf /root/redis/redis-4.0.8.tar.gz -C /root
		CHECK "tar -xf"
		ssh 192.168.4.$i make -C /root/redis-4.0.8
		CHECK "make"
		ssh 192.168.4.$i make install -C /root/redis-4.0.8
		CHECK "make install"
		ssh 192.168.4.$i /root/redis-4.0.8/utils/install_server.sh<<EOF







EOF
		CHECK "init"
		ssh 192.168.4.$i sed -ri "93s/6379/63$i/" /etc/redis/6379.conf
		ssh 192.168.4.$i sed -ri "70s/127.0.0.1/192.168.4.$i/" /etc/redis/6379.conf
		ssh 192.168.4.$i "redis-cli shutdown"
		CHECK "shutdown"
	        ssh 192.168.4.$i "redis-server /etc/redis/6379.conf"
		CHECK "start"
	fi
done

for j in {51..59}
do
	if [ $j -eq 57 ];then
		continue
	else
		ssh 192.168.4.$i "ss -antup |grep :63"
	fi
done
