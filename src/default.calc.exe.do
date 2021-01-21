set -- "$1" "$2.calc" "$3"

redo-ifchange calc.binary "$2"

read -r binary < calc.binary

sed "1s;^#!.*/calc;#!$binary;" < "$2" > "$3"
chmod -w "$3"
