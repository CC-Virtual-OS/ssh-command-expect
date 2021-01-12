#!/usr/bin/perl -w
#
## 12/01/2021
# Alessio Dini, Lottomatica
# Script for automatic setup about VLANs, Portchannels, VLTs and more stuff on MX7000 switches

use strict;

# '1' value as beginning value. This will force interaction with the user
my $a1 = 1;
my $b1 = 1;
my $a2 = 1;
my $b2 = 1;
my $a1ip;
my $b1ip;
my $a2ip;
my $b2ip;

sub check_ip {
        my $name = $_[0];
        my $ip = $_[1];
        if ($ip !~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/ ) {
                print "\nPlease check the format of the ip address for $name Switch\n";
                return 254;
        }
        if ($name eq "B1") {
                if ("$ip" eq "$a1ip") {
                        print "\nYou inserted the same ip of another switch. Please PAY ATTENTION!!!\n";
                        return 255;
                }
        }
        if ($name eq "A2") {
                if ("$ip" eq "$a1ip" || "$ip" eq "$b1ip") {
                        print "\nYou inserted the same ip of another switch. Please PAY ATTENTION!!!\n";
                        return 255;
                }
        }
        if ($name eq "B2") {
                if ("$ip" eq "$a1ip" || "$ip" eq "$b1ip" || "$ip" eq "$a2ip") {
                        print "\nYou inserted the same ip of another switch. Please PAY ATTENTION!!!\n";
                        return 255;
                }
        }
        return 0;
}


print "\n\nWelcome my master! Are you ready to have fun together?\n";
print "\nPlease, let me know the ip addresses of A1 - B1 - A2 - B2 MX7000 switches.\n";

#A1
do {
        print "\nInsert A1 address\n";
        $a1ip = <STDIN>;
        chomp $a1ip;
        $a1 = check_ip("A1","$a1ip");
} until ($a1 == 0 );


#B1
do {
        print "\nInsert B1 address\n";
        $b1ip = <STDIN>;
        chomp $b1ip;
        $b1 = check_ip("B1","$b1ip");
} until ($b1 == 0 );


#A2
do {
        print "\nInsert A2 address\n";
        $a2ip = <STDIN>;
        chomp $a2ip;
        $a2 = check_ip("A2","$a2ip");
} until ($a2 == 0 );


#B2
do {
        print "\nInsert B2 address\n";
        $b2ip = <STDIN>;
        chomp $b2ip;
        $b2 = check_ip("B2","$b2ip");
} until ($b2 == 0 );


print "\n\nI show you the summary before the configuration. Following is a virtual view of MX7000's back:\n";
print "\n -----------------------------------------------------\n";
print " |  A1 SWITCH   -> $a1ip \n";
print " -----------------------------------------------------\n";
print " -----------------------------------------------------\n";
print " |  A2 SWITCH   -> $a2ip \n";
print " -----------------------------------------------------\n";
print " |                                                    |\n";
print " |                                                    |\n";
print " |                                                    |\n";
print " |                                                    |\n";
print " |               MX7000 BACK VIEW                     |\n";
print " |                                                    |\n";
print " |                                                    |\n";
print " |                                                    |\n";
print " -----------------------------------------------------\n";
print " |  B1 SWITCH   -> $b1ip \n";
print " ------------------------------------------------------\n";
print " ------------------------------------------------------\n";
print " |  B2 SWITCH   -> $b2ip \n";
print " ------------------------------------------------------\n";

print "\n\n";
print "I suggest you to check via CMM the switches ip. Are you sure to continue with the setup? (yes/no)\n";
my $setup = <STDIN>;
chomp $setup;
if ("$setup" eq "y" || "$setup" eq "yes") {
        print "Nice!\n";
}
else
{
        print "Bad for you then :( \n";
}
