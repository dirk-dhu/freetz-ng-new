$(call PKG_INIT_BIN, 82ac89b)
$(PKG)_SOURCE:=certbot-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git@https://github.com/certbot/certbot.git
$(PKG)_HASH:=X

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/certbot-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/certbot

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-certbot, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_CERTBOT); \
	$(call HostPython, \
		cd $(dir $<)/acme; \
		$(TARGET_CONFIGURE_ENV) \
		$(FREETZ_LD_RUN_PATH) \
		 \
		TARGET_ARCH=$(FREETZ_TARGET_ARCH), \
		./setup.py install --prefix=/usr --root=$(FREETZ_BASE_DIR)/$(PYTHON_CERTBOT_DEST_DIR) \
	); \
	$(call HostPython, \
		cd $(dir $<)/certbot-apache; \
		$(TARGET_CONFIGURE_ENV) \
		$(FREETZ_LD_RUN_PATH) \
		 \
		TARGET_ARCH=$(FREETZ_TARGET_ARCH), \
		./setup.py install --prefix=/usr --root=$(FREETZ_BASE_DIR)/$(PYTHON_CERTBOT_DEST_DIR) \
	); \
	for f in ls $(FREETZ_BASE_DIR)/$(PYTHON_CERTBOT_DEST_DIR)/usr/bin/*; do sed -i -r -e 's~^#!/.*/hostpython~#!/usr/bin/python~g' $$f; done

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_CERTBOT_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CERTBOT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/certbot \
		$(PYTHON_CERTBOT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/certbot-*.egg-info

$(PKG_FINISH)
