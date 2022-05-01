#!/bin/sh

clear

REGION=`cat /efs/imei/mps_code.dat`
ANDROID=`getprop ro.build.version.release`

if [ $ANDROID -eq 12 ]; then
PTH="/optics/configs/carriers/$REGION/conf/system"
else
PTH="/optics/configs/carriers/$REGION/conf"
fi

BACKUP=$PTH/cscfeature.xml.bak

#Checking if it's already decryted
if [ "`file $PTH/cscfeature.xml`" == "data" ]; then

echo -e "\n\n-- You are on Android $ANDROID --"

echo -e "\n\n-- Mounting RW --\n\n"

mount -o rw,remount /optics

echo -e "-- Making a Backup of cscfeature.xml --\n\n"
if [ ! -f "$BACKUP" ]; then
cp $PTH/cscfeature.xml $PTH/cscfeature.xml.bak
else
echo -e "-- Backup Already Exists --\n\n"
fi

echo -e "-- Downloading OMC Decoder --\n\n"

curl --no-progress-meter -Lo cscdecoder-aarch64 https://github.com/soulr344/OMCDecoder/releases/download/v1.0/cscdecoder-aarch64 && chmod +x cscdecoder-aarch64

echo -e "-- Decrypting --"

./cscdecoder-aarch64 -i $PTH/cscfeature.xml
chmod 644 $PTH/cscfeature.xml
chmod 644 $PTH/cscfeature.xml.bak

echo -e "\n\n-- Cleaning --\n\n"

rm cscdecoder-aarch64
rm decode-csc.sh

echo -e "-- Done :) --\n\n"

else

echo -e "-- File is Already Decrypted :) --"
fi

echo -e "\n\n-- Cleaning --\n\n"

rm decode-csc.sh

echo -e "-- Done :) --\n\n"
