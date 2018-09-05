#!/usr/bin/perl
use warnings;

$config="/tmp/dpopadh.cnf";
$new="/tmp/new_dpopadh.cnf";

$replace='sl1i-ddndids02a*adh*route*DDS_POP*maxCache : 3000';

open $fh1, '<',$config;
open $fh2, '>',$new;

while (<$fh1>) {

	if ( $_ =~ m/sl1i-ddndids02a\*adh\*route\*DDS_POP\*maxCache/ ) {

		print $fh2 "$replace\n";

	}

	else {

		print $fh2 $_;

	}
}
