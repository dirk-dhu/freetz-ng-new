$(call PKG_INIT_LIB, 1.6.0)
$(PKG)_LIB_VERSION:=0.21.0
$(PKG)_SOURCE:=augeas-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=8906de3c36e9158cf6cc25e8e3e986b2
$(PKG)_SITE:=http://download.augeas.net/

$(PKG)_DIR:=$(SOURCE_DIR)/augeas-$($(PKG)_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/src/.libs/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$(pkg).so.$($(PKG)_LIB_VERSION)

$(PKG)_DEPENDS_ON += libxml2 readline

$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libxml2 FREETZ_LIB_libreadline

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)


$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(LIBAUGEAS_DIR) PACKAGE_VERSION=$($(PKG)_VERSION) \
		all

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(LIBAUGEAS_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/lib/libaugeas.la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(LIBAUGEAS_DIR) clean
	$(RM) $(TARGET_TOOLCHAIN_STAGING_DIR)/lib/libaugeas* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/lib/pkgconfig/libaugeas.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/include/augeas*.h

$(pkg)-uninstall:
	$(RM) $(LIBAUGEAS_TARGET_DIR)/libaugeas*.so*

$(PKG_FINISH)
