#!/bin/bash

echo -n "seconds: "
read sec

hours=`echo "scale=0; ($sec/3600)" | bc`
hsec=`echo "($hours*3600)" | bc`
l=`echo "($sec-$hsec)" | bc`
min=`echo "scale=0; ($l/60)" | bc`
msec=`echo "($min*60)" | bc`
l=`echo "($l-$msec)" | bc`

echo "$hours:$min:$l"

