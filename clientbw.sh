#!/bin/bash

sort -nr -t, -k 6 *ThroughputPeak* | head | awk -F, '{ print $1,$4,$6 }'
