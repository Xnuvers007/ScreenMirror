#!/bin/bash
#!/bin/sh

# Di kode oleh Xnuvers007, jangan mengubah/mengeditnya tanpa ada credits/sumber aslinya

vlc_down(){
read -p "Sudah Menginstall VLC ? (y/n) : " VLC
    if [ "$VLC" = "y" ] || [ "$VLC" = "Y"]; then
        echo "$Green"
        echo "========= VLC ================"
        vlc --version
        echo
        echo "$t_reset"
    elif [ "$VLC" = "n" ] || [ "$VLC" = "N"]; then
        echo "$Red"
        echo "Kamu harus menginstall VLC"
        sudo apt-get install vlc
    else
        bye
    fi
}

#if [[ $password == "root" ]]; then
    echo "Password is root"
    sudo apt-get install scrcpy
    read -p "Apa Kamu ingin update dan upgrade ? (y/n) : " update
    if [[ $update == "y" ]]; then
        sudo apt-get update
        sudo apt-get upgrade
        vlc_down
    elif [[ $update == "n" ]]; then
        echo "Tidak Di Update"
        #exit
        vlc_down
    else
        echo "invalid/gagal"
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
                    echo "perangkat yang terhubung adalah $ADB_OUT"
            else
                    echo "perangkat tidak terhubung, silakan periksa dan mulai ulang skrip"
                    exit $?
            fi
    }

    check_if_android_device_connected

    echo
    echo
    echo "1. Menggunakan Kabel USB"
    echo "2. Menggunakan Jaringan LAN (Wifi)"
    read -p "Masukan pilihan : " option
    if [ "$option" = "1" ]; then
        read -p "Masukan username : " username
        sudo usermod -aG plugdev "$username"
        sudo -S adb kill-server
        sudo -S adb devices
        gnome-terminal -- bash -c "./sndcpy.sh; exec bash"
        read -p "Password Linux kamu : " password
        clear
        #echo "$password" | sudo -S chmod +x run.sh ; ./run.sh
        gnome-terminal -- bash -c "echo '$password' | sudo -S scrcpy -b 4M -m 800 ;exec bash"
    elif [ "$option" = "2" ]; then
        read -p "Masukan username : " username
        sudo usermod -aG plugdev "$username"
        sudo -S adb kill-server
        sudo -S adb devices
        adb tcpip 5555
        read -p "Masukkan alamat IP Android Anda dari Tentang Telepon > pilih Alamat IP : " ip
        adb connect $ip:5555
        echo "dalam kasus ini, kamu perlu mencabut kabel usb kamu, karena menggunakan Jaringan Internet LAN"
        echo "jika kamu sudah mencabutnya, maka enter untuk untuk melanjutkannya"
        read -p "silahkan ketik enter untuk continue..."
        gnome-terminal -- bash -c "./sndcpy.sh; exec bash"
        read -p "Password Linux kamu : " password
        clear
        #echo "$password" | sudo -S chmod +x run.sh ; ./run.sh
        gnome-terminal -- bash -c "echo '$password' | sudo -S scrcpy --tcpip='$ip:5555' -b 4M -m 800 ;exec bash"
    else
        echo "invalid/gagal"
        exit
    fi

#else
#    echo "Password is not root"
#    exit
#fi
