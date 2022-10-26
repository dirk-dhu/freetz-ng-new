$(call PKG_INIT_BIN, 0.0.1.37)
$(PKG)_SOURCE:=linknx-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=3c3aaf8c409538153b15f5fb975a4485e58c4820cfea289a3f20777ba69782ab
$(PKG)_SITE:=https://sources.buildroot.net/linknx
$(PKG)_BINARY:=$($(PKG)_DIR)/src/linknx
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/linknx

# add EXTRA_(C|LD)FLAGS
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;
$(PKG)_EXTRA_CFLAGS  += -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS += -Wl,--gc-sections -largp

$(PKG)_CONFIGURE_OPTIONS += --without-pth-test --with-pth=$(TARGET_TOOLCHAIN_STAGING_DIR)

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)
$(PKG)_CONFIGURE_POST_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile -exec $(SED) -r -i -e 's~^CXX(.*)-wrapper~CXX\1~'      \{\} \+;
$(PKG)_CONFIGURE_POST_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile -exec $(SED) -r -i 's~(LIBS =.*)(true)~\1~'      \{\} \+;

$(PKG)_DEPENDS_ON += pthsem argp curl libstdcxx
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libpthsem FREETZ_LIB_libargp_WITH_STATIC FREETZ_LIB_libcurl FREETZ_LIB_libstdc__ 

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(LINKNX_DIR)  \
		EXTRA_CFLAGS="$(LINKNX_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(LINKNX_EXTRA_LDFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(LINKNX_DIR) clean
	$(RM) $(LINKNX_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(LINKNX_TARGET_BINARY)

$(PKG_FINISH)
