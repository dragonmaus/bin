#!/bin/sh

set -e

. echo.sh

name=$(basename "$0" .sh)
usage="Usage: $name [path]"

[ $# -eq 0 ] && set -- .
[ $# -eq 1 ] || die 1 "$usage"

case "$1" in (/*) ;; (*) set -- "$PWD/$1" ;; esac

p=
IFS=/
for e in $1
do
	case $e in
	(''|.)
		;;
	(..)
		p=${p%/*}
		;;
	(*)
		p=$p/$e
		;;
	esac
done

echo "$p"
