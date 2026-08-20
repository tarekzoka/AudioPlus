#!/bin/sh
#

wget -O /tmp/ipaudioplus.tar.gz "https://raw.githubusercontent.com/tarekzoka/AudioPlus/raw/main/ipaudioplus.tar.gz"

tar -xzf /tmp/*.tar.gz -C /

rm -r /tmp/ipaudioplus.tar.gz

echo "         UPLOADED BY TARK_HANFY    "


killall -9 enigma2

sleep 2;


