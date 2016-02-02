$(call PKG_INIT_BIN, a3b1237)
$(PKG)_SOURCE:=ipaddress-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/phihag/ipaddress.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/ipaddress-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/ipaddress.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_IPADDRESS) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_IPADDRESS_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_IPADDRESS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/ipaddress.py \
		$(PYTHON_IPADDRESS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/ipaddress-*.egg-info

$(PKG_FINISH)
