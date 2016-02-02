$(call PKG_INIT_BIN, bcc55d4)
$(PKG)_SOURCE:=zopeinterface-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/zopefoundation/zope.interface.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/zopeinterface-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zope/interface

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-zopeinterface, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_ZOPEINTERFACE)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_ZOPEINTERFACE_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_ZOPEINTERFACE_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zopeinterface \
		$(PYTHON_ZOPEINTERFACE_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zopeinterface-*.egg-info

$(PKG_FINISH)
