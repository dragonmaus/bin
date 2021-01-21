binary=$(readlink -f "$(which "$2")")

redo-ifchange "$binary"

echo "$binary" > "$3"
chmod -w "$3"
