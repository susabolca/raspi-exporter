#!/bin/bash

cpu_max=4
job=push
pre=abc

# uname 
u=$(uname -v)
v=($(uname -m -n -r -s -m))
echo ${pre}_uname_info { sysname=\"${v[0]}\",nodename=\"${v[1]}\",release=\"${v[2]}\",version=\"${u}\",machine=\"${v[3]}\" } 1

# tempture
v=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
echo ${pre}_thermal { dev=\"zone0\",job=\"${job}\" } $v

# cpu_freq
for ((i=0; i<cpu_max; i++)); do 
    v=$(cd /sys/devices/system/cpu/cpu0/cpufreq/ && cat cpuinfo_cur_freq || echo 0)
    echo ${pre}_cpu_freq { cpu=\"$i\",job=\"${job}\" } $v
done

# load
v=($(cat /proc/loadavg))
echo ${pre}_loadavg { min=\"1\",job=\"${job}\" } ${v[0]}
echo ${pre}_loadavg { min=\"5\",job=\"${job}\" } ${v[1]}
echo ${pre}_loadavg { min=\"15\",job=\"${job}\" } ${v[2]}

u=$(cat /proc/meminfo)
echo ${pre}_meminfo { type=\"MemTotal\",job=\"${job}\" } $(echo $u | awk '{print $2}')
echo ${pre}_meminfo { type=\"MemFree\",job=\"${job}\" } $(echo $u | awk '{print $5}')
echo ${pre}_meminfo { type=\"SwapTotal\",job=\"${job}\" } $(echo $u | awk '{print $56}')
echo ${pre}_meminfo { type=\"SwapFree\",job=\"${job}\" } $(echo $u | awk '{print $59}')
echo ${pre}_meminfo { type=\"Slab\",job=\"${job}\" } $(echo $u | awk '{print $80}')

