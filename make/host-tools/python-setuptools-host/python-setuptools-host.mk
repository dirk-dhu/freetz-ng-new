#PYTHON_SETUPTOOLS_HOST_VERSION:=39.0.1
PYTHON_SETUPTOOLS_HOST_MD5:=
PYTHON_SETUPTOOLS_HOST_SOURCE_COMMIT:=76f1da9
PYTHON_SETUPTOOLS_HOST_SOURCE:=setuptools-$(PYTHON_SETUPTOOLS_HOST_SOURCE_COMMIT).tar.gz
PYTHON_SETUPTOOLS_HOST_SITE:=git@https://github.com/eliben/setuptools.git
PYTHON_SETUPTOOLS_HOST_DIR:=$(TOOLS_SOURCE_DIR)/setuptools-$(PYTHON_SETUPTOOLS_HOST_SOURCE_COMMIT)

PYTHON_HOST_DIR:=$(TOOLS_SOURCE_DIR)/Python-$(PYTHON_HOST_VERSION)
PYTHON_HOST_BINARY:=$(PYTHON_HOST_DIR)/python
PYTHON_HOST_TARGET_BINARY:=$(HOST_TOOLS_DIR)/usr/lib/python$(PYTHON_HOST_MAJOR_VERSION)

PYTHON_SETUPTOOLS_HOST_BINARY:=$(PYTHON_HOST_TARGET_BINARY)/site-packages/setuptools

python-setuptools-host-source: $(DL_DIR)/$(PYTHON_SETUPTOOLS_HOST_SOURCE)
#$(DL_DIR)/$(PYTHON_SETUPTOOLS_HOST_SOURCE): | $(DL_DIR)
#	$(DL_TOOL) $(DL_DIR) $(PYTHON_SETUPTOOLS_HOST_SOURCE) $(PYTHON_SETUPTOOLS_HOST_SITE)

python-setuptools-host-unpacked: $(PYTHON_SETUPTOOLS_HOST_DIR)/.unpacked
$(PYTHON_SETUPTOOLS_HOST_DIR)/.unpacked: $(DL_DIR)/$(PYTHON_SETUPTOOLS_HOST_SOURCE) | $(TOOLS_SOURCE_DIR) $(UNPACK_TARBALL_PREREQUISITES) python2-host libffi-host
	$(call UNPACK_TARBALL,$(DL_DIR)/$(PYTHON_SETUPTOOLS_HOST_SOURCE),$(TOOLS_SOURCE_DIR))
	@touch $@

# python quirk:
#  CFLAGS and OPT flags passed here are then used while cross-compiling -> use some target neutral flags
python-setuptools-host-configured: $(PYTHON_SETUPTOOLS_HOST_DIR)/.configured
$(PYTHON_SETUPTOOLS_HOST_DIR)/.configured: $(PYTHON_SETUPTOOLS_HOST_DIR)/.unpacked
	@touch $@

$(PYTHON_SETUPTOOLS_HOST_BINARY): $(PYTHON_SETUPTOOLS_HOST_DIR)/.configured
	mkdir -p $@ $(PYTHON_SETUPTOOLS_HOST_DIR)/usr/bin; \
	(cd $(PYTHON_SETUPTOOLS_HOST_DIR); \
		CC=$(TOOLS_CC) \
		CFLAGS="-Os" \
		OPT="-fno-inline" \
		PYTHONHOME=$(HOST_TOOLS_DIR)/usr/ PYTHONPATH=$(PYTHON_HOST_TARGET_BINARY)/site-packages PKG_CONFIG_PATH=$(HOST_TOOLS_DIR)/lib/pkgconfig \
		$(HOST_TOOLS_DIR)/usr/bin/python ./bootstrap.py \
	)
	(cd $(PYTHON_SETUPTOOLS_HOST_DIR); \
		CC=$(TOOLS_CC) \
		CFLAGS="-Os" \
		OPT="-fno-inline" \
		PYTHONHOME=$(HOST_TOOLS_DIR)/usr/ PYTHONPATH=$(PYTHON_HOST_TARGET_BINARY)/site-packages PKG_CONFIG_PATH=$(HOST_TOOLS_DIR)/lib/pkgconfig \
		$(HOST_TOOLS_DIR)/usr/bin/python ./setup.py install \
	)

$(PYTHON_SETUPTOOLS_HOST_TARGET_BINARY): $(PYTHON_SETUPTOOLS_HOST_BINARY) | $(HOST_TOOLS_DIR)

python-setuptools-host: $(PYTHON_SETUPTOOLS_HOST_BINARY) | $(HOST_TOOLS_DIR)

python-setuptools-host-clean:

python-setuptools-host-dirclean:
	$(RM) -r $(PYTHON_SETUPTOOLS_HOST_DIR) \

python-setuptools-host-distclean: python-setuptools-host-dirclean
	$(RM) -r \
		$(PYTHON_HOST_TARGET_BINARY) \
		$(HOST_TOOLS_DIR)/usr/lib/python2.7/site-packages/setuptools* \

.PHONY: python-setuptools-host-source python-setuptools-host-unpacked python-setuptools-host-configured python-setuptools-host python-setuptools-host-clean python-setuptools-host-dirclean python-setuptools-host-distclean
