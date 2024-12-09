#!/bin/bash

arch=$(uname -a)
cpu_p=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)
cpu_v=$(grep '^processor' /proc/cpuinfo | wc -l)

mem_used=$(free -m | awk '$1 == "Mem:" {print $3}')
mem_total=$(free -m | awk '$1 == "Mem:" {print $2}')
mem_persentage=$(free | awk '$1 == "Mem:" {printf "%0.2f", ($3/$2)*100}')

disk_used=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{du += $3} END {print du}')
disk_total=$(df -Bg | grep "^/dev/" | grep -v "/boot$" | awk '{dt += $2} END {print dt}')
disk_persentage=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{dt += $2} {du += $3} END {printf "%d", du/dt*100}')

cpu_load=$(top -bn2 | grep "%Cpu(s)" | tail -n1 | awk '{usage=$2+$4} END {printf "%.1f%%\n", usage}')
lst_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvm_use=$(lsblk | grep -q "lvm" && echo "yes" || echo "no")
conx_tcp=$(grep TCP /proc/net/sockstat | awk '$1 == "TCP:" {print $3}')
user_log=$(users | wc -w)
net_ip=$(hostname -I | awk '{print $1}')
net_mac=$(ip link show | grep link/ether | awk '{print $2}')
sudo_cmds=$(grep -c 'COMMAND' /var/log/sudo/sudo.log 2>/dev/null || echo "0")

wall "	#Architecture: $arch
	#CPU physical: $cpu_p
	#vCPU: $cpu_v
	#Memory Usage: $mem_used/${mem_total}MB ($mem_persentage%)
	#Disk Usage: $disk_used/${disk_total}Gb ($disk_persentage%)
	#CPU load: $cpu_load
	#Last boot: $lst_boot
	#LVM use: $lvm_use
	#Connexions TCP: $conx_tcp ESTABLISHED
	#User log: $user_log
	#Network: IP $net_ip ($net_mac)
	#Sudo: $sudo_cmds cmd"

