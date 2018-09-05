#!/usr/bin/perl


$service = "IDN_TDAY";
$userAppId = "67_ITEM_REQUIREMENT+256";

$RICCount =  $#ARGV;
$RICCount++;

if ($#ARGV == -1 ) {
	
	#TODO: need loop to get all RICs involved here interactively
	
	print "This script currently does not run interactively.\n";
	print "Syntax: ./itemReq.pl <ric1> <ric2>...\n\n";
}
else
{
	print "$RICCount RICs read from command line arguments....\n";
	print "Collecting PE codes, may take a few minutes....\n";
	foreach $item (@ARGV)
	{
		push(@PEList, `permTest -clientconnection null -concreteservice $service -username $userAppId -itemname $item -reqtype lock+SourceRVProtocol| grep -v Oak| grep -v permTest| grep -v permission| grep -v SSL| grep .`);
	}

	print "Generating SQL...\n";

	open SQL, ">.sqlTemp.sql" or die "Can not open .sqlTemp.sql!\n\n\n";
	print SQL "use dacs_main\n";
	print SQL "go\n";
	foreach $PE (@PEList)
	{
		print SQL "SELECT local_name,type FROM auth_entity INNER JOIN PE_AE ON auth_entity.id = PE_AE.ae_id AND PE_AE.pe_id = $PE AND NOT local_name=NULL ORDER BY type\n";
		print SQL "go\n";
	}

	print "Executing SQL query.  This can take a while....\n";
	@DacsCodes = `isql -Usa -P"" -w400 -i.sqlTemp.sql -n | grep -v local_name | grep -v affected | grep -v -`;
	
	$specialCase = @ARGV[0] . "\n-----------\n";
	print $specialCase;
	$i = 1;
	foreach $item (@DacsCodes) 
	{
		unless (length $item > 1)
		{
			if ($i <= $#ARGV)	
			{
				$item = "\n" . @ARGV[$i] . "\n-----------\n";
				$i++;
			}
		}
	}
	print @DacsCodes;
}
