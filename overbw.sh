#!/bin/bash

echo -n "Enter bandwidth (Mb): "
read val

bw=`echo "(1024*1024)*$val" | bc -l` 
echo $bw
cat 20*.txt | sort -rnk 3 | awk '{ print $3 }' > temp.txt

for i in `cat temp.txt`; do
	if [[ $i -gt $bw ]]; then
		grep $i 20*.txt
	fi;

rm -f temp.txt

done
