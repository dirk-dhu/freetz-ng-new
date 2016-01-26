#$(call PKG_INIT_BIN, 70c13f2) # 0.4.17
$(call PKG_INIT_BIN, 80fae38) # 0.12.15
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=git://github.com/knxd/knxd.git

$(PKG)_BUILD_PREREQ += git cmake
$(PKG)_BUILD_PREREQ_HINT := Hint: on Debian-like systems this binary is provided by the git package (sudo apt-get install git cmake)
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/knxd-$($(PKG)_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/src/server/knxd
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/knxd
ifeq ($(FREETZ_PACKAGE_PERL),y)
$(PKG)_TARGET_PERL_CLIENT:= $($(PKG)_DEST_DIR)/usr/lib/perl5/$(FREETZ_PACKAGE_PERL_VERSION)/EIBConnection.pm
endif
ifeq ($(FREETZ_PACKAGE_PYTHON),y)
$(PKG)_TARGET_PYTHON_CLIENT:= $($(PKG)_DEST_DIR)/usr/lib/python2.7/EIBConnection.py
endif
ifeq ($(FREETZ_PACKAGE_PHP),y)
$(PKG)_TARGET_PHP_CLIENT:= $($(PKG)_DEST_DIR)/usr/mww/knxd/EIBConnection.php
endif

#$(PKG)_CONFIGURE_PRE_CMDS += libtoolize --copy --force --install && aclocal -I m4 --force; autoheader && automake --add-missing --copy --force-missing;
$(PKG)_CONFIGURE_PRE_CMDS += autoreconf -i; autoconf;
#$(PKG)_CONFIGURE_PRE_CMDS += $(PWD)/$(PATCH_TOOL) $(PWD)/$(KNXD_DIR) $(PWD)/$(KNXD_MAKE_DIR)/patches/before_configure/200-add-errno-to-types-h.patch; \
#                             $(PWD)/$(PATCH_TOOL) $(PWD)/$(KNXD_DIR) $(PWD)/$(KNXD_MAKE_DIR)/patches/before_configure/100-configure-libfmt-ok.patch;

$(PKG)_BUILD_PREREQ += libtoolize aclocal automake autoconf

$(PKG)_CONFIGURE_OPTIONS += --enable-onlyknxd
$(PKG)_CONFIGURE_OPTIONS += --enable-eibnetiptunnel
$(PKG)_CONFIGURE_OPTIONS += --enable-eibnetipserver
$(PKG)_CONFIGURE_OPTIONS += --disable-systemd

# add EXTRA_(C|LD)FLAGS
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD|CPP)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;
$(PKG)_EXTRA_CFLAGS   := -ffunction-sections -fdata-sections -D_GLIBCXX_USE_C99=1
$(PKG)_EXTRA_CPPFLAGS := -D_GLIBCXX_USE_C99=1 
$(PKG)_EXTRA_LDFLAGS  := -Wl,--gc-sections -largp

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_CFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include~'   \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_CPPFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include~' \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_LDFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib~'      \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += ln -s $(abspath $(FMT_DIR)) $(abspath $(KNXD_DIR)/libfmt);
$(PKG)_CONFIGURE_PRE_CMDS += $(SED) -r -i 's/test -d libfmt/return/' $(abspath $($(PKG)_DIR))/tools/get_libfmt;
$(PKG)_CONFIGURE_PRE_CMDS += $(SED) -r -i 's/cross_compiling=no/cross_compiling=yes/' $(abspath $($(PKG)_DIR))/configure;
$(PKG)_CONFIGURE_POST_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile -exec $(SED) -r -i 's~(LIBS =.*)(true)~\1~'      \{\} \+;

$(PKG)_CONFIGURE_ENV      += ac_cv_header_fmt_printf_h=yes
$(PKG)_CONFIGURE_ENV      += ac_cv_header_argp_h=yes
$(PKG)_CONFIGURE_ENV      += ac_cv_search_argp_parse=true
$(PKG)_CONFIGURE_ENV      += ac_cv_lib_ev_ev_run=yes

$(PKG)_DEPENDS_ON += libev fmt argp libusb1 $(STDCXXLIB)
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libfmt FREETZ_LIB_libev FREETZ_LIB_libargp_WITH_STATIC FREETZ_LIB_libusb_1 FREETZ_STDCXXLIB

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(KNXD_DIR)  \
		EXTRA_CFLAGS="$(KNXD_EXTRA_CFLAGS)" \
		EXTRA_CPPFLAGS="$(KNXD_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(KNXD_EXTRA_LDFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(KNXD_DIR)/src/server install-strip DESTDIR=$(abspath $(KNXD_DEST_DIR))
	$(SUBMAKE) -C $(KNXD_DIR)/src/tools  install-strip DESTDIR=$(abspath $(KNXD_DEST_DIR))
	$(SUBMAKE) -C $(KNXD_DIR)/src/usb    install-strip DESTDIR=$(abspath $(KNXD_DEST_DIR))		

$($(PKG)_TARGET_PHP_CLIENT) $($(PKG)_TARGET_PERL_CLIENT) $($(PKG)_TARGET_PYTHON_CLIENT): $($(PKG)_BINARY)
	mkdir -p $(@D); \
	find $(abspath $($(PKG)_DIR)) -name $(@F) -exec cp {} $@ \;

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_TARGET_PHP_CLIENT) $($(PKG)_TARGET_PERL_CLIENT) $($(PKG)_TARGET_PYTHON_CLIENT)

$(pkg)-clean:
	$(RM) $(KNXD_DIR)/.configured

$(pkg)-uninstall:
	$(SUBMAKE) -C $(KNXD_DIR) uninstall DESTDIR=$(abspath $(KNXD_DEST_DIR))
	$(RM) $(KNXD_TARGET_BINARY) $(KNXD_TARGET_PHP_CLIENT) $(KNXD_TARGET_PERL_CLIENT) $(KNXD_TARGET_PYTHON_CLIENT)

$(PKG_FINISH)
