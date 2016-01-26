$(call PKG_INIT_BIN, 2.69)
$(PKG)_SOURCE:=autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=562471cbcb0dd0fa42a76665acf0dbb68479b78a
$(PKG)_SITE:=http://ftp.gnu.org/gnu/autoconf

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/autoconf-$($(PKG)_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/bin/autoconf
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(DEV_TOOLS_PREFIX)/bin/autoconf

$(PKG)_EXTRA_CFLAGS  := -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS := -Wl,--gc-sections

$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;

$(PKG)_CONFIGURE_OPTIONS := --prefix=$(DEV_TOOLS_PREFIX)
$(PKG)_CONFIGURE_OPTIONS += --bindir=$(DEV_TOOLS_PREFIX)/bin
$(PKG)_CONFIGURE_OPTIONS += --datadir=$(DEV_TOOLS_PREFIX)/share
$(PKG)_CONFIGURE_OPTIONS += --includedir=$(DEV_TOOLS_PREFIX)/include
$(PKG)_CONFIGURE_OPTIONS += --infodir=$(DEV_TOOLS_PREFIX)/share/info
$(PKG)_CONFIGURE_OPTIONS += --libdir=$(DEV_TOOLS_PREFIX)/lib
$(PKG)_CONFIGURE_OPTIONS += --libexecdir=$(DEV_TOOLS_PREFIX)/lib
$(PKG)_CONFIGURE_OPTIONS += --mandir=$(DEV_TOOLS_PREFIX)/share/man
$(PKG)_CONFIGURE_OPTIONS += --sbindir=$(DEV_TOOLS_PREFIX)/sbin

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(DEV_TOOLS_AUTOCONF_DIR) \
		EXTRA_CFLAGS="$(DEV_TOOLS_AUTOCONF_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(DEV_TOOLS_AUTOCONF_EXTRA_LDFLAGS)" \
		STRIP="$(TARGET_STRIP)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(DEV_TOOLS_AUTOCONF_DIR) \
		DESTDIR="$(abspath $(DEV_TOOLS_AUTOCONF_DEST_DIR))" \
		install-strip; \

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(DEV_TOOLS_AUTOCONF_DIR) clean
	$(RM) $(DEV_TOOLS_AUTOCONF_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(DEV_TOOLS_AUTOCONF_TARGET_BINARY)


$(PKG_FINISH)
