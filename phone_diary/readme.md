Associated blog post: https://teawide.xyz/blog/post/speech_to_text_diary_scripts

## Running
Main script is watchscript. Keep all scripts in the same directory.
Use the following envorinment variable to specify the path where
your audio files appear:
```bash
PATH_TO_WATCH=/path/to/watch/
```
Additional env varialbes:
```
STT_LAN="en-US"
VIMWIKIPATH=/path/to/vimwiki
```
You can run it as a systemd module. To do that, make sure to
specify a correct env varialbes in ``audiodiary.service``
and copy it to ``~/.config/systemd/user``.  
Then run:  
```bash
 systemctl --user daemon-reload && systemctl --user enable audiodiary.service
```

## Additional configuration
``watchscript`` calls another script, ``speech_to_diary.sh``
each time a new file appears in the watch directory.
To see a help message, run:  
```bash
speech_to_diary.sh -h
```  
Modify watchscipt if you want to specify some flags.  
Modify recognize.py if you want different a speech recognition option.
