#!/bin/bash

#rdf=`pwd | awk -F/ '{ print $5 }'`

rdflist=`ls -d /smb/rdf/slts/*/ | awk -F/ '{ print $5 }'`
banddir=/smb/rdf/bandwidth

for i in $rdflist; do
        echo $i;
done

echo -n "Which RDF: "
read rdf

#daylist=`ls -d /smb/rdf/slts/$rdf/*/ | awk -F/ '{ print $6 }'`

#for i in $daylist; do
#        echo $i;
#done

#echo -n "Which Day: "
#read day

name=`echo $rdf | sed 's/^.*-//'`

file=sltNetworkThroughputPeak_

mkdir temp

find /smb/rdf/slts/$rdf -name $file\* > temp/files.temp
sort temp/files.temp | uniq > temp/files.txt

echo -n "Do you want client or rdf traffic? "
read traff

if [[ "$traff" == "client" ]]; then
	traffsort="sort -nr -t, -k 6"
fi

if [[ "$traff" == "rdf" ]]; then
	traffsort="sort -nr -t, -k 4"
fi


for i in `cat temp/files.txt`; do
                
		#dir=`echo "$i" | awk -F/ '{ print $5 }' | awk -F_ '{ print $1 }'`
		rdf=`echo $i | awk -F\/ '{ print $5 }'`
		dir=`echo "$i" | sed 's/sltNetworkThroughputPeak.*//'`
                date=`echo "$i" | sed 's/^.*sltNetworkThroughputPeak_//' | awk -F_ '{ print $2 }' | awk -F. '{ print $1 }'`
                file=`echo "$i" | awk -F/ '{ print $8 }' | sed 's/20.*$//'`
		year=`echo $date | sed 's/....$//'`
		month=`echo $date | sed 's/^....//' | sed 's/..$//'`
		day=`echo $date | sed 's/^......//'`

	echo $date >> temp/day.temp
	sort temp/day.temp | uniq > temp/day.txt

	if [ ! -d $banddir/$rdf ]; then
		mkdir $banddir/$rdf
	fi

	echo "" >> $banddir/$rdf/$rdf.txt
	echo "$month/$day/$year" >> $banddir/$rdf/$rdf.txt
	echo "" >> $banddir/$rdf/$rdf.txt

	cat $i | $traffsort | head | awk -F, '{ print $1,$4,$6 }' | head >> $banddir/$rdf/$rdf.txt
	done

#rm -rf temp
unix2dos -q $banddir/$rdf/$rdf.txt
