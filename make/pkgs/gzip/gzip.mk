$(call PKG_INIT_BIN, 1.6)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=38603cb2843bf5681ff41aab3bcd6a20
$(PKG)_SITE:=ftp.gnu.org/gnu/$(pkg)
$(PKG)_BINARY:=$($(PKG)_DIR)/$(pkg)
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/$(pkg)

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(GZIP_DIR)

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(GZIP_DIR) clean

$(pkg)-uninstall:
	$(RM) $(GZIP_TARGET_BINARY)

$(PKG_FINISH)
