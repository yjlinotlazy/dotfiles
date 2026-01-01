#!/bin/sh

# Source colorscheme
source "${HOME}/.cache/wal/colors.sh"

# Statusbar
pkill waybar
waybar -c ~/.config/mango/waybar/config.jsonc -s ~/.config/mango/waybar/style.css >/dev/null 2>&1 &

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
