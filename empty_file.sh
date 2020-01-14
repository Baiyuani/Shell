#!/bin/bash
#删除目录下大小为0的文件
if [ $# -eq 0 ];then
	echo "删除目录下大小为0的文件(请输入脚本参数:目录路径)"
else
	find $1 -type f -size 0 -exec rm -rf {} \;
fi

