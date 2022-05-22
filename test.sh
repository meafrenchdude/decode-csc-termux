#!/bin/bash

clear

region=`cat /efs/imei/mps_code.dat`
android=`getprop ro.build.version.release`

#Checking android version. Path is different in A12
if [ $android -eq 12 ]; then
pth="/optics/configs/carriers/$region/conf/system"
else
pth="/optics/configs/carriers/$region/conf"
fi

echo $path

echo -e "\n\n-- Cleaning --\n\n"
rm cscdecoder-aarch64 2> /dev/null
rm decode-csc.sh 2> /dev/null
