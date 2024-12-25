#!/usr/bin/bash

wd=$HOME/vimwiki
# cmd="alacritty --config-file\
#     $HOME/.config/alacritty/alacritty_vimwiki.toml\
#     --class vimwiki,vimwiki --title vimwiki -e\
#     nvimjournal.sh"
cmd="alacritty --class 'vimwiki,vimwiki' -e nvim"

eval $(xdotool getmouselocation --shell)
vimwiki_id=$(xdotool search --class "vimwiki")

if ! [ "$vimwiki_id" ]; then
    cd "$wd" && exec $cmd & disown
    sleep 0.5
    # vimwiki_id=$(xdotool search --class "vimwiki")
    xdotool windowstate --remove FULLSCREEN
    xdotool windowstate --remove MAXIMIZED_VERT
    xdotool windowstate --remove MAXIMIZED_HORZ
    xdotool windowsize --hints 190 35
    # xdotool windowmove $vimwiki_id 60 80
    # xdotool windowsize $vimwiki_id 1800 940
elif [[ $(xdotool getwindowclassname $(xdotool getactivewindow)) == "vimwiki" ]]; then
    xdotool windowminimize $vimwiki_id
else # focus vimwiki
    curdesk=$(xdotool get_desktop)
    xdotool set_desktop_for_window $vimwiki_id $curdesk
    sleep 0.1
    xdotool windowactivate $vimwiki_id
fi
