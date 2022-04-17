#!/bin/bash
#!/bin/sh
# Coded By Xnuvers007 don't modified without Credits

# For Windows Version , will be soon

Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'
t_reset='\e[0m'


echo "$Green"
echo "========= Hostname ================"
hostnamectl
echo
echo "========= Your IP  ================"
echo "IP Wlan0 : " ; ip addr show wlan0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo "IP Wlan1 : " ; ip addr show wlan1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo "IP Eth0 : " ; ip addr  show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo "IP Eth1 : " ; ip addr  show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo "IP Usb0 : " ; ip addr  show usb0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo "IP Usb1 : " ; ip addr  show usb1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo
echo "======== Linux Standard Base ======"
lsb_release -a
echo

read -p "Press [Enter] key to continue..."
clear
echo "$Green"
echo "You Need Android at least API 21 or Android 5.0 , Recommended is Android 10"
echo "Make Sure you enabled USB Debugging on your Android device, settings > Developer options > USB Debugging"
echo "if you already connect ur cable usb to laptop, then continue"
read -p "Press [Enter] key to continue..."
echo "$t_reset"
clear

read -p "Your password Linux : " password
clear
echo "$password" | sudo -S chmod +x run.sh ; ./run.sh