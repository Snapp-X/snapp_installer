#!/usr/bin/env bash

# This script installs snapp_installer on your embedded device.
# It has been tested on Raspberry Pi 4 with Raspbian OS 64-bit.

# exit when any command fails
set -e

user_home=$(eval echo ~${SUDO_USER})
snapp_home=$user_home/snapp_installer/bin

main() {
    # create a folder in user home /embedded
    if [ ! -d "$snapp_home" ]; then
        echo "Creating directory $snapp_home."
        echo
        mkdir -p $snapp_home
    else
        echo "The $snapp_home directory is already available."
        echo
    fi

    cd $snapp_home

    curl -f -o snapp_installer https://raw.githubusercontent.com/Snapp-Embedded/snapp_installer/main/snapp_installer
    curl -f -o kiosk.sh https://raw.githubusercontent.com/Snapp-Embedded/snapp_installer/main/kiosk.sh
    curl -f -o config.ini https://raw.githubusercontent.com/Snapp-Embedded/snapp_installer/main/config.ini

    echo "add nececerry file permissions to downloaded files"
    echo

    # update snapp_installer  file permissions to be executable for all users
    chmod a+x snapp_installer

    # update kiosk.sh file permissions to be writable for current user and group
    chmod ug+w kiosk.sh

    if ! check_snapp_installed; then
        add_snapp_to_path
        export PATH="$PATH:$snapp_home"
    fi

    echo "snapp_installer installed successfully."
    echo
    echo "snapp_installer path:"
    which snapp_installer

    echo
    echo "Type snapp_installer in your terminal"
}

add_snapp_to_path() {
    if grep -q "export PATH=\"\$PATH:$snapp_home\"" "$user_home/.bashrc"; then
        echo "we have snapp_installer as env in ~/.bashrc."
    else
        echo "adding snapp_installer to PATH as env in ~/.bashrc."
        echo "export PATH=\"\$PATH:$snapp_home\"" >>$user_home/.bashrc
        source $user_home/.bashrc
    fi
}

check_snapp_installed() {
    which snapp_installer >/dev/null 2>&1
    return $?
}

main "$@"
