set -- "$1" "$2.sh" "$3"

redo-ifchange sh.binary "$2"

binary=$(head -1 < sh.binary)

sed "1s;^#!.*/sh;#!$binary;" < "$2" > "$3"
chmod -w "$3"
