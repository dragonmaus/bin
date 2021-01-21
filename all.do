redo-ifchange "$PWD.list"

xargs redo-ifchange .gitignore < "$PWD.list"
