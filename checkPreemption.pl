#!/usr/bin/perl
use warnings;

$val="0";
@new=glob "new/adh.dump*";
@old=glob "old/adh.dump*";

foreach $file (@new) {

	open $fn, '<', $file;

	while (<$fn>) {
		#print "$_\n";

		if ( $_ =~ /MARKET/ ) {

			@split=split(/\s+/,$_);
			$ric=$split[3];
			#print "$ric\n";
			push @anew, $ric;
		}

	}

}

foreach $file (@old) {

	open $fn, '<', $file;

	while (<$fn>) {
		#print "$_\n";

		if ( $_ =~ /MARKET/ ) {

			@split=split(/\s+/,$_);
			$ric=$split[3];
			#print "$ric\n";
			push @aold, $ric;

		}

	}

}

#$Nnum=@anew;
#$Onum=@aold;

#print "Nums are $Nnum and $Onum\n";

foreach $ric (@anew) {

	$num=grep(m/\Q$ric\E/,@aold);
	
	if ( $num == "0" ) {

		$val++;
		#print "Val is $val\n";

	}

}

if ( $val >= "10" ) {

	print "Items were preempted\n";

}
