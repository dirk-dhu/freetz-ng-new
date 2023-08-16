$(call TOOLS_INIT, 0)

$(PKG)_DEPENDS_ON+=sfk-host
$(PKG)_DEPENDS_ON+=libdtc-host

ifeq ($(shell uname -m), aarch64)
$(PKG)_BUILD_PREREQ := A-32bit-capable-CPU
$(PKG)_BUILD_PREREQ_HINT := You have to install a cpu which can handle 32-bit code to compile YourFritz-avm_kernel_config
endif

$(PKG)_BINS:=extract bin2asm
$(PKG)_BUILD_DIR:=$($(PKG)_BINS:%=$($(PKG)_DIR)/avm_kernel_config.%)
$(PKG)_TARGET_DIR:=$($(PKG)_BINS:%=$(TOOLS_DIR)/avm_kernel_config.%)


$(TOOLS_LOCALSOURCE_PACKAGE)
$(TOOLS_CONFIGURED_NOP)

$($(PKG)_BUILD_DIR): $($(PKG)_DIR)/.unpacked
	$(TOOLS_SUBMAKE) -C $(YF_AKCAREA_HOST_DIR) \
		OPT="-O0" \
		CC="$(TOOLS_CC)" \
		BITNESS="$(HOST_CFLAGS_FORCE_32BIT_CODE)" \
		LIBFDT_DIR=$(HOST_TOOLS_DIR) \
		$(YF_AKCAREA_HOST_BINS:%=avm_kernel_config.%)
	touch -c $@

$($(PKG)_TARGET_DIR): $(TOOLS_DIR)/avm_kernel_config.%: $($(PKG)_DIR)/avm_kernel_config.%
	$(INSTALL_FILE)

$(pkg)-precompiled: $($(PKG)_TARGET_DIR)


$(pkg)-clean:
	-$(MAKE) -C $(YF_AKCAREA_HOST_DIR) clean

$(pkg)-dirclean:
	$(RM) -r $(YF_AKCAREA_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) $(YF_AKCAREA_HOST_TARGET_DIR)

$(TOOLS_FINISH)
