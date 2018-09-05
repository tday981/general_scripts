#!/bin/bash

if [ ! -n "$1" ]; then
	
	echo "Which file?"
	exit 0

fi

clear
grep -if /home/jason/bin/.standby $1 | sort
