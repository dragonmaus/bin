set -- "$1" "$2.py" "$3"

redo-ifchange python.binary "$2"

binary=$(head -1 < python.binary)

sed "1s;^#!.*/python[.0-9]*;#!$binary;" < "$2" > "$3"
chmod -w "$3"
