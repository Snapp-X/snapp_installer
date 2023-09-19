USER_HOME=$(eval echo ~${SUDO_USER})
KIOSK_HOME=$USER_HOME/kiosk

# create a folder in user home /kiosk
if [ ! -d "$KIOSK_HOME" ]; then
    echo "Creating directory $KIOSK_HOME."
    mkdir -p $KIOSK_HOME
else
    echo "The $KIOSK_HOME directory is already available."
fi

cd $KIOSK_HOME

sudo curl -o flutter-embedded.sh https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/flutter-embedded.sh
sudo curl -o kiosk.sh https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/kiosk.sh
sudo curl -o config.ini https://raw.githubusercontent.com/Snapp-X/flutter-raspberry-pi/main/config.ini

# make the flutter-embedded.sh executable 
# move it to the $PATH Variable

