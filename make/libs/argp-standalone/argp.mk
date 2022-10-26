$(call PKG_INIT_LIB, 1.3)
$(PKG)_LIB_VERSION:=1.3
$(PKG)_SOURCE:=argp-standalone-$($(PKG)_VERSION).tar.gz
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/argp-standalone-$($(PKG)_VERSION)
$(PKG)_HASH:=dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be
$(PKG)_SITE:=http://www.lysator.liu.se/~nisse/misc

$(PKG)_LIBNAMES_SHORT := libargp
$(PKG)_LIBNAME        :=libargp.a

$(PKG)_LIBS_LIBRARY := $($(PKG)_DIR)/$($(PKG)_LIBNAME))
$(PKG)_LIBS_STAGING := $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$($(PKG)_LIBNAME)
$(PKG)_LIBS_TARGET  := $($(PKG)_TARGET_DIR)/$($(PKG)_LIBNAME)

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)
$(PKG)_CONFIGURE_POST_CMDS += $(SED) -r -i 's/__THROW//g' ./argp-parse.c;

$(PKG)_EXTRA_CFLAGS  := 

$(PKG)_CONFIGURE_OPTIONS += --disable-nls

$(PKG)_CONFIGURE_ENV += ac_cv_prog_cc_c99=-std=gnu90
$(PKG)_CONFIGURE_ENV += ac_cv_prog_cc_stdc=-std=gnu90
$(PKG)_CONFIGURE_ENV += am_cv_prog_cc_stdc=-std=gnu90

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_LIBS_LIBRARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(ARGP_DIR) \
	        CFLAGS="$(ARGP_EXTRA_CFLAGS)"

$($(PKG)_LIBS_STAGING): $($(PKG)_LIBS_LIBRARY)
#	 $(SUBMAKE) -C $(ARGP_DIR) \
#		DESTDIR="$(TARGET_TOOLCHAIN_STAGING)" \
#		install
	echo staging
	cp $(ARGP_DIR)/$(ARGP_LIBNAME) $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib
	cp $(ARGP_DIR)/argp.h $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include

$($(PKG)_LIBS_TARGET): $($(PKG)_LIBS_STAGING)
	[ -e $(@D) ] || mkdir -p $(@D)
	cp $< $@

$(pkg): $($(PKG)_LIBS_STAGING)

$(pkg)-precompiled: $($(PKG)_LIBS_TARGET)

$(pkg)-clean:
	#-$(SUBMAKE) -C $(ARGP_DIR) clean
	$(RM) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libargp* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/argp*

$(pkg)-uninstall:
	$(RM) \
		$(ARGP_TARGET_DIR)/$(ARGP_LIBNAME)

$(call PKG_ADD_LIB,libargp)
$(PKG_FINISH)
