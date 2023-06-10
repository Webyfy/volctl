VERSION = 0.99
PACKAGE_NAME = volctl

VOLCTL_BIN = volctl
VOLNTFY_BIN = volntfy
VOLNTFYD_BIN = volntfy-d


PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DATADIR = $(PREFIX)/share/$(PACKAGE_NAME)
RM = rm
Q = @

all: build/$(VOLCTL_BIN) build/$(VOLNTFYD_BIN) build/$(VOLNTFY_BIN)

build/$(VOLCTL_BIN): common/$(VOLCTL_BIN).in
	$(Q)mkdir -p build
	$(Q)sed -e 's|@DATADIR@|'$(DATADIR)'|' $<  >$@

build/$(VOLNTFY_BIN): common/$(VOLNTFY_BIN)
	$(Q)mkdir -p build
	$(Q)sed -e 's|DATADIR=""|DATADIR="'$(DATADIR)'"|' $<  >$@


build/$(VOLNTFYD_BIN): common/$(VOLNTFYD_BIN)
	$(Q)mkdir -p build
	$(Q)cp $< $@

clean:
	$(RM) -f backup*.tgz
	$(RM) -rf build
	$(RM) -rf doc-pak

install:all
	install -Dm755 build/$(VOLCTL_BIN) "$(BINDIR)/$(VOLCTL_BIN)"
	install -Dm755 build/$(VOLNTFY_BIN) "$(BINDIR)/$(VOLNTFY_BIN)"
	install -Dm755 build/$(VOLNTFYD_BIN) "$(BINDIR)/$(VOLNTFYD_BIN)"
	install -Dm644 common/config.skel "$(DATADIR)/config.skel"
	install -Ddm 755 $(DATADIR)/icons/
	install -Dm 644 icons/*.svg $(DATADIR)/icons/

uninstall:
	$(RM) "$(BINDIR)/$(VOLCTL_BIN)"
	$(RM) "$(BINDIR)/$(VOLNTFY_BIN)"
	$(RM) "$(BINDIR)/$(VOLNTFYD_BIN)"
	$(RM) -rf "$(DATADIR)"

deb:
	sudo checkinstall -D -y \
		--maintainer "webyfy \<info@webyfy.com\>" \
		--deldesc=yes \
		--deldoc=yes \
		--delspec=yes \
		--fstrans=no \
		--arch=all \
		--pkgname=$(PACKAGE_NAME) \
		--pkgversion=$(VERSION) \
		--pkgrelease=$$(date +"%Y%m%d") \
		--pkglicense=GPL \
		--requires=bash,pulseaudio-utils,coreutils,ncurses-bin,sound-theme-freedesktop,util-linux,python3-dbus \
		--pakdir=build \
		--pkggroup=sound \
		--install=no

.PHONY: all clean uninstall deb
