$(call PKG_INIT_BIN, 1.0.0b2)
$(PKG)_SOURCE:=pyusb-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=bc12e83ff3ef1045d4306d13a9955fc1
$(PKG)_SITE:=https://pypi.python.org/packages/source/p/pyusb

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/pyusb-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/usb/backend

$(PKG)_DEPENDS_ON += python libusb1

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libusb_1


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYUSB)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYUSB_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYUSB_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/usb \
		$(PYTHON_PYUSB_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pyusb-*.egg-info

$(PKG_FINISH)
