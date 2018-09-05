#!/bin/bash
bdsdir=/smb/rdf/bds

#Set date variables
mnth=`date +"%m"`
dy=`date +"%d"`
yr=`date +%"y"`

if [ ! -d /smb/rdf/bds ]; then
	mkdir /smb/rdf/bds;
fi

echo -n "Output to file (y/n):"
read ans

if [[ "$ans" == y || "$ans" == Y ]]; then

#echo -n "Output file name: "
#read name

logs=`ls -d /smb/rdf/logs/*/ | awk -F/ '{ print $5 }'`

for i in $logs; do
	echo $i;
done

echo -n "Which RDF: "
read rdf

#grep "Criteria Name" /smb/rdf/logs/$rdf/*.txt
for i in `find /smb/rdf/logs/ -type d -name "$rdf"`; do
name=`basename $i`

if [ ! -d $bdsdir/$name ]; then

	mkdir -p $bdsdir/$name

fi

#cat /smb/rdf/logs/$i/$mnth\_$dy\_$yr/*.txt | grep "Criteria Name" > $bdsdir/$rdf.txt
#cat $i/$mnth\_$dy\_$yr/*.txt | grep "Criteria Name" > $bdsdir/$name.txt
cat $i/*.txt | grep -i "criteria" > $bdsdir/$name/$name.log

done

else

logs=`ls -d /smb/rdf/logs/*/ | awk -F/ '{ print $5 }'`

for i in $logs; do
	echo $i;
done

echo -n "Which RDF: "
read rdf

#grep "Criteria Name" /smb/rdf/logs/$rdf/*.txt
#cat /smb/rdf/logs/$rdf/$mnth\_$dy\_$yr/*.txt | grep "Criteria Name"
cat /smb/rdf/logs/$rdf/*.txt | grep -i "criteria"

fi
