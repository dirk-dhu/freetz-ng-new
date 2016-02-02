$(call PKG_INIT_BIN, 9b3244e)
$(PKG)_SOURCE:=configargparse-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/bw2/ConfigArgParse.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/configargparse-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/configargparse.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_CONFIGARGPARSE) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_CONFIGARGPARSE_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CONFIGARGPARSE_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/configargparse.py \
		$(PYTHON_CONFIGARGPARSE_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/configargparse-*.egg-info

$(PKG_FINISH)
