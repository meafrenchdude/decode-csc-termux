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

backup=$pth/cscfeature.xml.bak

echo -e "\n\n-- You are on Android $android --"
echo -e "\n\n-- Your Region is $region --"

#checking if the files exist
if [ -d /optics/configs/carriers/$region ] && [ -f $pth/cscfeature.xml ]; then

#Checking if it's already decryted
if [ "`file $pth/cscfeature.xml`" == "$pth/cscfeature.xml: data" ]; then

echo -e "\n\n-- Mounting RW --"
mount -o rw,remount /optics

echo -e "\n\n-- Making a Backup of cscfeature.xml --"
#Checking if a bakcup exists
if [ ! -f "$backup" ]; then
cp $pth/cscfeature.xml $pth/cscfeature.xml.bak
else
echo -e "\n\n-- Backup Already Exists --"
fi

echo -e "\n\n-- Downloading OMC Decoder --"
curl --no-progress-meter -Lo cscdecoder-aarch64 https://github.com/soulr344/OMCDecoder/releases/download/v1.0/cscdecoder-aarch64 && chmod +x cscdecoder-aarch64

echo -e "\n\n-- Decrypting --"
./cscdecoder-aarch64 -i $pth/cscfeature.xml
chmod 644 $pth/cscfeature.xml
chmod 644 $pth/cscfeature.xml.bak

echo -e "\n\n-- Done :) --"

else
echo -e "\n\n-- File is Already Decrypted --"

fi

else
echo -e "\n\n-- Can't Find The Required Files at /optics/configs/carriers/$region --"

fi

echo -e "\n\n-- Cleaning --\n\n"
rm cscdecoder-aarch64 2> /dev/null
rm decode-csc.sh 2> /dev/null
