$(call TOOLS_INIT, 1.16.5)
$(PKG)_SOURCE:=$(pkg_short)-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=f01d58cd6d9d77fbdca9eb4bbd5ead1988228fdb73d6f7a201f5f8d6b118b469
$(PKG)_SITE:=@GNU/$(pkg_short)
### WEBSITE:=https://www.gnu.org/software/automake/
### MANPAGE:=https://www.gnu.org/software/automake/manual/automake.html
### CHANGES:=https://ftp.gnu.org/gnu/automake/
### CVSREPO:=https://git.savannah.gnu.org/cgit/automake.git

$(PKG)_PREFIX:=$($(PKG)_DIR)/._INSTALL
$(PKG)_INSTALL_DIR := $(TOOLS_DIR)/build
$(PKG)_VERSION_MAJOR:=$(call GET_MAJOR_VERSION,$($(PKG)_VERSION))

$(PKG)_LINKS               := aclocal automake
$(PKG)_BINARIES            := $(patsubst %, %-$(AUTOMAKE_HOST_VERSION_MAJOR), $($(PKG)_LINKS))
$(PKG)_SHARES              := $($(PKG)_BINARIES)

$(PKG)_BINARIES_BUILD_DIR  := $($(PKG)_BINARIES:%=$($(PKG)_DIR)/bin/%)

$(PKG)_BINARIES_LINK_DIR   := $($(PKG)_LINKS:%=$($(PKG)_INSTALL_DIR)/bin/%)
$(PKG)_SHARES_LINK_DIR     := $($(PKG)_LINKS:%=$($(PKG)_INSTALL_DIR)/share/%)

$(PKG)_BINARIES_TARGET_DIR := $($(PKG)_BINARIES:%=$($(PKG)_INSTALL_DIR)/bin/%)
$(PKG)_SHARES_TARGET_DIR   := $($(PKG)_SHARES:%=$($(PKG)_INSTALL_DIR)/share/%/)
$(PKG)_SHARES_TARGET_FLAG  := $($(PKG)_SHARES:%=$($(PKG)_INSTALL_DIR)/share/%/.created)

$(PKG)_DEPENDS_ON+=autoconf-host

$(PKG)_CONFIGURE_OPTIONS += --prefix=$($(PKG)_PREFIX)


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_DIR)/.compiled: $($(PKG)_DIR)/.configured
	$(TOOLS_SUBMAKE) -C $(AUTOMAKE_HOST_DIR) all
	@touch $@

$($(PKG)_DIR)/.installed: $($(PKG)_DIR)/.compiled
	$(TOOLS_SUBMAKE) -C $(AUTOMAKE_HOST_DIR) install
	@touch $@

$($(PKG)_BINARIES_BUILD_DIR): $($(PKG)_DIR)/.installed

$($(PKG)_BINARIES_TARGET_DIR): $($(PKG)_INSTALL_DIR)/bin/%: $($(PKG)_DIR)/bin/%
	mkdir -p "$(dir $@)"
	ln -sf "$(notdir $@)" "$(patsubst %-$(AUTOMAKE_HOST_VERSION_MAJOR),%,$@)"
	chmod +w "$<"
	$(INSTALL_FILE)

$($(PKG)_SHARES_TARGET_FLAG): $($(PKG)_INSTALL_DIR)/share/%/.created : $($(PKG)_PREFIX)/share/%
	mkdir -p "$(dir $@)"
	ln -sf "$(notdir $(patsubst %/.created,%,$@))" "$(patsubst %-$(AUTOMAKE_HOST_VERSION_MAJOR)/,%,$(dir $@))"
	cp -r "$<" "$(dir $@).."
	@touch $@

$(pkg)-precompiled: $($(PKG)_BINARIES_TARGET_DIR) $($(PKG)_SHARES_TARGET_FLAG)


$(pkg)-clean:
	-$(MAKE) -C $(AUTOMAKE_HOST_DIR) uninstall
	-$(RM) $(AUTOMAKE_HOST_DIR)/.{configured,compiled,installed}

$(pkg)-dirclean:
	$(RM) -r $(AUTOMAKE_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) -r \
		$(AUTOMAKE_HOST_BINARIES_LINK_DIR) \
		$(AUTOMAKE_HOST_BINARIES_TARGET_DIR) \
		$(AUTOMAKE_HOST_SHARES_LINK_DIR) \
		$(AUTOMAKE_HOST_SHARES_TARGET_DIR)

$(TOOLS_FINISH)
