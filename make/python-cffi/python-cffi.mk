$(call PKG_INIT_BIN, 1.8.3)
$(PKG)_SOURCE:=cffi-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5_1.8.2:=538f307b6c5169bba41fbfda2b070762
$(PKG)_SOURCE_MD5_1.8.3:=c8e877fe0426a99d0cf5872cf2f95b27
$(PKG)_SOURCE_MD5:=$($(PKG)_SOURCE_MD5_$($(PKG)_VERSION))
$(PKG)_SITE_1.8.2:=https://files.pythonhosted.org/packages/b8/21/9d6f08d2d36a0a8c84623646b4ed5a07023d868823361a086b021fb21172
$(PKG)_SITE_1.8.3:=https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a
$(PKG)_SITE:=$($(PKG)_SITE_$($(PKG)_VERSION))
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/cffi-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/_cffi_backend.so

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

#version must be different from tools/make/python-cffi-host/python-cffi-host.mk
ifneq ($($(PKG)_VERSION),$(PYTHON_CFFI_HOST_VERSION_FULL))
$(PKG_SOURCE_DOWNLOAD)
else
$(PKG_SOURCE_DOWNLOAD_NOP)
python-cffi-source: $(DL_DIR)/$($(PKG)_HOST_SOURCE)
$(DL_DIR)/$($(PKG)_SOURCE):: | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $($(PKG)_SOURCE) $($(PKG)_SITE) $($(PKG)_SOURCE_MD5)

python-cffi-unpacked: $($(PKG)_DIR)/.unpacked
$($(PKG)_DIR)/.unpacked: $(DL_DIR)/$($(PKG)_SOURCE) | $(TOOLS_SOURCE_DIR) $(UNPACK_TARBALL_PREREQUISITES)
	$(call UNPACK_TARBALL,$(DL_DIR)/$($(PKG)_HOST_SOURCE),$(TOOLS_SOURCE_DIR))
	$(call APPLY_PATCHES,$($(PKG)_MAKE_DIR)/patches,$($(PKG)_DIR))
	@touch $@
endif

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-mock, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_CFFI); \
	cd $(FREETZ_BASE_DIR); \
	cp -fa $(dir $@)/cffi-*egg-info $(TARGET_TOOLCHAIN_STAGING_DIR)/lib/python2.7/site-packages; \
	cp -Rfa $(dir $@)/cffi $(TARGET_TOOLCHAIN_STAGING_DIR)/lib/python2.7/site-packages; \

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_CFFI_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CFFI_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cffi \
		$(PYTHON_CFFI_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cffi-*.egg-info

$(PKG_FINISH)
