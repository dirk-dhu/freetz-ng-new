$(call PKG_INIT_LIB, 1.17.8)
$(PKG)_LIB_VERSION:=2.11708.0
$(PKG)_SOURCE:=cairo-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=5b10c8892d1b58d70d3f0ba5b47863a061262fa56b9dc7944161f8c8b783bc64
$(PKG)_SITE:=https://www.cairographics.org/releases,https://cairographics.org/snapshots
### WEBSITE:=https://www.cairographics.org/
### MANPAGE:=https://www.cairographics.org/documentation/
### CHANGES:=https://www.cairographics.org/news/

$(PKG)_LIBNAME_SHORT:=$(pkg)
$(PKG)_LIBNAME_LONG:=$($(PKG)_LIBNAME_SHORT:%=lib%.so.$($(PKG)_LIB_VERSION))
$(PKG)_BINARY:=$($(PKG)_DIR)/src/.libs/$($(PKG)_LIBNAME_LONG)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$($(PKG)_LIBNAME_LONG)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$($(PKG)_LIBNAME_LONG)

$(PKG)_HOST_DEPENDS_ON += meson-host
$(PKG)_DEPENDS_ON += pixman fontconfig freetype libpng zlib

$(PKG)_CONFIGURE_OPTIONS += -Dbuildtype=release
$(PKG)_CONFIGURE_OPTIONS += -Ddwrite=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dfontconfig=enabled
$(PKG)_CONFIGURE_OPTIONS += -Dfreetype=enabled
$(PKG)_CONFIGURE_OPTIONS += -Dglib=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dgtk2-utils=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dgtk_doc=false
$(PKG)_CONFIGURE_OPTIONS += -Dpng=enabled
$(PKG)_CONFIGURE_OPTIONS += -Dquartz=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dspectre=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dsymbol-lookup=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dtee=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dtests=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dxcb=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dxlib=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dxlib-xcb=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dxml=disabled
$(PKG)_CONFIGURE_OPTIONS += -Dzlib=disabled


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_MESON)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMESON) compile \
		-C $(CAIRO_DIR)/builddir/
#meson	$(MESON) configure $(CAIRO_DIR)/builddir/

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMESON) install \
		--destdir "$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		-C $(CAIRO_DIR)/builddir/
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/cairo*.pc
#meson		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libcairo*.la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(CAIRO_DIR) clean
	$(RM) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libcairo* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/cairo/ \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/cairo*.pc

$(pkg)-uninstall:
	$(RM) $(CAIRO_TARGET_DIR)/libcairo.so*

$(PKG_FINISH)
