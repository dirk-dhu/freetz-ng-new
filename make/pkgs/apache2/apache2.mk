$(call PKG_INIT_BIN, 2.4.58)
$(PKG)_SOURCE:=httpd-$($(PKG)_VERSION).tar.bz2
$(PKG)_HASH:=fa16d72a078210a54c47dd5bef2f8b9b8a01d94909a51453956b3ec6442ea4c5
$(PKG)_SITE:=@APACHE/httpd
### WEBSITE:=https://httpd.apache.org/
### MANPAGE:=https://httpd.apache.org/docs/2.4/
### CHANGES:=https://downloads.apache.org/httpd/CHANGES_2.4
### CVSREPO:=https://github.com/apache/httpd

# if ssl is configured, then it will be somehow picked up by apache2 configure, therefore enable it anyway
$(PKG)_WITH_SSL:=
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_SSL)),y) 
$(PKG)_WITH_SSL:=y
endif
ifeq ($(strip $(FREETZ_LIB_libssl)),y) 
$(PKG)_WITH_SSL:=y
endif

$(PKG)_CONDITIONAL_PATCHES+=$(FREETZ_PACKAGE_APACHE2_MPM)
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_SMALL)),y)
$(PKG)_CONDITIONAL_PATCHES+=small
endif
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_WITH_MYCONFIG)),y)
$(PKG)_CONDITIONAL_PATCHES+=myconfig
endif
ifeq ($(strip $(FREETZ_PACKAGE_ROUNDCUBEMAIL)),y)
$(PKG)_CONDITIONAL_PATCHES+=roundcubemail
endif
ifeq ($(strip $(FREETZ_PACKAGE_LINKNX)),y)
$(PKG)_CONDITIONAL_PATCHES+=linknx
endif
ifeq ($(strip $(FREETZ_PACKAGE_WFROG)),y)
$(PKG)_CONDITIONAL_PATCHES+=wfrog
endif
ifeq ($(strip $(APACHE2_WITH_SSL)),y)
$(PKG)_CONDITIONAL_PATCHES+=ssl
endif
ifeq ($(strip $(FREETZ_PACKAGE_FHEM)),y)
$(PKG)_CONDITIONAL_PATCHES+=fhem
endif
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_PROXY)),y)
$(PKG)_CONDITIONAL_PATCHES+=proxy
endif
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_SSL_WITH_CERT)),y)
$(PKG)_CONFIGURE_PRE_CMDS += $(SED) -i -e 's/www.example.com/$(shell echo $(FREETZ_PACKAGE_APACHE2_SSL_CERT_USE_DOMAINNAME) | tr -d "")/' $(abspath $($(PKG)_DIR))/docs/conf/extra/httpd-ssl.conf.in;
endif

# patch PidFile to /var/run/apache2/httpd.pid
$(PKG)_CONFIGURE_PRE_CMDS += $(SED) -i -e 's~@rel_runtimedir@~/var/run/apache2~g' $(abspath $($(PKG)_DIR))/docs/conf/extra/httpd-mpm.conf.in;
$(PKG)_CONFIGURE_PRE_CMDS += $(SED) -i -e 's~@rel_runtimedir@~/var/run/apache2~g' $(abspath $($(PKG)_DIR))/include/ap_config_layout.h.in;

$(PKG)_BINARY:=$($(PKG)_DIR)/$(pkg)
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/sbin/$(pkg)
$(PKG)_TAR_CONFIG := $($(PKG)_DEST_DIR)/etc/default.$(pkg)/default_config/default_config.tar
$(PKG)_TAR_HTDOC  := $($(PKG)_DEST_DIR)/etc/default.$(pkg)/default_htdoc/default_htdoc.tar

$(PKG)_APXS_SCRIPT:=$($(PKG)_DIR)/support/apxs
$(PKG)_APXS_SCRIPT_STAGING_DIR:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/apxs

$(PKG)_HTPW_BINARY:=$($(PKG)_DIR)/support/htpasswd
$(PKG)_HTPW_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/sbin/htpasswd

$(PKG)_CERT_KEY_TARGET   := $($(PKG)_DEST_DIR)/etc/default.$(pkg)/ssl/server.key
$(PKG)_CERT_CRT_TARGET   := $($(PKG)_DEST_DIR)/etc/default.$(pkg)/ssl/server.crt
$(PKG)_CERT_CHAIN_TARGET := $($(PKG)_DEST_DIR)/etc/default.$(pkg)/ssl/server-ca.crt
$(PKG)_CERT_CSR          := $($(PKG)_DIR)/server.csr

