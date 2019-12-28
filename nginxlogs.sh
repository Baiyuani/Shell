#!/bin/bash
#日志切割
dated=$(date +%Y%m%d)
logpath=/usr/local/nginx/logs
mv $logpath/access.log $logpath/access-$dated.log
mv $logpath/error.log $logpath/error-$dated.log
kill -USR1 $(cat $logpath/nginx.pid)
