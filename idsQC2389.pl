#!/usr/bin/perl
use warnings;

@new=glob "new/adh.dump*";
@old=glob "old/adh.dump*";

foreach $file (@new) {

	open $fn, '<', $file;

	while (<$fn>) {
		#print "$_\n";
		if ( $_ =~ m/LVLT.*\s+MARKET/ || $_ =~ m/CSCO.*\s+MARKET/ ) {

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
		if ( $_ =~ m/LVLT.*\s+MARKET/ || $_ =~ m/CSCO.*\s+MARKET/ ) {

			@split=split(/\s+/,$_);
			$ric=$split[3];
			#print "$ric\n";
			push @aold, $ric;

		}
}
}


$numNew=@anew;
$numOld=@aold;
$diff=($numNew-$numOld);

if ( $numNew gt $numOld ) {

	print "New items were added.\n";
	print "The new dump has $diff more items after new requests.\n";

}
