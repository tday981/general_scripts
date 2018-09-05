#!/usr/bin/perl
#use warnings;
use List::MoreUtils qw(uniq);

print "Please provide a line handler: \n";
$lh=<>;
chomp $lh;
print "\n";

print "Which ric: \n";
$ric=<>;
chomp $ric;

print "L1 or L2: \n";
$level=<>;
chomp $level;

@list=("/storage/labels/prod/ddnLabels.xml","/storage/labels/prod/ddnReqLabels.xml");

foreach $file (@list) {

	open $fh, '<', $file or die "Can't open $file: $!\n";

	if ( $file =~ /ddnLabels.xml/ ) {

		while (<$fh>) {

			if ( $_ =~ /\Qlabel ID\E/ ) {

				@lar=split(/\"/,$_);
				$lid=$lar[1];
				$lk=$lid;
				#print "l is $l\n";
	
			}

			if ( $_ =~ /\"$lh\"/ ) {

				@par=split(/\"/,$_);
				$p=$par[1];
				#print "p is $p\n";

			}

			if ( $_ =~ /\QmultTag\E/ ) {

				@mt=split(/[>,<]/,$_);
				$m=$mt[2];
				#print "m is $m\n";

			}

			if ( defined $lid && defined $p && defined $m ) {

				#print "labelId is $l with multTag $m for provider $p.\n";
				#print "$lid $p $m\n";
				push @mtag,$m;
				$h{$m}=$lid;
				#last;

			}

			if ( $_ =~ /\Qlabel>\E/ ) {

				undef $l;
				undef $p;
				undef $m;

			}

		}

		if ( $level ne "" ) {

			@ar=grep(/$level/,@mtag);
			$val=$ar[0];

			if ( defined $val ) {

				$l=$h{$val};
				#print "matched level: Processing $val\n";

			}

			else {

				$val=@mtag[0];
				#print "val $val\n";
				$l=$h{$val};
				#print "level not matched: Processing $val\n";
			
			}

		}

		elsif ( $level eq "" ) {

			$val=@mtag[0];
			#print "val $val\n";
			$l=$h{$val};
			#print "no level: Processing $val\n";

		}

	}

	if ( $file =~ /ddnReqLabels.xml/ ) {

		while (<$fh>) {

			if ( $_ =~ /\Qport ID\E/ ) {

				@pid=split(/[\"<>]/,$_);
				$pval="$pid[2],$pid[4]";
				push @port,$pval;

			}

			if ( $_ =~ /\Q<multAddr TAG\E/ ) {

				@maddr=split(/\"/,$_);
				$vals="$maddr[1],$maddr[3],$maddr[5],$maddr[7]";
				#print "vals is $vals\n";
				push @mult,$vals;
			}
				
			if ( $_ =~ /\Qlabel ID\E/ ) {

				@lar=split(/\"/,$_);
				$nl=$lar[1];
				#print "nl is $nl\n";

			}

			if ( $_ =~ /\Q<multTag\E/ ) {

				@mar=split(/[<>]/,$_);
				$mtag=$mar[2];

				#print "mtag is $mtag\n";

			}

			if ( $_ =~ /\Qlabel>\E/ ) {

				undef $nl;
				undef $mtag;

			}

			if ( defined $nl && $l == $nl && defined $mtag ) {

				#print "nl is $nl and mtag is $mtag\n";
				last;

			}


		}

	}

}

if ( ! defined $mtag ) {

	die "\n !! Error: Didn't find mtag for label $l in ddnReqLabels.xml !!\n";

}

@res=grep(/$mtag/,@mult);
@jp=split(/,/,$res[0]);

#print "name is $jp[0] addr is $jp[1] port is $jp[2] dscp is $jp[3]\n";

@pinf=grep(/$jp[2]/,@port);
@info=split(/,/,$pinf[0]);

#print "pname is $info[0] and port is $info[1]\n";

open $mainOut, '>', "TEST.xml";
open $mtpOut, '>', "Profile.xml";
open $ricOut, '>', "RIC.xml";
open $fltOut, '>', "test.flt";

print $mainOut "<?xml version=\"1.0\" ?>\n";
print $mainOut "<TGParameter log=\"0\">\n";
print $mainOut "    <TrafficGenerateType value=\"XMLTraffic\" />\n";
print $mainOut "    <Protocol value=\"MTP\" />\n";
print $mainOut "    <Continuous value=\"No\" />\n";
print $mainOut "    <LogFile value=\"\" />\n";
print $mainOut "    <Traffic>\n";
print $mainOut "        <Item TrafficFileName=\".\\RIC.xml;\" MsgsPerFrame=\"1\" MsgsPerSecond=\"1\" TimesToLoop=\"1\" LoopType=\"TrafficFile\" AutoIncISN=\"Yes\" RICListFile=\"\" FIDListFile=\"\">\n";
print $mainOut "            <Profile value=\".\\Profile.xml\" />\n";
print $mainOut "        </Item>\n";
print $mainOut "    </Traffic>\n";
print $mainOut "</TGParameter>\n";


print $ricOut "<?xml version=\"1.0\"?>\n";
print $ricOut "<Traffic>\n";
print $ricOut "  <Message>\n";
print $ricOut "    <MsgBase>\n";
print $ricOut "      <SetID value=\"30\"/>\n";
print $ricOut "      <StreamID value=\"0\"/>\n";
print $ricOut "      <MsgClass value=\"Request\"/>\n";
print $ricOut "      <ContainerType value=\"NoData\"/>\n";
print $ricOut "      <MsgKey>\n";
print $ricOut "        <Mask value=\"0\"/>\n";
print $ricOut "        <DomainType value=\"MarketPrice\"/>\n";
print $ricOut "        <NameType value=\"1\"/>\n";
print $ricOut "        <NameEncodingType value=\"0\"/>\n";
print $ricOut "        <Name value=\"$ric\"/>\n";
print $ricOut "        <Qos value=\"10\"/>\n";
print $ricOut "        <ServiceID value=\"0\"/>\n";
print $ricOut "        <Opaque value=\"\"/>\n";
print $ricOut "      </MsgKey>\n";
print $ricOut "    </MsgBase>\n";
print $ricOut "    <Mask value=\"684\"/>\n";
print $ricOut "    <PriorityClass value=\"0\"/>\n";
print $ricOut "    <PriorityCount value=\"0\"/>\n";
print $ricOut "    <RecoveryItemSeqNum value=\"0\"/>\n";
print $ricOut "    <ConstitFilter value=\"2\"/>\n";
print $ricOut "  </Message>\n";
print $ricOut "\n";
print $ricOut "</Traffic>\n";

print $mtpOut "<?xml version=\"1.0\" ?>\n";
print $mtpOut "<MTPTransport>\n";
print $mtpOut "	        <DestIPAddr value=\"$jp[1]\" />\n";
print $mtpOut "		<DestPort value=\"$info[1]\" />\n";
print $mtpOut "		<Version value=\"0\" />\n";
print $mtpOut "		<MaxFrameSize value=\"1472\" />\n";
print $mtpOut "		<LineID value=\"40\" />\n";
print $mtpOut "		<InitSeqNum value=\"0\" />\n";
print $mtpOut "		<SeqNumLength value=\"2\" />\n";
print $mtpOut "		<SourceIPAddr value=\"159.44.3.173\" />\n";
print $mtpOut "		<SourcePort value=\"7777\" />\n";
print $mtpOut "		<ArbFlag value=\"0\" />\n";
print $mtpOut "		<TTL value=\"128\" />\n";
print $mtpOut "		<DSCP value=\"0\" />\n";
print $mtpOut "</MTPTransport>\n";

print $fltOut "AND(All_msgBase_msgKey_name = \"$ric\", TRWF_ResponseType = \"TRWF_TRDM_RPT_UNSOLICITED_RESP\")\n";

print "\nJob completed successfully. \n\n";
