#!/bin/bash

a=30
b=$((24*60*60/30))

t1=0
while true; do 
    ./exporter.sh | ./push.sh
    ((t1-=1))
    echo $t1
    if [ $t1 -le 0 ] ; then
       	t1=$b
        ./smartctl.sh | ./push.sh	
    fi
    sleep 30;
done
