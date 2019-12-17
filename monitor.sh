#!/bin/bash
#
while :
do
clear
uptime | awk '{print "CPU最近15分钟平均负载为"$NF}'
ifconfig eth0 | awk -F[\(\)] '/RX p/{print "网卡接收流量为"$2}'
ifconfig eth0 | awk -F[\(\)] '/TX p/{print "网卡发送流量为"$2}'
free -m | awk '/Mem/{print "内存剩余空间为"$4" MB"}'
df -h | awk '/\/$/{print "磁盘剩余空间"$4}'
awk 'END{print "计算机用户数量为"NR"个"}' /etc/passwd
u=`who | wc -l`
echo "当前登录用户数量${u}个"
p=`ps aux | wc -l`
echo "当前开启的进程数量为${p}个"
a=`rpm -qa | wc -l`
echo "本机已安装的软件包数量为${a}个"
sleep 0.5
done
