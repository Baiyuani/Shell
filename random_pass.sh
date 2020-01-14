#!/bin/bash
# Random Password Generator
a=abcdefghigklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
pass=''
for i in {1..8}
do
	b=$[RANDOM%62]
	pass=$pass${a:$b:1}
done
echo $pass
