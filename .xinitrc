#!/bin/sh

#vmware imwheel &
#vmware sudo systemctl restart vmtoolsd &
#vmware vmware-user &
#vmware pulsemixer --set-volume 20

#carbon pulseaudio --start # why do I need this?
#carbon pulsemixer --list-sources | cut -d":" -f3 | cut -d"," -f1 | xargs -I{} pulsemixer --mute --id {}
#carbon pulsemixer --list-sinks | cut -d":" -f3 | cut -d"," -f1 | xargs -I{} pulsemixer --mute --id {}
#carbon xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Accel Speed' 0.5
#carbon xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Tapping Enabled' 1
#carbon xinput set-prop 'TPPS/2 Elan TrackPoint' 'libinput Accel Speed' 0.01
#carbon xbacklight \=20

xset r rate 250 100

sxhkd &
dunst &
exec i3
