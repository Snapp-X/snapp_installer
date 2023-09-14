#!/bin/bash -i

flutter_repo="https://github.com/flutter/flutter"
flutter_channel="stable"
USER_HOME=$(eval echo ~${SUDO_USER})
flutter_path="$USER_HOME/sdk"
flutter_folder="$flutter_path/flutter"

# List of dependency packages to install the flutter
dep_packages=("curl" "git" "unzip" "xz-utils" "zip" "libglu1-mesa")

# List of development packages to develop flutter app on linux
dev_packages=("clang" "cmake" "ninja-build" "pkg-config" "libgtk-3-dev" "liblzma-dev")

main(){
    # Check the number of command-line arguments
    if [ $# -eq 0 ]; then
        echo "You need to specify an argument:"
        echo
        help
        exit 1
    fi
    
    # Check for the command-line argument
    if [ "$1" == "install" ]; then
        install
        elif [ "$1" == "uninstall" ]; then
        uninstall
        elif [ "$1" == "doctor" ]; then
        doctor
        elif [ "$1" == "help" ]; then
        help
    else
        echo "Invalid argument: $1"
        help
        exit 1
    fi
}

doctor(){
    print_banner "Doctor summary:"
    
    # Check dependency packages (curl, git, unzip, ...)
    echo " $(check_dep_packages && echo '✓' || echo '✘') | Linux Dependency packages | curl git unzip ..."
    show_dep_packages_state
    # Check Flutter folder
    echo " $(check_flutter_folder && echo '✓' || echo '✘' ) | Flutter folder is located in $flutter_folder."
    # Check Flutter command
    echo " $(check_flutter_installed && echo '✓' || echo '✘') | Flutter command is available in the PATH."
    # Check Linux development packages (clang, cmake, ninja-build, ...)
    echo " $(check_dev_packages && echo '✓' || echo '✘') | Linux development packages | clang cmake ninja-build ..."
    show_dev_packages_state
    # Check Flutter channel
    echo " $(check_flutter_channel && echo '✓' || echo '✘') | Check flutter channel. should be $flutter_channel."
}

install() {
    print_banner "Installation Summery"
    echo
    echo "
        * Get Linux dependencies to be able to run the flutter: curl, git ,...
        * Clone the flutter from Github: $flutter_repo
        * move flutter to the $flutter_folder directory
        * update the path to make the flutter command excutable
        * Check and show the flutter path
        * add dependencies for developing on linux
        * change flutter channel to $flutter_channel
        * run flutter doctor
        * run flutter precache command for linux
    "
    echo
}

uninstall() {
    print_banner "Uninstalling Flutter..."
}

help(){
    echo
    echo "Usage: $0 {doctor|install|uninstall|help}"
    echo
    echo "Options:"
    echo "  doctor     : Check all the steps"
    echo "  install    : Install Flutter "
    echo "  uninstall  : Uninstall Flutter "
    echo "  help       : Show this help message"
    echo
    exit 1
}


print_banner() {
    local message="${1:-Banner:}"
    local width=40  # Adjust the width of the banner as needed
    local border_char="*"
    
    # Calculate the padding length
    local padding_length=$((($width - ${#message}) / 2))
    
    
    # Create the middle part of the banner
    local middle_banner=""
    for ((i = 0; i < $padding_length; i++)); do
        middle_banner+="$border_char"
    done
    middle_banner+=" $message "
    for ((i = 0; i < $padding_length; i++)); do
        middle_banner+="$border_char"
    done
    
    # Create the top border
    local border=""
    for ((i = 0; i < (${#middle_banner}); i++)); do
        border+="$border_char"
    done
    
    # Print the banner
    echo "$border"
    echo "$middle_banner"
    echo "$border"
}


check_dep_packages() {
    all_installed=0 # Success (true)
    
    for package in "${dep_packages[@]}"; do
        if ! dpkg -l | grep -q "ii  $package"; then
            all_installed=1 # Failure (false)
            break  # No need to check further once one package is not installed
        fi
    done
    
    return $all_installed
}

show_dep_packages_state(){
    for package in "${dep_packages[@]}"; do
        if ! dpkg -l | grep -q "ii  $package"; then
            echo "    * ✘ $package is missing"
        else
            echo "    * ✓ $package is installed"
        fi
    done
    
    return $all_installed
}

check_dev_packages() {
    # List of packages to check
    
    all_installed=0 # Success (true)
    
    for package in "${dev_packages[@]}"; do
        if ! dpkg -l | grep -q "ii  $package"; then
            all_installed=1 # Failure (false)
            break  # No need to check further once one package is not installed
        fi
    done
    
    return $all_installed
}

show_dev_packages_state(){
    for package in "${dev_packages[@]}"; do
        if ! dpkg -l | grep -q "ii  $package"; then
            echo "    * ✘ $package is missing"
        else
            echo "    * ✓ $package is installed"
        fi
    done
    
    return $all_installed
}

check_flutter_folder() {
    [ -e "$flutter_folder/bin/flutter" ]
    return $?
}

check_flutter_installed(){
    which flutter >/dev/null 2>&1
    return $?
}

check_flutter_channel() {
    if which flutter >/dev/null 2>&1; then
        if flutter channel | grep -q "* $flutter_channel"; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

main