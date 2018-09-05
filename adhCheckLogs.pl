#!/bin/perl
use warnings;
use List::MoreUtils qw(any);
#use Expect;
#use strict;
#
@match=("Dismounting application","Main thread called shutdown on sink component ","Peer server is being timedout.","Ping Timeout","RRCP STATUS MSG","Server will be removed from network.","Source Mirroring auto failback will be actioned: the server will be restarted. ","SrcStreamService initiating consumer side shutdown.Reason:  Download not complete the server will be restarted","The datafeed links are bad and discourageRequestsOnOutage is enabled.","Timed out sink component","Advanced Data Hub process was restarted");

print "Collect files before processing: ";
$ans=<>;
chomp $ans;

my $hosts="/etc/hosts";
open my $fh, '<', $hosts or die "Can't open file $!\n";  

my @arr = <$fh>;

my $num = 0;
for (@arr) {


	if ( "$_" =~ /sl1i-ddndsrc/ || $_ =~ /sl1i-ddnbadh/ ) {
	#if ( "$_" =~ /sl1i-ddnbadh/ ) {
	
		@line = split(/\s+/);
		push (@list,"$line[1]");
		#print "added $line[1]\n";

	}


}
	
foreach $host (@list) {

	print "processing $host\n";

	$wf="/storage/adh_logs/".$host.".txt";

	($dest = "/storage/adh_logs/".$host) =~ s/sl1i-ddn//;

	if ( ! -d $dest ) {

		mkdir $dest;

	}

	if ( $ans =~ /y/ ) {

		copy($host);

	}

	@list1=glob($dest."/EventLog*");

	#print "@list\n";

	open $out, '>>', $wf or die "Can't open output: $wf: $!\n";

	foreach $file (@list1) {
	
		open $fh1, '<', $file or die "Can't open input: $file; $!\n";

		while (<$fh1>) {
	
			chomp $_;
			foreach $val (@match) {

				if ( $_ =~ /\Q$val\E/) {
					#print "$_\n";

					#if ($_ =~ "Advanced Data Hub process was restarted" ) {

						$ck=qx(fgrep -c "$_" $wf);

						chomp $ck;
						#print "ck is $ck\n";
						if ( $ck < "1" ) {

							push @disp, "$_";
							print $out "$_\n";

						}

						else {

							#print $out $_;
							next;

						}

					#}

				}

			undef $ck;
			}

		}


	}

	smf();

}

if ( @disp ) {

	print "\n\nResults:\n\n\n";
	foreach $ent (@disp) {

		print "$ent\n";

	}

}

else {

	print "\n\nDone\n";

}

sub copy {

	$host=$_[0];

	$addr="root\@$host";
	
	print "\tcopying files...\n";
	#system "echo \"yes\" | pscp -q -pw Pegestech1 new_adh.zip $addr:/ThomsonReuters/dpop/adh/bin/";
	#system "echo \"yes\" | pscp -q -pw Pegestech1 $addr:/ThomsonReuters/smf/log/log_201512* $dest/";
	system "echo \"yes\" | pscp -q -pw Pegestech1 $addr:/ThomsonReuters/smf/log/EventLogAdaptorGMI* $dest/";
	#system "echo \"yes\" | pscp -q -pw Pegestech1 $addr:/ThomsonReuters/smf/log/smf-server* $dest/";


}

sub smf {

	@smfl=glob($dest."/smf-server*");

	if ( @smfl != 0 ) {
	
	open $out1,'>', "smf-".$host or die "Can't open smf out: $!\n";

	foreach $log (@smfl) {

		open $sl,'<', $log or die "Can't open $log: $!\n";

		while (<$sl>) {

			if ( $_ =~ /^2015/ ) {

				$date=$_;

			}

			if ( $_ =~ /Downcast caused variable wraparound casting from std/ && defined $date ) {

				print $out1 "$date $_\n";
				undef $date;

			}

		}

	}

	}

}
