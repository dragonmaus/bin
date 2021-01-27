set -- "$1" "$2.c" "$3"

home=$(readlink -f "$(dirname "$0")")

redo-ifchange "$2.exe.deps"

xargs redo-ifchange "$home/bin/load" "$home/bin/strip" "$2.o" < "$2.exe.deps"

sed -E -e 's;^.*/lib/lib(.+)\.a$;-l\1;' < "$2.exe.deps" \
| xargs "$home/bin/load" -o "$3" "$2.o"

"$home/bin/strip" "$3"
chmod -w "$3"
