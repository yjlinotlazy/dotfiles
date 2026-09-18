#!/bin/sh

raw=`df -HBG /home/yli/e | grep /dev/`

used=`echo $raw | awk '{print $3}'`

all=`echo $raw | awk '{print $2}'`

free=`echo $raw | awk '{print $4}'`

gpu=`nvidia-smi --id=0 --query-gpu=utilization.gpu --format=csv,noheader,nounits`

echo "$gpu"
