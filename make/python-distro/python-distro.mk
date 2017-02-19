$(call PKG_INIT_BIN, 1.5.0)
$(PKG)_SOURCE:=v$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=da1cab49e8aad7bd6ae5c9f66657bd2e
$(PKG)_SITE:=https://github.com/nir0s/distro/archive

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/distro.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_DISTRO, , TARGET_ARCH=$(FREETZ_TARGET_ARCH)); \
	for f in ls $(FREETZ_BASE_DIR)/$(PYTHON_DISTRO_DEST_DIR)/usr/bin/*; do sed -i -r -e 's~^#!/.*/hostpython~#!/usr/bin/python~g' $$f; done; \

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_DISTRO_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_DISTRO_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/distro \
		$(PYTHON_DISTRO_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/distro-*.egg-info

$(PKG_FINISH)
