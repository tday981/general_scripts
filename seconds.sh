#!/bin/bash

echo -n "seconds: "
read sec

hours=`echo "scale=0; ($sec/3600)" | bc`
hsec=`echo "($hours*3600)" | bc`
x=`echo "($sec-$hsec)" | bc`
min=`echo "scale=0; ($x/60)" | bc`
msec=`echo "($min*60)" | bc`
x=`echo "($x-$msec)" | bc`

echo "$hours:$min:$x"

