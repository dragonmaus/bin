a=$1
b=$2
c=$3

redo-ifchange "$b.o.deps"

set -- $(sed -En 's;/inc/(.+)\.h$;/lib/lib\1.a;p' < "$b.o.deps" | sort -u)

seen=
while [ $# -gt 0 ]
do
	for lib in $seen
	do
		if [ $1 = $lib ]
		then
			shift
			continue 2
		fi
	done

	redo-ifchange $1.deps

	while read -r lib
	do
		set -- $* $lib
	done < $1.deps

	seen="$seen $1"
done

for lib in $seen
do
	echo $lib
done | sort -u > "$c"
chmod -w "$c"
