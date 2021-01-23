#!/bin/sh

. echo.sh

d=0
l=0
s=0
while getopts :dls opt
do
	case $opt in
	(d)
		d=1
		;;
	(l)
		l=1
		;;
	(s)
		d=1
		l=1
		s=1
		;;
	(*)
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

cd "$(xdg-user-dir BACKGROUNDS)"

[ $d -eq 1 ] && read -r desk < .current-desktop
[ $l -eq 1 ] && read -r lock < .current-lockscreen

find * -type f 2> /dev/null \
| grep -Fvx -e "$desk" -e "$lock" \
| sort -R \
| head -2 \
| (
	IFS= read -r desk
	IFS= read -r lock

	[ $s -eq 1 ] && lock=$desk

	if [ $d -eq 1 ]
	then
		echo "$desk" > .current-desktop{new}
		mv -f .current-desktop{new} .current-desktop
	fi

	if [ $l -eq 1 ]
	then
		echo "$lock" > .current-lockscreen{new}
		mv -f .current-lockscreen{new} .current-lockscreen
	fi
)

if [ $d -eq 1 ]
then
	read -r desk < .current-desktop
	set-desktop "$desk"
fi

if [ $l -eq 1 ]
then
	read -r lock < .current-lockscreen
	set-lockscreen "$lock"
fi
