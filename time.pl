#!/usr/bin/perl
use POSIX;

#$time=localtime;

$cy=POSIX::strftime( "%Y",localtime());
$cm=POSIX::strftime( "%m",localtime());
$cd=POSIX::strftime( "%d",localtime());

$pm=sprintf("%02d",$cm-1);

print "$cy$cm$cd\n";
print "$cy$pm$cd\n";
