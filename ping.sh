#!/bin/bash
#多进程版
myping() {
	ping -c 3 -i 0.2 -W 1 $1 &> /dev/null
	if [ $? -eq 0 ] ;then
		echo "$1通了"
	else
		echo "$1不通" 
	fi
}
for i in {1..254}
do 
	myping 192.168.4.$i &
done
wait
