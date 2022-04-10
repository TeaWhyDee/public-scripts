Associated blog post: https://teawide.xyz/blog/post/speech_to_text_diary_scripts

Main script is watchscript. Edit it's contents with your filepaths.  
You can run it as a systemd module. To do that, make sure to
specify a correct path in ``audiodiary.service``
and copy it to ``~/.config/systemd/user``.  
Then run:  
```bash
 systemctl --user daemon-reload && systemctl --user enable audiodiary.service
```
You can specify environment variables

``watchscript`` calls another script, ``speech_to_diary.sh``
each time a new file appears in the watch
directory.
To see a help message, run:  
```bash
speech_to_diary.sh -h
```  
