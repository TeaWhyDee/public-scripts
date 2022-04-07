#!/usr/bin/bash

vimwikipath=~/vimwiki
vimwikiext=".md"      # vimwiki extension. .wiki or .md
# stt_bin="python ~/Documents/scripts/phone_diary/recognize.py"
do_stt="y"            # Generate speech to text text?
move_audio_to_res="y" # Move audio recording to $vimwikipath/diary/resources/?
send_notify="n"       # Send a notify when processing file complete?

if [ $VIMWIKIPATH ]; then
    vimwikipath=$VIMWIKIPATH
fi
while [ "$1" != "" ]; do
    case $1 in
        -vwp | --vimwikipath )
            shift
            vimwikipath=$1
            ;;
        -nc | --nocopyaudio )
            move_audio_to_res="n"
            ;;
        -ns | --nospeechtotext )
            do_stt="n"
            ;;
        -n | --notify )
            send_notify="y"
            ;;
        -stt | --speechtotext )
            shift
            stt_bin=$1
            ;;
        -h | --help )
                echo "
    Usage:
    speech_to_diary.sh [args] FULLPATH/RELPATH

    This script converts your speech to text (google by default) 
    and appends it to today's vimwiki diary entry. 
    By default it also copies the audio file into the 
    \${vimwiki}/diary/resources directory and appends the audio 
    filepath to the diary entry.

    Vimwiki path can be set with enironment variable "\$VIMWIKIPATH"
    or with the parameter below (overriding env variable if set).

    The script will try to determie your wiki format (.wiki or .md)
    by looking at the index file in the vimwikipath folder.
    To set the format manually, set \$VIMWIKIEXT to either 'wiki' or 'md'

    -vwp --vimwikipath PATH 
        Use PATH as the root vimwiki dir.
    -nc --nocopyaudio 
        Do not copy the audio file to resources dir,
        do not add path to audio file to diary entry.
    -ns --nospeechtotext
        Do not convert speech to text,
        do not add transcription to diary entry.
    -n --notify
        Send notification with notify-send whenever processing file.
                "
                exit
            ;;
        * )
            path=$1
    esac
    shift
done

echo Starting the processing
set -e

# Try to automatically determine vimiwki type.
vimwikiext=$(find $vimwikipath -maxdepth 1 -name "index.*" | head -n 1 | sed 's/.*\.//')
# Env variable overrides this
if [ $VIMWIKIEXT ]; then
    vimwikiext=$VIMWIKIEXT
fi

dir=$(echo "$path" | sed 's/\(.*\)\/.*/\1/')
ext=$(echo "$path" | sed 's/.*\.//')
filename=$(echo $path | sed 's/.*\/\(.*\)/\1/')
filename_noext=$(echo $filename | sed 's/\..*//')
filename_underscore=$(echo $filename | sed 's/ /_/')

# Speech to text
diary_filename="$(date +%Y-%m-%d).$vimwikiext"
diary_text="\n$filename $(date +%T)"
if [ do_stt="y" ]; then
    # Convert audio if not wav or flac
    echo $dir
    if [[ $ext != "wav" && $ext != "flac" ]]; then
        ffmpeg -i "$path" "$dir/$filename_noext.wav"
        oldpath="$path"
        rm "$oldpath"
        path="$dir/$filename_noext.wav"
        filename=$(echo $path | sed 's/.*\/\(.*\)/\1/')
        filename_noext=$(echo $filename | sed 's/\..*//')
        filename_underscore=$(echo $filename | sed 's/ /_/')
    fi

    speech_to_text=$(python3 ~/Documents/scripts/phone_diary/recognize.py "$path")
    recording_title=$(echo $filename | sed 's/\.wav//' | sed 's/\./:/g')
    diary_text+="\n$speech_to_text"
    if [[ $ext != "wav" && $ext != "flac" ]]; then
        rm "$oldpath" -f
    fi
fi

if [ $move_audio_to_res="y" ]; then
    mkdir -p "$vimwikipath/diary/resources"
    diary_text+="\n$vimwikipath/diary/resources/$filename_underscore" 
    mv "$path" $vimwikipath/diary/resources/$filename_underscore
fi

if [ $send_notify="y" ]; then 
    notify-send "Processed audio for STT" "$path"
fi

# Put the text into todays vimwiki diary.
# Edit this code to change where to save the text.
echo -e $diary_text >> $vimwikipath/diary/$diary_filename
echo Succsessfully put audio diary
