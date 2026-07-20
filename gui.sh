#!/bin/bash

cd "$(dirname "$0")"

#설치
sudo apt update && sudo apt upgrade -y
sudo apt install --no-install-recommends ubuntu-desktop
sudo systemctl set-default graphical.target

#자동부팅
sudo sed -i '/AutomaticLogin/d' /etc/gdm3/custom.conf
sudo sed -i "/\[daemon\]/a AutomaticLoginEnable = true\nAutomaticLogin = easyrnd" /etc/gdm3/custom.conf

#화면 잠금 및 절전모드 끄기
# 화면이 꺼지는 시간 설정 (0은 안 함)
gsettings set org.gnome.desktop.session idle-delay 0
# 자동 화면 잠금 끄기
gsettings set org.gnome.desktop.screensaver lock-enabled false
# 서스펜드(컴퓨터 절전 상태) 진입 막기 (AC 전원 사용 시)
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
