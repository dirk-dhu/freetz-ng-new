$(call PKG_INIT_BIN,1.11.0)
$(PKG)_SOURCE:=$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=72cba57bb6b67190303c49aa33e07b52
$(PKG)_SITE:=https://github.com/benjaminp/six/archive

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/six-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/six.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_SIX); \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_SIX_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_SIX_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/six.py \
		$(PYTHON_SIX_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/six-*.egg-info

$(PKG_FINISH)
