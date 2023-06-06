#!/bin/sh
# Linux

pulseaudio --start 
pulsemixer --list-sources | cut -d":" -f3 | cut -d"," -f1 | xargs -I{} pulsemixer --mute --id {}
pulsemixer --list-sinks | cut -d":" -f3 | cut -d"," -f1 | xargs -I{} pulsemixer --mute --id {}
xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Accel Speed' 0.5
xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Tapping Enabled' 1
xinput set-prop 'TPPS/2 Elan TrackPoint' 'libinput Accel Speed' 0.5
xbacklight \=20
sudo hda-verb /dev/snd/hwC0D0 0x1d SET_PIN_WIDGET_CONTROL 0x0
sudo iw wlan0 set power_save off

xrdb -merge $HOME/.Xresources
xset r rate 250 100

unclutter --timeout 2 --start-hidden --fork &
sxhkd &
dunst &
exec i3
