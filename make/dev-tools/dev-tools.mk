$(call PKG_INIT_BIN, 0.1.1)
#$(PKG)_SOURCE:=dev-tools-$($(PKG)_VERSION).tgz
#$(PKG)_SOURCE_MD5:=e56d0d81e5e40b1c41c4b9ed74a1edd8
$(PKG)_SITE:=@SF/dev-tools

$(PKG)_BINARIES            := objdump ld gcc
$(PKG)_BINARIES_BUILD_DIR  := $($(PKG)_BINARIES:%=$($(PKG)_DIR)/usr/bin/%)
$(PKG)_LIBS_BUILD_DIR      := $($(PKG)_DIR)/usr/libexec/gcc/$(REAL_GNU_TARGET_NAME)/$(TARGET_TOOLCHAIN_GCC_VERSION)
$(PKG)_BINARIES_TARGET_DIR := $($(PKG)_BINARIES:%=$($(PKG)_DEST_DIR)/usr/bin/%)

$(PKG)_PREFIX := $(shell echo $(FREETZ_PACKAGE_DEV_TOOLS_PREFIX) | tr -d '"')
$(PKG)_LIBEXEC_TARGET_DIR  := $($(PKG)_TARGET_DIR)/root$($(PKG)_PREFIX)/libexec/gcc/$(REAL_GNU_TARGET_NAME)/$(TARGET_TOOLCHAIN_GCC_VERSION)
$(PKG)_LIBNAMES_SHORT      := lto_plugin
$(PKG)_LIBVERSIONS_MAJOR   := 0
$(PKG)_LIBVERSIONS_MINOR   := 0.0
$(PKG)_LIBNAMES_LONG_MAJOR := $(join $($(PKG)_LIBNAMES_SHORT:%=lib%.so.),$($(PKG)_LIBVERSIONS_MAJOR))
$(PKG)_LIBNAMES_LONG       := $(join $($(PKG)_LIBNAMES_LONG_MAJOR:%=%.),$($(PKG)_LIBVERSIONS_MINOR))
$(PKG)_LIBS_TARGET_DIR     := $($(PKG)_LIBNAMES_LONG:%=$($(PKG)_LIBEXEC_TARGET_DIR)/%)

$(PKG)_BINARIES_FULL_TARGET_DIR := $($(PKG)_DEST_DIR)$($(PKG)_PREFIX)
$(PKG)_LIBS_FULL_TARGET_DIR     := $($(PKG)_DEST_DIR)/lib

$(PKG)_TARGET_UTIL_CHECK_DONE    := $($(PKG)_DIR)/.target_util_check_done

$(PKG_SOURCE_DOWNLOAD_NOP)
$(PKG_UNPACKED)
$(PKG_CONFIGURED)

$($(PKG)_DIR)/.configured:
	mkdir -p $(dir $@); touch $@

#.PHONY: target-toolchain binutils_target gcc_target
#$($(PKG)_TARGET_UTIL_CHECK_DONE): target-toolchain binutils_target gcc_target
# target to check if target utils (FREETZ_TARGET_TOOLCHAIN) have to be build independent if FREETZ_BUILD_TOOLCHAIN or FREETZ_DOWNLOAD_TOOLCHAIN is selected
$($(PKG)_TARGET_UTIL_CHECK_DONE): $($(PKG)_DIR)/.configured $($(PKG)_DIR)/.unpacked
	if [ -e $(TARGET_UTILS_DIR)/usr/bin ] && [ -e $(TARGET_UTILS_DIR)/usr/libexec/gcc/$(REAL_GNU_TARGET_NAME)/$(TARGET_TOOLCHAIN_GCC_VERSION) ]; then \
	touch $@; else \
	FREETZ_BUILD_TOOLCHAIN=y FREETZ_BUILD_TOOLCHAIN_TARGET_ONLY=y $(MAKE) binutils_target gcc_target uclibc_target && touch $@; fi; \
	#$(MAKE) -i dev-tools-uninstall
	#FREETZ_BUILD_TOOLCHAIN=y $(MAKE) target-toolchain binutils_target gcc_target && touch $@; fi; \
	

$($(PKG)_BINARIES_BUILD_DIR): $($(PKG)_TARGET_UTIL_CHECK_DONE)
	mkdir -p $(dir $@); \
	$(RM) -fr $(DEV_TOOLS_DEST_DIR)/usr/local ; \
	cp $(TARGET_UTILS_DIR)/usr/bin/$(@F) $(dir $@)

$($(PKG)_LIBS_BUILD_DIR): $($(PKG)_TARGET_UTIL_CHECK_DONE)
	mkdir -p $@; \
	cp -P $(TARGET_UTILS_DIR)/usr/libexec/gcc/$(REAL_GNU_TARGET_NAME)/$(TARGET_TOOLCHAIN_GCC_VERSION)/liblto_plugin.so* $@

