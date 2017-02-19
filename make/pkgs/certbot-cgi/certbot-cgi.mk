$(call PKG_INIT_BIN, 1.0.0)
$(PKG)_CATEGORY:=Web interfaces
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/certbot-$($(PKG)_VERSION)
$(PKG)_HASH:=X

$(PKG)_CERT_CRT_TARGET := $($(PKG)_DIR)/server.crt
$(PKG)_CERT_KEY_TARGET := $($(PKG)_DEST_DIR)/etc/default.certbot/ssl/server.key
$(PKG)_CERT_CSR_TARGET := $($(PKG)_DEST_DIR)/etc/default.certbot/ssl/server.der
$(PKG)_CERT_CFG_TARGET := $($(PKG)_DEST_DIR)/etc/default.certbot/certbot.cfg

$(PKG)_DEPENDS_ON += openssl

$(PKG_SOURCE_DOWNLOAD_NOP)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE_NOP)

$($(PKG)_CERT_CRT_TARGET): $($(PKG)_CERT_KEY_TARGET) $($(PKG)_CERT_CSR_TARGET)
	#openssl x509 -req -in $(CERTBOT_CGI_CERT_CSR) -out $@ -signkey $< -days 1001

$($(PKG)_CERT_CFG_TARGET):
	echo "export CERTBOT_ENABLED=no" > $@; \
	echo 'export CERTBOT_FLASH=/tmp/flash/certbot' >> $@; \
	echo 'export CERTBOT_CERTS=/mod/etc/certbot/save' >> $@; \
	echo 'export CERTBOT_CERTPATH=$$CERTBOT_CERTS/server.crt' >> $@; \
	echo 'export CERTBOT_FULLCHAINPATH=$$CERTBOT_CERTS/fullchain.pem' >> $@; \
	echo 'export CERTBOT_CHAINPATH=$$CERTBOT_CERTS/chain.pem' >> $@; \
	echo 'export CERTBOT_DEFAULT=/mod/etc/default.certbot' >> $@; \
	echo "export CERTBOT_DOMAIN=$(FREETZ_PACKAGE_CERTBOT_CGI_WITH_DOMAINNAME)" >> $@; \
	echo "export CERTBOT_MAILNAME=$(FREETZ_PACKAGE_CERTBOT_CGI_WITH_MAILNAME)" >> $@; \
	echo "export CERTBOT_COUNTRY=$(FREETZ_PACKAGE_CERTBOT_CGI_WITH_COUNTRY)" >> $@; \
	echo "export CERTBOT_STATE=$(FREETZ_PACKAGE_CERTBOT_CGI_WITH_STATE)" >> $@; \
	echo "export CERTBOT_SSLPORT=$(FREETZ_PACKAGE_APACHE2_SSL_WITH_SSLPORT)" >> $@; \
	echo "export CERTBOT_HTTPPORT=8081" >> $@; \
	echo "export CERTBOT_DNSPORT=15353" >> $@; \
	echo "export CERTBOT_STARTONCE=no" >> $@; \
	echo "export CERTBOT_CHALLENGE=dns-01" >> $@; \
	echo "export CERTBOT_TEST=no" >> $@; \

$($(PKG)_CERT_KEY_TARGET):
	mkdir -p $(dir $@); \
	openssl genrsa -out $@ 2048 

$($(PKG)_CERT_CSR_TARGET): $($(PKG)_CERT_KEY_TARGET) 
	mkdir -p $(dir $@); \
	openssl req \
	-new -key $< \
	-out $@ -outform der \
	-subj "/C=$(strip $(FREETZ_PACKAGE_CERTBOT_CGI_WITH_COUNTRY))$(if $(shell echo $(FREETZ_PACKAGE_CERTBOT_CGI_WITH_STATE)),/ST=$(strip $(FREETZ_PACKAGE_CERTBOT_CGI_WITH_STATE)),)/L=HOME/O=$(strip $(FREETZ_PACKAGE_CERTBOT_CGI_WITH_DOMAINNAME))/emailAddress=$(strip $(FREETZ_PACKAGE_CERTBOT_CGI_WITH_MAILNAME))@$(strip $(FREETZ_PACKAGE_CERTBOT_CGI_WITH_DOMAINNAME))/CN=$(strip $(FREETZ_PACKAGE_CERTBOT_CGI_WITH_DOMAINNAME))" && \
	chmod 600 $(CERTBOT_CGI_CERT_KEY_TARGET)

$(pkg):

$(pkg)-precompiled: $($(PKG)_CERT_CSR_TARGET) $($(PKG)_CERT_CFG_TARGET)

$(pkg)-clean:
	$(RM) $(CERTBOT_CGI_CERT_CSR_TARGET) $(CERTBOT_CGI_CERT_CRT_TARGET)

$(pkg)-dirclean:
	$(RM) $(CERTBOT_CGI_CERT_KEY_TARGET)

$(pkg)-uninstall:
	$(RM) -r $(CERTBOT_CGI_DEST_DIR)

$(PKG_FINISH)
