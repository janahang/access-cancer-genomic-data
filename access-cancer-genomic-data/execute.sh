#!/bin/bash

if [ $# -gt 3 ]; then echo "More then 3 genes were entered. First three genes will be used"; fi
R CMD BATCH --no-timing --slave --no-save --no-restore "--args $1 $2 $3" assignment.r output.log 
