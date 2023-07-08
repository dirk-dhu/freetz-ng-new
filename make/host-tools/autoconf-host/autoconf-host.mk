$(call TOOLS_INIT, 2.71)
$(PKG)_SOURCE:=$(pkg_short)-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=f14c83cfebcc9427f2c3cea7258bd90df972d92eb26752da4ddad81c87a0faa4
$(PKG)_SITE:=@GNU/$(pkg_short)
### WEBSITE:=https://www.gnu.org/software/autoconf/
### MANPAGE:=https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/
### CHANGES:=https://ftp.gnu.org/gnu/autoconf/
### CVSREPO:=https://git.savannah.gnu.org/gitweb/?p=autoconf.git

$(PKG)_PREFIX:=$($(PKG)_DIR)/._INSTALL
$(PKG)_INSTALL_DIR := $(TOOLS_DIR)/build/bin

$(PKG)_BINARIES            := autoconf autoheader autom4te autoreconf autoscan autoupdate ifnames
$(PKG)_BINARIES_BUILD_DIR  := $($(PKG)_BINARIES:%=$($(PKG)_DIR)/bin/%)
$(PKG)_BINARIES_TARGET_DIR := $($(PKG)_BINARIES:%=$($(PKG)_INSTALL_DIR)/%)

$(PKG)_SHARE:=$($(PKG)_PREFIX)/share/autoconf
$(PKG)_TARGET_SHARE:=$(TOOLS_DIR)/build/share/autoconf

$(PKG)_DEPENDS_ON+=m4-host

$(PKG)_CONFIGURE_OPTIONS += --prefix=$($(PKG)_PREFIX)

$(PKG)_MAKE_VARS += M4="m4"
$(PKG)_MAKE_VARS += EMACS="no"


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_DIR)/.compiled: $($(PKG)_DIR)/.configured
	$(TOOLS_SUBMAKE) -C $(AUTOCONF_HOST_DIR) \
		$(AUTOCONF_HOST_MAKE_VARS) \
		all
	@touch $@

$($(PKG)_DIR)/.installed: $($(PKG)_DIR)/.compiled
	$(TOOLS_SUBMAKE) -C $(AUTOCONF_HOST_DIR) \
		$(AUTOCONF_HOST_MAKE_VARS) \
		install
	@touch $@

$($(PKG)_BINARIES_BUILD_DIR) $($(PKG)_SHARE): $($(PKG)_DIR)/.installed

$($(PKG)_BINARIES_TARGET_DIR): $($(PKG)_INSTALL_DIR)/%: $($(PKG)_DIR)/bin/%
	chmod +w $<
	$(INSTALL_FILE)

$($(PKG)_TARGET_SHARE)/.created: $($(PKG)_SHARE)
	mkdir -p $(dir $(AUTOCONF_HOST_TARGET_SHARE))
	cp -r $(AUTOCONF_HOST_SHARE) $(dir $(AUTOCONF_HOST_TARGET_SHARE))
	@touch $@

$(pkg)-fixhardcoded: $($(PKG)_FIXHARDCODED)
$($(PKG)_FIXHARDCODED):
	@ \
	[ -d "$(AUTOCONF_HOST_PREFIX)" ] && x="$(AUTOCONF_HOST_PREFIX)" || x="/home/freetz/freetz-ng/tools/build"; \
	sed "s!$$x!$(realpath tools/build/)!g" -i \
	  $(AUTOCONF_HOST_BINARIES_TARGET_DIR) \
	  $(AUTOCONF_HOST_TARGET_SHARE)/autom4te.cfg
	touch $@

$(pkg)-precompiled: $($(PKG)_BINARIES_TARGET_DIR) $($(PKG)_TARGET_SHARE)/.created $($(PKG)_FIXHARDCODED)


$(pkg)-clean:
	-$(MAKE) -C $(AUTOCONF_HOST_DIR) uninstall
	-$(RM) $(AUTOCONF_HOST_DIR)/.{configured,compiled,installed}

$(pkg)-dirclean:
	$(RM) -r $(AUTOCONF_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) -r \
		$(AUTOCONF_HOST_INSTALL_DIR)/autoconf \
		$(AUTOCONF_HOST_INSTALL_DIR)/autoheader \
		$(AUTOCONF_HOST_INSTALL_DIR)/autom4te \
		$(AUTOCONF_HOST_INSTALL_DIR)/autoreconf \
		$(AUTOCONF_HOST_INSTALL_DIR)/autoscan \
		$(AUTOCONF_HOST_INSTALL_DIR)/autoupdate \
		$(AUTOCONF_HOST_INSTALL_DIR)/ifnames \
		$(AUTOCONF_HOST_TARGET_SHARE)

$(TOOLS_FINISH)
