$(call PKG_INIT_BIN, release_2016.7)
$(PKG)_SOURCE:=pytz-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://git.launchpad.net/pytz

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/pytz-$($(PKG)_VERSION)/src

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pytz

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	cd $(dir $<); make build
	$(call HostPython, \
		cd $(dir $<)/build/dist/; \
		$(TARGET_CONFIGURE_ENV) \
		$(FREETZ_LD_RUN_PATH) \
		 \
		TARGET_ARCH=$(FREETZ_TARGET_ARCH), \
		./setup.py install --prefix=/usr --root=$(FREETZ_BASE_DIR)/$(PYTHON_CERTBOT_DEST_DIR) \
	)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYTZ_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYTZ_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pytz \
		$(PYTHON_PYTZ_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pytz-*.egg-info

$(PKG_FINISH)
