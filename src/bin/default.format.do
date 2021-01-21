cat > "$3" << 'END'
exec '%s' "$@"\n
END

chmod -w "$3"
