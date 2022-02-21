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

# start gnome-keyring daemon (for minecraft launcher)
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# disable screen blanking
xset s off
xset -dpms
xset s noblank
# set background
~/.config/fehbg/.fehbg
# set touchpad preferences
xinput set-prop "Elan Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "Elan Touchpad" "libinput Disable While Typing Enabled" 0
xinput set-prop "Elan TrackPoint" "libinput Accel Speed" -0.5
# start i3
exec i3
