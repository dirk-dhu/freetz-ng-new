$(call PKG_INIT_BIN, 07d3a03)
$(PKG)_SOURCE:=pyrfc3339-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/kurtraschke/pyRFC3339.git
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/pyrfc3339-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyrfc3339

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYRFC3339)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYRFC3339_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYRFC3339_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyrfc3339 \
		$(PYTHON_PYRFC3339_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyrfc3339-*.egg-info

$(PKG_FINISH)
