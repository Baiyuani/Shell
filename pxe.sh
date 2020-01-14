#!/bin/bash
#pxe服务装配(网关/DNS全部指向本机)
#----------------------------函数区-----------------------#
mycheck() {
        if [ $? -ne 0 ];then
                cecho 31 "运行出错:$1"
                exit 1
        fi
}
cecho() {
	echo -e "\033[$1m$2\033[0m"
}
myhttp() {
        yum -y install httpd &> /dev/null
	if [ $? -ne 0 ];then
		echo "yum源有问题"
		exit 2
	else
        	mkdir /var/www/html/mount
	        mount /dev/cdrom /var/www/html/mount &> /dev/null
	        mycheck http
	fi
}
mytftp() {
        yum -y install tftp-server &> /dev/null
        mycheck tftp
        systemctl restart tftp 
        systemctl restart tftp 
        \cp -r /var/www/html/mount/isolinux/* /var/lib/tftpboot/
        mycheck tftp
        mkdir /var/lib/tftpboot/pxelinux.cfg
        \cp /var/www/html/mount/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default &> /dev/null
        mycheck tftp
}
mypxe() {
        yum -y install syslinux &> /dev/null
        mycheck "pxelinux.0"
        \cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
        mycheck "pxelinux.0"
}
setconfig() {
        defaultd=/var/lib/tftpboot/pxelinux.cfg/default
        aa='inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet'
        ks="ks=http://$ip/ks.cfg"
        mymenu='menu default'
        sed -ri "/timeout 600/s/600/100/" $defaultd
        sed -ri "66,+100d" $defaultd
        sed -ri "/kernel/i$mymenu" $defaultd
        sed -ri "/append/s#inst.st.*#$ks#" $defaultd
}
mydhcp() {
        yum -y install dhcp &> /dev/null
        mycheck dhcp
        mycfg=/etc/dhcp/dhcpd.conf
	echo "subnet 10.5.5.0 netmask 255.255.255.224 {
  range 10.5.5.26 10.5.5.30;
  option domain-name-servers ns1.internal.example.org;
  option domain-name "internal.example.org";
  option routers 10.5.5.1;
  option broadcast-address 10.5.5.31;
  default-lease-time 600;
  max-lease-time 7200;
}
" >> $mycfg
        #myread=/usr/share/doc/dhcp*/dhcpd.conf.example
        #sed -ri "5r $myread" $mycfg
        #sed -ri "5,+44d" $mycfg
        #sed -ri "17,+100d" $mycfg
	sed -ri "/netmask/s#10.5.5.0#192.168.4.0#" $mycfg
	sed -ri "/netmask/s#224#0#" $mycfg
	sed -ri "/range/s#10.5.5.26 10.5.5.30#192.168.4.100 192.168.4.200#" $mycfg
	sed -ri "/ns1.internal.example.org/s#ns1.internal.example.org#$ip#" $mycfg
	sed -ri "/internal.example.org/d" $mycfg
	sed -ri "/routers/s#10.5.5.1#$ip#" $mycfg
	sed -ri "/broadcast/d" $mycfg
	sed -ri "/max/a\  next-server $ip;" $mycfg
	sed -ri "/next/a\  filename \"pxelinux.0\";" $mycfg
}
myks() {
	cecho 32 "1.创建新应答文件"
	cecho 32 "2.使用默认应答文件(回车)"
	cecho 34 "(5s后自动选择默认)"
	echo
	read -p "输入选项:" -t 5 bb
	case ${bb:-2} in 
	1)
		yum -y install system-config-kickstart	&> /dev/null
		mycheck kickstart
		sed -i "/\[/s#.*#\[development\]#" /etc/yum.repos.d/*.repo
		LANG=en system-config-kickstart &> /dev/null 
		mycheck kickstart ;;
	2)
		ksconfig
		cecho 32 "root密码为1"
		echo
	esac
}

ksconfig() {
echo "#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
rootpw --iscrypted \$1\$ng1.AKVC\$jlFlUoOa24C6g9wKc7rce0
# Use network installation
url --url=\"http://$ip/mount\"
# System language
lang en_US
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use graphical install
graphical
firstboot --disable
# SELinux configuration
selinux --disabled

# Firewall configuration
firewall --disabled
# Network information
network  --bootproto=dhcp --device=eth0
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part / --fstype=\"xfs\" --grow --size=1

%packages
@base

%end " > /var/www/html/ks.cfg
}

mystart() {
	systemctl restart httpd tftp dhcpd &> /dev/null
	systemctl enable httpd tftp dhcpd &> /dev/null
	firewall-cmd --set-default-zone=trusted &> /dev/null
	setenforce 0 &> /dev/null
}

#----------------------------------执行区----------------------------#

echo "执行脚本前请确认光盘已经挂载"
cecho 32 "1.已确认,继续"
cecho 31 "2.去挂载光盘(退出)"
cecho 34 "(5s后自动继续下一步)"
echo 
while :
do
	read -p "输入选项:" -t 5 cc
	cecho 32 "开始安装...."
	echo
	if [ ${cc:-1} -eq 1 ] &> /dev/null ;then
		ip=$(ifconfig | sed -n "2p" | awk '{print $2}')
		#read -p "请输入本机ip:" ip
		myhttp
		mytftp
		mypxe
		setconfig
		mydhcp
		myks
		mystart
		cecho 32 "配置完成!"
		cecho 41 "附:如果无法完成装机,请手动启动tftp服务"
		exit
	elif [ $cc -eq 2 ] &> /dev/null ;then
		cecho 31 "行吧"
		exit 
	else
		cecho 31 "你输的是个啥"
	fi
done
