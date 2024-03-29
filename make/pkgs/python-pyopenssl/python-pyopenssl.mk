$(call PKG_INIT_BIN, 17.3.0)
$(PKG)_SOURCE:=pyOpenSSL-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=29630b9064a82e04d8242ea01d7c93d70ec320f5e3ed48e95fcabc6b1d0f6c76
$(PKG)_SITE:=https://pypi.python.org/packages/source/p/pyOpenSSL

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/OpenSSL/SSL.so

$(PKG)_DEPENDS_ON += python openssl

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC
$(PKG)_REBUILD_SUBOPTS += $(OPENSSL_REBUILD_SUBOPTS)

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYOPENSSL)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYOPENSSL_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYOPENSSL_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/OpenSSL \
		$(PYTHON_PYOPENSSL_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyOpenSSL-*.egg-info

$(PKG_FINISH)
