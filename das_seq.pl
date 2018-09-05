#!/usr/bin/perl
#use warnings;
#
$in=$ARGV[0];

$/="\r\n";
open $fh, '<',$in or die "Can't open file $!\n";

@file=<$fh>;

foreach $line (@file) {

	if ( $line =~ /\QVLAN Id: 561\E/ ) {

		$on=1;

	}

	if ( $on == "1" && $line =~ /\QItemSeqNum\E/ ) {
	#if ( $on == "1" && $line =~ /\QRRCP SeqNo\E/ ) {
	#
		chomp $line;

		#print "$line\n";
		@ar=split(/\s/,$line);
		#@ar=split(/\:/,$line);
		#print "seq is $ar[1]\n";
		$num=$ar[1];
		chomp $num;
		push @seq,$num; 

	}

	if ( $line =~ /\QVLAN Id: 500\E/ ) {

		$on=0;

	}

}

$count=0;
while ( @seq > "1" ) {

$val=shift(@seq);
chomp $val;

#print "val is $val\n";

if ( $val >= $seq[0] ) {

	$count++;
	print "$val is out of place with $seq[0]\n";

}

}

if ( $count == "0" ) {

	print "No sequence gaps were found\n";

}
