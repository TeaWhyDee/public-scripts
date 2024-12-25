#!/usr/bin/bash

bak_dest=/media/backup/Automatic

if mountpoint -q -- "/media/backup/"; then
    # KEEPASS
    ionice -c2 -n7 rsync_tmbackup.sh \
        --rsync-append-flags "--include=\"*.kdbx\" --exclude=\"*\"" \
        ~/.config/keepmenu/ $bak_dest/keepass

    # TASKWARRIOR
    ionice -c2 -n7 rsync_tmbackup.sh \
        ~/.task $bak_dest/task
        # --rsync-append-flags "--include=\"*.data\" --include=\"*.task\" --exclude=\"*\"" \

    # GPG
    ionice -c2 -n7 rsync_tmbackup.sh \
        ~/.gnupg $bak_dest/gnupg
else
    if notif_or_ignore "pls mount backup"; then
        alacritty -e "mount_backup"
        tea_backup
    fi
fi
