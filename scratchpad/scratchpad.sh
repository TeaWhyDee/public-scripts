#!/usr/bin/bash

while [ "$1" != "" ]; do
    case $1 in
        -wd )
            shift
            wd=$1
            if [ ! -d $wd ]; then
                echo no such directory
                exit 1
            fi
            ;;
        -h | --help )
                echo '
        '
                exit
            ;;
        -c | --class )
            shift
            class="$1"
            ;;
        * )
            cmd="$1"
            if [ ! "$class" ]; then
                class="$cmd"
            fi
    esac
    shift
done

if [ ! "$cmd" ]; then
    # Example cmd:
    # cmd="alacritty --class 'myclass,myclass' -e nvim"
    echo no cmd provided
    exit 1
fi

eval $(xdotool getmouselocation --shell)
id=$(xdotool search --class "$class")

if ! [ "$id" ]; then
    cd "$wd" && exec $cmd & disown
    sleep 0.5
    # id=$(xdotool search --class "vimwiki")
    xdotool windowstate --remove FULLSCREEN
    xdotool windowstate --remove MAXIMIZED_VERT
    xdotool windowstate --remove MAXIMIZED_HORZ
    xdotool windowsize 1800 950
    # xdotool windowmove $id 60 80
    # xdotool windowsize $id 1800 940
elif [[ $(xdotool getwindowclassname $(xdotool getactivewindow)) == "$class" ]]; then
    xdotool windowminimize $id
else # focus 
    curdesk=$(xdotool get_desktop)
    xdotool set_desktop_for_window $id $curdesk
    sleep 0.1
    xdotool windowactivate $id
fi
