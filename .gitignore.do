redo-ifchange "$PWD.list" src/git-ignore.exe

sed 's;^;/;' < "$PWD.list" \
| xargs src/git-ignore.exe -f "$3" /.gitignore /.redo/ 2> /dev/null
chmod -w "$3"
