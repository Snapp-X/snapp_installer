#!/usr/bin/env bash

# This script installs snapp_installer on your embedded device.
# It has been tested on Raspberry Pi 4 with Raspbian OS 64-bit.

# Exit when any command fails
set -e

# Define user and snapp installation paths
user_home=$(eval echo ~${SUDO_USER})
snapp_home="$user_home/snapp_installer/bin"
temp_dir=$(mktemp -d)

# Function to clean up the temporary directory
cleanup() {
    echo "Cleaning up temporary directory: $temp_dir"
    rm -rf "$temp_dir"
}

# Set up cleanup trap
trap cleanup EXIT

main() {
    # Create the snapp installation directory if it does not exist
    if [ ! -d "$snapp_home" ]; then
        echo "Creating directory $snapp_home."
        echo
        mkdir -p "$snapp_home"
    else
        echo "The $snapp_home directory is already available."
        echo
    fi

    # Clone the repository into the temporary directory
    echo "Cloning the repository..."
    git clone --depth 1 https://github.com/Snapp-X/snapp_installer.git "$temp_dir/snapp_installer"

    # Copy the necessary files and folders to the snapp_home directory
    echo "Copying files and folders to $snapp_home..."
    cp -r "$temp_dir/snapp_installer/command" "$snapp_home/"
    cp "$temp_dir/snapp_installer/snapp_installer" "$snapp_home/"
    cp "$temp_dir/snapp_installer/kiosk.sh" "$snapp_home/"
    cp "$temp_dir/snapp_installer/config.ini" "$snapp_home/"

    echo "Adding necessary file permissions to downloaded files"
    echo

    # Update snapp_installer file permissions to be executable for all users
    chmod a+x "$snapp_home/snapp_installer"

    # Update kiosk.sh file permissions to be writable for the current user and group
    chmod ug+w "$snapp_home/kiosk.sh"

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
        echo "snapp_installer is already in PATH in ~/.bashrc."
    else
        echo "Adding snapp_installer to PATH in ~/.bashrc."
        echo "export PATH=\"\$PATH:$snapp_home\"" >>"$user_home/.bashrc"
        source "$user_home/.bashrc"
    fi
}

check_snapp_installed() {
    which snapp_installer >/dev/null 2>&1
    return $?
}

main "$@"
