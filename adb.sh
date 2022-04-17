#!/bin/bash
#!/bin/sh

# Coded By Xnuvers007 don't modified without Credits

# For Windows Version , will be soon

vlc_down(){
read -p "Have you installed VLC ? (y/n) : " VLC
    if [ "$VLC" = "y" ] || [ "$VLC" = "Y"]; then
        echo "$Green"
        echo "========= VLC ================"
        vlc --version
        echo
        echo "$t_reset"
    elif [ "$VLC" = "n" ] || [ "$VLC" = "N"]; then
        echo "$Red"
        echo "You have to install VLC"
        sudo apt-get install vlc
    else
        bye
    fi
}

#if [[ $password == "root" ]]; then
    echo "Password is root"
    sudo apt-get install scrcpy
    read -p "Do you want to update ? (y/n) : " update
    if [[ $update == "y" ]]; then
        sudo apt-get update
        sudo apt-get upgrade
        vlc_down
    elif [[ $update == "n" ]]; then
        echo "No update"
        #exit
        vlc_down
    else
        echo "Wrong input"
        exit
    fi
    echo "$t_reset"


    ADB_PATH=$(which adb)

    $ADB_PATH kill-server
    $ADB_PATH start-server

    check_if_android_device_connected() {
            ADB_OUT=`$ADB_PATH devices | awk 'NR>1 {print $1}'`
            if test -n "$ADB_OUT"
            then
                    echo "device connected is $ADB_OUT"
            else
                    echo "device is not connected, please check and restart the script"
                    exit $?
            fi
    }

    check_if_android_device_connected

    echo
    echo
    echo "1. Use Cable USB"
    echo "2. Use LAN (Wifi) Network"
    read -p "Choose your option : " option
    if [ "$option" = "1" ]; then
        read -p "Enter username : " username
        sudo usermod -aG plugdev "$username"
        sudo -S adb kill-server
        sudo -S adb devices
        gnome-terminal -- bash -c "./sndcpy.sh; exec bash"
        read -p "Your password Linux : " password
        #echo "$password" | sudo -S chmod +x run.sh ; ./run.sh
        gnome-terminal -- bash -c "echo '$password' | sudo -S scrcpy -b 4M -m 800 ;exec bash"
    elif [ "$option" = "2" ]; then
        read -p "Enter username : " username
        sudo usermod -aG plugdev "$username"
        sudo -S adb kill-server
        sudo -S adb devices
        adb tcpip 5555
        read -p "Enter your IP Android from About Phone select IP Address: " ip
        adb connect $ip:5555
        echo "in this case, u need to unplug your cable usb because use LAN"
        echo "if u already to unplug, then continue"
        read -p "Press [Enter] key to continue..."
        gnome-terminal -- bash -c "./sndcpy.sh; exec bash"
        read -p "Your Password Linux : " password
        #echo "$password" | sudo -S chmod +x run.sh ; ./run.sh
        gnome-terminal -- bash -c "echo '$password' | sudo -S scrcpy --tcpip='$ip:5555' -b 4M -m 800 ;exec bash"
    else
        echo "Wrong input"
        exit
    fi

#else
#    echo "Password is not root"
#    exit
#fi
