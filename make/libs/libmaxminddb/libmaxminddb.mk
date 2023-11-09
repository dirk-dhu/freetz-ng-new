$(call PKG_INIT_LIB, 1.8.0)
$(PKG)_SHLIB_VERSION:=0.0.7
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=1107799f77be6aa3b9796ad0eed8ffcc334bf45f8bd18e6a984d8adf3e719c6d
$(PKG)_SITE:=https://github.com/maxmind/libmaxminddb/releases/download/$($(PKG)_VERSION)
### WEBSITE:=https://maxmind.github.io/libmaxminddb/
### CHANGES:=https://github.com/maxmind/libmaxminddb/releases
### CVSREPO:=https://github.com/maxmind/libmaxminddb/

$(PKG)_BINARY:=$($(PKG)_DIR)/src/.libs/libmaxminddb.so.$($(PKG)_SHLIB_VERSION)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libmaxminddb.so.$($(PKG)_SHLIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/libmaxminddb.so.$($(PKG)_SHLIB_VERSION)


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(LIBMAXMINDDB_DIR)

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(LIBMAXMINDDB_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install-strip
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libmaxminddb.la \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/libmaxminddb.pc

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP_WILDCARD_BEFORE_SO)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(LIBMAXMINDDB_DIR) clean
	$(RM) -r \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libmaxminddb* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/libmaxminddb.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/maxminddb.h

$(pkg)-uninstall:
	$(RM) $(LIB_TARGET_DIR)/libmaxminddb*.so*

$(PKG_FINISH)

