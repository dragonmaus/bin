# Ensure that `echo' is sane
case "$KSH_VERSION" in
(*LEGACY\ KSH*|*MIRBSD\ KSH*|*PD\ KSH*)
	# ksh doesn't have builtin printf, but `print -R` does what we want
	echo() {
		print -R "$@"
	}
	;;
(*)
	echo() {
		case "$1" in
		(-n)
			shift
			printf %s "$*"
			;;
		(*)
			printf '%s\n' "$*"
			;;
		esac
	}
	;;
esac

warn() {
	echo "$@" 1>&2
}

die() {
	e=$1
	shift
	warn "$@"
	exit "$e"
}
