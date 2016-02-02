$(call PKG_INIT_BIN, 3.11)
$(PKG)_SOURCE:=PyYAML-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=f50e08ef0fe55178479d3a618efe21db
$(PKG)_SITE:=https://pypi.python.org/packages/source/P/PyYAML

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/PyYAML-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/_yaml.so

$(PKG)_DEPENDS_ON += python
$(PKG)_DEPENDS_ON += yaml

$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libyaml

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYYAML)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYYAML_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYYAML_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/yaml \
		$(PYTHON_PYYAML_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/PyYAML-*.egg-info

$(PKG_FINISH)
