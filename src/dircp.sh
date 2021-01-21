#!/bin/sh

set -e

. echo.sh

name=$(basename "$0" .sh)
usage="Usage: $name [-h] [-v] from to"
help="$usage

Recursively copy a directory while preserving permissions.

  -v   print files as they are copied

  -h   display this help"

v=
while getopts :hv opt
do
	case $opt in
	(h)
		die 0 "$help"
		;;
	(v)
		v=v
		;;
	(:)
		warn "$name: Option '$OPTARG' requires an argument"
		die 100 "$usage"
		;;
	(\?)
		warn "$name: Unknown option '$OPTARG'"
		die 100 "$usage"
		;;
	esac
done
shift $((OPTIND - 1))

if [ $# -lt 2 ]
then
	warn "$name: Missing argument(s)"
	die 100 "$usage"
fi

[ -e "$1" ] || die 1 "$name: Could not find '$1': No such file or directory"
[ -d "$1" ] || die 1 "$name: Could not chdir into '$1': Not a directory"

case $(uname) in
(Linux)
	archive='tar -c -f - --null --no-recursion -T -'
	unarchive="tar -x$v -f -"
	;;
(OpenBSD)
	archive='pax -0dwz'
	unarchive="pax -rz$v -p e"
	;;
esac

mkdir -p "$2"
(cd "$1" && exec find . -print0) | sort -z | (cd "$1" && exec $archive) | (cd "$2" && exec $unarchive)
