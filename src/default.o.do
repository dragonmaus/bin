try() {
	if [ -f "$1" ]
	then
		redo-ifchange "$1.o"

		cp -f "$1.o" "$2"
		chmod -w "$2"

		return 0
	fi

	if [ -f "$1.do" ]
	then
		[ "$3" = recur ] && return 1

		redo-ifchange "$1"

		try "$1" "$2" recur
		return $?
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
