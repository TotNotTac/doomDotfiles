#!/usr/bin/env sh
source ~/.profile

xhost +SI:localuser:$USER

picom -b

exec dbus-launch --exit-with-session emacs -mm --debug-in
