#!/bin/bash

# Enable NVMe support in /boot/firmware/config.txt

TARGET_PATH="/etc/systemd/system/"

sudo cp tdlas.service tdlasbr.service tdlasinfo.service "$TARGET_PATH"

cp run_dashboard /opt/tdlas/

#tdlasinfo를 GUI 프로그램으로 변
#sudo systemctl mask getty@tty1
sudo systemctl enable tdlasbr
sudo systemctl enable tdlas
#sudo systemctl enable tdlasinfo


