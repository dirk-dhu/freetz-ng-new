$(call PKG_INIT_BIN, 0.9.1)
$(PKG)_SOURCE:=$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=1ea2d4fb2c5e919cc14ccda5b71e4b8b
$(PKG)_SITE:=https://github.com/requests/toolbelt/archive

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/requests_toolbelt

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_REQUESTSTOOLBELT, , TARGET_ARCH=$(FREETZ_TARGET_ARCH))

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_REQUESTSTOOLBELT_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_REQUESTSTOOLBELT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/requests_toolbelt \
		$(PYTHON_REQUESTSTOOLBELT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/requests_toolbelt*.egg-info

$(PKG_FINISH)
