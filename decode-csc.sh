#!/bin/bash

clear

region=`cat /efs/imei/mps_code.dat`
android=`getprop ro.build.version.release`

#Checking android version. Path is different in A12
if [ $android -eq 12 ]; then
path="/optics/configs/carriers/$region/conf/system"
else
path="/optics/configs/carriers/$region/conf"
fi

backup=$path/cscfeature.xml.bak

echo -e "\n\n-- You are on Android $android --"
echo -e "\n\n-- Your Region is $region --"

#Checking if the files exist
if [ -d /optics/configs/carriers/$region ] && [ -f $path/cscfeature.xml ]; then

#Checking if it's already decryted
if [ "`file $path/cscfeature.xml`" == "$path/cscfeature.xml: data" ]; then

echo -e "\n\n-- Mounting RW --"
mount -o rw,remount /optics

echo -e "\n\n-- Making a Backup of cscfeature.xml --"
#Checking if a backup exists
if [ ! -f "$backup" ]; then
cp $path/cscfeature.xml $path/cscfeature.xml.bak
else
echo -e "\n\n-- Backup Already Exists --"
fi

echo -e "\n\n-- Downloading OMC Decoder --"
curl --no-progress-meter -Lo cscdecoder-aarch64 https://github.com/soulr344/OMCDecoder/releases/download/v1.0/cscdecoder-aarch64 && chmod +x cscdecoder-aarch64

echo -e "\n\n-- Decrypting --"
./cscdecoder-aarch64 -i $path/cscfeature.xml
chmod 644 $path/cscfeature.xml
chmod 644 $path/cscfeature.xml.bak

echo -e "\n\n-- Done :) --"

else
echo -e "\n\n-- File is Already Decrypted --"

fi

else
echo -e "\n\n-- Can't find the required files at $path --"
echo -e "\n\n-- Make sure the files are there and you are on the right region of your stock rom --"

fi

echo -e "\n\n-- Cleaning --\n\n"
rm cscdecoder-aarch64 2> /dev/null
rm decode-csc.sh 2> /dev/null
