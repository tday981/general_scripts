#!/usr/bin/perl
#
#use strict;
use warnings;

if (@ARGV == 0) {

	die "\n!!Must specify input and output file at run-time.!!\n\n";
}

if (@ARGV < 2) {

	die "\n!!Must specify an output file at run-time.!!\n\n";

}

open LIST,"<$ARGV[0]";
#open LIST,"<1.txt";
open OUT,">$ARGV[1]";

my @array = <LIST>;
chomp (@array);

print OUT "\<?xml version=\"1\.0\"?\>\n";
#print "\<?xml version=\"1\.0\"?\>\n";
print OUT "\<HostIPConfig>\n";

foreach (@array) {

#print "$_";
	print OUT "\<host ip=\"$_\" port=\"27000\"\/\>\n";

} 

print OUT "\<\/HostIPConfig>\n";
close OUT;
