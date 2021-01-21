redo-always

ls -A \
| grep -E -e '^error.*\.c$' -e '\.(a|deps|o)$' \
| xargs -r rm -fv 1>&2
