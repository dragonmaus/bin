redo-ifchange compile.binary

read -r binary < compile.binary
binary=$(basename "$binary")

if [ "$binary" = musl-clang ]
then
	cat > "$3" <<-'END'
	exec '%s' -static -L"$home/lib" -Qunused-arguments "$@"\n
	END
else
	cat > "$3" <<-'END'
	exec '%s' -static -L"$home/lib" "$@"\n
	END
fi

chmod -w "$3"
