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
echo "========= IP Kamu  ================"
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

read -p "Silahkan Enter untuk continue..."
clear
echo "$Green"
echo "Anda Membutuhkan Android setidaknya API 21 atau Android 5.0, Direkomendasikan adalah Android 10"
echo "Pastikan Anda mengaktifkan USB Debugging di perangkat Android Anda, pengaturan > Opsi pengembang > USB Debugging"
echo "Jika sudah terkoneksi kabel usb nya ke laptop, lalu enter untuk continue"
read -p "ketik enter untuk continue..."
echo "$t_reset"
clear

read -p "Password Linux Kamu : " password
clear
echo "$password" | sudo -S chmod +x run.sh ; ./run.sh
