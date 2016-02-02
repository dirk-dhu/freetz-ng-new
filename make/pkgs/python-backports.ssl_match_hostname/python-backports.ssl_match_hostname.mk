$(call PKG_INIT_BIN, 3.7.0.1)
$(PKG)_SOURCE:=backports.ssl_match_hostname-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=32d2f593af01a046bec3d2f5181a420a
$(PKG)_SITE:=https://files.pythonhosted.org/packages/ff/2b/8265224812912bc5b7a607c44bf7b027554e1b9775e9ee0de8032e3de4b2

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/backports.ssl_match_hostname-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/backports

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/backports \
		$(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/backports.ssl_match_hostname-*.egg-info

$(PKG_FINISH)
