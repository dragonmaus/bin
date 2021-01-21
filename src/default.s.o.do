set -- "$1" "$2.s" "$3"

home=$(readlink -f "$(dirname "$0")")

redo-ifchange "$2.o.deps"

xargs redo-ifchange "$home/bin/assemble" "$2" < "$2.o.deps"

"$home/bin/assemble" -o "$3" "$2"
chmod -w "$3"
