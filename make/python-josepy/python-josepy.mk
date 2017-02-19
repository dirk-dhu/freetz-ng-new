$(call PKG_INIT_BIN, 1.2.0)
$(PKG)_SOURCE:=v$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=86e79262934693dd050d60441e4baf7b
$(PKG)_SITE:=https://github.com/certbot/josepy/archive

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/josepy/jws.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_JOSEPY, , TARGET_ARCH=$(FREETZ_TARGET_ARCH))

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_JOSEPY_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_JOSEPY_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/josepy \
		$(PYTHON_JOSEPY_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/josepy-*.egg-info

$(PKG_FINISH)
