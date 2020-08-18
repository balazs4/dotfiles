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

xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Accel Speed' 0.5
xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Tapping Enabled' 1
xset r rate 200 30

pulseaudio --start
pulsemixer --set-volume 20
pulsemixer --mute
xbacklight \=20

dunst & exec i3
