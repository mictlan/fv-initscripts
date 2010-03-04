# Makefile

TRANSLATIONS=""

all: build

test:
	set -e; for SCRIPT in scripts/*; \
	do \
		sh -n $$SCRIPT; \
	done

build:
	@echo "Nothing to build."

install: test
	# Installing init scripts
	set -e; for SCRIPT in scripts/*; \
	do \
		install -D -m 0755 $$SCRIPT $(DESTDIR)/etc/init.d/`basename $$SCRIPT`; \
	done

	# Installing documentation
	mkdir -p $(DESTDIR)/usr/share/doc/fv-initscripts
	cp -r COPYING docs/* $(DESTDIR)/usr/share/doc/fv-initscripts

	# Installing manpages
	set -e; for MANPAGE in manpages/*.en.7; \
	do \
		install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/man7/`basename $$MANPAGE .en.7`.7; \
	done

	set -e; for TRANSLATIONS in $$TRANSLATIONS; \
	do \
		for MANPAGE in manpages/*.$$TRANSLATION.7; \
		do \
			install -D -m 0644 $$MANPAGE $(DESTDIR)/usr/share/man/$$TRANSLATION/man7/`basename $$MANPAGE .$$TRANSLATION.7`.7; \
		done; \
	done

uninstall:
	# Uninstalling executables
	for SCRIPT in scripts/*; \
	do \
		rm -f $(DESTDIR)/etc/init.d/`basename $$SCRIPT`; \
	done

	# Uninstalling documentation
	rm -rf $(DESTDIR)/usr/share/doc/fv-initscripts

	# Uninstalling manpages
	set -e; for MANPAGE in manpages/*.en.7; \
	do \
		rm -f $(DESTDIR)/usr/share/man/man7/`basename $$MANPAGE .en.7`.7; \
	done

	set -e; for TRANSLATIONS in $$TRANSLATIONS; \
	do \
		for MANPAGE in manpages/*.$$TRANSLATION.7; \
		do \
			rm -f $(DESTDIR)/usr/share/man/$$TRANSLATION/man7/`basename $$MANPAGE .de.7`.7; \
		done; \
	done

update:
	set -e; for MANPAGE in manpages/*.en.*; \
	do \
		sed -i	-e 's/2007\\-06\\-04/2007\\-06\\-11/' \
			-e 's/1.87.6/1.87.7/' \
		$$MANPAGE; \
	done

clean:

distclean:

reinstall: uninstall install
