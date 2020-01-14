#!/bin/bash 
#awk 判断 ps 命令输出的第 8 列为 Z 是,显示该进程的 PID 和进程命令
# Z身上的引号是重点
ps aux | awk '$8=="Z"{print "发现僵尸进程,进程PID为"$2,"命令为"$NF}' 
