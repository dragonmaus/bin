redo-ifchange preamble.sh "$2.binary" "$2.format"

read -r binary < "$2.binary"
read -r format < "$2.format"

cat preamble.sh > "$3"
printf "$format" "$binary" >> "$3"
chmod +x-w "$3"
