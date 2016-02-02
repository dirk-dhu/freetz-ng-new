PYTHON_CFFI_HOST_VERSION:=1.8
PYTHON_CFFI_HOST_VERSION_FULL:=1.8.2
PYTHON_CFFI_HOST_SOURCE:=cffi-$(PYTHON_CFFI_HOST_VERSION_FULL).tar.gz
PYTHON_CFFI_HOST_MD5:=538f307b6c5169bba41fbfda2b070762
PYTHON_CFFI_HOST_SITE:=https://files.pythonhosted.org/packages/b8/21/9d6f08d2d36a0a8c84623646b4ed5a07023d868823361a086b021fb21172
PYTHON_CFFI_HOST_DIR:=$(TOOLS_SOURCE_DIR)/cffi-$(PYTHON_CFFI_HOST_VERSION_FULL)
PYTHON_CFFI_HOST_MAKE_DIR:=$(TOOLS_DIR)/make/python-cffi-host

PYTHON_HOST_DIR:=$(TOOLS_SOURCE_DIR)/Python-$(PYTHON_HOST_VERSION)
PYTHON_HOST_BINARY:=$(PYTHON_HOST_DIR)/python
PYTHON_HOST_TARGET_BINARY:=$(HOST_TOOLS_DIR)/usr/bin/python2.7
PYTHON_HOST_TARGET_LIB:=$(HOST_TOOLS_DIR)/usr/lib/python2.7

PYTHON_CFFI_HOST_BINARY:=$(PYTHON_HOST_TARGET_LIB)/site-packages/_cffi_backend.so

#version must bedifferent from make/python-cffi/python-cffi.mk
python-cffi-host-source: $(DL_DIR)/$(PYTHON_CFFI_HOST_SOURCE)
$(DL_DIR)/$(PYTHON_CFFI_HOST_SOURCE):: | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(PYTHON_CFFI_HOST_SOURCE) $(PYTHON_CFFI_HOST_SITE) $(PYTHON_CFFI_HOST_MD5)

python-cffi-host-unpacked: $(PYTHON_CFFI_HOST_DIR)/.unpacked
$(PYTHON_CFFI_HOST_DIR)/.unpacked: $(DL_DIR)/$(PYTHON_CFFI_HOST_SOURCE) | $(TOOLS_SOURCE_DIR) $(UNPACK_TARBALL_PREREQUISITES) python2-host libffi-host python-pycparser-host
	$(call UNPACK_TARBALL,$(DL_DIR)/$(PYTHON_CFFI_HOST_SOURCE),$(TOOLS_SOURCE_DIR))
	$(call APPLY_PATCHES,$(PYTHON_CFFI_HOST_MAKE_DIR)/patches,$(PYTHON_CFFI_HOST_DIR))
	@touch $@

# python quirk:
#  CFLAGS and OPT flags passed here are then used while cross-compiling -> use some target neutral flags
python-cffi-host-configured: $(PYTHON_CFFI_HOST_DIR)/.configured
$(PYTHON_CFFI_HOST_DIR)/.configured: $(PYTHON_CFFI_HOST_DIR)/.unpacked
	@touch $@

$(PYTHON_CFFI_HOST_BINARY): $(PYTHON_CFFI_HOST_DIR)/.configured
	(cd $(PYTHON_CFFI_HOST_DIR); \
		CC=$(TOOLS_CC) \
		CFLAGS="-Os" \
		OPT="-fno-inline" \
		PYTHONHOME=$(HOST_TOOLS_DIR)/usr/ PYTHONPATH=$(PYTHON_HOST_TARGET_BINARY)/site-packages PKG_CONFIG_PATH=$(HOST_TOOLS_DIR)/lib/pkgconfig \
		$(HOST_TOOLS_DIR)/usr/bin/python ./setup.py install_lib  \
	) && \
	(cd $(PYTHON_CFFI_HOST_DIR); \
		CC=$(TOOLS_CC) \
		CFLAGS="-Os" \
		OPT="-fno-inline" \
		PYTHONHOME=$(HOST_TOOLS_DIR)/usr/ PYTHONPATH=$(PYTHON_HOST_TARGET_BINARY)/site-packages PKG_CONFIG_PATH=$(HOST_TOOLS_DIR)/lib/pkgconfig \
		$(HOST_TOOLS_DIR)/usr/bin/python ./setup.py install_egg_info  \
	)

$(PYTHON_CFFI_HOST_TARGET_BINARY): $(PYTHON_CFFI_HOST_BINARY) | $(HOST_TOOLS_DIR)

python-cffi-host: $(PYTHON_CFFI_HOST_BINARY) | $(HOST_TOOLS_DIR)

python-cffi-host-clean:

python-cffi-host-dirclean:
	$(RM) -r $(PYTHON_CFFI_HOST_DIR)

python-cffi-host-distclean: python-cffi-host-dirclean
	$(RM) -r \
		$(PYTHON_HOST_TARGET_BINARY) \
		$(HOST_TOOLS_DIR)/usr/lib/python2.7/site-packages/cffi* \
		$(HOST_TOOLS_DIR)/usr/lib/python2.7/site-packages/_cffi_backend.so

.PHONY: python-cffi-host-source python-cffi-host-unpacked python-cffi-host-configured python-cffi-host python-cffi-host-clean python-cffi-host-dirclean python-cffi-host-distclean
