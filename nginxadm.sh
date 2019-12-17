#!/bin/bash
#nginx服务工具
cecho() {
        echo -e "\033[$1m$2\033[0m"
}
nginxd=/usr/local/nginx/sbin/nginx
startd() {
        $nginxd  
}
stopd() {
        $nginxd -s stop 
}
restartd() {
        $nginxd -s stop 
        sleep 0.5
        $nginxd
	if [ $? -eq 0 ];then  
	        cecho 32 '服务重启完成'
	else
		cecho 31 '重启失败'
	fi
}
statusd() {
        netstat -ntulp | grep nginx &> /dev/null
        if [ $? -eq 0 ] ;then
                cecho 32 '服务处于运行中'
        else
                cecho 31 '服务处于关闭状态'
        fi
}
reloadd() {
	$nginxd -s reload 
}
cecho 42  "
+---------------+
|1.启动服务     |
|2.停止服务     |
|3.查看服务状态 |
|4.重启服务     |
|5.重新加载配置 |
+---------------+"
read option
case $option in
1)
        startd ;;
2)
        stopd ;;
3)
        statusd ;;
4)
        restartd ;;
5)
	reloadd ;;
*)
        cecho 31 '输入错误'
esac

