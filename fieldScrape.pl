#!/usr/bin/perl
use warnings;

$file = "cme_chris.txt";

open $fh , '<', $file or die "Can't open input $!\n";
open $fhO, '>', "cme_pe.txt" or die "Can't open output $!\n";

while (<$fh>) {

	if ( $_ =~ /\(RSSL_MKF_HAS_SERVICE_ID|RSSL_MKF_HAS_NAME|RSSL_MKF_HAS_NAME_TYPE\)\"  serviceId=\"4257\" name=/ ) {

		@ar1=split(/\"/,$_);
		$name = $ar1[5];

	}


	if ( $_ =~ /fieldEntry fieldId=\"1\" dataType=\"RSSL_DT_UINT\" data=/ ) {

		@ar2=split(/\"/,$_);
		$pe=$ar2[5];

	}

	if ( defined $name && defined $pe ) {

		print $fhO "$name,$pe\n";

		undef $name;
		undef $pe;

	}

}
