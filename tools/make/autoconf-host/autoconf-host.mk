AUTOCONF_HOST_VERSION:=2.69
AUTOCONF_HOST_SOURCE:=autoconf-$(AUTOCONF_HOST_VERSION).tar.xz
AUTOCONF_HOST_SOURCE_MD5:=50f97f4159805e374639a73e2636f22e
AUTOCONF_HOST_SITE:=@GNU/autoconf

AUTOCONF_HOST_MAKE_DIR:=$(TOOLS_DIR)/make/autoconf-host
AUTOCONF_HOST_DIR:=$(TOOLS_SOURCE_DIR)/autoconf-$(AUTOCONF_HOST_VERSION)

autoconf-host-source: $(DL_DIR)/$(AUTOCONF_HOST_SOURCE)
$(DL_DIR)/$(AUTOCONF_HOST_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(AUTOCONF_HOST_SOURCE) $(AUTOCONF_HOST_SITE) $(AUTOCONF_HOST_SOURCE_MD5)

autoconf-host-unpacked: $(AUTOCONF_HOST_DIR)/.unpacked
$(AUTOCONF_HOST_DIR)/.unpacked: $(DL_DIR)/$(AUTOCONF_HOST_SOURCE) | $(TOOLS_SOURCE_DIR)
	tar -C $(TOOLS_SOURCE_DIR) $(VERBOSE) -xf $(DL_DIR)/$(AUTOCONF_HOST_SOURCE)
	$(call APPLY_PATCHES,$(AUTOCONF_HOST_MAKE_DIR)/patches,$(AUTOCONF_HOST_DIR))
	touch $@

$(AUTOCONF_HOST_DIR)/.configured: $(AUTOCONF_HOST_DIR)/.unpacked
	(cd $(AUTOCONF_HOST_DIR); $(RM) config.cache; \
		CFLAGS="-Wall -O2" \
		CC="$(TOOLS_CC)" \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--target=$(GNU_HOST_NAME) \
		--prefix=$(HOST_TOOLS_DIR)/usr \
		$(DISABLE_NLS) \
	);
	touch $@

$(AUTOCONF_HOST_DIR)/bin/autoconf: $(AUTOCONF_HOST_DIR)/.configured
	$(MAKE) -C $(AUTOCONF_HOST_DIR) all && \
	touch -c $@

$(TOOLS_DIR)/build/usr/bin/autoconf: $(AUTOCONF_HOST_DIR)/bin/autoconf
	PATH=$(TARGET_PATH) \
		$(MAKE) -C $(AUTOCONF_HOST_DIR) \
		install && \
	touch $@

autoconf-host: $(TOOLS_DIR)/build/usr/bin/autoconf

autoconf-host-clean:
	-$(MAKE) -C $(AUTOCONF_HOST_DIR) clean

autoconf-host-dirclean:
	$(RM) -r $(AUTOCONF_HOST_DIR)

autoconf-host-distclean: autoconf-host-dirclean
	$(RM) $(TOOLS_DIR)/autoconf $(TOOLS_DIR)/autoreconf