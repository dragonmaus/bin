redo-always

ls -A \
| grep -E '\.(binary|deps|exe|o)$' \
| xargs -r rm -fv 1>&2

redo-ifchange bin/clean inc/clean lib/clean
