$(call PKG_INIT_BIN, f1d3775)
$(PKG)_SOURCE:=zopeevent-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/zopefoundation/zope.event.git
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/zopeevent-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zope/event

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-zopeevent, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_ZOPEEVENT)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_ZOPEEVENT_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_ZOPEEVENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zopeevent \
		$(PYTHON_ZOPEEVENT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/zopeevent-*.egg-info

$(PKG_FINISH)
