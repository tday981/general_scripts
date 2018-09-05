#!/bin/bash

#Determine if system or channel is requested
echo -n "system or channel? "
read ans

if [[ "$ans" == "system" ]]; then
file=sltSystemSBBufUtilPeak*;
sortopts="sort -t, -k 2,30r"
fi

if [[ "$ans" == "channel" ]]; then
file=sltChannelSBBufUtilPeak*;
sortopts="sort -t, -k 3,30nr"
fi

#Number of lines to remove from top of file
rmln=18

#Number of lines in file
kln=`cat $file | wc -l`

#Number of lines to tail
let ln=$kln-$rmln

#Remove lines
tail -n $ln $file > temp.txt

#List buffer usage
cat temp.txt | $sortopts | less
