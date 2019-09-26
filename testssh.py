from pexpect import pxssh
import sys
hostname = sys.argv[1] 
print hostname
username = 'administrator'
password = 'C4mb14m1!'
password2 = 'Password1'
try:
    s = pxssh.pxssh()
    s.login (hostname, username, password)
    print "logged in as administrator with C4mb14m1!"
    s.sendline('sudo -s')
    i = s.expect('assword.*: ')
    if i==0:
        print "I give password"
        s.sendline(password)
        s.prompt(timeout=3) 
    else:
        s.prompt()
    s.interact()
except pxssh.ExceptionPxssh as e:
    try:
        s = pxssh.pxssh()
        s.login (hostname, username, password2)
        print "logged in as administrator with Password1"
        s.sendline('sudo -s')
        i = s.expect('assword.*: ')
        if i==0:
            print "I give password"
            s.sendline(password2)
            s.prompt(timeout=3)
        else :
            s.prompt()
        s.interact()
    except pxssh.ExceptionPxssh as e:
        print "pxssh failed on login."
        print str(e)
    

