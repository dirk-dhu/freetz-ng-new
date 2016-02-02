$(call PKG_INIT_BIN, master)
$(PKG)_HASH:=d634bd20e5870d99b98e8772a11dc493
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/ws-28xx-master
$(PKG)_SOURCE:=$($(PKG)_VERSION).zip
$(PKG)_SITE:=https://github.com/dpeddi/ws-28xx/archive
$(PKG)_BINARY:=$($(PKG)_DIR)/*.py
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/lib/wfrog/ws-28xx

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	mkdir -p $@
	cp $(WFROG_WS28XX_DIR)/*.py $@
	cp -R $(WFROG_WS28XX_DIR)/wfrog $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) $(WFROG_WS28XX_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(WFROG_WS28XX_TARGET_BINARY)

$(PKG_FINISH)
