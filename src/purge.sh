#!/bin/sh

set -e

. echo.sh

name=$(basename "$0" .sh)
real=$(readlink -f "$0")

# `stat' doesn't have a consistent interface
nlinks() {
	ls -dn "$1" | awk '{ print $2 }'
}
fsize() {
	ls -dn "$1" | awk '{ print $5 }'
}

# not all systems have `shred'
if ! command -v shred > /dev/null 2>&1
then
	shred() {
		[ "$1" = -fvz ] && shift
		local i s
		s=$(fsize "$1")
		[ -w "$1" ] || chmod +w "$1"
		for i in 1 2 3
		do
			echo "$name: $__purge_prefix$1: pass $i/4 (random)"
			[ "$s" -gt 0 ] && dd if=/dev/random of="$1" bs="$s" count=1 conv=notrunc > /dev/null 2>&1
			fsync "$1"
		done
		echo "$name: $__purge_prefix$1: pass 4/4 (000000)"
		[ "$s" -gt 0 ] && dd if=/dev/zero of="$1" bs="$s" count=1 conv=notrunc > /dev/null 2>&1
		fsync "$1"
	}
fi

erase() {
	local new old
	old=$1
	if [ "$old" != 0 ]
	then
		new=$(echo "$old" | env LC_ALL=C sed s/./0/g)
		mv "$old" "$new"
		echo "$name: $__purge_prefix$old: renamed to $__purge_prefix$new"
		old=$new
	fi
	while [ "$old" != 0 ]
	do
		new=${old%0}
		mv "$old" "$new"
		echo "$name: $__purge_prefix$old: renamed to $__purge_prefix$new"
		old=$new
	done
	rm -df "$old"
	echo "$name: $__purge_prefix$1: removed"
}

for a
do
	if [ -d "$a" -a ! -h "$a" ]
	then
		(
			cd "$a"
			export __purge_prefix="$__purge_prefix$a/"
			ls -A | tr '\n' '\0' | xargs -0r "$real"
		)
	elif [ -f "$a" -a ! -h "$a" -a "$(nlinks "$a")" -eq 1 ]
	then
		shred -fvz "$a"
	fi
	erase "$a"
done
