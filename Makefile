# Chili SDDM theme. Run `make` with no target for the list of targets and variables.

PREFIX   ?= /usr
THEMEDIR ?= $(PREFIX)/share/sddm/themes/chili

GREETER  ?= sddm-greeter-qt6

INSTALL      ?= install
INSTALL_DIR  := $(INSTALL) -d -m 755
INSTALL_DATA := $(INSTALL) -m 644

ROOT_FILES := Main.qml metadata.desktop theme.conf preview.jpg
ASSETS     := $(wildcard assets/*)
COMPONENTS := $(wildcard components/*.qml)

.PHONY: help install uninstall test-mode

help:
	@echo "Chili SDDM theme. Nothing to build; available targets:"
	@echo ""
	@echo "  sudo make install     install to $(THEMEDIR)"
	@echo "  sudo make uninstall   remove $(THEMEDIR)"
	@echo "  make test-mode        preview the theme from this folder using $(GREETER)"
	@echo ""
	@echo "Variables (override as make VAR=value <target>):"
	@echo "  PREFIX=$(PREFIX)"
	@echo "  THEMEDIR=$(THEMEDIR)"
	@echo "  DESTDIR=$(DESTDIR)   staging root for packaging"
	@echo "  GREETER=$(GREETER)"

install:
	$(INSTALL_DIR) $(DESTDIR)$(THEMEDIR)
	$(INSTALL_DIR) $(DESTDIR)$(THEMEDIR)/assets
	$(INSTALL_DIR) $(DESTDIR)$(THEMEDIR)/components
	$(INSTALL_DATA) $(ROOT_FILES) $(DESTDIR)$(THEMEDIR)
	$(INSTALL_DATA) $(ASSETS) $(DESTDIR)$(THEMEDIR)/assets
	$(INSTALL_DATA) $(COMPONENTS) $(DESTDIR)$(THEMEDIR)/components
	@echo "Installed to $(DESTDIR)$(THEMEDIR). Set Current=chili in the [Theme] section of your sddm.conf."

uninstall:
	rm -rf $(DESTDIR)$(THEMEDIR)

# Runs the greeter in a normal window against the checkout, no install needed.
test-mode:
	$(GREETER) --test-mode --theme $(CURDIR)
