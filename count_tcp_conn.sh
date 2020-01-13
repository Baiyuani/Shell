#!/bin/bash
# Count the number of local TCP connections
netstat -ant | sed -n '/ESTABLISHED/p' | awk '{print $5}'
