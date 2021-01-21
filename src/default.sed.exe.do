set -- "$1" "$2.sed" "$3"

redo-ifchange sed.binary "$2"

read -r binary < sed.binary

sed "1s;^#!.*/sed;#!$binary;" < "$2" > "$3"
chmod -w "$3"
