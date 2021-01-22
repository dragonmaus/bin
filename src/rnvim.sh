#!/bin/sh
exec nvim -u NONE --cmd 'syntax on' --cmd 'filetype plugin indent on' "$@"
