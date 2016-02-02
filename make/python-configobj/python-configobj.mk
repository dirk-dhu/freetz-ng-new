$(call PKG_INIT_BIN, 5.0.6)
$(PKG)_SOURCE:=configobj-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=e472a3a1c2a67bb0ec9b5d54c13a47d6
$(PKG)_SITE:=https://pypi.python.org/packages/source/c/configobj

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/configobj-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/configobj.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_CONFIGOBJ); \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_CONFIGOBJ_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CONFIGOBJ_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/configobj.py \
		$(PYTHON_CONFIGOBJ_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/validate.py \
		$(PYTHON_CONFIGOBJ_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/_version.py \
		$(PYTHON_CONFIGOBJ_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/configobj-*.egg-info

$(PKG_FINISH)
