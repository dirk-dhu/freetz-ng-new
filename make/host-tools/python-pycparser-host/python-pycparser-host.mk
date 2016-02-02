#PYTHON_PYCPARSER_HOST_VERSION:=1.8
PYTHON_PYCPARSER_HOST_MD5:=
PYTHON_PYCPARSER_HOST_SOURCE_COMMIT:=6ba9544
PYTHON_PYCPARSER_HOST_SOURCE:=pycparser-$(PYTHON_PYCPARSER_HOST_SOURCE_COMMIT).tar.gz
PYTHON_PYCPARSER_HOST_SITE:=git@https://github.com/eliben/pycparser.git
PYTHON_PYCPARSER_HOST_DIR:=$(TOOLS_SOURCE_DIR)/pycparser-$(PYTHON_PYCPARSER_HOST_SOURCE_COMMIT)

PYTHON_HOST_DIR:=$(TOOLS_SOURCE_DIR)/Python-$(PYTHON_HOST_VERSION)
PYTHON_HOST_BINARY:=$(PYTHON_HOST_DIR)/python
PYTHON_HOST_TARGET_BINARY:=$(HOST_TOOLS_DIR)/usr/lib/python$(PYTHON_HOST_MAJOR_VERSION)

PYTHON_PYCPARSER_HOST_BINARY:=$(PYTHON_HOST_TARGET_BINARY)/site-packages/pycparser

python-pycparser-host-source: $(DL_DIR)/$(PYTHON_PYCPARSER_HOST_SOURCE)
#$(DL_DIR)/$(PYTHON_PYCPARSER_HOST_SOURCE): | $(DL_DIR)
#	$(DL_TOOL) $(DL_DIR) $(PYTHON_PYCPARSER_HOST_SOURCE) $(PYTHON_PYCPARSER_HOST_SITE)

python-pycparser-host-unpacked: $(PYTHON_PYCPARSER_HOST_DIR)/.unpacked
$(PYTHON_PYCPARSER_HOST_DIR)/.unpacked: $(DL_DIR)/$(PYTHON_PYCPARSER_HOST_SOURCE) | $(TOOLS_SOURCE_DIR) $(UNPACK_TARBALL_PREREQUISITES) python2-host libffi-host
	$(call UNPACK_TARBALL,$(DL_DIR)/$(PYTHON_PYCPARSER_HOST_SOURCE),$(TOOLS_SOURCE_DIR))
	@touch $@

# python quirk:
#  CFLAGS and OPT flags passed here are then used while cross-compiling -> use some target neutral flags
python-pycparser-host-configured: $(PYTHON_PYCPARSER_HOST_DIR)/.configured
$(PYTHON_PYCPARSER_HOST_DIR)/.configured: $(PYTHON_PYCPARSER_HOST_DIR)/.unpacked
	@touch $@

$(PYTHON_PYCPARSER_HOST_BINARY): $(PYTHON_PYCPARSER_HOST_DIR)/.configured
	(cd $(PYTHON_PYCPARSER_HOST_DIR); \
		CC=$(TOOLS_CC) \
		CFLAGS="-Os" \
		OPT="-fno-inline" \
		PYTHONHOME=$(HOST_TOOLS_DIR)/usr/ PYTHONPATH=$(PYTHON_HOST_TARGET_BINARY)/site-packages PKG_CONFIG_PATH=$(HOST_TOOLS_DIR)/lib/pkgconfig \
		$(HOST_TOOLS_DIR)/usr/bin/python ./setup.py install \
	)

$(PYTHON_PYCPARSER_HOST_TARGET_BINARY): $(PYTHON_PYCPARSER_HOST_BINARY) | $(HOST_TOOLS_DIR)

python-pycparser-host: $(PYTHON_PYCPARSER_HOST_BINARY) | $(HOST_TOOLS_DIR)

python-pycparser-host-clean:

python-pycparser-host-dirclean:
	$(RM) -r $(PYTHON_PYCPARSER_HOST_DIR) \

python-pycparser-host-distclean: python-pycparser-host-dirclean
	$(RM) -r \
		$(PYTHON_HOST_TARGET_BINARY) \
		$(HOST_TOOLS_DIR)/usr/lib/python2.7/site-packages/pycparser* \

.PHONY: python-pycparser-host-source python-pycparser-host-unpacked python-pycparser-host-configured python-pycparser-host python-pycparser-host-clean python-pycparser-host-dirclean python-pycparser-host-distclean
