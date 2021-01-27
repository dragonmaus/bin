#include <err.h>
#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "utf8.h"

enum level { okay, space, warning, failure, encoding };
const char *tag[] = { "OKAY", "SPCE", "WARN", "FAIL", "UTF8" };

int count[] = { 0, 0, 0, 0, 0 };

	unsigned int
oneof(register const char *s, char c)
{
	register char t;

	while ((t = *s++)) {
		if (c == t) {
			return 1;
		}
	}

	return 0;
}

	int
printer(const char *path, const struct stat *stat, int flag, struct FTW *ftw)
{
	enum level level;
	const char *n;
	unsigned char c;

	n = path + ftw->base;
	level = okay;

	if (!utf8_valid(n)) {
		level = encoding;
	}
	while (level < failure && (c = *n++)) {
		if (c == ' ' && *n == 0) {
			level = failure;
		}
		else if (c < 0x20 || c == 0x7f) {
			level = failure;
		}
		else if (oneof("\"&'()*;<>?[\\]|", c)) {
			level = warning;
		}
		else if (c == ' ' && level == okay) {
			level = space;
		}
	}

	count[level]++;

	if (level != okay) {
		printf("%s\t%s\n", tag[level], path);
	}

	return 0;
}

	int
main(int argc, const char **argv)
{
	if (getuid() != 0) {
		errx(EXIT_FAILURE, "Must be run as root");
	}

#ifdef __OpenBSD__
	if (pledge("stdio rpath", NULL) != 0) {
		err(EXIT_FAILURE, "Unable to restrict operations");
	}
#endif

	if (nftw("/", printer, 1000, FTW_PHYS) != 0) {
		err(EXIT_FAILURE, "Unable to walk directory tree");
	}

	printf("Total:\t%d clean, %d spaces, %d metacharacters, "
	       "%d illegal characters, %d encoding errors\n",
	       count[okay], count[space], count[warning],
	       count[failure], count[encoding]);

	return EXIT_SUCCESS;
}
