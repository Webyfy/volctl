VERSION := 1.0.2
PACKAGE_NAME := volctl

VOLCTL_BIN := volctl
VOLNTFY_BIN := volntfy
VOLNTFYD_BIN := volntfy-d
VOLNTFYD_DESKTOP := volntfy-d.desktop

prefix := /usr
exec_prefix := $(prefix)
bindir := $(exec_prefix)/bin
DATADIR := $(prefix)/share/$(PACKAGE_NAME)
BASH_COMPLETION_DIR := $(prefix)/share/bash-completion/completions
AUTOSTART_DIR := /etc/xdg/autostart
MANPAGE_DIR := $(prefix)/share/man/man1
RM := rm
Q := @

ifneq (,$(findstring ${HOME},$(realpath $(prefix))))
	AUTOSTART_DIR := "${HOME}/.config/autostart"
endif

bindir := $(DESTDIR)$(bindir)
DATADIR := $(DESTDIR)$(DATADIR)
BASH_COMPLETION_DIR := $(DESTDIR)$(BASH_COMPLETION_DIR)
AUTOSTART_DIR := $(DESTDIR)$(AUTOSTART_DIR)
MANPAGE_DIR := $(DESTDIR)$(MANPAGE_DIR)

all: build/$(VOLCTL_BIN) build/$(VOLNTFYD_BIN) build/$(VOLNTFY_BIN) build/$(VOLNTFYD_DESKTOP) $(wildcard common/*.1)
	$(Q)cp common/*.1 build/

build/$(VOLCTL_BIN): common/$(VOLCTL_BIN).in
	$(Q)mkdir -p build
	$(Q)cp $< $@
	$(Q)sed -i 's|@DATADIR@|'$(DATADIR)'|' $@
	$(Q)sed -i 's|@APP_VERSION@|'$(VERSION)'|' $@

build/$(VOLNTFY_BIN): common/$(VOLNTFY_BIN).in
	$(Q)mkdir -p build
	$(Q)cp $< $@
	$(Q)sed -i 's|DATADIR=""|DATADIR="'$(DATADIR)'"|' $@
	$(Q)sed -i 's|@APP_VERSION@|'$(VERSION)'|' $@

build/$(VOLNTFYD_BIN): common/$(VOLNTFYD_BIN).in
	$(Q)mkdir -p build
	$(Q)cp $< $@
	$(Q)sed -i 's|@APP_VERSION@|'$(VERSION)'|' $@

build/$(VOLNTFYD_DESKTOP): common/$(VOLNTFYD_DESKTOP)
	$(Q)mkdir -p build
	$(Q)sed -e 's|@BINDIR@|'$(bindir)'|' $<  >$@

gen-man: build/$(VOLCTL_BIN) build/$(VOLNTFYD_BIN) build/$(VOLNTFY_BIN)
	$(foreach f,$^,chmod +x $(f); python3 -m help2man -o common/$(shell basename $(f)).1 $(f);)

clean:
	$(RM) -f backup*.tgz
	$(RM) -rf build

install: all
	install -Dm755 build/$(VOLCTL_BIN) "$(bindir)/$(VOLCTL_BIN)"
	install -Dm755 build/$(VOLNTFY_BIN) "$(bindir)/$(VOLNTFY_BIN)"
	install -Dm755 build/$(VOLNTFYD_BIN) "$(bindir)/$(VOLNTFYD_BIN)"
	install -Dm644 common/config.skel "$(DATADIR)/config.skel"
	# bash autocompletion
	install -Dm644 common/volctl_completion "$(BASH_COMPLETION_DIR)/_volctl"
	# autostart
	install -Dm644 build/$(VOLNTFYD_DESKTOP) "$(AUTOSTART_DIR)/$(VOLNTFYD_DESKTOP)"
	# man files
	install -Dm644 build/$(VOLCTL_BIN).1 "$(MANPAGE_DIR)/$(VOLCTL_BIN).1"
	install -Dm644 build/$(VOLNTFY_BIN).1 "$(MANPAGE_DIR)/$(VOLNTFY_BIN).1"
	install -Dm644 build/$(VOLNTFYD_BIN).1 "$(MANPAGE_DIR)/$(VOLNTFYD_BIN).1"

uninstall:
	$(RM) -f "$(bindir)/$(VOLCTL_BIN)"
	$(RM) -f "$(bindir)/$(VOLNTFY_BIN)"
	$(RM) -f "$(bindir)/$(VOLNTFYD_BIN)"
	$(RM) -f "$(BASH_COMPLETION_DIR)/_volctl"
	$(RM) -f "$(AUTOSTART_DIR)/$(VOLNTFYD_DESKTOP)"
	$(RM) -rf "$(DATADIR)"
	$(RM) -f "$(MANPAGE_DIR)/$(VOLCTL_BIN).1"
	$(RM) -f "$(MANPAGE_DIR)/$(VOLNTFY_BIN).1"
	$(RM) -f "$(MANPAGE_DIR)/$(VOLNTFYD_BIN).1"

# run as root user (or use sudo)
deb: all
	chmod 0644 doc-pak/*
	checkinstall -D -y \
	--install=no \
	--fstrans=no \
	--pkgname=$(PACKAGE_NAME) \
	--pkgversion=$(VERSION) \
	--pkgaltsource=https://gitlab.com/webyfy/iot/e-gurukul/volctl \
	--pkgarch=all \
	--pkgrelease=$$(date +"%Y%m%d") \
	--pkglicense=GPL-3 \
	--pkggroup=sound \
	--pakdir=build \
	--maintainer="Webyfy \<info@webyfy.com\>" \
	--requires="bash, python3:any, pulseaudio-utils, coreutils, ncurses-bin, sound-theme-freedesktop, util-linux, python3-dbus" \
	--suggests="notification-daemon	\| notify-osd \| xfce4-notifyd \| dunst \| lxqt-notificationd \| mate-notification-daemon \| gnome-shell \| plasma-desktop \| plasma-nano" \
	--reset-uids=yes \
	--delspec=yes
	make uninstall


.PHONY: all clean uninstall deb
