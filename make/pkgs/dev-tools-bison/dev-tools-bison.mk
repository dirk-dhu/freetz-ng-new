$(call PKG_INIT_BIN, 3.0.5)
$(PKG)_SOURCE:=bison-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5_3.0.5:=41ad57813157b61bfa47e33067a9d6f0
$(PKG)_SOURCE_MD5_3.0.1:=4148256d9c07a3a485b4f314f98fed1f
$(PKG)_SOURCE_MD5_3.0.4:=a586e11cd4aff49c3ff6d3b6a4c9ccf8
$(PKG)_SOURCE_MD5_3.0.2:=72c66879187c128d04f4ab7422e8072d
$(PKG)_SOURCE_MD5:=$($(PKG)_SOURCE_MD5_$($(PKG)_VERSION))
$(PKG)_SITE:=http://ftp.gnu.org/gnu/bison

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/bison-$($(PKG)_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/src/bison
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(DEV_TOOLS_PREFIX)/bin/bison

$(PKG)_EXTRA_CFLAGS  := -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS := -Wl,--gc-sections

$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's~LDADD = lib/libbison.a(.*)~LDADD = lib/libbison.a\1 \$$$\$$$\(LIB_POSIX_SPAWN\)~'   \{\} \+;

$(PKG)_CONFIGURE_OPTIONS := --prefix=$(DEV_TOOLS_PREFIX)
$(PKG)_CONFIGURE_OPTIONS += --bindir=$(DEV_TOOLS_PREFIX)/bin
$(PKG)_CONFIGURE_OPTIONS += --datadir=$(DEV_TOOLS_PREFIX)/share
$(PKG)_CONFIGURE_OPTIONS += --includedir=$(DEV_TOOLS_PREFIX)/include
$(PKG)_CONFIGURE_OPTIONS += --infodir=$(DEV_TOOLS_PREFIX)/share/info
$(PKG)_CONFIGURE_OPTIONS += --libdir=$(DEV_TOOLS_PREFIX)/lib
$(PKG)_CONFIGURE_OPTIONS += --libexecdir=$(DEV_TOOLS_PREFIX)/lib
$(PKG)_CONFIGURE_OPTIONS += --mandir=$(DEV_TOOLS_PREFIX)/share/man
$(PKG)_CONFIGURE_OPTIONS += --sbindir=$(DEV_TOOLS_PREFIX)/sbin
#$(PKG)_CONFIGURE_OPTIONS += --disable-threads
#$(PKG)_CONFIGURE_OPTIONS += --cross

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(DEV_TOOLS_BISON_DIR) \
		EXTRA_CFLAGS="$(DEV_TOOLS_BISON_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(DEV_TOOLS_BISON_EXTRA_LDFLAGS)" \
		STRIP="$(TARGET_STRIP)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(DEV_TOOLS_BISON_DIR) \
		DESTDIR="$(abspath $(DEV_TOOLS_BISON_DEST_DIR))" \
		install-strip; \
	$(RM) -rf $(dir $@)../share/info $(dir $@)../share/man

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(DEV_TOOLS_BISON_DIR) clean
	$(RM) $(DEV_TOOLS_BISON_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(DEV_TOOLS_BISON_TARGET_BINARY)


$(PKG_FINISH)
