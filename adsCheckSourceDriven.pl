#!/usr/bin/perl
use warnings;

$file = "mob.txt";

open $fh, '<', $file or die "Can't open file $!\n";
@ar= <$fh>;

foreach $line (@ar) {

	if ( $line =~ /cacheType/ ) {

		@ar1=split(/\s+/,$line);
		$cache=$ar1[3];
		#print "cache is $cache\n"

	}

	if ( $line =~ /serverID/ ) {

		@ar2=split(/\s+/,$line);
		$serverId=$ar2[3];
		#print "serverId is $serverId\n";

	}

	if ( defined $cache && defined $serverId ) {

		$hash{$serverId}=$cache;
		undef $cache;
		undef $serverId;
	}

}

@keys= keys %hash;

for $key (@keys) {

	$value=$hash{$key};

	if ( $value eq "Source" ) {

		push @source,$key;

	}

}

#$num=scalar @source;
#print scalar @source ."\n";
$i=0;
foreach $num (@source) {

	chomp $num;
	#print "Num is $num\n";

	if ( $num != "602"  &&  $num != "606" ) {
	
		print "$num is also Source Driven\n"; 

	}
	
	else {
	
		$i++;

	}

}

if ( $i == "2" ) {

	print "Only IDS is Source Driven\n";

}
