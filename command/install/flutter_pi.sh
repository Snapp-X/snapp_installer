#!/usr/bin/env bash

set -e

user_home=$(eval echo ~${SUDO_USER})

flutter_pi_repo="https://github.com/ardera/flutter-pi"
flutter_pi_installation_path="$user_home/sdk/flutter-pi"

INSTALL_GSTREAMER=false

# Parse command-line arguments
for arg in "$@"; do
    case $arg in
    --gstreamer)
        INSTALL_GSTREAMER=true
        shift # Remove --gstreamer from processing
        ;;
    *)
        echo "Unknown option: $arg"
        exit 1
        ;;
    esac
done

# Function to print a message
function print_message() {
    echo -e "\n\033[1;34m$1\033[0m\n"
}

# Install flutter-pi method
function install_flutter_pi() {

    # Update system and install required packages
    print_message "Updating system and installing required packages..."
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y cmake libgl1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev libdrm-dev libgbm-dev ttf-mscorefonts-installer fontconfig libsystemd-dev libinput-dev libudev-dev libxkbcommon-dev

    # Install GStreamer packages if requested
    if $INSTALL_GSTREAMER; then
        print_message "Installing GStreamer packages..."
        sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-alsa
    fi

    # Update system fonts
    print_message "Updating system fonts..."
    sudo fc-cache -fv

    # Clone flutter-pi repository
    print_message "Cloning flutter-pi repository..."
    if [ -d "$flutter_pi_installation_path" ]; then
        print_message "flutter-pi directory already exists at $flutter_pi_installation_path. Deleting and cloning again."
        rm -rf "$flutter_pi_installation_path"
    fi

    git clone --recursive "$flutter_pi_repo" "$flutter_pi_installation_path"

    cd "$flutter_pi_installation_path"

    # Compile flutter-pi
    print_message "Compiling flutter-pi..."
    mkdir -p build && cd build
    cmake ..
    make -j$(nproc)

    # Install flutter-pi
    print_message "Installing flutter-pi..."
    sudo make install

    # Return to initial directory
    cd ../..

    # Configure Raspberry Pi settings if requested
    print_message "Configuring Raspberry to boot into console mode..."
    sudo raspi-config nonint do_boot_behaviour B2

    # Give 'pi' permission to use 3D acceleration
    print_message "Giving the 'pi' user permission to use 3D acceleration (potential security hazard)..."
    sudo usermod -a -G render pi

    # Print success message
    print_message "flutter-pi installation and setup is complete!"

    # Schedule reboot in the background and exit script successfully
    sudo bash -c "sleep 10; sudo reboot" &
    print_message "The system will reboot in 10 seconds to apply changes."

    exit 0
}

install_flutter_pi
