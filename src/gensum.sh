#!/bin/sh

case $(uname) in
(*BSD|Darwin)
	md5 "$@"
	sha256 "$@"
	sha512 "$@"
	stat -L -f 'SIZE (%N) = %z%n' "$@"
	stat -L -f 'TIME (%N) = %m%n' "$@"
	;;
(*)
	md5sum "$@" | sed -E 's/^([0-9a-f]{32})..(.+)$/MD5 (\2) = \1/'
	sha256sum "$@" | sed -E 's/^([0-9a-f]{64})..(.+)$/SHA256 (\2) = \1/'
	sha512sum "$@" | sed -E 's/^([0-9a-f]{128})..(.+)$/SHA512 (\2) = \1/'
	stat -L -c 'SIZE (%n) = %s' "$@"
	stat -L -c 'TIME (%n) = %Y' "$@"
	;;
esac
