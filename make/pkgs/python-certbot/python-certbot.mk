$(call PKG_INIT_BIN, 1.11.0)
#$(PKG)_SOURCE:=certbot-$($(PKG)_VERSION).tar.gz
#$(PKG)_SITE:=git@https://github.com/certbot/certbot.git
$(PKG)_SOURCE:=v$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5_1.10.1:=deeaf6b77ff6bb4318acd1da4fc9974a
$(PKG)_SOURCE_MD5_1.11.0:=805e64dbfa69d9f4fd8ba2981ed9ff97
$(PKG)_SOURCE_MD5_1.14.0:=88f267993e5f887dde34a0b042d84585
$(PKG)_SOURCE_MD5_1.15.0:=fb16598707f6a2093352e8cf1ca919e3
$(PKG)_SOURCE_MD5_1.16.0:=36f0bc3f59bb13cc156e73c8887f4c63
$(PKG)_SOURCE_MD5_1.17.0:=d0ab745bbc525e17e2f12d12d197d943
$(PKG)_SOURCE_MD5_1.19.0:=e8934685c32f70e29eccfb26628443fe
$(PKG)_SOURCE_MD5_1.22.0:=e80e91aec502b001799bffa2b442db26
$(PKG)_SOURCE_MD5:=$($(PKG)_SOURCE_MD5_$($(PKG)_VERSION))
$(PKG)_SITE:=https://github.com/certbot/certbot/archive/

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/certbot-$($(PKG)_VERSION)
#$(PKG)_DEST_DIR:=$(FREETZ_BASE_DIR)/certbot-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/certbot
#$(PKG)_TARGET_HTTP_AUTH:=$($(PKG)_DEST_DIR)/usr/lib/certbot/tests/manual-http-auth.sh $($(PKG)_DEST_DIR)/usr/lib/certbot/tests/manual-http-cleanup.sh $($(PKG)_DEST_DIR)/usr/lib/certbot/tests/run_http_server.py

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-certbot, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call HostPython, \
		cd $(dir $<)/certbot; \
		$(TARGET_CONFIGURE_ENV) \
		$(FREETZ_LD_RUN_PATH) \
		 \
		TARGET_ARCH=$(FREETZ_TARGET_ARCH), \
		./setup.py install --prefix=/usr --root=$(FREETZ_BASE_DIR)/$(PYTHON_CERTBOT_DEST_DIR) \
	); \
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
	for f in ls $(FREETZ_BASE_DIR)/$(PYTHON_CERTBOT_DEST_DIR)/usr/bin/*; do sed -i -r -e 's~^#!/.*/hostpython~#!/usr/bin/python~g' $$f; done; \

$($(PKG)_TARGET_HTTP_AUTH): $($(PKG)_TARGET_BINARY)
	mkdir -p ${@D}; \
	cp $(PYTHON_CERTBOT_DIR)/tests/$(@F) $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_TARGET_HTTP_AUTH)

$(pkg)-clean:
	$(RM) -r $(PYTHON_CERTBOT_DIR)/build 

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CERTBOT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/certbot \
		$(PYTHON_CERTBOT_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/certbot-*.egg-info \
		$(PYTHON_CERTBOT_TARGET_HTTP_AUTH)

$(PKG_FINISH)
