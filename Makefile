VERSION = 0.80
PACKAGE_NAME = volctl

VOLCTL_BIN = volctl
VOLNOTI_D_BIN = volnoti-d

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
SKELDIR = $(PREFIX)/share/$(PACKAGE_NAME)
RM = rm
Q = @

all: build/$(VOLCTL_BIN) build/$(VOLNOTI_D_BIN)

build/$(VOLCTL_BIN): common/$(VOLCTL_BIN).in
	$(Q)mkdir -p build
	$(Q)sed -e 's|@SKELDIR@|'$(SKELDIR)'|' $<  >$@

build/$(VOLNOTI_D_BIN): common/$(VOLNOTI_D_BIN)
	$(Q)mkdir -p build
	$(Q)cp $< $@

clean:
	$(RM) -f backup*.tgz
	$(RM) -rf build
	$(RM) -rf doc-pak

install:all
	install -Dm755 build/$(VOLCTL_BIN) "$(BINDIR)/$(VOLCTL_BIN)"
	install -Dm755 build/$(VOLNOTI_D_BIN) "$(BINDIR)/$(VOLNOTI_D_BIN)"
	install -Dm644 common/config.skel "$(SKELDIR)/config.skel"

uninstall:
	$(RM) "$(BINDIR)/$(VOLCTL_BIN)"
	$(RM) "$(BINDIR)/$(VOLNOTI_D_BIN)"
	$(RM) -rf "$(DESTDIR)$(SKELDIR)"

deb:
	checkinstall -D -y \
		--maintainer "webyfy \<info@webyfy.com\>" \
		--deldesc=yes \
		--deldoc=yes \
		--delspec=yes \
		--fstrans=yes \
		--arch=all \
		--pkgname=$(PACKAGE_NAME) \
		--pkgversion=$(VERSION) \
		--pkgrelease=$$(date +"%Y%m%d") \
		--pkglicense=GPL \
		--requires=bash,pulseaudio-utils,coreutils,sound-theme-freedesktop,libglib2.0-bin \
		--pakdir=build \
		--pkggroup=sound \
		--install=no

.PHONY: all clean uninstall deb
