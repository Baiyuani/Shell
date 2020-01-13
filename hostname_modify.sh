#!/bin/bash
# Batch modify host name



for i in {51..56}
do
	ssh root@192.168.4.$i "hostnamectl set-hostname redis$i"
	if [ $? -eq 0 ];then
		ssh 192.168.4.$i  hostname
	else
		echo "$i error"
	fi
done
