$(call PKG_INIT_LIB, 1.17.4)
$(PKG)_LIB_VERSION:=2.11704.0
$(PKG)_SOURCE:=cairo-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=74b24c1ed436bbe87499179a3b27c43f4143b8676d8ad237a6fa787401959705
$(PKG)_SITE:=https://www.cairographics.org/releases,https://cairographics.org/snapshots
### WEBSITE:=https://www.cairographics.org/
### MANPAGE:=https://www.cairographics.org/documentation/
### CHANGES:=https://www.cairographics.org/news/

$(PKG)_LIBNAME_SHORT:=$(pkg)
$(PKG)_LIBNAME_LONG:=$($(PKG)_LIBNAME_SHORT:%=lib%.so.$($(PKG)_LIB_VERSION))
$(PKG)_BINARY:=$($(PKG)_DIR)/src/.libs/$($(PKG)_LIBNAME_LONG)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$($(PKG)_LIBNAME_LONG)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$($(PKG)_LIBNAME_LONG)

$(PKG)_DEPENDS_ON += pixman fontconfig freetype libpng zlib

$(PKG)_CONFIGURE_OPTIONS += --disable-gtk-doc
$(PKG)_CONFIGURE_OPTIONS += --disable-atomic
$(PKG)_CONFIGURE_OPTIONS += --disable-gcov
$(PKG)_CONFIGURE_OPTIONS += --disable-valgrind
$(PKG)_CONFIGURE_OPTIONS += --enable-xlib=no
$(PKG)_CONFIGURE_OPTIONS += --enable-xlib-xrender=no
$(PKG)_CONFIGURE_OPTIONS += --enable-xcb=no
$(PKG)_CONFIGURE_OPTIONS += --enable-xlib-xcb=no
$(PKG)_CONFIGURE_OPTIONS += --enable-xcb-shm=no
$(PKG)_CONFIGURE_OPTIONS += --enable-qt=no
$(PKG)_CONFIGURE_OPTIONS += --enable-quartz=no
$(PKG)_CONFIGURE_OPTIONS += --enable-quartz-font=no
$(PKG)_CONFIGURE_OPTIONS += --enable-quartz-image=no
$(PKG)_CONFIGURE_OPTIONS += --enable-win32=no
$(PKG)_CONFIGURE_OPTIONS += --enable-win32-font=no
$(PKG)_CONFIGURE_OPTIONS += --enable-os2=no
$(PKG)_CONFIGURE_OPTIONS += --enable-beos=no
$(PKG)_CONFIGURE_OPTIONS += --enable-drm=no
$(PKG)_CONFIGURE_OPTIONS += --enable-gallium=no
$(PKG)_CONFIGURE_OPTIONS += --enable-png=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-gl=no
$(PKG)_CONFIGURE_OPTIONS += --enable-glesv2=no
$(PKG)_CONFIGURE_OPTIONS += --enable-glesv3=no
$(PKG)_CONFIGURE_OPTIONS += --enable-cogl=no
$(PKG)_CONFIGURE_OPTIONS += --enable-directfb=no
$(PKG)_CONFIGURE_OPTIONS += --enable-vg=no
$(PKG)_CONFIGURE_OPTIONS += --enable-egl=no
$(PKG)_CONFIGURE_OPTIONS += --enable-glx=no
$(PKG)_CONFIGURE_OPTIONS += --enable-wgl=no
$(PKG)_CONFIGURE_OPTIONS += --enable-script=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-ft=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-fc=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-ps=no
$(PKG)_CONFIGURE_OPTIONS += --enable-pdf=no
$(PKG)_CONFIGURE_OPTIONS += --enable-svg=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-test-surfaces=no
$(PKG)_CONFIGURE_OPTIONS += --enable-tee=no
$(PKG)_CONFIGURE_OPTIONS += --enable-xml=no
$(PKG)_CONFIGURE_OPTIONS += --enable-pthread=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-gobject=no
$(PKG)_CONFIGURE_OPTIONS += --enable-full-testing=no
$(PKG)_CONFIGURE_OPTIONS += --enable-trace=no
$(PKG)_CONFIGURE_OPTIONS += --enable-interpreter=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-symbol-lookup=no
$(PKG)_CONFIGURE_OPTIONS += --disable-some-floating-point
$(PKG)_CONFIGURE_OPTIONS += --without-x
$(PKG)_CONFIGURE_OPTIONS += --without-gallium


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(CAIRO_DIR)

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(CAIRO_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/cairo.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libcairo.la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(CAIRO_DIR) clean
	$(RM) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libcairo.* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/cairo/ \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/cairo.pc

$(pkg)-uninstall:
	$(RM) $(CAIRO_TARGET_DIR)/libcairo.so*

$(PKG_FINISH)
