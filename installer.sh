user_home=$(eval echo ~${SUDO_USER})
embedded_home=$user_home/embedded

# create a folder in user home /embedded
if [ ! -d "$embedded_home" ]; then
    echo "Creating directory $embedded_home."
    mkdir -p $embedded_home
else
    echo "The $embedded_home directory is already available."
fi

cd $embedded_home

sudo curl -o flutter-embedded.sh https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/flutter-embedded.sh
sudo curl -o kiosk.sh https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/kiosk.sh
sudo curl -o config.ini https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/config.ini

# make the flutter-embedded.sh executable 
# move it to the $PATH Variable

