#!/usr/bin/perl
# 
# HTML scraping script.  Originally written to scrap a list of hosts in a /etc/hosts
# compatible file format.  The general idea is that it will pull the file in $hostAddr,
# search through it for anything between $tag and $tagEnd, and then output it to a
# seperate file.  The second half of the program (which can be disabled by setting $scp 
# to 0) will push the file out to a remote host as defined by STDIN.  The $user is 
# passed to scp to log in with.  The scp process will directly prompt you for your 
# password.  
#
#
# Kludged together 12/17/08 by BA
#


# set up initial variables
$hostAddr = "http://10.91.31.7/wiki/index.php/Hostlist";  # for initial wget
$tag = "<pre>"; # the tag we should look for to scrape between
$tagEnd = "<\/pre>"; # no quick way to do this automatically
$debug = 0; # debug mode.  creates lots of output, most meaningless
$scp = 0; # enables or disables the remote copy option

# This is used for the scp commands to copy the hosts file to other boxen
$user = "root";

# Error messages
$err_Input = "Hostlist file can not be read from.  Please verify file exists!\n";
$err_Output = "hosts.new can not be opened for writing!\n";

# Get the hostlist from the wiki on 25.188
system("wget -O Hostlist $hostAddr");

# Open files, FILE is input and NEWHOSTLIST is output
open FILE, "Hostlist" or die $err_Input;
open NEWHOSTLIST, ">hosts.new" or die $err_Output;

# this switches on the $tag tag detection.  Do not modify.
$inPreTags = 0;

# This is a special case.  We want to preserve the localhost
# because some processes might fail without it.
print NEWHOSTLIST "127.0.0.1	localhost\n\n";
while (my $line = <FILE>) {

	# Looking for the closing tag.  This actually has to come first due to the
	# fact that we do not want to write the $tagEnd tag into the new hosts file
	# before we detect we've hit it and switch off.
	if ($line =~ m/$tagEnd/)
	{
		if ($debug == 1)
		{
			print "$tagEnd tag closed on line:\n";
			print $line;
			print "\n\n";
		}
		$inPreTags = 0;
	}

	# we are within the $tag tags so we can write out to the file here.
	if ($inPreTags == 1)
	{
		if ($debug == 1)
		{
			print $line;
		}
		print NEWHOSTLIST $line;
	}

	# Looking for our opening tag.  Should not be writing to file yet
	if ($line =~ m/$tag/)
	{
		if ($debug == 1)
		{
			print "$tag tag found on line:\n";
			print $line;
			print "\n\n";
		}
		$inPreTags = 1;
	}
}

close(FILE);
close(NEWHOSTLIST);
#print "Hostlist import complete.  Please verify file and then \"cat hosts.new > /etc/hosts\" (this will overwrite your old hosts file!)\n\n";
system("cat hosts.new > /etc/hosts");
