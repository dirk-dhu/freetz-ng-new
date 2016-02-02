$(call PKG_INIT_BIN, 0.8.0)
$(PKG)_SOURCE:=mock-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/testing-cabal/mock.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/mock-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/mock.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_MOCK) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_MOCK_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_MOCK_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/mock.py \
		$(PYTHON_MOCK_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/mock-*.egg-info

$(PKG_FINISH)
