$(call PKG_INIT_BIN, 0.47.0)
$(PKG)_SOURCE:=v$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=2c70e7eccf407a5d5cc5c101dc87e078
$(PKG)_SITE:=https://github.com/websocket-client/websocket-client/archive

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/websocket-client-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/websocket

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_WEBSOCKET_CLIENT) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_WEBSOCKET_CLIENT_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_WEBSOCKET_CLIENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/websocket \
		$(PYTHON_WEBSOCKET_CLIENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/websocket_client-*.egg-info

$(PKG_FINISH)
