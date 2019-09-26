#!/bin/bash
CMD=$1
#ADMIN_PASSWORD='Password1'
ADMIN_PASSWORD='C4mb14m1!'
function usage() {
    echo -e "Scrivi nel file ./targets gli ip dei server da contattare \nUtilizzo:\n$0 [command to send] \n"
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
log_user 0
set prompt "#|>|:|\\\$";
spawn ssh administrator@'$host'

expect "yes/no" {
	send "yes\r"
	expect "assword: " { send "'$ADMIN_PASSWORD'\r" }
} "assword: " { send "'$ADMIN_PASSWORD'\r" 
} "*?\$*?" { send "\r" } 

expect "*?\$*?" { 
	send "sudo su -\r"   
	expect "*?: " { send "'$ADMIN_PASSWORD'\r" }	
}

expect "*?#*?" { 
	send "hostname\r"
	expect "*#" 
	send_user $expect_out(buffer);
	send "'"$CMD"'\r"
	expect "*#"
	send_user $expect_out(buffer);
}
send -- "exit\r"
send -- "exit\r"
#puts $hostname
#puts $cmdoutput
expect eof ' 
echo
echo
echo
done
