$(call PKG_INIT_BIN, 1c1027a)
$(PKG)_SOURCE:=idna-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/kjd/idna.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/idna-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/idna

$(PKG)_HOST_DEPENDS_ON += python-setuptools-host
$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_IDNA)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_IDNA_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_IDNA_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/idna \
		$(PYTHON_IDNA_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/idna-*.egg-info

$(PKG_FINISH)
