#!/bin/bash

clear

region=`cat /efs/imei/mps_code.dat`
android=`getprop ro.build.version.release`

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

echo -e "\n\n-- Mounting RW --\n\n"

mount -o rw,remount /optics

echo -e "-- Making a Backup of cscfeature.xml --\n\n"
if [ ! -f "$backup" ]; then
cp $pth/cscfeature.xml $pth/cscfeature.xml.bak
else
echo -e "-- Backup Already Exists --\n\n"
fi

echo -e "-- Downloading OMC Decoder --\n\n"

curl --no-progress-meter -Lo cscdecoder-aarch64 https://github.com/soulr344/OMCDecoder/releases/download/v1.0/cscdecoder-aarch64 && chmod +x cscdecoder-aarch64

echo -e "-- Decrypting --"

./cscdecoder-aarch64 -i $pth/cscfeature.xml
chmod 644 $pth/cscfeature.xml
chmod 644 $pth/cscfeature.xml.bak

echo -e "\n\n-- Cleaning --\n\n"

rm cscdecoder-aarch64
rm decode-csc.sh

else

echo -e "\n\n-- File is Already Decrypted --"

echo -e "\n\n-- Cleaning --\n\n"

rm decode-csc.sh

fi

else

echo -e "\n\n-- Can't Find Required Files at /optics/configs/carriers/$region --"

fi

echo -e "\n\n-- Done :) --\n\n"
