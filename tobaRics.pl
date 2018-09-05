#!/usr/bin/perl
use warnings;
use List::MoreUtils qw/ uniq/;

@files=("info.01a","info.01b");

foreach $file (@files) {


	open $fh, '<',$file or die "Can't open file $!\n";
	open $fh0, '>',$file."_out";

	while (<$fh>) {

		if ( $_ =~ /MP\s+ACTIVE/ ) {

			@ar=split(/\s+/,$_);
			push @a,$ar[2];

		}

		elsif ( $_ =~ /MBP\sACTIVE/ || $_ =~ /MBO\sACTIVE/ ) {

			@ar=split(/\s+/,$_);
			push @a,$ar[3];

		}

	}

	@una = sort (uniq(@a));

	foreach $out (@una) {

		print $fh0 "$out\n";

	}

}
