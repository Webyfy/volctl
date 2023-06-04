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
	$(RM) -rf build

install:all
	install -Dm755 build/$(VOLCTL_BIN) "$(BINDIR)/$(VOLCTL_BIN)"
	install -Dm755 build/$(VOLNOTI_D_BIN) "$(BINDIR)/$(VOLNOTI_D_BIN)"
	install -Dm644 common/config.skel "$(SKELDIR)/config.skel"

uninstall:
	$(RM) "$(BINDIR)/$(VOLCTL_BIN)"
	$(RM) "$(BINDIR)/$(VOLNOTI_D_BIN)"
	$(RM) -rf "$(DESTDIR)$(SKELDIR)"

.PHONY: all clean uninstall
