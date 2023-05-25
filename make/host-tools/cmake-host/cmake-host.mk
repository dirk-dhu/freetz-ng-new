$(call TOOLS_INIT, 3.26.4)
$(PKG)_MAJOR_VERSION:=$(call GET_MAJOR_VERSION,$($(PKG)_VERSION))
$(PKG)_SOURCE:=cmake-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=313b6880c291bd4fe31c0aa51d6e62659282a521e695f30d5cc0d25abbd5c208
$(PKG)_SITE:=https://github.com/Kitware/CMake/releases/download/v$($(PKG)_VERSION)
### WEBSITE:=https://cmake.org/
### MANPAGE:=https://cmake.org/cmake/help/latest/
### CHANGES:=https://github.com/Kitware/CMake/releases
### CVSREPO:=https://gitlab.kitware.com/cmake/cmake
# needs:  export CMAKE_ROOT=~/freetz-ng/tools/build/usr/share/cmake-3.25

$(PKG)_SHARE_NAME:=cmake-$($(PKG)_MAJOR_VERSION)
$(PKG)_INSTALL:=$($(PKG)_DIR)/INSTALL

$(PKG)_BINARY:=$($(PKG)_INSTALL)/bin/cmake
$(PKG)_TARGET_BINARY:=$(TOOLS_DIR)/cmake

$(PKG)_SHARE:=$($(PKG)_INSTALL)/share
$(PKG)_TARGET_SHARE:=$(TOOLS_DIR)/build/usr/share

$(PKG)_SHARE_INCLUDE:=$($(PKG)_INSTALL)/share/$($(PKG)_SHARE_NAME)/include/cmCPluginAPI.h
$(PKG)_TARGET_SHARE_INCLUDE:=$($(PKG)_TARGET_SHARE)/$($(PKG)_SHARE_NAME)/include/cmCPluginAPI.h

$(PKG)_DEPENDS_ON+=ninja-host

$(PKG)_CONFIGURE_OPTIONS +=  --generator=Ninja
$(PKG)_CONFIGURE_OPTIONS +=  --enable-ccache
$(PKG)_CONFIGURE_OPTIONS +=  --no-qt-gui
$(PKG)_CONFIGURE_OPTIONS +=  --no-system-libs
$(PKG)_CONFIGURE_OPTIONS +=  --prefix=$($(PKG)_INSTALL)


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_DIR)/.compiled: $($(PKG)_DIR)/.configured
	$(TOOLS_SUBNINJA) -C $(CMAKE_HOST_DIR)
	@touch $@

$($(PKG)_DIR)/.installed: $($(PKG)_DIR)/.compiled
	$(TOOLS_SUBNINJA) -C $(CMAKE_HOST_DIR) install
	@touch $@

$($(PKG)_BINARY) $($(PKG)_SHARE_INCLUDE): $($(PKG)_DIR)/.installed

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_FILE)

$($(PKG)_TARGET_SHARE_INCLUDE): $($(PKG)_SHARE_INCLUDE)
	mkdir -p $(CMAKE_HOST_TARGET_SHARE)/;
	cp -r $(CMAKE_HOST_SHARE)/$(CMAKE_HOST_SHARE_NAME) $(CMAKE_HOST_TARGET_SHARE)/;

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_TARGET_SHARE_INCLUDE)


$(pkg)-clean:
	-$(NINJA) -C $(CMAKE_HOST_DIR) uninstall
	 $(RM) $(NCFTP_DIR)/.{configured,compiled,installed}

$(pkg)-dirclean:
	$(RM) -r $(CMAKE_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) -r $(CMAKE_HOST_TARGET_BINARY) $(CMAKE_HOST_TARGET_SHARE)/$(CMAKE_HOST_SHARE_NAME)

$(TOOLS_FINISH)
