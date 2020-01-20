#!/bin/bash
# Check traffic
echo "error-------------------------"
awk '{ip[$16]++}END{for(i in ip){print ip[i],i}}' error.log |sort -nr
echo "access------------------------"
awk '{ip[$1]++}END{for(i in ip){print ip[i],i}}' access.log |sort -nr
