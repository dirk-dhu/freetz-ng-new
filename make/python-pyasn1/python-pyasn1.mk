$(call PKG_INIT_BIN, 0.2.3)
$(PKG)_SOURCE:=$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=599c051dcb7244e0ef39d33180188f6f
$(PKG)_SITE:=https://github.com/etingof/pyasn1/archive

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/pyasn1-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyasn1

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYASN1)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYASN1_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYASN1_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyasn1 \
		$(PYTHON_PYASN1_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyasn1-*.egg-info

$(PKG_FINISH)
