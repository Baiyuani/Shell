#!/bin/bash
#
disk=`df | awk "/root/{print $4}"`
mem=`free | awk "/Mem/{print $4}"`
while :
do
	disk=`df | awk "/root/{print $4}"`
	mem=`free | awk "/Mem/{print $4}"`
	if [ $disk -lt 1024000 ];then
		echo 'Insufficient resources,资源不足' > mail -s "磁盘空间不足" root 
	fi
	if [ $mem -lt 512000 ];then
		echo 'Insufficient resources,资源不足' > mail -s "内存空间不足" root 
	fi
	sleep 2
done
