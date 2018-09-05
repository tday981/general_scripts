#!/bin/perl 
use warnings;
unlink "list.out";
my @suf=("ALP","TO","M","J","U","N","O","L","SA");
my $source="list.txt";

open my $fh, '<', $source or die "Can't open file";
open my $fh1, '>>', "list.out" or die;

my @ar = <$fh>;


for (@suf) {

	for my $line (@ar) {

		if ( "$line" =~ /\.$_\n/ ) {

			#print $fh1 $line;
			push ( @list,$line );
		
		}

	}

	$count = 1;
	while ($count <= 9) {

		print $fh1 "$list[rand @list]";
		$count ++;

	}
	undef (@list);
}
