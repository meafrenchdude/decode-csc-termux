#!/bin/bash

clear

REGION=`cat /efs/imei/mps_code.dat`
BACKUP=/optics/configs/carriers/$REGION/conf/cscfeature.xml.bak

echo -e "\n\n-- Mounting RW --\n\n"

mount -o rw,remount /optics

if [ ! -f "$BACKUP" ]; then
echo -e "-- Making a Backup of cscfeature.xml --\n\n"
cp /optics/configs/carriers/$REGION/conf/cscfeature.xml /optics/configs/carriers/$REGION/conf/cscfeature.xml.bak
else
echo -e "-- Backup Already Exists --\n\n"
fi

echo -e "-- Downloading OMC Decoder --\n\n"

curl --no-progress-meter -Lo cscdecoder-aarch64 https://github.com/soulr344/OMCDecoder/releases/download/v1.0/cscdecoder-aarch64 && chmod +x cscdecoder-aarch64

echo -e "-- Decrypting --"

./cscdecoder-aarch64 -i /optics/configs/carriers/$REGION/conf/cscfeature.xml
chmod 644 /optics/configs/carriers/$REGION/conf/cscfeature.xml

echo -e "\n\n-- Cleaning --\n\n"

rm cscdecoder-aarch64
rm decode-csc.sh

echo -e "-- Done :) --\n\n"
