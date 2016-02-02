$(call PKG_INIT_BIN, b2af86d)
$(PKG)_SOURCE:=pythondialog-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@http://github.com/frougon/pythondialog.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/pythondialog-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/dialog.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYTHONDIALOG) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYTHONDIALOG_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYTHONDIALOG_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/dialog.py \
		$(PYTHON_PYTHONDIALOG_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/python2_pythondialog-*.egg-info

$(PKG_FINISH)
