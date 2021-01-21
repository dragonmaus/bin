set -- "$1" "$2.a" "$3"

home=$(readlink -f "$(dirname "$0")")

redo-ifchange "$2.list"

xargs redo-ifchange "$home/bin/archive" < "$2.list"

xargs "$home/bin/archive" cr "$3" < "$2.list"
chmod -w "$3"
