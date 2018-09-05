#!/bin/bash

if [ ! -d /smb/rdf/bandwidth ]; then
	mkdir /smb/rdf/bandwidth
fi

banddir="/smb/rdf/bandwidth"

rdflist=`ls -d /smb/rdf/slts/*/ | awk -F/ '{ print $5 }'`

for i in $rdflist; do
	echo $i;
done

echo -n "Which RDF: "
read rdf

daylist=`ls -d /smb/rdf/slts/$rdf/*/ | awk -F/ '{ print $6 }'`

#for i in $daylist; do
#	echo $i;
#done

#echo -n "Which Day: "
#read day

echo -n "Enter bandwidth (Kb): "
read val 

bw=`echo "(1024*$val)" | bc -l`

#for i in `find /smb/rdf/slts/$rdf/$day* -name sltNetworkThroughputPeak*`; do
for i in `find /smb/rdf/slts/$rdf/* -name sltNetworkThroughputPeak*`; do
		dir=`echo "$i" | awk -F/ '{ print $5 }' | awk -F_ '{ print $1 }'`
		date=`echo "$i" | sed 's/^.*sltNetworkThroughputPeak_//' | awk -F_ '{ print $2 }' | awk -F. '{ print $1 }'`

			if [ ! -d $banddir/$dir ]; then
				mkdir $banddir/$dir
			fi
			numlist=$banddir/$dir/temp.txt
			cat $i | grep ^\"20.. | awk -F, '{ print $1,$4,$6 }' | sort -rd | sed 's/"//g' >> $numlist;
done

cat $numlist | awk '{ print $3 }' | grep [0-9] > $banddir/$dir/temp1.txt
for i in `cat $banddir/$dir/temp1.txt`; do
	
	if [[ $i -ge $bw ]]; then
		grep $i $numlist >> ban.temp
	fi;

done

sort -k3,3nr ban.temp | uniq > ban.txt
rm ban.temp

#rm -f $banddir/$dir/temp*
