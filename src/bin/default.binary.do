# redo adds three paths to the start of PATH; get them out of the way
binary=$(readlink -f "$(env PATH="${PATH#*:*:*:}" which "$2")")

redo-ifchange "$binary"

echo "$binary" > "$3"
chmod -w "$3"
