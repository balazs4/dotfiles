#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

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
dunst &
exec i3
