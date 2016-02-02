$(call PKG_INIT_BIN,  48855cd)
$(PKG)_SOURCE:=platformer-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/fijal/platformer.git
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/platformer-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/platformer

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PLATFORMER)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PLATFORMER_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PLATFORMER_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/platformer \
		$(PYTHON_PLATFORMER_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/platformer-*.egg-info

$(PKG_FINISH)
