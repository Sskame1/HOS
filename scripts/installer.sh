#!/bin/sh
# HOS Tools Installer

BIN_DIR="/usr/bin"
HOS_PROJ_DIR="$(pwd)"

set -e

echo "HOS Tools Installation"
echo "========================="

# check rights
if [ "$(id) -u" -ne 0 ]; then
    echo "please run as root"
    exit 1
fi

tools_install() {
    # install all apk
    sudo apk add squashfs-tools cpio xorriso syslinux wget git vim

    # ====================
    sudo rm -rf "$BIN_DIR/hossnap"
    # install snapshot
    cp "$HOS_PROJ_DIR/tools/hossnap" "$BIN_DIR"
    chmod +x "$BIN_DIR/hossnap"
    echo "install"
    exit 0
}

hos_install() {
    #Instal all HOS on Alpine
    echo "not work"
}

while true; do
    echo ""
    echo "Select an action:"
    echo "1 - tools_install"
    echo "2 - hos_install"
    echo "3 - exit"
    echo -n "Your choice [1-2]: "
    
    read choice

    case $choice in
        1)
            tools_install
            ;;
        2)
            hos_install
            ;;
        3)
            echo "Exit..."
            exit 0
            ;;
        *)
            echo "Wrong choice!"
            exit 0
            ;;
    esac
done
