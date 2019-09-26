#!/bin/bash
SCRIPT2SEND=$1
ADMIN_PASSWORD='C4mb14m1!'
function usage() {
    echo -e "Scrivi nel file ./targets gli ip dei server da contattare \nUtilizzo:\n$0 [script to send] \n"
    exit 0
}

[[  $# -eq 0 ]]  && usage
[[   $1 == "--help"  ||  $1 == "-h"    ]] && usage


for host in $(cat ./targets) 
do
echo
echo '##################'$host'########################'
echo
/usr/bin/expect -c '

set timeout -1

#INVIO LO SCRIPT
send_user "### INVIO LO SCRIPT IN SCP ###\n"
spawn scp '"$SCRIPT2SEND"' administrator@'"$host"':/home/administrator/


expect "yes/no" {
	send "yes\r"
	expect "assword: " { send "'"$ADMIN_PASSWORD"'\r" }
} "assword: " { send "'"$ADMIN_PASSWORD"'\r" 
} "*?\$*?" { send "\r" }

send_user "### FINE INVIO SCP ###\n"

send_user "\n### CONNESSIONE AL SERVER '"$host"' ###\n"

spawn ssh administrator@'"$host"'

expect "yes/no" {
	send "yes\r"
	expect "assword: " { send "'"$ADMIN_PASSWORD"'\r" }
} "assword: " { send "'"$ADMIN_PASSWORD"'\r" 
} "*?\$*?" { send "\r" } 

expect "*?\$*?" { 
	send "sudo su -\r"   
	expect "*?: " { send "'"$ADMIN_PASSWORD"'\r" }	
}
expect "*?#*?" { 
	send "hostname\r"
	send "chmod +x /home/administrator/'"$SCRIPT2SEND"'\r"
	send "/home/administrator/'"$SCRIPT2SEND"'\r"    }
#sleep 2
send -- "exit\r"
send -- "exit\r"
expect eof ' 
done
