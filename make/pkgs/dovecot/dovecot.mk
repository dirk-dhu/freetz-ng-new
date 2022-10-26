$(call PKG_INIT_BIN, 2.3.19.1)
$(PKG)_SOURCE:=dovecot-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=db5abcd87d7309659ea6b45b2cb6ee9c5f97486b2b719a5dd05a759e1f6a5c51
$(PKG)_SITE:=http://www.dovecot.org/releases/2.3

$(PKG)_STARTLEVEL=92 # after xmail

$(PKG)_BINARY        := $($(PKG)_DIR)/src/master/.libs/$(pkg)
$(PKG)_TARGET_BINARY := $($(PKG)_DEST_DIR)/usr/sbin/$(pkg)
$(PKG)_TAR_CONFIG    := $($(PKG)_DEST_DIR)/etc/default.$(pkg)/default_config/default_config.tar
$(PKG)_DH_PARAMS     := $($(PKG)_DEST_DIR)/etc/default.$(pkg)/dhparams.pem


$(PKG)_CONDITIONAL_PATCHES+=$(FREETZ_PACKAGE_DOVECOT_FOR)
ifeq ($(strip $(FREETZ_PACKAGE_DOVECOT_SYSLOG)),y)
$(PKG)_CONDITIONAL_PATCHES+=syslog
endif

$(PKG)_EXTRA_CFLAGS  := -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS := -Wl,--gc-sections -lcrypt -lcrypto -lssl -lz -Wl,-rpath=/usr/lib/freetz

$(PKG)_DEPENDS_ON += zlib openssl

$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libcrypto_WITH_ZLIB FREETZ_LIB_libcrypt FREETZ_LIB_libcrypto FREETZ_OPENSSL_SHLIB_VERSION


$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;

$(PKG)_CONFIGURE_OPTIONS := --sysconfdir=/mod/etc
$(PKG)_CONFIGURE_OPTIONS += --libexecdir=/usr/libexec
$(PKG)_CONFIGURE_OPTIONS += --without-nss
$(PKG)_CONFIGURE_OPTIONS += --without-shadow
$(PKG)_CONFIGURE_OPTIONS += --without-pam
$(PKG)_CONFIGURE_OPTIONS += --without-bsdauth
$(PKG)_CONFIGURE_OPTIONS += --with-gssapi=no
$(PKG)_CONFIGURE_OPTIONS += --without-sia
$(PKG)_CONFIGURE_OPTIONS += --with-ldap=no
$(PKG)_CONFIGURE_OPTIONS += --without-bsdauth
$(PKG)_CONFIGURE_OPTIONS += --without-vpopmail
$(PKG)_CONFIGURE_OPTIONS += --with-sql=no
$(PKG)_CONFIGURE_OPTIONS += --with-ssl=openssl
$(PKG)_CONFIGURE_OPTIONS += --with-sql=no
$(PKG)_CONFIGURE_OPTIONS += --without-pgsql
$(PKG)_CONFIGURE_OPTIONS += --without-mysql
$(PKG)_CONFIGURE_OPTIONS += --without-sqlite
$(PKG)_CONFIGURE_OPTIONS += --without-lucene
$(PKG)_CONFIGURE_OPTIONS += --without-vpopmail
$(PKG)_CONFIGURE_OPTIONS += --without-solr
$(PKG)_CONFIGURE_OPTIONS += --without-zlib
$(PKG)_CONFIGURE_OPTIONS += --without-bzlib
$(PKG)_CONFIGURE_OPTIONS += --with-storages=maildir,imapc

# following configure values have been checked with configure runs 
#   directly on 7270 7390 and 7490 hardware with native compiler
$(PKG)_CONFIGURE_ENV += i_cv_epoll_works=yes
$(PKG)_CONFIGURE_ENV += i_cv_inotify_works=yes
$(PKG)_CONFIGURE_ENV += ac_cv_func_fallocate=no
$(PKG)_CONFIGURE_ENV += i_cv_posix_fallocate_works=no
$(PKG)_CONFIGURE_ENV += i_cv_signed_size_t=no
$(PKG)_CONFIGURE_ENV += i_cv_typeof_size_t='unsigned int/unsigned int'
$(PKG)_CONFIGURE_ENV += i_cv_gmtime_max_time_t=32
$(PKG)_CONFIGURE_ENV += i_cv_signed_time_t=yes
$(PKG)_CONFIGURE_ENV += i_cv_mmap_plays_with_write=yes
$(PKG)_CONFIGURE_ENV += ac_cv_func_dirfd=yes
$(PKG)_CONFIGURE_ENV += ac_cv_search_fdatasync='none required'
$(PKG)_CONFIGURE_ENV += i_cv_fd_passing=yes
$(PKG)_CONFIGURE_ENV += i_cv_c99_vsnprintf=yes
$(PKG)_CONFIGURE_ENV += lib_cv___va_copy=yes
$(PKG)_CONFIGURE_ENV += lib_cv_va_copy=yes
$(PKG)_CONFIGURE_ENV += lib_cv_va_val_copy=yes
$(PKG)_CONFIGURE_ENV += ac_cv_sys_file_offset_bits=64
# disable backtrace.so because it its remove by freetz or use dev-tools
$(PKG)_CONFIGURE_ENV += ac_cv_func_backtrace_symbols=no


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(DOVECOT_DIR) \
		EXTRA_CFLAGS="$(DOVECOT_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(DOVECOT_EXTRA_LDFLAGS)" \
		STRIP="$(TARGET_STRIP)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE) -C $(DOVECOT_DIR) \
		DESTDIR="$(abspath $(DOVECOT_DEST_DIR))" \
		install-strip; \
	rm -rf $(abspath $(DOVECOT_DEST_DIR))/usr/share $(abspath $(DOVECOT_DEST_DIR))/usr/lib/dovecot/*.*a $(abspath $(DOVECOT_DEST_DIR))/usr/lib/dovecot/*/*.*a $(abspath $(DOVECOT_DEST_DIR))/usr/include $(abspath $(DOVECOT_DEST_DIR))/mod

$($(PKG)_TAR_CONFIG):
	mkdir -p $(dir $@)
	tar --exclude='Makefile' --exclude='README' --exclude='*.am' --exclude='*.in' -C $(DOVECOT_DIR)/doc/example-config -cf $(DOVECOT_TAR_CONFIG) .
	
$($(PKG)_DH_PARAMS):
	openssl dhparam -out $@ 2048 

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_TAR_CONFIG) $($(PKG)_DH_PARAMS)

$(pkg)-clean:
	-$(SUBMAKE) -C $(DOVECOT_DIR) clean
	$(RM) $(DOVECOT_DIR)/.configured

$(pkg)-uninstall:
	$(RM) -r $(DOVECOT_DEST_DIR)/usr/lib/dovecot $(DOVECOT_DEST_DIR)/usr/libexec/dovecot $(DOVECOT_DEST_DIR)/usr/include/dovecot
	$(RM) $(DOVECOT_TARGET_BINARY)

$(PKG_FINISH)
