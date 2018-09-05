#!/bin/bash
echo -n "Value in bits: "
read val

newval=`echo "scale=3;$val / (1024*1024)" | bc -l`

echo "$newval Mb"
