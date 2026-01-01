#!/bin/sh

raw=`df -HBG /home/yli/e | grep /dev/`

used=`echo $raw | awk '{print $3}'`

all=`echo $raw | awk '{print $2}'`

free=`echo $raw | awk '{print $4}'`

echo "$used/$all"
