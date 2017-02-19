$(call PKG_INIT_BIN, 6060d29)
$(PKG)_SOURCE:=asn1crypto-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/wbond/asn1crypto.git
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/asn1crypto-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/asn1crypto.git

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_ASN1CRYPTO)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_ASN1CRYPTO_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_ASN1CRYPTO_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/asn1crypto \
		$(PYTHON_ASN1CRYPTO_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/asn1crypto*.egg-info

$(PKG_FINISH)
