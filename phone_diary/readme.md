Associated blog post:  

Main script is watchscript. Edit it's contents with your filepaths.
Run:
``speech_to_diary.sh -h``
to see a help message.  
You can run it as a systemd module. To do that, make sure to
specify a correct path in audiodiary.service
and copy it to ~/.config/systemd/user. Then run:
``systemctl --user enable audiodiary.service``

