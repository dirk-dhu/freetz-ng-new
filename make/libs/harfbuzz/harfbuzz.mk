$(call PKG_INIT_LIB, 7.1.0)
$(PKG)_LIB_VERSION:=0.60700.0
$(PKG)_SOURCE:=harfbuzz-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=f135a61cd464c9ed6bc9823764c188f276c3850a8dc904628de2a87966b7077b
$(PKG)_SITE:=https://github.com/harfbuzz/harfbuzz/releases/download/$($(PKG)_VERSION)
### WEBSITE:=https://harfbuzz.github.io/
### MANPAGE:=https://github.com/harfbuzz/harfbuzz/wiki
### CHANGES:=https://github.com/harfbuzz/harfbuzz/releases
### CVSREPO:=https://github.com/harfbuzz/harfbuzz

$(PKG)_LIBNAME_SHORT:=$(pkg)
$(PKG)_LIBNAME_LONG:=$($(PKG)_LIBNAME_SHORT:%=lib%.so.$($(PKG)_LIB_VERSION))
$(PKG)_BINARY:=$($(PKG)_DIR)/src/.libs/$($(PKG)_LIBNAME_LONG)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$($(PKG)_LIBNAME_LONG)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$($(PKG)_LIBNAME_LONG)

$(PKG)_DEPENDS_ON += freetype

$(PKG)_REBUILD_SUBOPTS += FREETZ_STDCXXLIB

$(PKG)_CONFIGURE_OPTIONS += --disable-gtk-doc
$(PKG)_CONFIGURE_OPTIONS += --disable-gtk-doc-html
$(PKG)_CONFIGURE_OPTIONS += --disable-gtk-doc-pdf
$(PKG)_CONFIGURE_OPTIONS += --disable-introspection
$(PKG)_CONFIGURE_OPTIONS += --without-glib
$(PKG)_CONFIGURE_OPTIONS += --without-gobject
$(PKG)_CONFIGURE_OPTIONS += --without-chafa
$(PKG)_CONFIGURE_OPTIONS += --without-icu
$(PKG)_CONFIGURE_OPTIONS += --without-cairo
$(PKG)_CONFIGURE_OPTIONS += --without-libstdc++
$(PKG)_CONFIGURE_OPTIONS += --with-freetype
$(PKG)_CONFIGURE_OPTIONS += --without-graphite2
$(PKG)_CONFIGURE_OPTIONS += --without-uniscribe
$(PKG)_CONFIGURE_OPTIONS += --without-gdi
$(PKG)_CONFIGURE_OPTIONS += --without-directwrite
$(PKG)_CONFIGURE_OPTIONS += --without-coretext


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(HARFBUZZ_DIR)

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(HARFBUZZ_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/harfbuzz*.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libharfbuzz*.la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(HARFBUZZ_DIR) clean
	$(RM) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libharfbuzz* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/harfbuzz/ \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/harfbuzz*.pc

$(pkg)-uninstall:
	$(RM) $(HARFBUZZ_TARGET_DIR)/libharfbuzz.so*

$(PKG_FINISH)
