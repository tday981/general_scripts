#!/bin/bash

echo -n "milliseconds: "
read milli

sec=`echo "scale=5; ($milli/1000)" | bc `
hours=`echo "scale=0; ($sec/3600)" | bc`
hsec=`echo "($hours*3600)" | bc`
x=`echo "($sec-$hsec)" | bc`
min=`echo "scale=0; ($x/60)" | bc`
msec=`echo "($min*60)" | bc`
x=`echo "($x-$msec)" | bc`
mill=`echo "scale=0; ($x/1000)" | bc`

echo "$hours:$min:$x"

