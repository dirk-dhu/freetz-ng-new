$(call PKG_INIT_BIN, 76f1da9)
$(PKG)_SOURCE:=setuptools-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/pypa/setuptools.git
$(PKG)_VERSION_ALT:=39.0.1
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/setuptools-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/setuptools

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	mkdir -p $@ $(PYTHON_SETUPTOOLS_DEST_DIR)/usr/bin; \
	$(call HostPython, \
		cd $(dir $<); \
		$(TARGET_CONFIGURE_ENV) \
		$(FREETZ_LD_RUN_PATH) \
		 \
		TARGET_ARCH=$(FREETZ_TARGET_ARCH), \
		./bootstrap.py \
	); \
	$(call HostPython, \
		cd $(dir $<); \
		$(TARGET_CONFIGURE_ENV) \
		$(FREETZ_LD_RUN_PATH) \
		 \
		TARGET_ARCH=$(FREETZ_TARGET_ARCH), \
		./setup.py install --prefix=/usr --root=$(FREETZ_BASE_DIR)/$(PYTHON_SETUPTOOLS_DEST_DIR) \
	); \
	for f in ls $(FREETZ_BASE_DIR)/$(PYTHON_SETUPTOOLS_DEST_DIR)/usr/bin/*; do sed -i -r -e 's~^#!/.*/hostpython~#!/usr/bin/python~g' $$f; done

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_SETUPTOOLS_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_SETUPTOOLS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/setuptools \
		$(PYTHON_SETUPTOOLS_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/setuptools-*.egg-info

$(PKG_FINISH)
