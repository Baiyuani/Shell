#!/bin/bash
# crond:
# 0 0 * * *  innobackupex.sh

grep innobak /etc/profile &> /dev/null
if [ $? -ne 0 ],then
	echo "innobak=`date +%F`" >> /etc/profile  # Prevent system restart
fi

# Full backup on Monday, incremental backup from Tuesday to Sunday

if [ `date +%u` -eq 1 ],then
	innobackupex --user root --password 123qqq...A /bak/`date +%F`_all --no-timestamp
	innobak=`date +%F`   
elif [ `date +%u` -eq 2 ],then
	innobackupex --user root --password 123qqq...A --incremental /bak/`date +%F` --incremental-basedir=/bak/${innobak}_all --no-timestamp
	innobak=`date +%F`
else
	innobackupex --user root --password 123qqq...A --incremental /bak/`date +%F` --incremental-basedir=/bak/${innobak} --no-timestamp
	innobak=`date +%F`
fi
