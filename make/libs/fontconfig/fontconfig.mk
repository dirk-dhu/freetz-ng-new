$(call PKG_INIT_LIB, 2.14.1)
$(PKG)_LIB_VERSION:=1.12.0
$(PKG)_SOURCE:=fontconfig-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=298e883f6e11d2c5e6d53c8a8394de58d563902cfab934e6be12fb5a5f361ef0
$(PKG)_SITE:=https://www.freedesktop.org/software/fontconfig/release
### WEBSITE:=https://www.freedesktop.org/wiki/Software/fontconfig/
### CHANGES:=https://gitlab.freedesktop.org/fontconfig/fontconfig/tags
### CVSREPO:=https://gitlab.freedesktop.org/fontconfig/fontconfig

$(PKG)_BINARY:=$($(PKG)_DIR)/src/.libs/lib$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/lib$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/lib$(pkg).so.$($(PKG)_LIB_VERSION)

$(PKG)_HOST_DEPENDS_ON += gperf-host
$(PKG)_DEPENDS_ON += freetype libxml2 zlib

$(PKG)_CONFIGURE_OPTIONS += --disable-nls
$(PKG)_CONFIGURE_OPTIONS += --disable-rpath
$(PKG)_CONFIGURE_OPTIONS += --disable-iconv
$(PKG)_CONFIGURE_OPTIONS += --disable-docbook
$(PKG)_CONFIGURE_OPTIONS += --disable-docs
$(PKG)_CONFIGURE_OPTIONS += --disable-cache-build
$(PKG)_CONFIGURE_OPTIONS += --enable-libxml2
$(PKG)_CONFIGURE_OPTIONS += --without-expat
$(PKG)_CONFIGURE_OPTIONS += --without-libintl-prefix
$(PKG)_CONFIGURE_OPTIONS += --without-libiconv


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(FONTCONFIG_DIR) \
		all

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(FONTCONFIG_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libfontconfig.la \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/fontconfig.pc

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(FONTCONFIG_DIR) clean
	$(RM) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libfontconfig.* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/fontconfig/ \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/fontconfig.pc

$(pkg)-uninstall:
	$(RM) $(FONTCONFIG_TARGET_DIR)/libfontconfig.so*

$(PKG_FINISH)