$($(PKG)_LIBS_TARGET_DIR): $($(PKG)_LIBS_BUILD_DIR)
	mkdir -p $(dir $@); \
	cp -a $</* $(dir $@); \
	$(TARGET_STRIP) $@

$($(PKG)_BINARIES_FULL_TARGET_DIR): $($(PKG)_TARGET_UTIL_CHECK_DONE)
	find $@ -type l -exec rm -f {} \; ; \
	mkdir -p $@; \
	$(RM) -fr $(DEV_TOOLS_DEST_DIR)/usr/bin $(DEV_TOOLS_DEST_DIR)/usr/libexec; \
	cp -fa $(TARGET_UTILS_DIR)/usr/. $@
ifeq ($(FREETZ_PACKAGE_DEV_TOOLS_LIBSINCS),y)
	cp -fa $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin $@; \
	rm -rf $@/bin/mips-linux-*; \
	cp -fa $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include $@; \
	cp -fa $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib $@; \
	cp -fa $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/share $@; \
	for f in `find $@/libexec -type f -name *.so`; do $(TARGET_STRIP) $$f; done; \
	for i in $@/lib/pkgconfig/*.pc; do sed -i 's~$(TARGET_TOOLCHAIN_STAGING_DIR)/usr~/usr/local~' $$i; done; \
	for i in $@/lib/*.la;           do sed -i 's~$(TARGET_TOOLCHAIN_STAGING_DIR)/usr~/usr/local~' $$i; done; \
	for i in $@/lib/*.la;           do sed -i 's~$(FREETZ_BASE_DIR)/toolchain/build/.*/usr~/usr/local~' $$i; done; \
	for i in $@/lib/*.la;           do sed -i 's~$(FREETZ_BASE_DIR)/toolchain/build/.*/$(REAL_GNU_TARGET_NAME)/lib~/usr/local/lib~' $$i; done; \
	for i in $@/bin/*-config;       do sed -i 's~$(FREETZ_BASE_DIR)/toolchain/build/.*/bin/$(REAL_GNU_TARGET_NAME)-~/usr/local/bin/~' $$i; done; \
	for i in $@/bin/*-config;       do sed -i 's~--cache.*\.cache~~' $$i; done; \
	for i in $@/bin/*-config;       do sed -i 's~$(TARGET_TOOLCHAIN_STAGING_DIR)/usr~/usr/local~' $$i; chmod a+x $$i; done
endif
	for i in $@/libexec/gcc/$(REAL_GNU_TARGET_NAME)/$(TARGET_TOOLCHAIN_GCC_VERSION)/*.la; \
	                                do sed -i 's~/usr~/usr/local~' $$i; done; \
	for f in `find $@/bin -type f -name *.so`; do grep -sq '#!/bin/sh' $$f || $(TARGET_STRIP) $$f; done; \
	rm $@/lib/libc.so $@/lib/libpthread.so && (cd $@/lib; ln -s /lib/libc.so.0 libc.so; ln -s /lib/libpthread.so.0 libpthread.so); \
	for f in `find $@/lib -type f -name *.so`; do $(TARGET_STRIP) $$f; done && touch $@

$($(PKG)_LIBS_FULL_TARGET_DIR): $($(PKG)_TARGET_UTIL_CHECK_DONE)
	mkdir -p $@; \
	cp -a $(TARGET_UTILS_DIR)/lib/. $@; \
	find $@ -type f -name *.so -exec $(TARGET_STRIP) {} \;  && touch $@


$(foreach binary,$($(PKG)_BINARIES_BUILD_DIR),$(eval $(call INSTALL_BINARY_STRIP_RULE,$(binary),$($(PKG)_PREFIX)/bin)))

#$(foreach binary,$($(PKG)_LIBS_BUILD_DIR),$(eval $(call INSTALL_BINARY_STRIP_RULE,$(binary),$($(PKG)_PREFIX)/libexec/gcc/$(REAL_GNU_TARGET_NAME)/$(TARGET_TOOLCHAIN_GCC_VERSION))))

$(pkg):

ifeq ($(FREETZ_PACKAGE_DEV_TOOLS_MINIMAL),y)
$(pkg)-precompiled: $($(PKG)_BINARIES_TARGET_DIR) $($(PKG)_LIBS_TARGET_DIR)
else
$(pkg)-precompiled: $($(PKG)_BINARIES_FULL_TARGET_DIR) $($(PKG)_LIBS_FULL_TARGET_DIR)
endif

$(pkg)-clean:
	$(RM) -rf $(DEV_TOOLS_DIR)/usr
	$(RM) -rf $(DEV_TOOLS_DIR)/lib
	$(RM) $(DEV_TOOLS_TARGET_UTIL_CHECK_DONE)
	$(RM) $(DEV_TOOLS_DIR)/.configured $(DEV_TOOLS_DIR)/.unpacked
	$(RM) $(DEV_TOOLS_TARGET_UTIL_CHECK_DONE)

$(pkg)-dirclean: dev-tools-target-toolchain-dirclean

dev-tools-target-toolchain-dirclean:
ifneq ($(strip $(FREETZ_BUILD_TOOLCHAIN)),y)
	FREETZ_BUILD_TOOLCHAIN=y $(MAKE) binutils_target-dirclean gcc_target-dirclean uclibc_target-dirclean
	FREETZ_BUILD_TOOLCHAIN=y $(MAKE) target-toolchain-dirclean
	FREETZ_BUILD_TOOLCHAIN=y $(MAKE) kernel-toolchain-dirclean
endif

$(pkg)-uninstall:
	$(RM) -fr $(DEV_TOOLS_DEST_DIR)/usr
	$(RM) -fr $(DEV_TOOLS_DEST_DIR)/lib


$(PKG_FINISH)
