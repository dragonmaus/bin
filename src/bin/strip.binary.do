binary=$(which sstrip strip 2> /dev/null | head -1)
if [ -z "$binary" ]
then
	echo "$0: fatal: don't know how to build '$1'" 1>&2
	exit 99
fi
real_binary=$(readlink -f "$binary") # just in case

redo-ifchange "$binary" "$real_binary"

echo "$binary" > "$3"
chmod -w "$3"
