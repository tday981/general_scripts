#!/bin/bash

ps -eo pid,pcpu,nice,user,s,args| grep -v PID | sort -nk2,2 | head -n 10