$(PKG)_DEPENDS_ON += apr apr-util
$(PKG)_DEPENDS_ON += $(if $(FREETZ_PACKAGE_APACHE2_PCRE1),pcre,pcre2)

ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_DEFLATE)),y)
$(PKG)_DEPENDS_ON += zlib
endif
ifeq ($(strip $(APACHE2_WITH_SSL)),y)
$(PKG)_REBUILD_SUBOPTS += FREETZ_OPENSSL_SHLIB_VERSION
$(PKG)_DEPENDS_ON += openssl
endif
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_LIBXML)),y)
$(PKG)_DEPENDS_ON += libxml2
endif
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_SSL_WITH_CERT)),y)
$(PKG)_CONFIGURE_PRE_CMDS += $(SED) -i -e 's/www\.example\.com/$(shell echo $(FREETZ_PACKAGE_APACHE2_SSL_CERT_USE_DOMAINNAME) | tr -d "" | sed s~\\\.~\\\\\\.~g)/' docs/conf/extra/httpd-ssl.conf.in;
endif

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE2_PCRE1
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE2_PCRE2
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE2_DEFLATE
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE2_SSL
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE2_LIBXML
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE2_COMPILEINMODS
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE2_STATIC

$(PKG)_CONFIGURE_ENV += ap_cv_void_ptr_lt_long=no

# TODO: investigate why
#   apr_pollset_create(&event_pollset, 1, plog, APR_POLLSET_THREADSAFE | APR_POLLSET_NOCOPY);
# call fails (s. server/mpm/event/event.c) and provide a better fix than that below (if possible).
#
# Until then provide a hint that MPM=event doesn't work and let the apache configure script
# decide which MPM to use. According to http://httpd.apache.org/docs/2.4/mpm.html#defaults
# this most likely be the MPM=worker.
$(PKG)_CONFIGURE_ENV += ac_cv_have_threadsafe_pollset=no

$(PKG)_CONFIGURE_OPTIONS += --with-apr="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/apr-1-config"
$(PKG)_CONFIGURE_OPTIONS += --with-apr-util="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/apu-1-config"
ifeq ($(strip $(FREETZ_PACKAGE_APACHE2_PCRE1)),y)
$(PKG)_CONFIGURE_OPTIONS += --with-pcre="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/pcre-config"
else
$(PKG)_CONFIGURE_OPTIONS += --with-pcre="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/pcre2-config"
endif
$(PKG)_CONFIGURE_OPTIONS += --with-ssl=$(if $(FREETZ_PACKAGE_APACHE2_SSL),"$(TARGET_TOOLCHAIN_STAGING_DIR)/usr",no)
$(PKG)_CONFIGURE_OPTIONS += --with-z=$(if $(FREETZ_PACKAGE_APACHE2_DEFLATE),"$(TARGET_TOOLCHAIN_STAGING_DIR)/usr",no)

$(PKG)_CONFIGURE_OPTIONS += --with-libxml2=$(if $(FREETZ_PACKAGE_APACHE2_LIBXML),"$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/libxml2",no)

$(PKG)_LIBEXECDIR := /usr/lib/$(pkg)
$(PKG)_CONFIGURE_OPTIONS += --with-program-name=$(pkg)
$(PKG)_CONFIGURE_OPTIONS += --with-suexec-bin=/usr/sbin/suexec2
$(PKG)_CONFIGURE_OPTIONS += --sysconfdir=/mod/etc/$(pkg)
$(PKG)_CONFIGURE_OPTIONS += --includedir=/usr/include/$(pkg)
$(PKG)_CONFIGURE_OPTIONS += --libexecdir=$($(PKG)_LIBEXECDIR)
$(PKG)_CONFIGURE_OPTIONS += --datadir=/mod/usr/share/$(pkg)
$(PKG)_CONFIGURE_OPTIONS += --localstatedir=/var/$(pkg)

$(PKG)_CONFIGURE_OPTIONS += --enable-substitute
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_APACHE2_DEFLATE),--enable-deflate,--disable-deflate)
$(PKG)_CONFIGURE_OPTIONS += --enable-expires
$(PKG)_CONFIGURE_OPTIONS += --enable-headers
$(PKG)_CONFIGURE_OPTIONS += --enable-unique-id
$(PKG)_CONFIGURE_OPTIONS += --enable-proxy
$(PKG)_CONFIGURE_OPTIONS += $(if $(APACHE2_WITH_SSL),--enable-ssl,--disable-ssl)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_APACHE2_MPM_PREFORK),--with-mpm=prefork,--with-mpm=worker)
$(PKG)_CONFIGURE_OPTIONS += --enable-dav
$(PKG)_CONFIGURE_OPTIONS += --enable-dav-fs
$(PKG)_CONFIGURE_OPTIONS += --enable-suexec
$(PKG)_CONFIGURE_OPTIONS += --enable-rewrite
$(PKG)_CONFIGURE_OPTIONS += --enable-cgi
$(PKG)_CONFIGURE_OPTIONS += --enable-cgid
$(PKG)_CONFIGURE_OPTIONS += --disable-lua
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_APACHE2_LIBXML),--enable-xml2enc --enable-proxy-html,--disable-xml2enc --disable-proxy-html)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_APACHE2_COMPILEINMODS),--enable-mods-static=all --disable-so,--enable-mods-shared=all --enable-so)
ifeq ($(strip $(APACHE2_WITH_SSL)),y)
$(PKG)_CONFIGURE_OPTIONS += --with-sslport=$(if $(FREETZ_PACKAGE_APACHE2_SSL_WITH_SSLPORT),$(FREETZ_PACKAGE_APACHE2_SSL_WITH_SSLPORT),443)
endif
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_APACHE2_PROXY), --enable-proxy-http,)


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(APACHE2_DIR) \
		$(if $(FREETZ_PACKAGE_APACHE2_STATIC),LDFLAGS="-all-static")

