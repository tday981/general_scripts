#!/usr/bin/perl
use warnings;

$log="/tmp/mp_linux.txt";

open $fh1, '<',$log or die "Can't open file $!\n";

@file=<$fh1>;

@heading=grep(/CPU/,@file);
$head=$heading[1];
chomp $head;

#print "$head\n";

foreach $line (@file) {

	if ($line =~ /^[0-9]/ && $line !~ /CPU/) {

		@ar1=split(/\s+/,$line);
		$val=$ar1[$#ar1];

		if ( $val <= 20 ) {

			push @rows,$line;

		}
	
	}

}

$nmatch = @rows;
#print "nmatch is $nmatch\n";

if ($nmatch == 0) {

	print "There are no instances\n";

}

else {
	print "$head\n";
	for $row (@rows) {

		chomp $row;
		print "$row\n";

	}
}