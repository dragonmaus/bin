# redo adds three paths to the start of PATH; get them out of the way
binary=$(env PATH="${PATH#*:*:*:}" which "$2")
real_binary=$(readlink -f "$binary") # just in case

redo-ifchange "$binary" "$real_binary"

echo "$binary" > "$3"
chmod -w "$3"
