ifeq ($(strip $(FREETZ_STRIP_LIBRARIES)),y)
TOOLS+=libffi-host
endif

LIBFFI_HOST_VERSION:=3.4.4
LIBFFI_HOST_LIB_VERSION:=6.0.4
LIBFFI_HOST_SOURCE:=libffi-$(LIBFFI_HOST_VERSION).tar.gz
LIBFFI_HOST_SOURCE_MD5:=83b89587607e3eb65c70d361f13bab43
LIBFFI_HOST_SITE:=ftp://sourceware.org/pub/libffi
LIBFFI_HOST_DIR:=$(TOOLS_SOURCE_DIR)/libffi-$(LIBFFI_HOST_VERSION)
LIBFFI_HOST_MAKE_DIR:=$(FREETZ_BASE_DIR)/make/libs/libffi
LIBFFI_HOST_DESTDIR:=$(FREETZ_BASE_DIR)/$(TOOLS_DIR)/build/lib
LIBFFI_HOST_BINARY:=$(LIBFFI_HOST_DIR)/$(shell gcc -dumpmachine | sed -e s'/-.*//')-pc-linux-gnu/.libs/libffi.so.$(LIBFFI_HOST_LIB_VERSION)
LIBFFI_HOST_TARGET_BINARY:=$(LIBFFI_HOST_DESTDIR)/libffi.so.$(LIBFFI_HOST_LIB_VERSION)
LIBFFI_HOST_LD_PRELOAD_PATH:=

LIBFFI_HOST_CONFIGURE_OPTIONS += --enable-shared
LIBFFI_HOST_CONFIGURE_OPTIONS += --enable-static
LIBFFI_HOST_CONFIGURE_OPTIONS += --disable-debug


libffi-host-source: $(DL_DIR)/$(LIBFFI_HOST_SOURCE)
#$(DL_DIR)/$(LIBFFI_HOST_SOURCE): | $(DL_DIR)
#	$(DL_TOOL) $(DL_DIR) $(LIBFFI_HOST_SOURCE) $(LIBFFI_HOST_SITE) $(LIBFFI_HOST_SOURCE_MD5)

libffi-host-unpacked: $(LIBFFI_HOST_DIR)/.unpacked
$(LIBFFI_HOST_DIR)/.unpacked: $(DL_DIR)/$(LIBFFI_HOST_SOURCE) | $(TOOLS_SOURCE_DIR) $(UNPACK_TARBALL_PREREQUISITES)
	$(call UNPACK_TARBALL,$(DL_DIR)/$(LIBFFI_HOST_SOURCE),$(TOOLS_SOURCE_DIR))
	$(call APPLY_PATCHES,$(LIBFFI_HOST_MAKE_DIR)/patches,$(LIBFFI_HOST_DIR))
	touch $@

$(LIBFFI_HOST_DIR)/.configured: $(LIBFFI_HOST_DIR)/.unpacked
	(cd $(LIBFFI_HOST_DIR); $(RM) config.cache; \
		./configure \
		--prefix=/ \
		$(DISABLE_NLS) $(LIBFFI_HOST_CONFIGURE_OPTIONS) \
	);
	touch $@

$(LIBFFI_HOST_BINARY): $(LIBFFI_HOST_DIR)/.configured
	$(MAKE) -C $(LIBFFI_HOST_DIR) all

$(LIBFFI_HOST_TARGET_BINARY): $(LIBFFI_HOST_BINARY)
	$(MAKE) -C $(LIBFFI_HOST_DIR) \
		DESTDIR="$(HOST_TOOLS_DIR)" \
		install
	$(SED) -i -e 's,^prefix=.*,prefix=$(HOST_TOOLS_DIR),g' $(LIBFFI_HOST_DESTDIR)/pkgconfig/libffi.pc
	$(SED) -i -e 's,^libdir=.*,libdir=$(LIBFFI_HOST_DESTDIR),g' $(LIBFFI_HOST_DESTDIR)/libffi.la

libffi-host: $(LIBFFI_HOST_TARGET_BINARY)

libffi-host-clean:
	-$(MAKE) -C $(LIBFFI_HOST_DIR) clean

libffi-host-dirclean:
	$(RM) -r $(LIBFFI_HOST_DIR)

libffi-host-distclean: libffi-host-dirclean
	$(RM) -r $(dir $(LIBFFI_HOST_TARGET_BINARY))libffi* $(dir $(LIBFFI_HOST_TARGET_BINARY))*/libffi.*
