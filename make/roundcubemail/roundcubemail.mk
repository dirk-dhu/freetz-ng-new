$(call PKG_INIT_BIN, 1.0.9)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5_1.0.3:=e35652adea5cd4069fcaa1410ae58864
$(PKG)_SOURCE_MD5_1.0.8:=b548c11b1cba877cb9756a8c802806cb
$(PKG)_SOURCE_MD5_1.0.9:=980db5229e29507e9cf8d70c0db52712
$(PKG)_SOURCE_MD5_1.1.4:=051c0a07e744006c57fab7a5db79b5bc
$(PKG)_SOURCE_MD5:=$($(PKG)_SOURCE_MD5_$($(PKG)_VERSION))
$(PKG)_SITE:=https://github.com/roundcube/$(pkg)/releases/download/$($(PKG)_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/config/config.inc.php.sample
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/etc/default.$(pkg)/config.inc.php.default
$(PKG)_CATEGORY:=Web interfaces

RANDOM :=`dd if=/dev/urandom bs=1 count=150 2> /dev/null | tr -d -c '[:alnum:][_:?*+,§%]' | cut -b-24`

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	#exchange the present file with itself and changed random number
	sed -i -s "s/1234.*KLMN/${RANDOM}/" $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) $(ROUNDCUBEMAIL_DIR)/.configured

$(pkg)-dirclean:
	$(RM) -r $(ROUNDCUBEMAIL_SOURCE_DIR)

$(pkg)-uninstall:
	$(RM) $(ROUNDCUBEMAIL_TARGET_BINARY)

$(PKG_FINISH)
