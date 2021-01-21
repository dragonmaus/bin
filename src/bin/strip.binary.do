binary=$(which sstrip strip 2> /dev/null | head -1)
if [ -z "$binary" ]
then
	echo "$0: fatal: don't know how to build '$1'" 1>&2
	exit 99
fi

redo-ifchange "$binary"

echo "$binary" > "$3"
chmod -w "$3"
