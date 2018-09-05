#!/usr/bin/perl
use warnings;

$in="/storage1/rdisp.txt";

open $fh, '<', $in or die "Can't open in file $!\n";

while (<$fh>) {

	if ( $_ =~ /226E72/ ) {

		print "$_\n";

	}

}
