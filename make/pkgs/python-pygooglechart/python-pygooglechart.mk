$(call PKG_INIT_BIN, 0.4.0)
$(PKG)_SOURCE:=pygooglechart-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5_0.3.0:=9cff857fedb8dbc9243379612d9cc1ff
$(PKG)_SOURCE_MD5_0.4.0:=247b69617aa4676ccd3b48fdbbcf2abf
$(PKG)_SOURCE_MD5:=$($(PKG)_SOURCE_MD5_$($(PKG)_VERSION))
$(PKG)_SITE:=https://files.pythonhosted.org/packages/95/88/54f91552de1e1b0085c02b96671acfba6e351915de3a12a398533fc82e20

$(PKG)_CONDITIONAL_PATCHES+=$($(PKG)_VERSION)

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/pygooglechart-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pygooglechart.py

$(PKG)_DEPENDS_ON += python

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_PYGOOGLECHART)
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_PYGOOGLECHART_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_PYGOOGLECHART_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/googlechart \
		$(PYTHON_PYGOOGLECHART_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/pygooglechart-*.egg-info

$(PKG_FINISH)
