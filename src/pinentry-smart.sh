#!/bin/sh

set -e

. echo.sh

# reasonably assumed to be unique and unpredictable
tag="$0-$(date -u +%s)-$(dd if=/dev/random bs=1 count=32 2> /dev/null | env LC_ALL=C tr -cd '[:print:]')"

set -- "$@" "$tag"

# filter through pinentry's arguments without changing them
display=$DISPLAY
done=false
while [ "$1" != "$tag" ]
do
	if ! $done
	then
		case "$1" in
		(-|--)
			done=true
			;;
		(--*)
			o=${1#--}
			case "$o" in
			(*=*)
				a=${o#*=}
				o=${o%%=*}
				;;
			(colors|display|lc-ctype|lc-messages|timeout|ttyalert|ttyname|ttytype)
				a=
				if [ "$2" != "$tag" ]
				then
					a=$2
					set -- "$@" "$1"
					shift
				fi
				;;
			esac
			[ "$o" = display ] && display=$a
			;;
		(-*)
			o=${1#-}
			while [ -n "$o" ]
			do
				case "$o" in
				([CDMNTaco])
					a=
					if [ "$2" != "$tag" ]
					then
						a=$2
						set -- "$@" "$1"
						shift
					fi
					;;
				([CDMNTaco]?*)
					a=${o#?}
					o=${o%%"$a"}
					;;
				(*)
					o=${o#?}
					continue
					;;
				esac
				[ "$o" = D ] && display=$a
				o=${o#?}
			done
			;;
		(*)
			done=true
			;;
		esac
	fi
	set -- "$@" "$1"
	shift
done
shift

[ -n "$display" ] && exec pinentry-dmenu "$@"
exec pinentry "$@"
