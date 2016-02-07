$(call PKG_INIT_LIB, 2.5.8)
$(PKG)_LIB_VERSION:=4.4.8
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=0821830d930a86a5c69110837c55b7da
$(PKG)_SITE:=@SF/mcrypt

$(PKG)_BINARY:=$($(PKG)_DIR)/lib/.libs/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$(pkg).so.$($(PKG)_LIB_VERSION)

$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static
$(PKG)_CONFIGURE_OPTIONS += --disable-rpath
$(PKG)_CONFIGURE_OPTIONS += --disable-desktop-integration

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(LIBMCRYPT_DIR) \
		all

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(LIBMCRYPT_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/lib/libmcrypt.la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(LIBMCRYPT_DIR) clean
	$(RM) $(TARGET_TOOLCHAIN_STAGING_DIR)/lib/libmcrypt* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/lib/pkgconfig/libmcrypt.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/include/mcrypt*.h

$(pkg)-uninstall:
	$(RM) $(LIBMCRYPT_TARGET_DIR)/libmcrypt*.so*

$(PKG_FINISH)
