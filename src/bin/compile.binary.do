compiler=$(which musl-clang musl-gcc clang gcc 2> /dev/null | head -1)
if [ -z "$compiler" ]
then
	echo "$0: fatal: don't know how to build '$1'" 1>&2
	exit 99
fi

compiler=$(basename $compiler)
deps=$compiler.binary
case $compiler in
(musl-*)
	deps="${compiler#musl-}.binary $deps"
	;;
esac
if [ $compiler = musl-gcc ]
then
	deps="$deps $compiler.specs"
fi

redo-ifchange $deps

cp -f $compiler.binary "$3"
chmod -w "$3"
