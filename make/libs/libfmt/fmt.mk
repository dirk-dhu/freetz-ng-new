$(call PKG_INIT_LIB, 4.0.0)
$(PKG)_LIB_VERSION:=4.0.0
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).zip
$(PKG)_HASH:=10a9f184d4d66f135093a08396d3b0a0ebe8d97b79f8b3ddb8559f75fe4fcbc3
$(PKG)_SITE:=https://github.com/fmtlib/fmt/releases/download/$($(PKG)_VERSION)

$(PKG)_BINARY:=$($(PKG)_DIR)/fmt/libfmt.a
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libfmt.a
$(PKG)_STAGING_INCLUDE:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/fmt
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_LIBDIR)/../libfmt.a
$(PKG)_TARGET_INCLUDE:=$($(PKG)_TARGET_LIBDIR)/../../include/fmt

$(PKG)_BUILD_PREREQ += cmake
$(PKG)_BUILD_PREREQ_HINT := Hint: on Debian-like systems this binary is provided by the git package (sudo apt-get install cmake)

$(PKG)_MAKE_VARS += CC="$(TARGET_CC)"
$(PKG)_MAKE_VARS += CXX="$(TARGET_CXX)"
$(PKG)_MAKE_VARS += CFLAGS="$(TARGET_CFLAGS)"
$(PKG)_MAKE_VARS += RANLIB="$(TARGET_RANLIB)"
$(PKG)_MAKE_VARS += AR="$(TARGET_AR)"
#$(PKG)_MAKE_VARS += PREFIX=/usr

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	cd $(FMT_DIR); $(FMT_MAKE_VARS) cmake .
	$(SUBMAKE) -C $(FMT_DIR)/. \
		$(FMT_MAKE_VARS)

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
#	$(SUBMAKE) -C $(FMT_DIR)/lib \
#		$(FMT_MAKE_VARS) \
#		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
#		install
#	$(PKG_FIX_LIBTOOL_LA) \
#		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/libfmt.pc
	cp $(FMT_BINARY) $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib

$($(PKG)_STAGING_INCLUDE): $($(PKG)_BINARY)	
	[ -e $(FMT_STAGING_INCLUDE) ] || mkdir -p $(FMT_STAGING_INCLUDE)
	cp $(FMT_DIR)/fmt/*.h $(FMT_STAGING_INCLUDE)

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
#	$(INSTALL_LIBRARY_STRIP)
	[ -e $(@D) ] || mkdir -p $(@D)
	cp $< $@

$($(PKG)_TARGET_INCLUDE): $($(PKG)_STAGING_INCLUDE)
	[ -e $(@D) ] || mkdir -p $(@D)
	cp -R $< $@


$(pkg): $($(PKG)_STAGING_BINARY) $($(PKG)_STAGING_INCLUDE)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_TARGET_INCLUDE)

$(pkg)-clean:
	$(RM) -r \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libfmt* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/fmt \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/libfmt.pc

$(pkg)-uninstall:
	$(RM) -r $(FMT_TARGET_DIR)/../libfmt*.* $(FMT_TARGET_INCLUDE)

$(PKG_FINISH)
