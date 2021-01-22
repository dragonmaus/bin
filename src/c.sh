#!/bin/sh

set -e

. echo.sh

name=$(basename "$0" .sh)
usage="Usage: $name [-h] [-cps]"
help="$usage
  -c   set the clipboard X selection (default)
  -p   set the primary X selection
  -s   set the secondary X selection

  -h   display this help"

selection=clipboard
while getopts :chps opt
do
	case $opt in
	(c)
		selection=clipboard
		;;
	(h)
		die 0 "$help"
		;;
	(p)
		selection=primary
		;;
	(s)
		selection=clipboard
		;;
	(*)
		warn "$name: Unknown option '$OPTARG'"
		die 100 "$usage"
		;;
	esac
done
shift $((OPTIND - 1))

exec xclip -i -selection $selection
