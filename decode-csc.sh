#!/bin/bash

clear

REGION=`ls /optics/configs/carriers`

echo -e "\n\n-- Making a Backup of cscfeature.xml --\n\n"

cp /optics/configs/carriers/$REGION/conf/cscfeature.xml /optics/configs/carriers/$REGION/conf/cscfeature.xml.bak

echo -e "-- Downloading OMC Decoder --\n\n"

curl -Lo cscdecoder-aarch64 https://github.com/soulr344/OMCDecoder/releases/download/v1.0/cscdecoder-aarch64 && chmod +x cscdecoder-aarch64

echo -e "\n"

echo -e "-- Decrypting --\n\n"

./cscdecoder-aarch64 -i /optics/configs/carriers/$REGION/conf/cscfeature.xml

echo -e "-- Cleaning --\n\n"

rm cscdecoder-aarch64

echo -e "-- Done :) --\n\n"
