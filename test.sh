#!/bin/sh

clear

REGION=`cat /efs/imei/mps_code.dat`
ANDROID=`getprop ro.build.version.release`

#if [ $ANDROID="A12" ]; then
PATH="/optics/configs/carriers/$REGION/conf/system"
#else
#PATH="/optics/configs/carriers/$REGION/conf"
#fi

BACKUP=$PATH/cscfeature.xml.bak

echo -e "\n\n-- Your android version is $ANDROID --"
echo -e "\n\n$PATH"
echo -e "\n\n-- Mounting RW --\n\n"

mount -o rw,remount /optics

echo -e "-- Making a Backup of cscfeature.xml --\n\n"
if [ ! -f "$BACKUP" ]; then
cp $PATH/cscfeature.xml $PATH/cscfeature.xml.bak
else
echo -e "-- Backup Already Exists --\n\n"
fi

echo -e "-- Downloading OMC Decoder --\n\n"

curl --no-progress-meter -Lo cscdecoder-aarch64 https://github.com/soulr344/OMCDecoder/releases/download/v1.0/cscdecoder-aarch64 && chmod +x cscdecoder-aarch64

echo -e "-- Decrypting --"

./cscdecoder-aarch64 -i $PATH/cscfeature.xml
chmod 644 $PATH/cscfeature.xml
chmod 644 $PATH/cscfeature.xml.bak

echo -e "\n\n-- Cleaning --\n\n"

rm cscdecoder-aarch64
rm decode-csc.sh

echo -e "-- Done :) --\n\n"
