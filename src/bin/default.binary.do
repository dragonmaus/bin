# redo adds three paths to the start of PATH; get them out of the way
binary=$(env PATH="${PATH#*:*:*:}" which "$2")

redo-ifchange "$binary"

echo "$binary" > "$3"
chmod -w "$3"
