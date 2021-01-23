#!/bin/sh

conf=${XDG_CONFIG_HOME:-~/.config}

[ -f "$conf/user-dirs.dirs" ] && . "$conf/user-dirs.dirs"

if [ "$1" = DESKTOP ]
then
	eval echo \${XDG_${1}_DIR:-$HOME/desk}
else
	eval echo \${XDG_${1}_DIR:-$HOME}
fi
