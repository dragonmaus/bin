#include <err.h>
#include <fcntl.h>
#include <libgen.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

	int
main(int argc, const char **argv)
{
	register int fd;

#ifdef __OpenBSD__
	if (pledge("stdio rpath unveil", NULL) != 0) {
		err(EXIT_FAILURE, "Unable to restrict operations");
	}
#endif

	if (!--argc) {
		fprintf(stderr, "Usage: %s file [file ...]\n", basename(*argv));
	}

	while (*++argv) {
#ifdef __OpenBSD__
		if (unveil(*argv, "r") != 0) {
			err(EXIT_FAILURE, "Unable to unveil '%s'", *argv);
		}
#endif
		fd = open(*argv, O_RDONLY | O_NONBLOCK | O_SYNC | O_NOFOLLOW);
		if (fd == -1) {
			err(EXIT_FAILURE, "Unable to open file '%s'", *argv);
		}
		if (fsync(fd) != 0) {
			err(EXIT_FAILURE, "Unable to synchronise file '%s'", *argv);
		}
		close(fd);
	}

	return EXIT_SUCCESS;
}
