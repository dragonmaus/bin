#!/bin/sh

set -e

. echo.sh

name=$(basename "$0" .sh)
usage="Usage: $name [-h] [-fqr] from [to]"
help="$usage

Recursively symlink files in a directory tree.

  -f   overwrite existing regular files
  -q   do not display progress
  -r   create relative symlinks

  -h   display this help"

opts=
force=false
relative=false
verbose=true
while getopts :fhqr opt
do
	opts="$opts -$opt"
	case $opt in
	(f)
		force=true
		;;
	(h)
		die 0 "$help"
		;;
	(q)
		verbose=false
		;;
	(r)
		relative=true
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

[ -e "$1" ] || die 1 "$name: Unable to read '$1': No such file or directory"
[ -d "$1" ] || die 1 "$name: Unable to read '$1': Not a directory"

[ -n "$2" ] || set -- "$1" .
[ -d "$2" ] || mkdir -pv "$2"

ls -A "$1" \
| while IFS= read -r f
do
	[ "$1/$f" -ef "$2" ] && continue

	if [ -d "$1/$f" ]
	then
		"$0" $opts "$1/$f" "$2/$f"
	else
		if [ -f "$2/$f" -a ! -h "$2/$f" ]
		then
			if ! $force
			then
				$verbose && warn "$name: Not overwriting '$2/$f'"
				continue
			fi
			rm -f "$2/$f"
		elif [ -d "$2/$f" ]
		then
			$verbose && warn "$name: '$2/$f' is a directory; skipping"
			continue
		fi

		l=$2/$f
		t=$1/$f
		case "$t" in (/*) ;; (*) relative=true ;; esac
		$relative && t=$(relpath "$l" "$t")

		ln -fns "$t" "$l"
		$verbose && echo "'$l' -> '$t'"
	fi
done
