try() {
	if [ -f "$1" ]
	then
		redo-ifchange "$1.o.deps"

		cp -f "$1.o.deps" "$2"
		chmod -w "$2"

		return 0
	fi

	redo-ifcreate "$1"

	return 1
}

for e in s c
do
	try "$2.$e" "$3" && exit 0
done

echo "$0: fatal: don't know how to build '$1'" 1>&2
exit 99
