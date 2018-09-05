#!/usr/bin/perl
use warnings;

$adhdir="/ThomsonReuters/dpop/adh/bin";

if ($#ARGV == -1 ) {

	print "This script currently does not run interactively.\n";
	print "Syntax: ./adhItemTrace.pl True/False\n\n";
        
}

else {

	if ( $ARGV[0] eq "True" ) {

		system "$adhdir/adhmon -set SrcDistProdSrvcDbg `hostname`.1.adh.serviceGenerator.srcPrdServicePool.DDS_POP.debug itemTrace True"
	
	}

	elsif ( $ARGV[0] eq "False" ) {

		system "$adhdir/adhmon -set SrcDistProdSrvcDbg `hostname`.1.adh.serviceGenerator.srcPrdServicePool.DDS_POP.debug itemTrace False"
	
	}


}
