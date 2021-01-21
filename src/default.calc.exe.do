set -- "$1" "$2.calc" "$3"

redo-ifchange calc.binary "$2"

binary=$(head -1 < calc.binary)

sed "1s;^#!.*/calc;#!$binary;" < "$2" > "$3"
chmod -w "$3"
