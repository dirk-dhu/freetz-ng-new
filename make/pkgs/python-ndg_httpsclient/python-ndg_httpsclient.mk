$(call PKG_INIT_BIN, e73dc05)
$(PKG)_SOURCE:=ndg_httpsclient-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/cedadev/ndg_httpsclient.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/ndg_httpsclient-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/ndg/httpsclient

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-ndg_httpsclient, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_NDG_HTTPSCLIENT); \
	for f in ls $(FREETZ_BASE_DIR)/$(PYTHON_NDG_HTTPSCLIENT_DEST_DIR)/usr/bin/*; do sed -i -r -e 's~^#!/.*/hostpython~#!/usr/bin/python~g' $$f; done

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_NDG_HTTPSCLIENT_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_NDG_HTTPSCLIENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/ndg_httpsclient \
		$(PYTHON_NDG_HTTPSCLIENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/ndg_httpsclient-*.egg-info

$(PKG_FINISH)
