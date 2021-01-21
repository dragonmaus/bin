system=$(uname | tr A-Z a-z)

if [ -e "$2.$system" ]
then
	cp -f "$2.$system" "$3"
	chmod -w "$3"
else
	echo "$0: fatal: don't know how to build '$1'" 1>&2
	exit 99
fi
