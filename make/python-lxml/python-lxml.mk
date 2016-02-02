$(call PKG_INIT_BIN, 3.4.0)
$(PKG)_SOURCE:=lxml-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=bc90cc4e4ee04e1f8290ae0f70e34eea
$(PKG)_SITE:=https://pypi.python.org/packages/source/l/lxml

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/lxml-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/lxml/etree.so

$(PKG)_DEPENDS_ON += python xsltproc libxml2

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC
$(PKG)_REBUILD_SUBOPTS += $(XSLTPROC_REBUILD_SUBOPTS)
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libxml2
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libxslt
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libexslt

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_LXML, , TARGET_ARCH=$(FREETZ_TARGET_ARCH))

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_LXML_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_LXML_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/lxml \
		$(PYTHON_LXML_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/lxml-*.egg-info

$(PKG_FINISH)
