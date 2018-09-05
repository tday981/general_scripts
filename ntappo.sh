#!/bin/bash

for i in *NTAPP0; do

name=`echo $i | awk -F_ '{ print $3 }' | sed 's/\..*$//'`
strings $i | awk -F, '{ print $1,$2,$50 }' | grep -v PDF | grep -v Application | sort -n -rk3,3 > temp.txt;
#string=`cat temp.txt | grep -v "^"[0-9]"" | awk '{ print $1 }'`
#num=`cat -n temp.txt | grep $string | awk '{ print $1 }'`
#head=`echo "( $num - 1 )" | bc -l`
#head -n $head temp.txt | sort -rnk2,2 > $name.txt
sort -rnk2,2 temp.txt | uniq > $name.txt

unix2dos -q $name.txt

done

rm temp.txt
