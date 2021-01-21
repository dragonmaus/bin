set -- "$1" "$2.c" "$3"

home=$(readlink -f "$(dirname "$0")")

redo-ifchange "$2.o.deps"

xargs redo-ifchange "$home/bin/compile" "$2" < "$2.o.deps"

"$home/bin/compile" -o "$3" "$2"
chmod -w "$3"
