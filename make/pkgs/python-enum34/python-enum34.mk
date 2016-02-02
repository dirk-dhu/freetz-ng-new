$(call PKG_INIT_BIN, dc35e72)
$(PKG)_SOURCE:=enum34-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/certik/enum34.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/enum34-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/enum

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_ENUM34)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_ENUM34_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_ENUM34_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/enum34 \
		$(PYTHON_ENUM34_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/enum34-*.egg-info

$(PKG_FINISH)
