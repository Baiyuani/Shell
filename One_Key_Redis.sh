#!/bin/bash
# Need SSH password free login required
# Configure yum is YES
# Redis of .tar place to /root/redis/

GCC (){
for i in {51..56}
do
	ssh 192.168.4.$i yum -y install gcc &> /dev/null
	if [ $? -eq 0 ] ;then
		echo "GCC$i YES"
	else
		echo "GCC$i NO"
	fi
done
}

TAR_REDIS (){
for i in {51..56}
do
	ssh 192.168.4.$i tar -xf /root/redis/redis-4.0.8.tar.gz -C /root
	if [ $? -eq 0 ] ;then
		echo "TAR_REDIS$i YES"
	else
		echo "TAR_REDIS$i NO"
	fi
done
}

MAKE (){
for i in {51..56}
do
	ssh 192.168.4.$i make -f /root/redis-4.0.8/Makefile
	if [ $? -eq 0 ] ;then
		echo "MAKE$i YES"
	else
		echo "MAKE$i NO"
	fi
done
}

MAKE_INSTALL (){
for i in {51..56}
do
	ssh 192.168.4.$i make install
	if [ $? -eq 0 ] ;then
		echo "MAKE_INSTALL$i YES"
	else
		echo "MAKE_INSTALL$i NO"
	fi
done
}

INIT (){
for i in {51..56}
do
	ssh 192.168.4.$i /root/redis-4.0.8/utils/install_server.sh<<EOF








EOF
	if [ $? -eq 0 ] ;then
		echo "INIT$i YES"
	else
		echo "INIT$i NO"
	fi
done
}

PORT () {
for i in {51..56}
do
	ssh 192.168.4.$i sed -ri "93s/6379/63$i/" /etc/redis/6379.conf
	if [ $? -eq 0 ] ;then
		echo "PORT$i YES"
	else
		echo "PORT$i NO"
	fi
done
}

BIND () {
for i in {51..56}
do
	ssh 192.168.4.$i sed -ri "70s/127.0.0.1/192.168.4.$i/" /etc/redis/6379.conf
	if [ $? -eq 0 ] ;then
		echo "BIND$i YES"
	else
		echo "BIND$i NO"
	fi
done
}

RESTART () {
for i in {51..56}
do
	ssh 192.168.4.$i /etc/init.d/redis_6379 restart
	if [ $? -eq 0 ] ;then
		echo "RESTART$i YES"
	else
		echo "RESTART$i NO"
	fi
done
}

CHECK () {
for i in {51..56}
do
	ssh 192.168.4.$i ss -antup |grep :63
done
}


GCC
TAR_REDIS
MAKE
MAKE_INSTALL
INIT
PORT
BIND
RESTART
CHECK
