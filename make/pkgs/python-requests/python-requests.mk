$(call PKG_INIT_BIN,  b8f4c7c)
$(PKG)_SOURCE:=requests-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/kennethreitz/requests.git
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/requests-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/requests

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-requests, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_REQUESTS)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_REQUESTS_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_REQUESTS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/requests \
		$(PYTHON_REQUESTS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/requests-*.egg-info

$(PKG_FINISH)
