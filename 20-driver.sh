#!/bin/bash

#20-driver.sh
cd "$(dirname "$0")"

DRIVER_VERSION="1.1.7"
DRIVER_FILENAME="libftd3xx-linux-arm-v8-${DRIVER_VERSION}.tgz"

if [ ! -d "./temp" ]; then
    mkdir ./temp
fi

cd ./temp

mv "../${DRIVER_FILENAME}" .

#압축해제
if [ ! -d "linux-arm-v8" ]; then
tar -xvzf ${DRIVER_FILENAME}
fi

cd ./linux-arm-v8

#파일복사
if [ -f "/usr/lib/libftd3xx.so" ]; then
    sudo rm -v /usr/lib/libftd3xx.so
fi
sudo cp -v libftd3xx.so /usr/lib/
sudo cp -v libftd3xx.so.${DRIVER_VERSION} /usr/lib/
sudo cp -v 51-ftd3xx.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
