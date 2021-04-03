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

case "$HOST" in
  vmware)
    imwheel &
    sudo systemctl restart vmtoolsd &
    vmware-user &
    pulsemixer --set-volume 20
    ;;

  carbon)
    pulseaudio --start # why do I need this?
    pulsemixer --mute --id sink-1
    pulsemixer --mute --id sink-2
    pulsemixer --mute --id sink-3
    pulsemixer --mute --id sink-4
    pulsemixer --mute --id source-0
    pulsemixer --mute --id source-6
    pulsemixer --mute --id source-7

    xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Accel Speed' 0.5
    xinput set-prop 'SYNA8007:00 06CB:CD8C Touchpad' 'libinput Tapping Enabled' 1
    xinput set-prop 'TPPS/2 Elan TrackPoint' 'libinput Accel Speed' 0.01

    xbacklight \=20
    ;;
esac

xset r rate 200 100
dunst &
exec i3
