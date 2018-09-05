#!/bin/bash
echo -n "Which process id: "
read pid

i=1

echo ""
echo "Working"
echo ""

while [[ $i -le 10 ]]; do
	pstack $pid >> $pid.stack
	echo "" >> $pid.stack
	echo "" >> $pid.stack
	sleep 1;
	let i=i+1
done
echo "Done"
