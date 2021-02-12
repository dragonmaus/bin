#!/bin/sh

set -e

. echo.sh

name=$(basename "$0" .sh)
usage="Usage: $name [-h] [-gir] [-f FILE] pattern [pattern ...]"
help="$usage
  -f FILE  add patterns to FILE
  -g       add patterns to global ignore file (core.excludesFile)
  -i       add patterns to internal repository ignore file (_/.git/info/exclude)
  -r       add patterns to root-level repository ignore file (_/.gitignore)

  -h       display this help

By default, patterns are added to the file '.gitignore' in the current directory.
The specified file is created if it does not exist."

find_git_root() (
	while :
	do
		if [ -d .git -o -f .git ]
		then
			readlink -f .
			return $?
		fi

		[ . -ef .. ] && return 1

		cd ..
	done
)

find_git_dir() (
	root=$(find_git_root) || return 1

	if [ -n "$GIT_DIR" -a -d "$GIT_DIR" ]
	then
		dir=$GIT_DIR
	elif [ -d "$root/.git" ]
	then
		dir=$root/.git
	elif [ -f "$root/.git" ]
	then
		dir=$(sed -n 's/^gitdir: //p' < "$root/.git")
	else
		return 1
	fi

	readlink -f "$dir"
)

file=
while getopts :f:ghir opt
do
	case $opt in
	(f)
		file=$OPTARG
		;;
	(g)
		file=$(git config --get --default ${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore core.excludesFile)
		;;
	(h)
		die 0 "$help"
		;;
	(i)
		dir=$(find_git_dir) || die 1 "$name: Not inside a git repository"
		file=$dir/info/exclude
		;;
	(r)
		dir=$(find_git_root) || die 1 "$name: Not inside a git repository"
		file=$dir/.gitignore
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

if [ -z "$file" ]
then
	file=$(readlink -f .)/.gitignore
fi

[ -e "$file" ] || touch "$file"

rm -f "$file{tmp}"
for line
do
	echo "$line"
done | cat "$file" - | sort -u | grep '^[^#]' > "$file{tmp}"

rm -f "$file{new}"
{
	grep -v '^!' < "$file{tmp}" || :
	grep '^!' < "$file{tmp}" || :
} > "$file{new}"
rm -f "$file{tmp}"

warn -n "Updating $file... "
if cmp -s "$file" "$file{new}"
then
	warn 'Nothing to do!'
else
	mv -f "$file{new}" "$file"
	warn 'Done!'
fi
rm -f "$file{new}"
