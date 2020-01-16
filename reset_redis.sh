#!/bin/bash
# Need SSH 'no password' login
for i in {51..59}
do
	if [ $i -eq 57 ] ;then
		continue
	else
		ssh 192.168.4.$i "sed -ri '815s/^/#/' /etc/redis/6379.conf"
		ssh 192.168.4.$i "sed -ri '823s/^/#/' /etc/redis/6379.conf"
		ssh 192.168.4.$i "sed -ri '829s/^/#/' /etc/redis/6379.conf"
		ssh 192.168.4.$i "rm -rf /var/lib/redis/6379/*"
		ssh 192.168.4.$i "redis-cli -h 192.168.4.$i -p 63$i shutdown"
		ssh 192.168.4.$i "redis-server /etc/redis/6379.conf"
	fi
done
pssh -h /root/ip.redis -i ss -antup |grep redis
