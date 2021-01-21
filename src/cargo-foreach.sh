#!/bin/sh

set -e

. echo.sh

name=$(basename "$0" .sh)
usage="Usage: $name [-h] [-qv] -C DIR command [args ...]"
help="$usage
  -C DIR  switch to DIR before starting
  -q      suppress command error output
  -v      print directory names as they are processed

  -h      display this help"

# cargo passes its arguments unchanged to subcommands
[ "$1" = foreach ] && shift

dir=.
quiet=false
verbose=false
while getopts :C:hqv opt
do
	case $opt in
	(C)
		dir=$OPTARG
		;;
	(h)
		die 0 "$help"
		;;
	(q)
		quiet=true
		;;
	(v)
		verbose=true
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

cd "$dir"
ls -A | while IFS= read -r dir
do
	[ -d "$dir" -a -f "$dir/Cargo.toml" ] || continue
	$verbose && echo ">> $dir"
	if ! (cd "$dir"; $quiet && exec 2> /dev/null; exec "$@") && ! $quiet
	then
		warn "command '$(echo $*)' failed in directory '$dir'"
	fi
done
