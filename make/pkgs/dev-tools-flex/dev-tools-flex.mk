$(call PKG_INIT_BIN, 2.6.4)
$(PKG)_SOURCE:=flex-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=2882e3179748cc9f9c23ec593d6adc8d
$(PKG)_SITE:=https://github.com/westes/flex/files/981163/

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/flex-$($(PKG)_VERSION)
$(PKG)_MAJOR_VERSION:=2
$(PKG)_MAJOR_LIBNAME=libfl
$(PKG)_LIBNAME=$($(PKG)_MAJOR_LIBNAME).so.$(DEV_TOOLS_FLEX_MAJOR_VERSION).0.0
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)$(DEV_TOOLS_PREFIX)/lib/$($(PKG)_LIBNAME)
$(PKG)_BINARY:=$($(PKG)_DIR)/src/flex
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(DEV_TOOLS_PREFIX)/bin/flex

$(PKG)_EXTRA_CFLAGS  := -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS := -Wl,--gc-sections

$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e '/^[\t]tests \\/d' \{\} \+;

$(PKG)_CONFIGURE_OPTIONS := --prefix=$(DEV_TOOLS_PREFIX)
$(PKG)_CONFIGURE_OPTIONS += --bindir=$(DEV_TOOLS_PREFIX)/bin
$(PKG)_CONFIGURE_OPTIONS += --datadir=$(DEV_TOOLS_PREFIX)/share
$(PKG)_CONFIGURE_OPTIONS += --includedir=$(DEV_TOOLS_PREFIX)/include
$(PKG)_CONFIGURE_OPTIONS += --infodir=$(DEV_TOOLS_PREFIX)/share/info
$(PKG)_CONFIGURE_OPTIONS += --libdir=$(DEV_TOOLS_PREFIX)/lib
$(PKG)_CONFIGURE_OPTIONS += --libexecdir=$(DEV_TOOLS_PREFIX)/lib
$(PKG)_CONFIGURE_OPTIONS += --mandir=$(DEV_TOOLS_PREFIX)/share/man
$(PKG)_CONFIGURE_OPTIONS += --sbindir=$(DEV_TOOLS_PREFIX)/sbin

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_DIR)/.configured: $($(PKG)_DIR)/configure

$($(PKG)_DIR)/configure:
	cd $(DEV_TOOLS_FLEX_DIR) && PATH=$(HOST_TOOLS_DIR)/bin:$(HOST_TOOLS_DIR)/usr/bin:$$PATH ./autogen.sh

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -j 1 -C $(DEV_TOOLS_FLEX_DIR) \
		EXTRA_CFLAGS="$(DEV_TOOLS_FLEX_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(DEV_TOOLS_FLEX_EXTRA_LDFLAGS)" \
		STRIP="$(TARGET_STRIP)"

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(DEV_TOOLS_FLEX_DIR)/src \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install-libLTLIBRARIES install-includeHEADERS
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)$(DEV_TOOLS_PREFIX)/lib/$(DEV_TOOLS_FLEX_MAJOR_LIBNAME).la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(SUBMAKE) -C $(DEV_TOOLS_FLEX_DIR)/src \
		DESTDIR="$(abspath $(DEV_TOOLS_FLEX_DEST_DIR))" \
		install-binPROGRAMS; \
	$(TARGET_STRIP) $@; \
	$(RM) -rf $(dir $@)../share $(dir $@)../lib; \
	cd $(dir $@); rm -f flex++; ln -s flex flex++

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(DEV_TOOLS_FLEX_DIR) clean
	$(RM) $(DEV_TOOLS_FLEX_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(DEV_TOOLS_FLEX_TARGET_BINARY) $(DEV_TOOLS_FLEX_DIR)$(DEV_TOOLS_PREFIX)/bin/flex++


$(PKG_FINISH)
