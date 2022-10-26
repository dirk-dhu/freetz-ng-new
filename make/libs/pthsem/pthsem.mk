$(call PKG_INIT_LIB, 2.0.8)
$(PKG)_LIB_VERSION:=20.0.28
$(PKG)_SOURCE:=pthsem_$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=4024cafdd5d4bce2b1778a6be5491222c3f6e7ef1e43971264c451c0012c5c01
#$(PKG)_SITE:=http://www.auto.tuwien.ac.at/~mkoegler/pth
$(PKG)_SITE:=http://sourceforge.net/projects/bcusdk/files/pthsem/

$(PKG)_LIBNAMES_SHORT := libpthsem
$(PKG)_LIBNAMES_LONG := $($(PKG)_LIBNAMES_SHORT:%=%.so.$($(PKG)_LIB_VERSION))

$(PKG)_LIBS_BUILD_DIR :=$($(PKG)_LIBNAMES_LONG:%=$($(PKG)_DIR)/.libs/%)
$(PKG)_LIBS_STAGING_DIR := $($(PKG)_LIBNAMES_LONG:%=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/%)
$(PKG)_LIBS_TARGET_DIR := $($(PKG)_LIBNAMES_LONG:%=$($(PKG)_TARGET_LIBDIR)/%)

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)

$(PKG)_CONFIGURE_OPTIONS += --with-mctx-mth=sjlj
$(PKG)_CONFIGURE_OPTIONS += --with-mctx-dsp=ssjlj
$(PKG)_CONFIGURE_OPTIONS += --with-mctx-stk=sas

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_LIBS_BUILD_DIR): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(PTHSEM_DIR)

$($(PKG)_LIBS_STAGING_DIR): $($(PKG)_LIBS_BUILD_DIR)
	$(SUBMAKE) -C $(PTHSEM_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install
	$(SUBMAKE) -C $(PTHSEM_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install-nodist_pkgconfigDATA
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/pthsem*.pc \
		$(PTHSEM_LIBNAMES_SHORT:%=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/%.la)
	# additional fixes not covered by default version of $(PKG_FIX_LIBTOOL_LA)
	$(call PKG_FIX_LIBTOOL_LA,pth_includedir pth_libdir) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/pthsem-config

$($(PKG)_LIBS_TARGET_DIR): $($(PKG)_TARGET_LIBDIR)/%: $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/%
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_LIBS_STAGING_DIR)

$(pkg)-precompiled: $($(PKG)_LIBS_TARGET_DIR)

$(pkg)-clean:
	-$(SUBMAKE) -C $(PTHSEM_DIR) clean
	$(RM) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/pthsem-config \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libpthsem* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/pthsem*.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/pthsem*

$(pkg)-uninstall:
	$(RM) \
		$(PTHSEM_TARGET_DIR)/libpthsem*.so*

$(call PKG_ADD_LIB,libpthsem)
$(PKG_FINISH)
