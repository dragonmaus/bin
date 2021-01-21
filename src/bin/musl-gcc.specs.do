redo-ifchange musl-gcc.binary

read -r script musl-gcc.binary

sed -En 's/^.* -specs "([^"]+)".*$/\1/p' < "$script" > "$3"
chmod -w "$3"
