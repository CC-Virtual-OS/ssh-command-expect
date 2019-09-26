#!/bin/bash
host=$1
#ADMIN_PASSWORD='Password1'
ADMIN_PASSWORD='C4mb14m1!'
ADMIN_PASSWORD2='Password1'
function usage() {
    echo -e "Scrivi nel file ./targets gli ip dei server da contattare \nUtilizzo:\n$0 [command to send] \n"
    exit 0
}

[[  $# -eq 0 ]]  && usage
[[   $1 == "--help"  ||  $1 == "-h"    ]] && usage

/usr/bin/expect -c '
set timeout 5
spawn ssh administrator@'$host'

expect "yes/no" {
	send "yes\r"
	expect "*assword: " { send "'$ADMIN_PASSWORD'\r" }
} "*assword: " { 
	send "'$ADMIN_PASSWORD'\r" 
} "*?\$*?" { 
	send "\r"
}

expect "*?\$*?" { 
	send "sudo su -\r"   
	expect "*?: " { send "'$ADMIN_PASSWORD'\r" }	
} "*assword: " {
        send "'$ADMIN_PASSWORD2'\r"
}

expect "*?#*?" { 
	send "hostname\r"
	expect "*#" 
}
send -- "\r"
interact
' 
