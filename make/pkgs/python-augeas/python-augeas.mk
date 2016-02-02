$(call PKG_INIT_BIN, 2391e27)
$(PKG)_SOURCE:=augeas-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/hercules-team/python-augeas.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/augeas-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/augeas.py

$(PKG)_DEPENDS_ON += python readline libaugeas

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_AUGEAS) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_AUGEAS_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_AUGEAS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/augeas.py \
		$(PYTHON_AUGEAS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/augeas-*.egg-info

$(PKG_FINISH)
