#!/bin/bash
# Random name calling script
line=`cat $1 | wc -l `
a=$[RANDOM%line+1]
sed -n "${a}p" $1
