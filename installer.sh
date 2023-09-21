user_home=$(eval echo ~${SUDO_USER})
raspi_home=$user_home/raspi-flutter/bin

# create a folder in user home /embedded
if [ ! -d "$raspi_home" ]; then
    echo "Creating directory $raspi_home."
    mkdir -p $raspi_home
else
    echo "The $raspi_home directory is already available."
fi

cd $raspi_home

sudo curl -o flutter-embedded.sh https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/flutter-embedded.sh
sudo curl -o kiosk.sh https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/kiosk.sh
sudo curl -o config.ini https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/config.ini

# make the flutter-embedded.sh executable 
# move it to the $PATH Variable

