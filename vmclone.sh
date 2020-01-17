#!/bin/bash
#快速创建KVM虚拟机
xmld=/etc/libvirt/qemu/
qcow2d=/var/lib/libvirt/images/
echo "快速创建KVM虚拟机"
read -p "请输入虚拟机编号(1-100)" num 
newvm=kvm${num}
expr $num / 1  &> /dev/null
if [ $? -ne 0 ] ;then
        echo "请输入数字!"
        exit 1
elif [ $num -lt 1 ] || [ $num -gt 100 ] ;then
        echo "编号超出范围!"
        exit 2
else
        ls ${xmld}${newvm}.xml &> /dev/null
        if [ $? -eq 0 ];then
                echo -e "\033[31m该编号已经使用\033[0m"
                exit 3
        else
                cp -p ${xmld}centos7.0.xml ${xmld}${newvm}.xml
                sed -ri "/<name>/s#centos7.0#${newvm}#" "${xmld}${newvm}.xml"
                sed -ri "/source f/s#centos7.0.qcow2#${newvm}.qcow2#" "${xmld}${newvm}.xml"
                sed -ri "/<uuid/d" "${xmld}${newvm}.xml"
                sed -ri "/<mac/d" "${xmld}${newvm}.xml"
                qemu-img create -f qcow2 -b ${qcow2d}'centos7.0.qcow2' ${qcow2d}${newvm}.qcow2 12G &> /dev/null 
                virsh define "${xmld}${newvm}.xml" &> /dev/null
                echo -e "\033[32m创建成功\033[0m"
        fi    
fi

