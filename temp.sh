#!/bin/bash

if [ ! -d /smb/rdf/bandwidth ]; then
	mkdir /smb/rdf/bandwidth
fi

banddir="/smb/rdf/bandwidth"

rdflist=`ls -d /smb/rdf/rdfslts/*/ | awk -F/ '{ print $5 }'`

for i in $rdflist; do
	echo $i;
done

echo -n "Which RDF: "
read rdf

echo -n "Any particular hour? "
read hour

if [[ "$hour" == y || "$hour" == yes ]]; then

	echo -n "Which hour? "
	read hr

for i in `find /smb/rdf/rdfslts/$rdf* -name *ThroughputPeak*`; do
	
		dir=`echo "$i" | awk -F/ '{ print $5 }' | awk -F_ '{ print $1 }'`
		date=`echo "$i" | sed 's/^.*sltNetworkThroughputPeak_//' | awk -F_ '{ print $2 }' | awk -F. '{ print $1 }'`

			if [ ! -d $banddir/$dir ]; then
				mkdir $banddir/$dir
			fi
			
			sort -nt, -k 2 $i | awk -F, '{ print $1,$4,$6 }' | grep "$hr:..:.." > $banddir/$dir/$date.txt;
		done;

else
for i in `find /smb/rdf/rdfslts/$rdf -name *ThroughputPeak*`; do
	
	echo $i
		dir=`echo "$i" | awk -F/ '{ print $5 }' | awk -F_ '{ print $1 }'`
		date=`echo "$i" | sed 's/^.*sltNetworkThroughputPeak_//' | awk -F_ '{ print $2 }' | awk -F. '{ print $1 }'`

			if [ ! -d $banddir/$dir ]; then
				mkdir $banddir/$dir
			fi

		sort -nr -t, -k 4 $i | head | awk -F, '{ print $1,$4,$6 }' > $banddir/$dir/$date.txt;
		done
fi
