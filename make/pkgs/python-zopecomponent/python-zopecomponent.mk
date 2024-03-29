$(call PKG_INIT_BIN, 54ed4d9)
$(PKG)_SOURCE:=zopecomponent-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/zopefoundation/zope.component.git
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/zopecomponent-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zope/component

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-zopecomponent, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_ZOPECOMPONENT)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_ZOPECOMPONENT_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_ZOPECOMPONENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zopecomponent \
		$(PYTHON_ZOPECOMPONENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zopecomponent-*.egg-info

$(PKG_FINISH)
