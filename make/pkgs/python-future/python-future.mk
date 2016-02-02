$(call PKG_INIT_BIN, fe494df)
$(PKG)_SOURCE:=future-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/PythonCharmers/python-future.git

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/future-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/future

$(PKG)_BUILD_PREREQ += wget curl
$(PKG)_BUILD_PREREQ_HINT := Hint: on Debian-like systems this binary is provided by the zip package (sudo apt-get install wget curl)

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_FUTURE); \
	[ -e $(FREETZ_BASE_DIR)/$(PYTHON_FUTURE_DEST_DIR)/usr/bin ] || mkdir -p $(FREETZ_BASE_DIR)/$(PYTHON_FUTURE_DEST_DIR)/usr/bin; \
	for f in ls $(FREETZ_BASE_DIR)/$(PYTHON_FUTURE_DEST_DIR)/usr/bin/*; do sed -i -r -e 's~^#!/.*/hostpython~#!/usr/bin/python~g' $$f; done

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_FUTURE_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_FUTURE_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/future \
		$(PYTHON_FUTURE_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/future-*.egg-info

$(PKG_FINISH)
