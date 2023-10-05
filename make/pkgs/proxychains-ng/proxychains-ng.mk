$(call PKG_INIT_BIN, 4.14)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=9d00e035b8a808b9e0c750501b08f38eeadd0be421f30ee83e88fd15e872b0ae
$(PKG)_SITE:=https://ftp.barfooze.de/pub/sabotage/tarballs
### WEBSITE:=https://proxychains-ng.sourceforge.net
### MANPAGE:=https://github.com/rofl0r/proxychains-ng#readme
### CHANGES:=https://github.com/rofl0r/proxychains-ng/releases
### CVSREPO:=https://github.com/rofl0r/proxychains-ng

$(PKG)_BINARY:=$($(PKG)_DIR)/proxychains4
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/proxychains4

$(PKG)_MODULE:=$($(PKG)_DIR)/libproxychains4.so
$(PKG)_TARGET_MODULE := $($(PKG)_DEST_LIBDIR)/libproxychains4.so

$(PKG)_CONFIGURE_OPTIONS += --libdir="$(FREETZ_RPATH)"


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY) $($(PKG)_MODULE): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(PROXYCHAINS_NG_DIR) \
		CC=$(TARGET_CC) \
		STRIP="$(TARGET_STRIP)" \
		CFLAGS="$(TARGET_CFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_TARGET_MODULE): $($(PKG)_MODULE)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_TARGET_MODULE)


$(pkg)-clean:
	-$(SUBMAKE) -C $(PROXYCHAINS_NG_DIR) clean

$(pkg)-uninstall:
	$(RM) $(PROXYCHAINS_NG_TARGET_BINARY) $(PROXYCHAINS_NG_TARGET_MODULE)

$(PKG_FINISH)

