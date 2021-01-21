redo-always

ls -A \
| grep -E -e '^(archive|compile|load|strip)$' -e '\.(binary|format|specs)$' \
| xargs -r rm -fv 1>&2
