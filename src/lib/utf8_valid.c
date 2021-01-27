#include "utf8.h"

#define IS10X(a) ((((a >> 7) & 1) == 1) && (((a >> 6) & 1) == 0))

	unsigned int
utf8_valid(register const char *s)
{
	register char c;

	while ((c = *s++)) {
		if (((c >> 7) & 1) == 0) {
			continue;
		}
		if (((c >> 6) & 1) == 0) {
			return 0;
		}
		if (((c >> 5) & 1) == 0) {
			if ((c = *s++)) {
				if (IS10X(c)) {
					continue;
				}
			}
			return 0;
		}
		if (((c >> 4) & 1) == 0) {
			if (*(s + 1)) {
				if (IS10X(*s) && IS10X(*(s + 1))) {
					s += 2;
					continue;
				}
			}
			return 0;
		}
		if (((c >> 3) & 1) == 0) {
			if (*(s + 2)) {
				if (IS10X(*s) && IS10X(*(s + 1)) && IS10X(*(s + 2))) {
					s += 3;
					continue;
				}
			}
		}
		return 0;
	}
	return 1;
}
