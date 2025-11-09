#!/bin/sh

kill_and_wait () {
    if [[ `pgrep -c "$1"` -gt 0 ]]
    then
        killall "$1"
        while [[ `pgrep -c "$1"` -gt 0 ]];
        do
            sleep 0.1
        done;
    fi;
}

# Source colorscheme
source "${HOME}/.cache/wal/colors.sh"

# Statusbar
kill_and_wait workspaces    
kill_and_wait media_info    
kill_and_wait layout  
eww -c ~/.config/eww/mybar kill 
eww -c ~/.config/eww/mybar daemon    
~/.config/eww/mybar/scripts/ewwcolorscheme  
eww -c ~/.config/eww/mybar open bar_right
eww -c ~/.config/eww/mybar open bar_center
eww -c ~/.config/eww/mybar open bar_left
kill_and_wait polybar
polybar -c ~/.config/eww/mybar/polybar_tray.ini tray& > /dev/null
    
# change light value and volume value by swayosd-client in keybind
swayosd-server >/dev/null 2>&1 &

# wall paper
# swaybg -i ~/.config/wallpaper/wall.jpg >/dev/null 2>&1 &
wpaperd -d

emacs&
fcitx5&
dropbox&
kitty&

# backup configs
bulk_synker ~/syncall_list.csv ~/Dropbox/Linux > ~/log/synk.log
