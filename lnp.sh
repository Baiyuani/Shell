#!/bin/bash
#lnmp配置并实现web动态页面访问

if [ -f /root/lnmp_soft.tar.gz ] ;then
        tar -xf /root/lnmp_soft.tar.gz -C /root
        tar -xf /root/lnmp_soft/nginx-1.12.2.tar.gz -C /root
        yum -y install gcc pcre-devel openssl-devel
        cd /root/nginx-1.12.2/
	sed -ri "s/1.12.2//" ~/nginx-1.12.2/src/core/nginx.h
	sed -ri "14s/nginx//" ~/nginx-1.12.2/src/core/nginx.h
	sed -ri "49s/nginx//" ~/nginx-1.12.2/src/http/ngx_http_header_filter_module.c
	sed -ri "36s/nginx//" ~/nginx-1.12.2/src/http/ngx_http_special_response.c
	./configure --with-http_stub_status_module --with-stream --with-http_ssl_module
        make && make install
else
        echo "lnmp_soft.tar.gz不存在"
	exit 1
fi
yum -y install php php-fpm php-mysql 
echo "稍等..."
sed -ri '/expose_php/s/On/Off/' /etc/php.ini
systemctl restart php-fpm 
systemctl enable php-fpm  &> /dev/null
confd=/usr/local/nginx/conf/nginx.conf
sed -ri '45c index index.php index.html;' $confd
sed -ri '65,71s/#//' $confd
sed -ri '69d' $confd
sed -ri '/fastcgi_params/s/_params/.conf/' $confd
sed -ri '/worker_processes/s/1/2/' $confd
sed -ri '/worker_connections/s/1024/65536/' $confd
sed -ri '/default_type/a server_tokens off;' $confd
echo '
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target ' > /usr/lib/systemd/system/nginx.service
systemctl daemon-reload
systemctl restart nginx
systemctl enable nginx
