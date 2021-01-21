redo-ifchange error.preamble error.list

cat error.preamble > "$3"

i=0
while IFS='	' read -r name errno temp str
do
	[ "$name" = - ] && continue
	i=$((i - 1))
	cat >> "$3" <<-END

	int $name =
	#ifdef $errno
	$errno;
	#else
	$i;
	#endif
	END
done < error.list

chmod -w "$3"
