#!/bin/sh

pulseaudio --start
pulsemixer --list-sources | cut -d":" -f3 | cut -d"," -f1 | xargs -I{} pulsemixer --mute --id {}
pulsemixer --list-sinks | cut -d":" -f3 | cut -d"," -f1 | xargs -I{} pulsemixer --mute --id {}
#carbon xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Accel Speed' 0.5
#carbon xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Tapping Enabled' 1
#carbon xinput set-prop 'TPPS/2 Elan TrackPoint' 'libinput Accel Speed' 0.0
#carbon sudo hda-verb /dev/snd/hwC0D0 0x1d SET_PIN_WIDGET_CONTROL 0x0
#carbon sudo iw wlan0 set power_save off

#aspire xinput set-prop 10 'libinput Accel Speed' 0.5
#aspire xinput set-prop 13 'libinput Accel Speed' 1.0
#aspire xinput set-prop 13 'libinput Accel Custom Scroll Step' 1.0

xrdb -merge $HOME/.Xresources
xset r rate 250 100

unclutter --timeout 2 --start-hidden --fork &
xbindkeys &
dunst &
picom &
exec i3
