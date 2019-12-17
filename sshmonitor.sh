#!/bin/bash
#监控ssh入侵
while :
do
aaa=`awk '/Invalid user/{a[$10]++}END{for(i in a){print i,a[i]}}' /var/log/secure | awk '$2>=3{print $1}'`
if [ -n "$aaa" ];then
	echo "入侵者ip是$aaa" | mail -s "有人入侵" root
fi
bbb=`awk '/Failed password/{a[$11]++}END{for(i in a){print i,a[i]}}' /var/log/secure | awk '$2>=3{print $1}'`
if [ -n "$bbb" ];then
	echo "入侵者ip是$bbb" | mail -s "有人入侵" root
fi
sleep 3
done
