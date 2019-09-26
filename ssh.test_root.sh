#!/bin/bash
CMD=$1
ADMIN_PASSWORD='Password1'
function usage() {
    echo -e "Scrivi nel file ./targets gli ip dei server da contattare \nUtilizzo:\n$0 [command to send] \n"
    exit 0
}

[[  $# -eq 0 ]]  && usage
[[   $1 == "--help"  ||  $1 == "-h"    ]] && usage

for host in $(cat ./targets) 
do
echo
echo
echo '##################'"$host"'########################'
echo
echo
/usr/bin/expect -c '
set timeout -1
#log_user 0
spawn ssh root@'"$host"'

expect "yes/no" {
	send "yes\r"
	expect "password: " { send "'"$ADMIN_PASSWORD"'\r" }
} "password: " { send "'"$ADMIN_PASSWORD"'\r" 
} "*?#*?" { send "\r" } 


expect "*?#*?" { 
	send "hostname\r"
	expect "*#" 
	#set hostname $expect_out(buffer)
	send "'"$CMD"'\r"   
	#expect "*#" 
	#set cmdoutput $expect_out(buffer)
}
send -- "exit\r"
send -- "exit\r"
#puts $hostname
#puts $cmdoutput
expect eof ' 
echo
echo
done
