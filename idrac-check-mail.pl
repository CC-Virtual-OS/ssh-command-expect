#!/usr/bin/perl
# Alessio Dini
# Script per abilitazione/disabilitazione notifiche via mail

use Net::OpenSSH;;

if(@ARGV < 1 )
{
    print "Syntax: $0 <iDRAC> <0|1>\n";
    print "Example: $0 1.2.3.4 0 ( disable the mail )\n";
    print "Example: $0 1.2.3.4 1 ( enable the mail )\n";
    exit -1;
}

my($day, $month, $year)=(localtime)[3,4,5];
my $ipfile = $ARGV[0];
#my $password = 'calvin';
my $password = 'F0rz4CR!';
my $timeout = 10;
my $username = 'root';
my $error = 'racadm getconfig -g cfgEmailAlert -i 999';
my $help = 'help';
my $choice = $ARGV[1];


my %param=(
    user => $username,
    password=> $password,
    timeout => 10,
    port => '22',
    master_opts => [-o => "StrictHostKeyChecking=no"]
    );

print "\n\nConnecting on iDRAC $ipfile\n";
my $ssh = Net::OpenSSH->new($ipfile,%param);
$ssh->error and die "Unable to connect to remote host: " . $ssh->error;
my $prova = $ssh->capture($error);
if ( $prova =~ /Invalid/ )
{
        if ( $prova =~/.+(\d) - (\d).+/ )
        {
                $rangestart = $1;
                $rangeend = $2;
                $count = $rangeend;
                print "This iDRAC supports up to $rangeend Mail Alerts\n";
                for $i ($rangestart..$rangeend)
                {
                        my $mcheck = " racadm getconfig -g cfgEmailAlert -i $i ";
                        my $mailcheck = $ssh->capture($mcheck);
                        if ( $mailcheck =~/cfgEmailAlertEnable=1/ )
                        {
                                if ( $mailcheck =~ /cfgEmailAlertAddress=(.*)/ )
                                {
                                        $maddr = $1;
                                        print "Notification enabled found: INDEX $i for mail $maddr\n";
                                }
                                if ( $choice == 0 )
                                {
                                        my $mdisable = "racadm config -g cfgEmailAlert -i $i -o cfgEmailAlertEnable 0";
                                        my $pdisable = $ssh->capture($mdisable);
                                }
                        }
                        if ( $mailcheck =~/cfgEmailAlertEnable=0/ )
                        {
                                if ( $mailcheck =~ /cfgEmailAlertAddress=(.*)/ )
                                {
                                        $maddr = $1;
                                        if ( $maddr )
                                        {
                                                print "Notification disabled found: INDEX $i for mail $maddr\n";
                                                if ( $choice == 1 )
                                                {
                                                        print "sto per eseguire il comando di enable\n";
                                                        my $menable = "racadm config -g cfgEmailAlert -i $i -o cfgEmailAlertEnable 1";
                                                        my $penable = $ssh->capture($menable);
                                                }
                                        }
                                }
                        }
                }
        }
}
