#!/usr/bin/env bash

# Do not change this file.
# It is a template file and will be used by snapp_installer to run the app in kiosk mode.

sleep 2

xset s noblank
xset s off
xset -dpms

#unclutter -idle 0.5 -root &

echo "Run the flutter app"

# get the executable app path from user and replace it with the path below
# placeholder

sleep 3

DISPLAY=:0 xdotool key alt+F11
echo "Run key alt+F11"
