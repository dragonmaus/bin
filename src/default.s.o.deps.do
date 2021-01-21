set -- "$1" "$2.s" "$3"

home=$(readlink -f "$(dirname "$0")")

redo-ifchange "$2"

sed -En "s;^[	 ]*%[	 ]*include[	 ]+'(.+)'.*$;$home/inc/\\1;p" < "$2" \
| sort -u \
> "$3"

chmod -w "$3"
