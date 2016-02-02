$(call PKG_INIT_BIN,0.7.1)
$(PKG)_SOURCE:=$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=aff66163b750ffec135fae90e985893c
$(PKG)_SITE:=https://github.com/Ape/samsungctl/archive

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/samsungctl-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/samsungctl.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_SAMSUNGCTL) && \
	for f in ls $(FREETZ_BASE_DIR)/$(PYTHON_SAMSUNGCTL_DEST_DIR)/usr/bin/*; do sed -i -r -e 's~^#!/.*/hostpython~#!/usr/bin/python~g' $$f; done

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_SAMSUNGCTL_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_SAMSUNGCTL_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/samsungctl.py \
		$(PYTHON_SAMSUNGCTL_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/samsungctl-*.egg-info

$(PKG_FINISH)
