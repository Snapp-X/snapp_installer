#!/bin/bash

sleep 5

xset s noblank
xset s off
xset -dpms

unclutter -idle 0.5 -root &

# get the executable app path from user and replace it with the path below
# /home/pi/app/build/linux/arm64/release/bundle/app