$($(PKG)_APXS_SCRIPT): $($(PKG)_DIR)/.configured
	touch $@

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE1) -C $(APACHE2_DIR) install \
		DESTDIR="$(FREETZ_BASE_DIR)/$(APACHE2_DEST_DIR)"
# remove unneeded files
	$(RM) -r \
		$(APACHE2_DEST_DIR)/mod/etc/apache2/original \
		$(APACHE2_DEST_DIR)/usr/{bin,include,sbin/envvars-std,share/man} \
		$(APACHE2_DEST_DIR)/mod/usr/share/apache2/{build,cgi-bin/*,error/README*,icons/README*,icons/*.gif,icons/*/*.gif,manual} \
		$(APACHE2_DEST_DIR)/var
# strip binaries & modules
	-$(TARGET_STRIP) $(APACHE2_DEST_DIR)/usr/sbin/* $(APACHE2_DEST_DIR)/usr/lib/apache2/*.so
# rename suexec to suexec2 manually, apache ignores --with-suexec-bin option
	mv $(APACHE2_DEST_DIR)/usr/sbin/suexec $(APACHE2_DEST_DIR)/usr/sbin/suexec2

$($(PKG)_HTPW_TARGET_BINARY): $($(PKG)_TARGET_BINARY)
	cp $(APACHE2_HTPW_BINARY) $@
	-$(TARGET_STRIP) $@

$($(PKG)_CERT_CRT_TARGET): $($(PKG)_CERT_KEY_TARGET) $($(PKG)_CERT_CSR)
	openssl x509 -req -in $(APACHE2_CERT_CSR) -out $@ -signkey $< -days 1001

$($(PKG)_CERT_KEY_TARGET) $($(PKG)_CERT_CSR):
	mkdir -p $(dir $@)
	mkdir -p $(dir $(APACHE2_CERT_CSR))
	openssl req -nodes -newkey rsa:2048 -keyout $(APACHE2_CERT_KEY_TARGET) -out $(APACHE2_CERT_CSR) -subj "/CN=$(strip $(FREETZ_PACKAGE_APACHE2_SSL_CERT_USE_DOMAINNAME))" && \
	chmod 600 $(APACHE2_CERT_KEY_TARGET)

$($(PKG)_CERT_CHAIN_TARGET): $($(PKG)_CERT_CRT_TARGET)
	mkdir -p $(dir $@)
	openssl x509 -inform PEM -in $(APACHE2_CERT_CRT_TARGET) -out $@

$($(PKG)_APXS_SCRIPT_STAGING_DIR): $($(PKG)_APXS_SCRIPT)
	$(SUBMAKE1) -C $(APACHE2_DIR) \
		install-include install-build \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)"
	$(SED) -i -r -e 's,^(includedir[ \t]*=[ \t]*)(.*),\1$(TARGET_TOOLCHAIN_STAGING_DIR)\2,' \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/mod/usr/share/apache2/build/config_vars.mk
	$(INSTALL_FILE)
	chmod 755 $@
	$(SED) -i -r -e 's,my \$$STAGING_DIR = "";,my \$$STAGING_DIR = "$(TARGET_TOOLCHAIN_STAGING_DIR)";,' $@
	$(SED) -i -r -e 's,\$$destdir \. ,,g' $@

$($(PKG)_TAR_CONFIG): $($(PKG)_TARGET_BINARY) $($(PKG)_DIR)/docs/conf
	mkdir -p $(dir $@)
	tar -C $(APACHE2_DEST_DIR)/mod/etc/apache2 -cf $@ .
	$(RM) -r $(APACHE2_DEST_DIR)/mod/etc
	[ ! -d $(APACHE2_DEST_DIR)/mod/usr ] && $(RM) -r $(APACHE2_DEST_DIR)/mod ||:

$($(PKG)_TAR_HTDOC): $($(PKG)_TARGET_BINARY)
	mkdir -p $(dir $@)
	tar -C $(APACHE2_DEST_DIR)/mod/usr/share/apache2 -cf $@ .
	$(RM) -r $(APACHE2_DEST_DIR)/mod/usr
	[ ! -d $(APACHE2_DEST_DIR)/mod/etc ] && $(RM) -r $(APACHE2_DEST_DIR)/mod ||:

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_APXS_SCRIPT_STAGING_DIR) $($(PKG)_TAR_CONFIG) $($(PKG)_TAR_HTDOC) $($(PKG)_HTPW_TARGET_BINARY) $(if $(FREETZ_PACKAGE_APACHE2_SSL_WITH_CERT),$($(PKG)_CERT_CHAIN_TARGET),)


$(pkg)-clean:
	-$(SUBMAKE) -C $(APACHE2_DIR) clean
	$(RM) -r \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/apxs \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/apache2 \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/share/apache2 \
		$(APACHE2_CERT_CSR)

$(pkg)-uninstall:
	$(RM) -r $(APACHE2_DEST_DIR)

$(PKG_FINISH)
