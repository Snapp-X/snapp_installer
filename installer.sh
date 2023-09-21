#!/usr/bin/env bash

# This script installs raspi-flutter on your embedded device.
# It has been tested on Raspberry Pi 4 with Raspbian OS 64-bit.


# exit when any command fails
set -e

user_home=$(eval echo ~${SUDO_USER})
raspi_home=$user_home/raspi-flutter/bin

main() {
    # create a folder in user home /embedded
    if [ ! -d "$raspi_home" ]; then
        echo "Creating directory $raspi_home."
        echo
        mkdir -p $raspi_home
    else
        echo "The $raspi_home directory is already available."
        echo
    fi
    
    cd $raspi_home
    
    curl -f -o raspi-flutter https://raw.githubusercontent.com/Snapp-X/raspi-flutter/main/raspi-flutter
    curl -f -o kiosk.sh https://raw.githubusercontent.com/Snapp-X/raspi-flutter/main/kiosk.sh
    curl -f -o config.ini https://raw.githubusercontent.com/Snapp-X/raspi-flutter/main/config.ini
    
    echo "add nececerry file permissions to downloaded files"
    echo
    
    # update raspi-flutter  file permissions to be executable for all users
    chmod a+x raspi-flutter
    
    # update kiosk.sh file permissions to be writable for current user and group
    chmod ug+w kiosk.sh
    
    if ! check_raspi_installed; then
        add_raspi_to_path
        export PATH="$PATH:$raspi_home"
    fi
    
    echo "raspi-flutter installed successfully."
    echo
    echo "raspi-flutter path:"
    which raspi-flutter
    
    echo
    echo "Type raspi-flutter in your terminal"
}


add_raspi_to_path(){
    if grep -q "export PATH=\"\$PATH:$raspi_home\"" "$user_home/.bashrc"; then
        echo "we have raspi-flutter as env in ~/.bashrc."
    else
        echo "adding raspi-flutter to PATH as env in ~/.bashrc."
        echo "export PATH=\"\$PATH:$raspi_home\"" >> $user_home/.bashrc
        source $user_home/.bashrc
    fi
}

check_raspi_installed(){
    which raspi-flutter >/dev/null 2>&1
    return $?
}


main "$@"