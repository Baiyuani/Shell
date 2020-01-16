#!/bin/bash
for i in {51..56}
do
	ssh 192.168.4.$i "sed -ri '815s/# //' /etc/redis/6379.conf"
	ssh 192.168.4.$i "sed -ri '823s/# //' /etc/redis/6379.conf"
	ssh 192.168.4.$i "sed -ri '829s/# //' /etc/redis/6379.conf"
	ssh 192.168.4.$i "sed -ri '829s/15000/5000/' /etc/redis/6379.conf"
	ssh 192.168.4.$i "redis-cli -h 192.168.4.$i -p 63$i shutdown"
	ssh 192.168.4.$i "/etc/init.d/redis_6379 start"
	ssh 192.168.4.$i "ss -antup |grep redis"
done
