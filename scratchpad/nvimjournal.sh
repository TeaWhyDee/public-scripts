#!/usr/bin/bash

sleep 0.1 && cd ~/vimwiki &&\
    nvim -S Session.vim -c VimwikiMakeDiaryNote\
    -c 'execute "normal \<c-l>"' -c 'TW' -c 'execute "normal \<c-h>"'

