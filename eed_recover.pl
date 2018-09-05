#!/usr/bin/perl
use warnings;
use feature qw(say);

$log="/tmp/rmdsTestClient1";

open $fh,'<', $log or die "Couldn't open file $!\n"; 

@file = <$fh>;

@string=grep(/ELEKTRON_DD Group 1 OK Received. Text \"OK\"/, @file);

$match="$string[$#string]";
print "match is $match\n";

seek($fh,0,0);

print qq($match);
while (<$fh>) {


	if (/\Q$match/) {

		chomp;
		print "$_\n";
		push @grabbed, $_;
		while (<$fh>) {

			chomp;
			last if /^$/;
			print "$_\n";
			push @grabbed, $_;

		}
	}
}
