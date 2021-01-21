set -- "$1" "$2.c" "$3"

home=$(readlink -f "$(dirname "$0")")

redo-ifchange "$2"

sed -En "s;^[	 ]*#[	 ]*include[	 ]+\"(.+)\".*$;$home/inc/\\1;p" < "$2" \
| sed -E 's;/inc/gen_allocdefs\.h$;/lib/gen_allocdefs.h;' \
| sort -u \
> "$3"

chmod -w "$3"
