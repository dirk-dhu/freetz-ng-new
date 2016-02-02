#$(call PKG_INIT_BIN, ed5a771)
$(call PKG_INIT_BIN, 82b6ce2) # 3.3.2
$(PKG)_SOURCE:=cryptography-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/pyca/cryptography.git
$(PKG)_HASH:=X
#$(PKG)_CONDITIONAL_PATCHES+=ed5a771

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/cryptography-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cryptography

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	export LD_LIBRARY_PATH=$(HOST_TOOLS_DIR)/lib; $(call Build/PyMod/PKG, PYTHON_CRYPTOGRAPHY)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_CRYPTOGRAPHY_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CRYPTOGRAPHY_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cryptography \
		$(PYTHON_CRYPTOGRAPHY_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cryptography-*.egg-info

$(PKG_FINISH)
