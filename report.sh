#!/bin/bash
echo " ##### CONFIGURAZIONE DI RETE ##### "
echo 
ifconfig | grep -B1 -i inet
echo
route -n
echo
ping -c3 $(netstat -rn | grep ^0 | awk '{print $2}')
#if [ $? -ne 0 ]
#then
#	GW=$(netstat -rn | grep ^0 | awk '{print $2}')
#	echo $GW
#	last_byte=$(($(echo $GW | cut -d '.' -f4 ) + 1))
#	NEW_GW=$(echo $GW | cut -d '.' -f1).$(echo $GW | cut -d '.' -f2).$(echo $GW | cut -d '.' -f3).$last_byte
#echo $NEW_GW
#fi	
echo 
echo "### file hosts ###"
cat /etc/hosts | grep $(hostname)
echo
echo "### DNS ###"
cat /etc/resolv.conf
echo "### REDHAT VERSION ### "
cat /etc/redhat-release
echo "### filesystems and disks ###" 
lvmdiskscan | grep sd
lsblk
df -hTP | egrep "ltm|nfs"
echo "### qradar ###"
cat /etc/rsyslog.conf |egrep 'auth.notice|authpriv.|local0.info'
echo
