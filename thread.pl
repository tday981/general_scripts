#!/usr/bin/perl
use warnings;

use threads;
use WWW::Mechanize;
no warnings 'uninitialized';

open(INPUT,'<','urls.txt') || die("Couldn't open the file in read mode\n");

print "Starting main program\n";

my @threads;

while(my $url = <INPUT>)
{
    chomp $url;
        my $t = threads->new(\&sub1, $url);
            push(@threads,$t);
            }

            foreach (@threads) {
                $_->join;
                }

                print "End of main program\n";

                sub sub1 {
                    my $site = shift;
                        sleep 1;
                            my $mech = WWW::Mechanize->new();
                                $mech->agent_alias('Windows IE 6');

                                    # trap any error which occurs while sending an HTTP HEAD request to the site
                                        eval{$mech->head($site);};
                                            if($@)
                                                {
                                                        print "Error connecting to: ".$site."\n";
                                                            }

                                                                my $response = $mech->response();

                                                                    print $site." => ".$response->header('Server'),"\n";
                                                                    }
