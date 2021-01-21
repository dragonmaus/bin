try() {
	if [ -f "$1" ]
	then
		redo-ifchange "$1.exe"

		cp -f "$1.exe" "$2"
		chmod +x-w "$2"

		return 0
	fi

	redo-ifcreate "$1"

	return 1
}

for e in s c sh py sed calc
do
	try "$2.$e" "$3" && exit 0
done

echo "$0: fatal: don't know how to build '$1'" 1>&2
exit 99
