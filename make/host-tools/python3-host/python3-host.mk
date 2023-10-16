$(call TOOLS_INIT, 3.11.6)
$(PKG)_SOURCE:=Python-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=0fab78fa7f133f4f38210c6260d90d7c0d5c7198446419ce057ec7ac2e6f5f38
$(PKG)_SITE:=https://www.python.org/ftp/python/$($(PKG)_VERSION)

$(PKG)_BINARY:=$($(PKG)_DIR)/python
$(PKG)_TARGET_BINARY:=$(HOST_TOOLS_DIR)/usr/bin/python3.11

# python quirk: CFLAGS and OPT flags passed here are then used while cross-compiling -> use some target neutral flags
$(PKG)_CONFIGURE_ENV += OPT="-fno-inline"

$(PKG)_CONFIGURE_OPTIONS += --build=$(GNU_HOST_NAME)
$(PKG)_CONFIGURE_OPTIONS += --host=$(GNU_HOST_NAME)
$(PKG)_CONFIGURE_OPTIONS += --target=$(GNU_HOST_NAME)
$(PKG)_CONFIGURE_OPTIONS += --prefix=/usr
$(PKG)_CONFIGURE_OPTIONS += --enable-optimizations


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	(PATH=$(TARGET_PATH); \
		$(TOOLS_SUBMAKE) -C $(PYTHON3_HOST_DIR) \
		all )
	@touch -c $@

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY) | $(HOST_TOOLS_DIR)
	\
	(PATH=$(TARGET_PATH); \
		$(TOOLS_SUBMAKE) -C $(PYTHON3_HOST_DIR) \
		DESTDIR="$(HOST_TOOLS_DIR)" \
		commoninstall bininstall maninstall )

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(MAKE) -C $(PYTHON3_HOST_DIR) clean

$(pkg)-dirclean:
	$(RM) -r $(PYTHON3_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) -r \
		$(PYTHON3_HOST_TARGET_BINARY) \
		$(HOST_TOOLS_DIR)/usr/bin/2to3-3* \
		$(HOST_TOOLS_DIR)/usr/bin/idle3* \
		\
		$(HOST_TOOLS_DIR)/usr/bin/pydoc3* \
		\
		\
		$(HOST_TOOLS_DIR)/usr/bin/python3* \
		\
		$(HOST_TOOLS_DIR)/usr/include/python3* \
		$(HOST_TOOLS_DIR)/usr/lib/libpython3* \
		$(HOST_TOOLS_DIR)/usr/lib/pkgconfig/python-3* \
		$(HOST_TOOLS_DIR)/usr/lib/pkgconfig/python3* \
		\
		$(HOST_TOOLS_DIR)/usr/lib/python3* \
		\
		$(HOST_TOOLS_DIR)/usr/share/man/man1/python3*

$(TOOLS_FINISH)
