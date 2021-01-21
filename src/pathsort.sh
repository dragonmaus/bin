#!/bin/sh
# poor man's method
tr / '\1' | sort "$@" | tr '\1' /
