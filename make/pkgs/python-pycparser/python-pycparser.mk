$(call PKG_INIT_BIN, 6ba9544)
$(PKG)_SOURCE:=pycparser-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/eliben/pycparser.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/pycparser-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pycparser

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYCPARSER)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYCPARSER_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYCPARSER_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pycparser \
		$(PYTHON_PYCPARSER_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pycparser-*.egg-info

$(PKG_FINISH)
