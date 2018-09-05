#!/usr/bin/perl
use warnings;
use List::MoreUtils qw/ uniq /;

my @dumpa= glob "/storage/adhdumpa/*";
my @dumpb= glob "/storage/adhdumpb/*";
open my $outa, '>>', "/storage/adh.dumpa";
open my $outb, '>>', "/storage/adh.dumpb";

foreach my $file (@dumpa) {

	open my $fh, '<', $file or die "Can't open file $!";
	my @file = <$fh>;

	for my $line (@file) {

		if ( $line =~ /\sPI\s/ ) {
	
			chomp $line;
			my @arr = split(/\s+/,$line);
			push ( @lista,$arr[3] );
	
		}

	}
}

foreach my $file (@dumpb) {

	open my $fh, '<', $file or die "Can't open file $!";
	my @file = <$fh>;

	for my $line (@file) {

		if ( $line =~ /\sPI\s/ ) {
	
			chomp $line;
			my @arr = split(/\s+/,$line);
			push ( @listb,$arr[3] );
	
		}

	}
}

my @una = sort (uniq(@lista)); 
my @unb = sort (uniq(@listb)); 

for (@una) {

	print $outa "$_\n";

}

for (@unb) {

	print $outb "$_\n";

}
