#!/bin/bash
#99乘法表
for i in `seq 9`
do
	for b in `seq $i`
	do
		echo -n "$b*$i=$[i*b] "
	done
	echo
done
