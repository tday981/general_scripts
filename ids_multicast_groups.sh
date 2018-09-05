#!/bin/bash

grep MCLabels /ThomsonReuters/dpop/config/dpopadh.cnf | grep 02a | sed -e 's/^.*\:\ //' -e 's/\,\ /\n/g' | sort -n | uniq > list.txt

for i in `cat list.txt`; do grep -A 3 "label\ ID\=\"$i\"" /ThomsonReuters/Config/ddnCoreLabels.xml | grep multTag | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'; done

for i in `cat join.txt`; do grep "multAddr\ TAG=\"$i" /ThomsonReuters/Config/ddnCoreLabels.xml | cut -d\" -f 4 >> net.txt; done

for i in `cat net.txt`; do netstat -vg | grep -q $i; if [[ "$?" -eq "1" ]]; then echo "$i is not present";fi; done
