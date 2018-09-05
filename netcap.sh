#!/bin/bash

echo -n "Write to a file? "
read ans

if [[ "$ans" == "y" || "$ans"  == "yes" ]]; then

	echo -n "Name file: "
	read file
	tcpdump -i eth0 -s 65535 -w /smb/$file;

else

	tcpdump -i eth0 -s 65535;

fi
